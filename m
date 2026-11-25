Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625055;
	b=SadFiTDiV7fXWxSoByx70aTtpP4kb9aLK6775AOH13ZmpscJWzgsBjDeGXwR4gA8bH6u
	 L1orhZd926zaGnYJ9sQj5I6Ii912DX1X5s5HAWH6n41LGKkeVzkySv/tTBQzJOQ0fgdm/
	 sChmvNsEweblgRzxHgDWA4UlwYT/7LdY1S3gMsNXMNrRNWdC6R/CStki46wANeOXXkjCz
	 trWSgoECBXM0WsMKn8apJfXpkfOXC1BK3S48FzqImiLl2ZqR77XF7xTQos6iXS5tGYdpo
	 ttto2H0jFre6WahKyeT+6zTIm+YB15uwLZkd5iUvxeS8jk2LJLbAPx81eKhbhRWXr7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625055;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KQIXEPqZOyCDillB8a8nW4Wqyo9ru9Uk8xVMBFpC93M=;
	b=OPlzS/x+5wazS+CV26i0L8z+J72PdxQPSFH4UDOAg8x0QVifiOHRMw0JSPoF67vd9ws0
	 11CkMCC1QVxUyrYhE/NbQE4kfnXdwsX8ZHGo+st3S9zAziCuQtd1bmqapiAqzMF5GOmul
	 pladfEqFLb/Jq93eIbdgezIn8h8D5MQ7n4phP581/ihEK7fpN9xM8sjmNFdQCbSs+tnvW
	 MbjRSdya/TLlpnJkf4Ajq4unn5p50RjftQ9g/sTqf7/bZjl449MFpAgEOOHAgOJacWU6g
	 IaGTYWXqv0zldPQWIl7c3rzy72vWfkZ9ejVYGue/Edz9oO0h8JyVqqFY8IlcsdT42JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3KUcLGr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5C7606A327;
	Wed, 25 Nov 2026 16:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=B3KUcLGr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 122251F000C0;
	Wed, 25 Nov 2026 16:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625055;
	bh=KQIXEPqZOyCDillB8a8nW4Wqyo9ru9Uk8xVMBFpC93M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B3KUcLGr4w9rCsP0YvOJfjZ8Ag3E0TYo7MkOs6blqJ8mk7YHTnB2Z3BPeFC7pt5Bt
	 V1irtvPt75tVrgZ9uk+E16Mw0N5nuT7HqwnO5kTCOxpnPDx5VS6x5L6Co3rv5hEXnt
	 1XpVN2Dbq5qDdDx2uyBKqF7MPjunpMm9qRI2SFu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lachlan Hodges <lachlan.hodges@morsemicro.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/816] wifi: mac80211: dont seed an S1G stas last_rate
Date: Wed, 25 Nov 2026 15:32:20 +0100
Message-ID: <20261125143858.275035358@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lachlan Hodges <lachlan.hodges@morsemicro.com>

[ Upstream commit 00f623647c331d31df8629af958f7582a7fc874c ]

When initialising the rate control system, ieee80211_s1g_sta_rate_init()
is called for S1G stations during association where it initialises a
last rate of type STA_STATS_RATE_TYPE_S1G but does not initialise
nss, mcs bw etc. Since the last_rate no longer has a value equivalent
to STA_STATS_RATE_INVALID, the invalid rate will be decoded and
the NL80211_STA_INFO_RX_BITRATE flag will be set.

As a result, there is a period during association before the first
data frame is rx'ed where the seeded value is overwritten by
ieee80211_rx_h_sta_process() while this invalid last_rate lives. If
the sta is desroyed during this process, nl80211_put_sta_rate() will
call into cfg80211_calculate_bitrate() and attempt to calculate
the bitrate using the invalid last_rate leading to a WARN:

