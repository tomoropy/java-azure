package com.example.todoapp.service;

import com.example.todoapp.entity.Todo;
import com.example.todoapp.repository.TodoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class TodoService {
    
    @Autowired
    private TodoRepository todoRepository;
    
    // 全てのTODOを取得（作成日時の降順）
    public List<Todo> getAllTodos() {
        return todoRepository.findAllOrderByCreatedAtDesc();
    }
    
    // IDでTODOを取得
    public Optional<Todo> getTodoById(Long id) {
        return todoRepository.findById(id);
    }
    
    // 新しいTODOを作成
    public Todo createTodo(Todo todo) {
        return todoRepository.save(todo);
    }
    
    // TODOを更新
    public Todo updateTodo(Long id, Todo todoDetails) {
        Optional<Todo> optionalTodo = todoRepository.findById(id);
        if (optionalTodo.isPresent()) {
            Todo todo = optionalTodo.get();
            todo.setTitle(todoDetails.getTitle());
            todo.setDescription(todoDetails.getDescription());
            todo.setCompleted(todoDetails.getCompleted());
            return todoRepository.save(todo);
        }
        return null;
    }
    
    // TODOの完了状態を切り替え
    public Todo toggleTodoCompletion(Long id) {
        Optional<Todo> optionalTodo = todoRepository.findById(id);
        if (optionalTodo.isPresent()) {
            Todo todo = optionalTodo.get();
            todo.setCompleted(!todo.getCompleted());
            return todoRepository.save(todo);
        }
        return null;
    }
    
    // TODOを削除
    public boolean deleteTodo(Long id) {
        if (todoRepository.existsById(id)) {
            todoRepository.deleteById(id);
            return true;
        }
        return false;
    }
    
    // 完了状態でフィルタリング
    public List<Todo> getTodosByCompletionStatus(Boolean completed) {
        return todoRepository.findByCompleted(completed);
    }
    
    // タイトルで検索
    public List<Todo> searchTodosByTitle(String title) {
        return todoRepository.findByTitleContainingIgnoreCase(title);
    }
    
    // 未完了のタスクを取得
    public List<Todo> getIncompleteTasks() {
        return todoRepository.findIncompleteTasksOrderByCreatedAt();
    }
}
