#! /usr/bin/env fish

for app in Launchpad Safari Messages Mail Maps Photos FaceTime Calendar Contacts Reminders TV Music Podcasts News 'App Store'
    dockutil --remove $app --no-restart || echo "$app not in dock"
end
dockutil --remove Notes