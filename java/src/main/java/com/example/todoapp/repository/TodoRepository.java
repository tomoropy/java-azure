package com.example.todoapp.repository;

import com.example.todoapp.entity.Todo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface TodoRepository extends JpaRepository<Todo, Long> {
    
    // 完了状態でフィルタリング
    List<Todo> findByCompleted(Boolean completed);
    
    // タイトルで検索（部分一致）
    List<Todo> findByTitleContainingIgnoreCase(String title);
    
    // 作成日時の降順で全件取得
    @Query("SELECT t FROM Todo t ORDER BY t.createdAt DESC")
    List<Todo> findAllOrderByCreatedAtDesc();
    
    // 未完了のタスクを作成日時の昇順で取得
    @Query("SELECT t FROM Todo t WHERE t.completed = false ORDER BY t.createdAt ASC")
    List<Todo> findIncompleteTasksOrderByCreatedAt();
}
