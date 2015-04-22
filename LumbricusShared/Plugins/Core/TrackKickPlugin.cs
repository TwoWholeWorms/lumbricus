﻿using System;
using System.Linq;
using System.Text.RegularExpressions;
using TwoWholeWorms.Lumbricus.Shared;
using TwoWholeWorms.Lumbricus.Shared.Model;
using TwoWholeWorms.Lumbricus.Shared.Plugins;

namespace TwoWholeWorms.Lumbricus.Shared.Plugins.Core
{

    public class TrackKickPlugin : AbstractPlugin
    {

        #region AbstractPlugin implementation

        public override void RegisterPlugin(IrcConnection conn)
        {
            conn.ProcessIrcLine += DoTrackKickPlugin;
        }

        public override string Name {
            get {
                return "Track Kick Plugin";
            }
        }

        #endregion

        public void DoTrackKickPlugin(IrcConnection conn, IrcLine line)
        {
            Regex r = new Regex(@"^(?<channel>#[^ ]+) (?<twat>.*)$", RegexOptions.ExplicitCapture);
            Match m = r.Match(line.Target);

            if (m.Success) {
                string channelName = m.Groups["channel"].Value;
                string twat        = m.Groups["twat"].Value;

                Nick banner = conn.Server.Nicks.FirstOrDefault(x => x.Name == line.Nick.ToLower());
                Nick twatNick = conn.Server.Nicks.FirstOrDefault(x => x.Name == twat.ToLower());
                Channel channel = conn.Server.Channels.FirstOrDefault(x => x.Name == channelName.ToLower());

                Ban ban = Ban.Fetch(channel, twatNick);
                if (ban != null) {
                    if (ban.BannerAccount == null && banner.Account != null) {
                        ban.BannerAccount = banner.Account;
                    }
                    ban.Nick = twatNick;
                    if (twatNick.Account != null) ban.Account = twatNick.Account;
                    ban.Channel = channel;
                    ban.BanMessage = line.Trail;

                    LumbricusContext.db.SaveChanges();
                }
            }
        }

    }

}
