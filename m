Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215491;
	b=GHlK9InhctJWEo7oPfoLyoCvpVvhIVJ5/BtP38xf2kFPJw88lGtcAuKt3eZ/b1afCV6R
	 Cqoifq5rowuehjWyU1pHVOXi0uhijCarU8PQxhut6EQw61kQOGaghT0hUGHlf73+edER1
	 Y07mPDu97abLM2rM6se8A4eQYhQOLSa3u4yxvRuUwm2dyL1ehAB1fiqBRwyC/AEU13cXs
	 wqcuSpFh4QXJL57hr3jHQ1Ny2sWWv6GrwTxlV5YYsskk5HD/zR6G9kmABBxqyKnjj0jQs
	 trlW78wbf1xR+dkZRqfv3vu+tC5icRnqfLgQJf8UISIEH1VQObiq7cI9hcuW71EnVDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215491;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HdgiTrRbWkP+Cm87Y7qi+K1ydG0IlZ0UIvborv4x55s=;
	b=OaNbUrpDbCTu3QXh4Gbe/t92sR1TRqcZqw5DKBGb0n2b/0XdKOXByA3k7MPAoppV3IIk
	 EBbYHcLY23zAWcR44ZmsoplWSdXWKF1osiDhMKnO+LsNBEutaMLkmHS2+pi2pl3Zir2dB
	 3EZ9QEDv1VGJrtCEXJAxXmNDwkUVgiKea3AqN5n1ywY6zy1gpyl5NTWkl98RqAjTeR5aL
	 oc2259qkqkO4VWz00ZsBZVQ/ZQrsI0xwZCCw/nyGdvW9/5PXMQN0Fae/G4L5F1YY9dapA
	 jgRywAHIDR5uoNmsAHGRgRw9tUkcZHBOB+TGxhF/ADlc7HzL0o4OaomFOOcKl6Xo8Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fT4BIJ6R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846C5606A31A;
	Wed, 28 Oct 2026 19:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fT4BIJ6R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D101F01825;
	Wed, 28 Oct 2026 19:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215491;
	bh=HdgiTrRbWkP+Cm87Y7qi+K1ydG0IlZ0UIvborv4x55s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fT4BIJ6RCbwhKapORJuBVNXZkw0aICLMiVXVUYv5t6g3PVcV0vdP1KqxQDCz85jNS
	 AA5EjoJDMgAjOVSr7yFZvbLHdK4Io1QvE63x1aJaqbc+ZoPXQOAQ6UYXseh7KTtzD1
	 SDbabFqW2yCwX8eXAgr/XPI/epP8bwgsd1iTztR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes@sipsolutions.net>,
	Cen Zhang <zzzccc427@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1186/1887] wifi: cfg80211: use wiphy work for socket owner autodisconnect
Date: Wed, 28 Oct 2026 17:54:42 +0100
Message-ID: <20261028170526.395865429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cen Zhang <zzzccc427@gmail.com>

[ Upstream commit 0c2ed186bbe14304415476d6707b747dddcd8583 ]

nl80211_netlink_notify() walks the cfg80211 wireless device list when a
NETLINK_GENERIC socket is released. If the socket owns a connection, the
notifier queues the embedded wdev->disconnect_wk work item.

That work is a plain work_struct today. NETDEV_GOING_DOWN cancels it, but a
NETLINK_URELEASE notifier that already observed conn_owner_nlportid can
queue it after that cancel returns. _cfg80211_unregister_wdev() then
removes the wdev from the list and waits for RCU readers, but
synchronize_net() does not drain work queued by such a reader.

Make the autodisconnect work a wiphy_work instead. The callback already
needs the wiphy mutex, and wiphy_work runs under that mutex. This lets
teardown cancel pending autodisconnect work while holding the mutex,
without a cancel_work_sync() vs. worker locking concern.

Also cancel the wiphy work after list_del_rcu() and synchronize_net(). Any
NETLINK_URELEASE notifier that had already reached the wdev list has then
either queued the work and it is removed, or can no longer find the wdev.

