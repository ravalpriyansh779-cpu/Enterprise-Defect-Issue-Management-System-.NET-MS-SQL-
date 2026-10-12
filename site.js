document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.grid tr.breach').forEach(function (r) { r.title = 'SLA breached'; });
});
