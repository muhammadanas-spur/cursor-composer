import { Component, OnInit } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule, NgModel } from '@angular/forms';
interface Task {
  id: number;
  title: string;
  completed: boolean;
}
@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent implements OnInit {
  tasks: Task[] = [];
  newTaskTitle: string = '';

  ngOnInit() {
    // Load tasks from localStorage
    const savedTasks = localStorage.getItem('tasks');
    if (savedTasks) {
      this.tasks = JSON.parse(savedTasks);
    }
  }

  private saveTasks() {
    localStorage.setItem('tasks', JSON.stringify(this.tasks));
  }

  addTask() {
    if (this.newTaskTitle.trim()) {
      const newTask: Task = {
        id: Date.now(),
        title: this.newTaskTitle,
        completed: false
      };
      this.tasks.unshift(newTask);
      this.newTaskTitle = '';
      this.saveTasks();
    }
  }

  toggleTask(task: Task) {
    task.completed = !task.completed;
    this.saveTasks();
  }

  editTask(task: Task) {
    const newTitle = prompt('Edit task:', task.title);
    if (newTitle !== null && newTitle.trim()) {
      task.title = newTitle;
      this.saveTasks();
    }
  }

  deleteTask(task: Task) {
    if (confirm('Are you sure you want to delete this task?')) {
      this.tasks = this.tasks.filter(t => t.id !== task.id);
      this.saveTasks();
    }
  }
}