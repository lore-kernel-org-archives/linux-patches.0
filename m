Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620068;
	b=wSKy1FKeMrZ0Xb4WuJrYpC3AP6f7rCBPksov4atoYA/t6aW7xBr1NbJmCpAw8I96EPit
	 hcdg80XPc10UA0rB/HPp2jICVs7cW9hpK0uq5WbYADUAZUWfdsM0QkIVcMV8mLLBPdiXo
	 URwtPeCUc3Wupb7StVYuTNuYjUAviM/YYsOtvvMqPVGmjGbZbsaqYfX//EOHgAyS8KAqI
	 5QbJ2nA7lX8Ym1Qko+p1O88750JMi85/Xvo/SMgsIU3rd7rtg50TlGrPcAJqMWRyp80iB
	 ZOlU+oXEYB/Glj1w9BUyYiECK2D7V5XcRuV0EkyGdvvT1Srt+hrm1siarlaO5NjIr2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620068;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsrAHTz6Ua1CEh7sRxzqG+FwM2SjMPg8x8Z4DYk0RGk=;
	b=pN4LaiQgsHPQpxvV2PPR1iYlxtn4c2f9PmmrIv4e/P3WcfOX2ObEdEXCVm7udLjn9m8n
	 E9L4aZpqf1FRVgRxyqEoPdpl2K3bwXp5eFd/3++p/h/uSxbJ+S+oOlo04ziYykuE5d+5n
	 TwUUroTMoYrtrDuk4jx2G1aEyUYzhVJDBERibpMKIeCj9zfLuMd2Jz3n/m+UDKM3P+niP
	 A/bWp40H5DaliihxFdqtHF1Yb0WGXN9h8/eolAOE/jZVTP0OdeUrhekz1+ae3HCJcu/1n
	 TCtXN1VFFO0yofusZpR97ufUJ1ZABGRxuqebz6h9PRH/lWe/8Hhkm4dg/AtRrw/QEMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU8mG3fC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9CA606A321;
	Wed, 25 Nov 2026 15:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZU8mG3fC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98A6A1F000C6;
	Wed, 25 Nov 2026 15:21:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620068;
	bh=nsrAHTz6Ua1CEh7sRxzqG+FwM2SjMPg8x8Z4DYk0RGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZU8mG3fCHCcmEh9WmCxmYs9bX3yEILZUS5pXP5HIo9JsOkClyhxM0SFOfluQVq3+1
	 nwRW3fU0RZKA4Ajk5BDfyStwoxQPhSkRV7VqHCqoTwjoQfgquGnPuamYuXJ+PTgXQX
	 u3KPn64DvlAgp2HD+HsEV9ggYsaTzkWTd1FbdQ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0799/1005] wifi: mac80211: drain link readers before stopping removed links
Date: Wed, 25 Nov 2026 15:35:37 +0100
Message-ID: <20261125143840.452879729@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: Zhao Li <enderaoelyther@gmail.com>

commit 745f5d04395dfc4c311f443c7c04ccb00c436984 upstream.

Removing an MLO link can leave work queued on its link container after
the container is freed.

ieee80211_tear_down_links() stops each link before the RCU grace period.
A reader that fetched the link earlier can therefore queue work after
ieee80211_link_stop() has canceled it. ieee80211_request_smps() and
ieee80211_csa_finish() can both reach this window.

Record each removed link while removing its keys and debugfs state. Wait
for RCU readers, then stop the recorded links so cancellation includes
work queued by those readers. Free the detached keys after the grace
period as before.

LLM assistance was used to find the bug and review.

Fixes: efe9c2bfd1a8 ("wifi: mac80211: isolate driver from inactive links")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141708.5532-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -191,6 +191,7 @@ struct link_container {
 static void ieee80211_tear_down_links(struct ieee80211_sub_if_data *sdata,
 				      struct link_container **links, u16 mask)
 {
+	struct ieee80211_link_data *stop[IEEE80211_MLD_MAX_NUM_LINKS] = {};
 	struct ieee80211_link_data *link;
 	LIST_HEAD(keys);
 	unsigned int link_id;
@@ -205,11 +206,16 @@ static void ieee80211_tear_down_links(st
 			continue;
 		ieee80211_remove_link_keys(link, &keys);
 		ieee80211_link_debugfs_remove(link);
-		ieee80211_link_stop(link);
+		stop[link_id] = link;
 	}
 
+	/* drain RCU readers before cancelling work they may queue */
 	synchronize_rcu();
 
+	for (link_id = 0; link_id < IEEE80211_MLD_MAX_NUM_LINKS; link_id++)
+		if (stop[link_id])
+			ieee80211_link_stop(stop[link_id]);
+
 	ieee80211_free_key_list(sdata->local, &keys);
 }
 


