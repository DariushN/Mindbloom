import 'package:feather/src/models/internal/mood.dart';
import 'package:feather/src/models/internal/weather_enum.dart';

const popSpotifyLink = 'spotify:playlist:37i9dQZF1DXarRysLJmuju';
const rnbSpotifyLink = 'spotify:playlist:37i9dQZF1DX2WkIBRaChxW';
const reggaeSpotifyLink = 'spotify:playlist:37i9dQZF1DXbSbnqxMTGx9';
const classicalSpotifyLink = 'spotify:playlist:37i9dQZF1DWWEJlAGA9gs0';
const bluesSpotifyLink = 'spotify:playlist:37i9dQZF1DXbkKnGZHv1kf';
const jazzSpotifyLink = 'spotify:playlist:37i9dQZF1DXbITWG1ZJKYt';
const danceSpotifyLink = 'spotify:playlist:37i9dQZF1DXaXB8fQg7xif';
const rockSpotifyLink = 'spotify:playlist:37i9dQZF1DWXRqgorJj26U';
const rapSpotifyLink = 'spotify:playlist:37i9dQZF1DX0XUsuxWHRQd';

const mapMoodWeatherToGenre = {
  Mood.ecstatic: {
    WeatherEnum.Thunder: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'Pop',
      'playlistLink': popSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Pop',
      'playlistLink': popSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Dance',
      'playlistLink': danceSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
  },
  Mood.happy: {
    WeatherEnum.Thunder: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Pop',
      'playlistLink': popSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Dance',
      'playlistLink': danceSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
  },
  Mood.content: {
    WeatherEnum.Thunder: {
      'genre':'Blues',
      'playlistLink': bluesSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Jazz',
      'playlistLink': jazzSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Pop',
      'playlistLink': popSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Blues',
      'playlistLink': bluesSpotifyLink,
    },
  },
  Mood.neutral: {
    WeatherEnum.Thunder: {
      'genre':'Classical',
      'playlistLink': classicalSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'Classical',
      'playlistLink': classicalSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Classical',
      'playlistLink': classicalSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Classical',
      'playlistLink': classicalSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Classical',
      'playlistLink': classicalSpotifyLink,
    },
  },
  Mood.bitter: {
    WeatherEnum.Thunder: {
      'genre':'Blues',
      'playlistLink': bluesSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Reggae',
      'playlistLink': reggaeSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Blues',
      'playlistLink': bluesSpotifyLink,
    },
  },
  Mood.sad: {
    WeatherEnum.Thunder: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Rap',
      'playlistLink': rapSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Reggae',
      'playlistLink': reggaeSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
  },
  Mood.depressed: {
    WeatherEnum.Thunder: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Rain: {
      'genre':'R&B',
      'playlistLink': rnbSpotifyLink,
    },
    WeatherEnum.Cloud: {
      'genre':'Rock',
      'playlistLink': rockSpotifyLink,
    },
    WeatherEnum.Sun: {
      'genre':'Reggae',
      'playlistLink': reggaeSpotifyLink,
    },
    WeatherEnum.Snow: {
      'genre':'Rock',
      'playlistLink': rockSpotifyLink,
    },
  },
};