4,336,675067400,-;------------[ cut here ]------------
4,337,675067524,-;WARNING: net/wireless/util.c:1960 at cfg80211_calculate_bitrate+0x4d8/0x8b0 [cfg80211], CPU#3: kworker/u16:3/874
4,338,675068176,-;invalid rate bw=0, mcs=0, nss=0
[snip loaded modules]
4,341,675068954,-;Hardware name: BCM2711
4,342,675068961,-;Workqueue: events_unbound cfg80211_wiphy_work [cfg80211]
4,343,675069386,-;Call trace:
4,344,675069392,-; unwind_backtrace from show_stack+0x10/0x14
4,345,675069440,-; show_stack from dump_stack_lvl+0xa8/0xb8
4,346,675069475,-; dump_stack_lvl from __warn+0x90/0x224
4,347,675069517,-; __warn from warn_slowpath_fmt+0x130/0x1a8
4,348,675069559,-; warn_slowpath_fmt from cfg80211_calculate_bitrate+0x4d8/0x8b0 [cfg80211]
4,349,675070005,-; cfg80211_calculate_bitrate [cfg80211] from nl80211_put_sta_rate+0x48/0x590 [cfg80211]
4,350,675070819,-; nl80211_put_sta_rate [cfg80211] from nl80211_put_sta_info_common+0x4f4/0xd50 [cfg80211]
4,351,675071616,-; nl80211_put_sta_info_common [cfg80211] from nl80211_send_station.constprop.0+0x114/0x424 [cfg80211]
4,352,675072427,-; nl80211_send_station.constprop.0 [cfg80211] from cfg80211_del_sta_sinfo+0xc4/0x368 [cfg80211]
4,353,675073222,-; cfg80211_del_sta_sinfo [cfg80211] from __sta_info_destroy_part2+0x108/0x2c0 [mac80211]
4,354,675074178,-; __sta_info_destroy_part2 [mac80211] from sta_info_destroy_addr+0x4c/0x88 [mac80211]
4,355,675075243,-; sta_info_destroy_addr [mac80211] from ieee80211_destroy_assoc_data+0x194/0x2d8 [mac80211]
4,356,675075920,-; ieee80211_destroy_assoc_data [mac80211] from ieee80211_rx_mgmt_assoc_resp+0x220/0x1d4c [mac80211]
4,357,675076558,-; ieee80211_rx_mgmt_assoc_resp [mac80211] from ieee80211_iface_work+0x1c0/0x5d0 [mac80211]
4,358,675077187,-; ieee80211_iface_work [mac80211] from cfg80211_wiphy_work+0x110/0x368 [cfg80211]
4,359,675077763,-; cfg80211_wiphy_work [cfg80211] from process_one_work+0x260/0x868
4,360,675078022,-; process_one_work from worker_thread+0x1bc/0x3ec
4,361,675078042,-; worker_thread from kthread+0x120/0x154
4,362,675078060,-; kthread from ret_from_fork+0x14/0x20
4,363,675078074,-;Exception stack(0xf0ac1fb0 to 0xf0ac1ff8)
4,364,675078081,-;1fa0:                                     00000000 00000000 00000000 00000000
4,365,675078088,-;1fc0: 00000000 00000000 00000000 00000000 00000000 00000000 00000000 00000000
4,366,675078093,-;1fe0: 00000000 00000000 00000000 00000000 00000013 00000000
4,367,675080226,-;irq event stamp: 15780967
4,368,675080287,-;hardirqs last  enabled at (15780975): [<c050c154>] __up_console_sem+0x50/0x60
4,369,675080395,-;hardirqs last disabled at (15780982): [<c050c140>] __up_console_sem+0x3c/0x60
4,370,675080497,-;softirqs last  enabled at (15780966): [<c0476f14>] handle_softirqs+0x398/0x650
4,371,675080608,-;softirqs last disabled at (15780939): [<c0477388>] __irq_exit_rcu+0x150/0x1f0
4,372,675080715,-;---[ end trace 0000000000000000 ]---

To fix, we can simply not seed this psuedo rate. It was originally
implemented to avoid errornous paths that S1G shouldn't take, but those
have since been fixed / cleaned up. While we are here, we also don't
need to initialise the tx side's last rate with
IEEE80211_TX_RC_S1G_MCS (which is equivalent to
IEEE80211_TX_RC_VHT_MCS). The entire tx reporting side does not
support S1G widths and is assumed to be handled by the driver so
we can just remove the entire function.

