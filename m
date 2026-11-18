Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017572;
	b=3eJ3rMl00XADGQa1b7UXrpBfcfSJ7bkl05kC5GuSWn+n6dxPCyJH5QwTdGqrxTXlhmoM
	 dSZSue06T69PYlKSfqWkv+DGbb97i4lJGSVZTGJLLsx0U9umuFcquq6nQDOTDMwljLHQI
	 8D62/8UP/7kQFMtgf19pUG5bfM2vKDURTdpJr/P8W3bR79k80YPu9JBOpc9gSfdbzRuz1
	 fVAqkrnY1o0wi6S/31Dv0+iPnlmfru07e/jBPXRqhbkcUUhOz99wTcwWqTOriw/wQq5ju
	 w9NthRMZTMPa/igcH5V9ED3uHGGQ3Ina2lYwHdzwMNWblpVLgWoL6/Ws/E86nV7d4Nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017572;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4F6wLx8clrisXze5goiWHXCpqlLmaBb4T1Sh8JDnr7k=;
	b=RzeiXxuaChLaxOh0PewsKBrOOK+egBU0P3G2dYOsFIQ8iomGgpHT7YD41fXBESeviwTf
	 aTSbuMMz4DnGluY84AK1CcrUcVi/7Di9V2QKX0pxHS9dBXM7/NJG6z/irY8DzAzmz9bnX
	 DlnHIsNyMzhY57S2kv7WMWUBOLGG9LM71kg/uIwg0WoKDL2Y+S/gEADjKdN8lcjaRwXLA
	 wmWlBBfjHWPorcV7KsUvn+BExt2XW3g4rVxL/e//+G7OCNtR/fgoMfhrUbnkb9Albc7VW
	 XdVu6Gr7p+Xi0Ww+nVyqbnwoimaJdidRs579C3mOgfZKG6FBMSDXLqi628jDQ1GyGXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zokE43ie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2657D606A335;
	Wed, 18 Nov 2026 15:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zokE43ie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E9091F000C4;
	Wed, 18 Nov 2026 15:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017571;
	bh=4F6wLx8clrisXze5goiWHXCpqlLmaBb4T1Sh8JDnr7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zokE43iehMnngTHm8Jo5E2f0BaeClh1itGeIZkNEqIuGXqathpkeeXaHj3lOCqEEG
	 pHVqoQASolHhy7luC7upBaek8Awd8azK1z9cXwlj62iXWLs7V5Q1ax3mAlZ+Sb3AUL
	 XevNFpT+waHFbPAnqlNsDUwoVN+tKYFQcaOsYnwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0932/2651] wifi: mac80211: implement NAN non-evacuable channels
Date: Wed, 18 Nov 2026 15:36:12 +0100
Message-ID: <20261118150321.436876517@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>

[ Upstream commit e9e25a957842ba2667b75df40f5a73bfda934d7b ]

Implement the nan_set_non_evac_channels operation in mac80211. It marks
the provided channels as non-evacuable in the current local schedule and
clears the flag on all other channels. All provided channels must exist
in the current schedule, otherwise -ENOENT is returned.

ieee80211_nan_find_evac_chan() skips channels marked as non-evacuable
when selecting a channel to evacuate for concurrent operations.

