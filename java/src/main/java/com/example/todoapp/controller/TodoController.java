package com.example.todoapp.controller;

import com.example.todoapp.entity.Todo;
import com.example.todoapp.service.TodoService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;
import java.util.Optional;

@Controller
@RequestMapping("/")
public class TodoController {
    
    @Autowired
    private TodoService todoService;
    
    // TODOリスト表示（メインページ）
    @GetMapping
    public String index(Model model, @RequestParam(required = false) String filter, 
                       @RequestParam(required = false) String search) {
        List<Todo> todos;
        
        if (search != null && !search.trim().isEmpty()) {
            todos = todoService.searchTodosByTitle(search);
            model.addAttribute("searchQuery", search);
        } else if ("completed".equals(filter)) {
            todos = todoService.getTodosByCompletionStatus(true);
            model.addAttribute("currentFilter", "completed");
        } else if ("incomplete".equals(filter)) {
            todos = todoService.getTodosByCompletionStatus(false);
            model.addAttribute("currentFilter", "incomplete");
        } else {
            todos = todoService.getAllTodos();
            model.addAttribute("currentFilter", "all");
        }
        
        model.addAttribute("todos", todos);
        model.addAttribute("newTodo", new Todo());
        return "index";
    }
    
    // 新しいTODO作成
    @PostMapping("/create")
    public String createTodo(@ModelAttribute Todo todo, RedirectAttributes redirectAttributes) {
        if (todo.getTitle() != null && !todo.getTitle().trim().isEmpty()) {
            todoService.createTodo(todo);
            redirectAttributes.addFlashAttribute("successMessage", "TODOが正常に作成されました！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "タイトルは必須です。");
        }
        return "redirect:/";
    }
    
    // TODO編集ページ表示
    @GetMapping("/edit/{id}")
    public String editTodo(@PathVariable Long id, Model model) {
        Optional<Todo> todo = todoService.getTodoById(id);
        if (todo.isPresent()) {
            model.addAttribute("todo", todo.get());
            return "edit";
        }
        return "redirect:/";
    }
    
    // TODO更新
    @PostMapping("/update/{id}")
    public String updateTodo(@PathVariable Long id, @ModelAttribute Todo todo, 
                           RedirectAttributes redirectAttributes) {
        Todo updatedTodo = todoService.updateTodo(id, todo);
        if (updatedTodo != null) {
            redirectAttributes.addFlashAttribute("successMessage", "TODOが正常に更新されました！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "TODOの更新に失敗しました。");
        }
        return "redirect:/";
    }
    
    // TODO完了状態切り替え
    @PostMapping("/toggle/{id}")
    public String toggleTodo(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        Todo updatedTodo = todoService.toggleTodoCompletion(id);
        if (updatedTodo != null) {
            String status = updatedTodo.getCompleted() ? "完了" : "未完了";
            redirectAttributes.addFlashAttribute("successMessage", 
                "TODOを" + status + "に変更しました！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "TODOの状態変更に失敗しました。");
        }
        return "redirect:/";
    }
    
    // TODO削除
    @PostMapping("/delete/{id}")
    public String deleteTodo(@PathVariable Long id, RedirectAttributes redirectAttributes) {
        boolean deleted = todoService.deleteTodo(id);
        if (deleted) {
            redirectAttributes.addFlashAttribute("successMessage", "TODOが正常に削除されました！");
        } else {
            redirectAttributes.addFlashAttribute("errorMessage", "TODOの削除に失敗しました。");
        }
        return "redirect:/";
    }
}
