// Enable pusher logging - don't include this in production
Pusher.logToConsole = true;

const pusher = new Pusher('6440facb664c305448af', {
  cluster: 'us2'
});

const channel = pusher.subscribe('go-fish');
channel.bind('game-changed', function(data) {
  if (window.location.pathname === '/lobby') {
    window.location.reload();
  }
  if (window.location.pathname === '/await_turn') {
    window.location.reload();
  }
  if (window.location.pathname === '/') {
    window.location.reload();
  }
});

channel.bind('game-over', function(data) {
  window.location = '/end_game';
});