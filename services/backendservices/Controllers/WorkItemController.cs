using Microsoft.AspNetCore.Mvc;
using workhelpers.Models;

namespace backendservices.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class WorkItemController : ControllerBase
    {
        private static List<WorkItem> workItemsList = new List<WorkItem>();

        [HttpGet]
        public ActionResult<IEnumerable<WorkItem>> GetTasks()
        {
            return Ok(workItemsList);
        }

        [HttpGet("{id}")]
        public ActionResult<WorkItem> GetTask(int id)
        {
            var task = workItemsList.FirstOrDefault(t => t.Id == id);
            if (task == null)
            {
                return NotFound();
            }
            return Ok(task);
        }

        [HttpPost]
        public ActionResult<WorkItem> CreateTask(WorkItem task)
        {
            task.Id = workItemsList.Count > 0 ? workItemsList.Max(t => t.Id) + 1 : 1;
            workItemsList.Add(task);
            return CreatedAtAction(nameof(GetTask), new { id = task.Id }, task);
        }

        [HttpPut("{id}")]
        public ActionResult UpdateTask(int id, WorkItem updatedTask)
        {
            var task = workItemsList.FirstOrDefault(t => t.Id == id);
            if (task == null)
            {
                return NotFound();
            }
            task.Title = updatedTask.Title;
            task.Completed = updatedTask.Completed;
            return NoContent();
        }

        [HttpDelete("{id}")]
        public ActionResult DeleteTask(int id)
        {
            var task = workItemsList.FirstOrDefault(t => t.Id == id);
            if (task == null)
            {
                return NotFound();
            }
            workItemsList.Remove(task);
            return NoContent();
        }
    }
}