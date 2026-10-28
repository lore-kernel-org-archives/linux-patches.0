Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213147;
	b=hIs63eUc1RhAFrPPrhRfAxfYzXZy9xPbsBlrVzfEDQirHVVtD2aQiGajivJsFQOooB5A
	 J8C6AdwImYNX5owPsfZ4fT5c+ezZ1PutiBdbCBrn+ZmRdWUNph35oDQM/4OFwY32T5vxm
	 YR+GHKVM3N972sDQkKAAkdcK353Gh209kwWoDmB8j9JzkEe/FTqxwC540DGa62Akc+mLH
	 zARw4mT+q5qgxLZhVAZ8idpFRuCZYgPGwT+kz8Ev9DvHZt5K8ISSF+8bVRLFk6l3IY4Cj
	 /0m+dQwU5RRmEc5DIFIsKmTCKIUkl+ItqEY0q+rlk3Z8wkV3j0LTY4ZrZKG3tSgdufw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213147;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WC3vhkoK8BIbAZ8ucgLbOr4/wOvSpff4wWkd6XpZSNQ=;
	b=Uto8f1/ejvQwI2vKaeSCe36qJ/rhqgCQ0GwR5U5+ztFvXzs4TUyb+UF1mcsXpxwV6dCt
	 HjVC1Il8rZ17clWnCNqjvY4aj7p8Q/YZcbwBaribv1aOlGDBvygAZ2XwsfAs1r63NcZPL
	 ggpyorcHk9RsF583KxyCHPG8q94nKePYQVJowlQIKr9j73NtCKCxXu8z//vwf314j6Xeu
	 cGGLW66Xk4liU1zn9wTg+5vB9jlkdWLxnHB5KFSX3/uLQ46EDhrYMWSTwubAB3FVYnk8u
	 no6D9Mc3aGVnQMjlT/sthDSkOJhN2ciBuVxUCrjKSgdCvdrtTMIRXDE+tuj/YHMG7xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0IR5IRkI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CBE606A320;
	Wed, 28 Oct 2026 18:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0IR5IRkI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F41D1F01825;
	Wed, 28 Oct 2026 18:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213146;
	bh=WC3vhkoK8BIbAZ8ucgLbOr4/wOvSpff4wWkd6XpZSNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0IR5IRkISfqX/RSClzHiFXNSMlzqNgw6/6MsskONqy46bQtUQhejLFgzzbdXt/N5f
	 u+CFsPd3Ol9737TF4q2960mjlbbhyxwDmxslZoHfOJi0+WCvbnfCWJqA9Aa8vY+e6c
	 SZEgGbnqXEz0zmCiop1RoZmMONF3BsuSZElHYmNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0404/1887] wifi: mac80211: keep paired old chanctx alive
Date: Wed, 28 Oct 2026 17:41:40 +0100
Message-ID: <20261028170508.426914245@linuxfoundation.org>
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

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 3412e9a800786d1dec4a58367db1cba275e7ef11 ]

An in-place replacement keeps reciprocal replace_ctx pointers between
the old WILL_BE_REPLACED chanctx and the new REPLACES_OTHER chanctx.
However, the early free paths only consider assigned and reserved link
users when deciding whether to free the old chanctx.

That lets the old chanctx be freed too early while the replacement
partner still points back to it, either when the last assigned link is
released or when that link successfully reassigns to another existing
context. Later unreserve and switch-finalization paths can then follow a
stale replace_ctx pointer.

Keep a paired old chanctx alive until the replacement pair has been torn
down. Apply the same check to both __ieee80211_link_release_channel()
and ieee80211_link_use_reserved_reassign(). If the replacement is later
abandoned, ieee80211_link_unreserve_chanctx() already tears down the
pairing before freeing the old chanctx once no users remain.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/b9b582b0db3814f641648b8886bb50f9d68f93ac.1785730815.git.zhilinz@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: replaced ieee80211_chanctx_has_replace_partner() calls with inline checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 26e692a853d9b..81a6852cfb264 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1062,6 +1062,7 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 {
 	struct ieee80211_sub_if_data *sdata = link->sdata;
 	struct ieee80211_chanctx *ctx = link->reserved_chanctx;
+	struct ieee80211_chanctx *old_ctx = NULL;
 
 	lockdep_assert_held(&sdata->local->chanctx_mtx);
 
@@ -1076,6 +1077,7 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 			if (WARN_ON(!ctx->replace_ctx))
 				return -EINVAL;
 
+			old_ctx = ctx->replace_ctx;
 			WARN_ON(ctx->replace_ctx->replace_state !=
 			        IEEE80211_CHANCTX_WILL_BE_REPLACED);
 			WARN_ON(ctx->replace_ctx->replace_ctx != ctx);
@@ -1086,6 +1088,10 @@ int ieee80211_link_unreserve_chanctx(struct ieee80211_link_data *link)
 
 			list_del_rcu(&ctx->list);
 			kfree_rcu(ctx, rcu_head);
+
+			if (ieee80211_chanctx_refcount(sdata->local,
+						       old_ctx) == 0)
+				ieee80211_free_chanctx(sdata->local, old_ctx);
 		} else {
 			ieee80211_free_chanctx(sdata->local, ctx);
 		}
@@ -1317,7 +1323,9 @@ ieee80211_link_use_reserved_reassign(struct ieee80211_link_data *link)
 
 	ieee80211_check_fast_xmit_iface(sdata);
 
-	if (ieee80211_chanctx_refcount(local, old_ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, old_ctx) == 0 &&
+	    !(old_ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      old_ctx->replace_ctx))
 		ieee80211_free_chanctx(local, old_ctx);
 
 	ieee80211_recalc_chanctx_min_def(local, new_ctx, NULL);
@@ -1797,7 +1805,9 @@ static void __ieee80211_link_release_channel(struct ieee80211_link_data *link)
 	}
 
 	ieee80211_assign_link_chanctx(link, NULL);
-	if (ieee80211_chanctx_refcount(local, ctx) == 0)
+	if (ieee80211_chanctx_refcount(local, ctx) == 0 &&
+	    !(ctx->replace_state == IEEE80211_CHANCTX_WILL_BE_REPLACED &&
+	      ctx->replace_ctx))
 		ieee80211_free_chanctx(local, ctx);
 
 	link->radar_required = false;
-- 
2.53.0



