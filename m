Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216737;
	b=K54PCm/u2AUHFv7HWfSMGaGnje4Io8jRRqrYHN8sGh61b3/j3CWbfH8GnhJWi1IoUyJi
	 ToV7MHr5KFAHR6fadSuONbvPCZyYyggm82q+Kq00ogBS4CE7BFB0IEzLGO/268vDpIAE9
	 RSM3f3PGfdacGjordxwzrSlU+tIwHYP0I4DJWQAZE00UIX+V2e5uVww3FE5FMyO3o8GLV
	 /NovLwPEkOECkJwUUAFLbYmyJW0JAMeqOd2jLMdpQ/d4DURr/iCFc4uYbZYdmNVOI8XWS
	 U5iM+D4kRVFaulVwmG/stNXM6PkRrSRcZQ2rNZqZaI0Yt/jgTnEwsV1laUn1bbQ+pvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FB0LsekdqGoSi54UiQZg7qvlAZCcW7INMxMl6ThXAbo=;
	b=oGxrWQZTwgIU6GrLENmWGSbmX5ceDGU4VETT1IA3R2f5Je4FZx3gVfT5lvOuYyxCIYFx
	 9YiGrfmXdu7sJCBp7XDAT0k3HSvw9xA9OUy5MNazJDnA9Umwa/rH5x61lM4Gt/t1nZEFx
	 0e1Q2Qc5ab+Iw2czvo2k0tZmnaGWJEILfzLEYcXPQSuKZ/JnIvNIFhwOthueZ/KJ4dR7n
	 vw6SLS5TH8psKbuLG9bxfyfE10o4GW1SXXQyZf+8cz4sFjanZ4xP1oct3EKtArA6DLtve
	 pa6nEQvOFGjQNJkbnzEhOuG5uj2YGEL8K2Bb/R5yYhKC6QnMPB6NOvKFQhlETRCpiOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCISzmCA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445BC606A31A;
	Wed, 28 Oct 2026 19:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iCISzmCA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42A401F01825;
	Wed, 28 Oct 2026 19:45:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216736;
	bh=FB0LsekdqGoSi54UiQZg7qvlAZCcW7INMxMl6ThXAbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iCISzmCASiVMI3fuNqtqXVcv76jcafeHmCq/fuGzH0enzwtHMuOIItEtCntf/lbvM
	 PCUbfCQsz0X/k9LCwQIHvTgZOgluxwO2d8c4qrdmctlCsoL97gy72hMxVCqHVihVU/
	 szJz8vD+kV1WCPnD4HLgr4IHFxlsZjAJAvVsIajM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1662/1887] wifi: mac80211: ibss: wait for in-flight TX on disconnect
Date: Wed, 28 Oct 2026 18:02:38 +0100
Message-ID: <20261028170537.279558752@linuxfoundation.org>
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

From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>

[ Upstream commit d0e69d9afa59b93c30294eba89b1f15f69e91105 ]

While leaving an IBSS in ieee80211_ibss_disconnect() mac80211 flushes
stations, turns the carrier off and immediately tells the driver to
leave as well. While there may be synchronize_net() in station flush
and in this code later, packets can still be transmitted due to
cross-CPU race conditions after carrier off is set.
Therefore, it's possible for a race to happen where a TX to the
driver occurs while or after telling it to leave the IBSS. This can
be confusing to drivers, and in the case of iwlwifi leads to an
attempt to use invalid queues.

Move netif_carrier_off() to occur before sta_info_flush() during
IBSS disconnect, and add synchronize_net() if flushing didn't,
so that the synchronize_net() always happens between turning the
carrier off and telling the driver, avoiding this race.

Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Link: https://patch.msgid.link/20260706223751.da1ce439cc93.If5cf482f87ab98ce66dd48724e24c81fed236d3f@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/ibss.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/ibss.c b/net/mac80211/ibss.c
index 363e7e4fdd02b..f2d4c68cf3aa2 100644
--- a/net/mac80211/ibss.c
+++ b/net/mac80211/ibss.c
@@ -692,7 +692,9 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 
 	ifibss->state = IEEE80211_IBSS_MLME_SEARCH;
 
-	sta_info_flush(sdata);
+	netif_carrier_off(sdata->dev);
+	if (!sta_info_flush(sdata))
+		synchronize_net();
 
 	spin_lock_bh(&ifibss->incomplete_lock);
 	while (!list_empty(&ifibss->incomplete_stations)) {
@@ -706,8 +708,6 @@ static void ieee80211_ibss_disconnect(struct ieee80211_sub_if_data *sdata)
 	}
 	spin_unlock_bh(&ifibss->incomplete_lock);
 
-	netif_carrier_off(sdata->dev);
-
 	sdata->vif.cfg.ibss_joined = false;
 	sdata->vif.cfg.ibss_creator = false;
 	sdata->vif.bss_conf.enable_beacon = false;
@@ -737,7 +737,6 @@ static void ieee80211_csa_connection_drop_work(struct work_struct *work)
 	sdata_lock(sdata);
 
 	ieee80211_ibss_disconnect(sdata);
-	synchronize_rcu();
 	skb_queue_purge(&sdata->skb_queue);
 
 	/* trigger a scan to find another IBSS network to join */
@@ -1878,8 +1877,6 @@ int ieee80211_ibss_leave(struct ieee80211_sub_if_data *sdata)
 	memset(&ifibss->ht_capa, 0, sizeof(ifibss->ht_capa));
 	memset(&ifibss->ht_capa_mask, 0, sizeof(ifibss->ht_capa_mask));
 
-	synchronize_rcu();
-
 	skb_queue_purge(&sdata->skb_queue);
 
 	del_timer_sync(&sdata->u.ibss.timer);
-- 
2.53.0