Fixes: bd2522b16884 ("cfg80211: NL80211_ATTR_SOCKET_OWNER support for CMD_CONNECT")
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Assisted-by: Codex:gpt-5.5
Signed-off-by: Cen Zhang <zzzccc427@gmail.com>
Link: https://patch.msgid.link/20260706152418.779226-1-zzzccc427@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/cfg80211.h | 2 +-
 net/wireless/core.c    | 7 ++++---
 net/wireless/core.h    | 2 +-
 net/wireless/nl80211.c | 3 ++-
 net/wireless/sme.c     | 6 ++----
 5 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index 297a88a4e14e6..c41c032f84c59 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -5917,7 +5917,7 @@ struct wireless_dev {
 	enum ieee80211_bss_type conn_bss_type;
 	u32 conn_owner_nlportid;
 
-	struct work_struct disconnect_wk;
+	struct wiphy_work disconnect_wk;
 	u8 disconnect_bssid[ETH_ALEN];
 
 	struct list_head event_list;
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 6f83ea71b7605..972d785319593 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -1216,6 +1216,7 @@ static void _cfg80211_unregister_wdev(struct wireless_dev *wdev,
 	list_del_rcu(&wdev->list);
 	synchronize_net();
 	rdev->devlist_generation++;
+	wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
 
 	cfg80211_mlme_purge_registrations(wdev);
 
@@ -1404,7 +1405,7 @@ void cfg80211_init_wdev(struct wireless_dev *wdev)
 	     wdev->iftype == NL80211_IFTYPE_ADHOC) && !wdev->use_4addr)
 		wdev->netdev->priv_flags |= IFF_DONT_BRIDGE;
 
-	INIT_WORK(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
+	wiphy_work_init(&wdev->disconnect_wk, cfg80211_autodisconnect_wk);
 }
 
 void cfg80211_register_wdev(struct cfg80211_registered_device *rdev,
@@ -1512,9 +1513,9 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 		wiphy_lock(&rdev->wiphy);
 		cfg80211_leave(rdev, wdev);
 		cfg80211_remove_links(wdev);
-		wiphy_unlock(&rdev->wiphy);
 		/* since we just did cfg80211_leave() nothing to do there */
-		cancel_work_sync(&wdev->disconnect_wk);
+		wiphy_work_cancel(wdev->wiphy, &wdev->disconnect_wk);
+		wiphy_unlock(&rdev->wiphy);
 		break;
 	case NETDEV_DOWN:
 		wiphy_lock(&rdev->wiphy);
diff --git a/net/wireless/core.h b/net/wireless/core.h
index 987c41b12856a..18f62a23b7052 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -427,7 +427,7 @@ void __cfg80211_port_authorized(struct wireless_dev *wdev, const u8 *bssid,
 				const u8 *td_bitmap, u8 td_bitmap_len);
 int cfg80211_mgd_wext_connect(struct cfg80211_registered_device *rdev,
 			      struct wireless_dev *wdev);
-void cfg80211_autodisconnect_wk(struct work_struct *work);
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work);
 
 /* SME implementation */
 void cfg80211_conn_work(struct work_struct *work);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index d749fa91f399b..dbd777ce43409 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -19798,7 +19798,8 @@ static int nl80211_netlink_notify(struct notifier_block * nb,
 				wdev->nl_owner_dead = true;
 				schedule_work(&rdev->destroy_work);
 			} else if (wdev->conn_owner_nlportid == notify->portid) {
-				schedule_work(&wdev->disconnect_wk);
+				wiphy_work_queue(wdev->wiphy,
+						 &wdev->disconnect_wk);
 			}
 
 			cfg80211_release_pmsr(wdev, notify->portid);
diff --git a/net/wireless/sme.c b/net/wireless/sme.c
index 5adf3912f5853..09d872835310b 100644
--- a/net/wireless/sme.c
+++ b/net/wireless/sme.c
@@ -1557,13 +1557,12 @@ int cfg80211_disconnect(struct cfg80211_registered_device *rdev,
  * Used to clean up after the connection / connection attempt owner socket
  * disconnects
  */
-void cfg80211_autodisconnect_wk(struct work_struct *work)
+void cfg80211_autodisconnect_wk(struct wiphy *wiphy, struct wiphy_work *work)
 {
 	struct wireless_dev *wdev =
 		container_of(work, struct wireless_dev, disconnect_wk);
-	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wdev->wiphy);
+	struct cfg80211_registered_device *rdev = wiphy_to_rdev(wiphy);
 
-	wiphy_lock(wdev->wiphy);
 	wdev_lock(wdev);
 
 	if (wdev->conn_owner_nlportid) {
@@ -1602,5 +1601,4 @@ void cfg80211_autodisconnect_wk(struct work_struct *work)
 	}
 
 	wdev_unlock(wdev);
-	wiphy_unlock(wdev->wiphy);
 }
-- 
2.53.0