Fixes: 12bf8fad4ca3 ("mac80211: initialize last_rate for S1G STAs")
Signed-off-by: Lachlan Hodges <lachlan.hodges@morsemicro.com>
Link: https://patch.msgid.link/20260827054456.254573-1-lachlan.hodges@morsemicro.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: dropped the ml_reconf_resp caller hunk since that function doesn't exist here, and adjusted the rate_control_rate_init() hunk to use struct sta_info *sta instead of struct link_sta_info *. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ieee80211_i.h |  1 -
 net/mac80211/mlme.c        | 12 ++++--------
 net/mac80211/rate.c        |  1 -
 net/mac80211/s1g.c         |  8 --------
 4 files changed, 4 insertions(+), 18 deletions(-)

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index c4dc2553454d1..09ef315c9c3f5 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2250,7 +2250,6 @@ ieee80211_he_op_ie_to_bss_conf(struct ieee80211_vif *vif,
 			const struct ieee80211_he_operation *he_op_ie_elem);
 
 /* S1G */
-void ieee80211_s1g_sta_rate_init(struct sta_info *sta);
 bool ieee80211_s1g_is_twt_setup(struct sk_buff *skb);
 void ieee80211_s1g_rx_twt_action(struct ieee80211_sub_if_data *sdata,
 				 struct sk_buff *skb);
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 7fd8fbe3400d3..3a08bb4dfca50 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -5044,7 +5044,6 @@ static bool ieee80211_assoc_config_link(struct ieee80211_link_data *link,
 }
 
 static int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
-					struct sta_info *sta,
 					struct link_sta_info *link_sta,
 					struct cfg80211_bss *cbss)
 {
@@ -5059,11 +5058,9 @@ static int ieee80211_mgd_setup_link_sta(struct ieee80211_link_data *link,
 	memcpy(link_sta->addr, cbss->bssid, ETH_ALEN);
 	memcpy(link_sta->pub->addr, cbss->bssid, ETH_ALEN);
 
-	/* TODO: S1G Basic Rate Set is expressed elsewhere */
-	if (cbss->channel->band == NL80211_BAND_S1GHZ) {
-		ieee80211_s1g_sta_rate_init(sta);
+	/* S1G does not use basic rates */
+	if (cbss->channel->band == NL80211_BAND_S1GHZ)
 		return 0;
-	}
 
 	sband = local->hw.wiphy->bands[cbss->channel->band];
 
@@ -5676,7 +5673,7 @@ static bool ieee80211_assoc_success(struct ieee80211_sub_if_data *sdata,
 			}
 		}
 
-		err = ieee80211_mgd_setup_link_sta(link, sta, link_sta,
+		err = ieee80211_mgd_setup_link_sta(link, link_sta,
 						   assoc_data->link[link_id].bss);
 		if (err)
 			goto out_err;
@@ -8270,8 +8267,7 @@ static int ieee80211_prep_connection(struct ieee80211_sub_if_data *sdata,
 			goto out_err;
 		}
 
-		err = ieee80211_mgd_setup_link_sta(link, new_sta,
-						   link_sta, cbss);
+		err = ieee80211_mgd_setup_link_sta(link, link_sta, cbss);
 		if (err) {
 			rcu_read_unlock();
 			sta_info_free(local, new_sta);
diff --git a/net/mac80211/rate.c b/net/mac80211/rate.c
index 1b045b62961f5..3ce47278eae24 100644
--- a/net/mac80211/rate.c
+++ b/net/mac80211/rate.c
@@ -54,7 +54,6 @@ void rate_control_rate_init(struct sta_info *sta)
 
 	/* TODO: check for minstrel_s1g ? */
 	if (sband->band == NL80211_BAND_S1GHZ) {
-		ieee80211_s1g_sta_rate_init(sta);
 		rcu_read_unlock();
 		return;
 	}
diff --git a/net/mac80211/s1g.c b/net/mac80211/s1g.c
index 657f281adf10a..f8877f78541e1 100644
--- a/net/mac80211/s1g.c
+++ b/net/mac80211/s1g.c
@@ -9,14 +9,6 @@
 #include "ieee80211_i.h"
 #include "driver-ops.h"
 
-void ieee80211_s1g_sta_rate_init(struct sta_info *sta)
-{
-	/* avoid indicating legacy bitrates for S1G STAs */
-	sta->deflink.tx_stats.last_rate.flags |= IEEE80211_TX_RC_S1G_MCS;
-	sta->deflink.rx_stats.last_rate =
-			STA_STATS_FIELD(TYPE, STA_STATS_RATE_TYPE_S1G);
-}
-
 bool ieee80211_s1g_is_twt_setup(struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
-- 
2.53.0