Fixes: 42c9de58d990 ("wifi: mac80211: add NAN channel evacuation support")
Signed-off-by: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260921215936.ef5884349253.I38b685378c3557679ed6387922a94a7da821555c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/mac80211.h     |  2 ++
 net/mac80211/cfg.c         | 13 +++++++++++++
 net/mac80211/ieee80211_i.h |  2 ++
 net/mac80211/nan.c         | 33 +++++++++++++++++++++++++++++++++
 4 files changed, 50 insertions(+)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index ed6a5874ff965..3e918cecb5123 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -923,12 +923,14 @@ struct ieee80211_bss_conf {
  * @channel_entry: the Channel Entry blob as defined in Wi-Fi Aware
  *	(TM) 4.0 specification Table 100 (Channel Entry format for the NAN
  *	Availability attribute).
+ * @no_evacuate: if set, this channel must not be evacuated
  */
 struct ieee80211_nan_channel {
 	struct ieee80211_chan_req chanreq;
 	u8 needed_rx_chains;
 	struct ieee80211_chanctx_conf *chanctx_conf;
 	u8 channel_entry[6];
+	bool no_evacuate;
 };
 
 /**
diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index a1753335eb9d0..797d654c9221b 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -5987,6 +5987,18 @@ ieee80211_set_peer_nan_sched(struct wiphy *wiphy,
 	return ieee80211_nan_set_peer_sched(sdata, sched);
 }
 
+static int
+ieee80211_set_nan_non_evac_channels(struct wiphy *wiphy,
+				    struct wireless_dev *wdev,
+				    struct cfg80211_nan_non_evac_channels *channels)
+{
+	struct ieee80211_sub_if_data *sdata = IEEE80211_WDEV_TO_SUB_IF(wdev);
+
+	lockdep_assert_wiphy(wiphy);
+
+	return ieee80211_nan_set_non_evac_channels(sdata, channels);
+}
+
 const struct cfg80211_ops mac80211_config_ops = {
 	.add_virtual_intf = ieee80211_add_iface,
 	.del_virtual_intf = ieee80211_del_iface,
@@ -6105,4 +6117,5 @@ const struct cfg80211_ops mac80211_config_ops = {
 	.set_epcs = ieee80211_set_epcs,
 	.nan_set_local_sched = ieee80211_set_local_nan_sched,
 	.nan_set_peer_sched = ieee80211_set_peer_nan_sched,
+	.nan_set_non_evac_channels = ieee80211_set_nan_non_evac_channels,
 };
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index e53ee000c4e38..43f7971e99abb 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -2079,6 +2079,8 @@ int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_nan_local_sched *sched);
 int ieee80211_nan_set_peer_sched(struct ieee80211_sub_if_data *sdata,
 				 struct cfg80211_nan_peer_sched *sched);
+int ieee80211_nan_set_non_evac_channels(struct ieee80211_sub_if_data *sdata,
+					struct cfg80211_nan_non_evac_channels *channels);
 void ieee80211_nan_free_peer_sched(struct ieee80211_nan_peer_sched *sched);
 void ieee80211_nan_update_ndi_carrier(struct ieee80211_sub_if_data *ndi_sdata);
 struct ieee80211_nan_channel *
diff --git a/net/mac80211/nan.c b/net/mac80211/nan.c
index c7769da9617b5..dc14b5d676fcb 100644
--- a/net/mac80211/nan.c
+++ b/net/mac80211/nan.c
@@ -248,6 +248,35 @@ ieee80211_nan_find_free_channel(struct ieee80211_nan_sched_cfg *sched_cfg)
 	return NULL;
 }
 
+int
+ieee80211_nan_set_non_evac_channels(struct ieee80211_sub_if_data *sdata,
+				    struct cfg80211_nan_non_evac_channels *channels)
+{
+	struct ieee80211_nan_sched_cfg *sched_cfg = &sdata->vif.cfg.nan_sched;
+
+	/*
+	 * cfg80211 already validated that all provided channels belong to the
+	 * current schedule, so just clear all non-evacuable flags and set the
+	 * ones in the list.
+	 */
+	for (int j = 0; j < ARRAY_SIZE(sched_cfg->channels); j++)
+		sched_cfg->channels[j].no_evacuate = false;
+
+	for (int i = 0; i < channels->n_channels; i++) {
+		for (int j = 0; j < ARRAY_SIZE(sched_cfg->channels); j++) {
+			if (!sched_cfg->channels[j].chanreq.oper.chan)
+				continue;
+			if (cfg80211_chandef_identical(&sched_cfg->channels[j].chanreq.oper,
+						       &channels->chandefs[i])) {
+				sched_cfg->channels[j].no_evacuate = true;
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
 int ieee80211_nan_set_local_sched(struct ieee80211_sub_if_data *sdata,
 				  struct cfg80211_nan_local_sched *sched)
 {
@@ -785,6 +814,10 @@ ieee80211_nan_find_evac_chan(struct ieee80211_local *local,
 
 		usable_channels++;
 
+		/* No-evacuate channel is usable but cannot be evacuated */
+		if (chan->no_evacuate)
+			continue;
+
 		chan_ctx = container_of(chan->chanctx_conf,
 					struct ieee80211_chanctx, conf);
 
-- 
2.53.0



