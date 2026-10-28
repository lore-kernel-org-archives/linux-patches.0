Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211306;
	b=IG0FNGNWUXtr1MXamAJxHyfWbIwoFcqs+4qGaQtfDBEpetLobXSfuk+G3Ps0n1lw8Mb2
	 Tb2BFf7OkTzl7tQDpwpJoINgnMRjusD3SayOc0f/9aEs1femOD5nfhlnhXIVoHJZGLRGq
	 5ldGWHzt0DZZC0AFUZtu+NnvNVvLTGfHtEeQYo8b7MGPknnPEDNN5ogCsx3GlRbiq+LLP
	 4FjQQ6YHs8y2syeBNzKmzRhqAz29ZQuspOtuPthL2TQesZT2C3dfRK2tgteV+Eyb1OM9z
	 kbBRKMFYSQNrvvnrECqQI9IxFrqQCNaDwAb/vE1pDjXQiPkmLfNLe8F+rxj8QJ2ljhQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=37VRYskBQULx6UP8f2elgCmqj9dEYZKtU2mK0pExhwo=;
	b=p6fMQ2GBm6NGrB/2J5QOrZ1n6suBBiX3H/3QwtvJMkVPjjNEPwnOXVw5b67VQQahjMyy
	 hfTANP5zN02txYeF8xQRl286lecM42N8yEC+Fv5CdKVybIvoK2iTonz6qVqMa+cJEY4fB
	 KAOVteXXNZudObGPNcID3CgtlUmI5U/JvJ5t7XlgM3Zrsb4rp9Ms1moBYqyena/HgVuRW
	 x82qlvgrScXGJ4/gPZU2QG5KFiOizA7rK3rRVFyXmQ7fGmi2fRakqNO4SDtOjVYTnsO5o
	 pXCqRM0Q7R9Sijnjawgu1Kse2RzaEfrn9Kz8KJTD660XMqQSfmsdKdEyZHSa2SOHuBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuQg7DMG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC686606A337;
	Wed, 28 Oct 2026 18:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IuQg7DMG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0431D1F01825;
	Wed, 28 Oct 2026 18:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211305;
	bh=37VRYskBQULx6UP8f2elgCmqj9dEYZKtU2mK0pExhwo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IuQg7DMG3Wf5L7wmCgF/NXD35Z1Z4C+cV/8oB3phy5daaWave248t8u+Lc3VFZ/lE
	 nZ9duVxdgKFyEiD/L7JkTmY/Nh5qzkuBf7A18BZ1JJ0qsV+AQEQs45MGxmeC946xuI
	 zN2F77jpJ3pCh3Nwoph8zlRSFIKstVvKSrF+NuJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 332/571] wifi: mac80211: count only matching reservations in reserved switch
Date: Wed, 28 Oct 2026 17:57:59 +0100
Message-ID: <20261028170015.884593391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiling Zou <zhilinz@nebusec.ai>

[ Upstream commit 437f3727b4fd715266c296435c116288f82666fd ]

ieee80211_vif_use_reserved_switch() validates a replacement by counting
assigned links on ctx->replace_ctx and treating reservations too
broadly. A link can still be assigned to the old channel context while
holding a reservation that belongs to a different replacement
operation.

That can make the current replacement appear complete too early. If
another link finalizes first, the function can free the
WILL_BE_REPLACED chanctx while the unmatched link and driver still use
it, leading to a use-after-free in later beacon generation.

Require an in-place reservation to point at the current replacement
context, and require the reserved and assigned contexts to be the
matching replacement pair, before counting or moving the link.

Fixes: 5bcae31d9cb1 ("mac80211: implement multi-vif in-place reservations")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
Link: https://patch.msgid.link/4b6c4b8648ab1920c38a40be32c0b1a2797b4ac6.1785726007.git.zhilinz@nebusec.ai
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
[ sashal: Adapted per-link reservation handling to the existing per-interface helpers and list traversal. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 84be216fcb7c2..f33bd3cc2a2dd 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1248,7 +1248,8 @@ ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
 }
 
 static bool
-ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
+ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_chanctx *old_ctx, *new_ctx;
 
@@ -1257,6 +1258,9 @@ ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
 	new_ctx = sdata->reserved_chanctx;
 	old_ctx = ieee80211_vif_get_chanctx(sdata);
 
+	if (new_ctx != ctx)
+		return false;
+
 	if (!old_ctx)
 		return false;
 
@@ -1269,6 +1273,12 @@ ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
 	if (new_ctx->replace_state != IEEE80211_CHANCTX_REPLACES_OTHER)
 		return false;
 
+	if (new_ctx->replace_ctx != old_ctx)
+		return false;
+
+	if (old_ctx->replace_ctx != new_ctx)
+		return false;
+
 	return true;
 }
 
@@ -1319,7 +1329,7 @@ static int ieee80211_chsw_switch_vifs(struct ieee80211_local *local,
 		list_for_each_entry(sdata, &ctx->reserved_vifs,
 				    reserved_chanctx_list) {
 			if (!ieee80211_vif_has_in_place_reservation(
-					sdata))
+					sdata, ctx))
 				continue;
 
 			old_ctx = ieee80211_vif_get_chanctx(sdata);
@@ -1426,7 +1436,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		list_for_each_entry(sdata, &ctx->replace_ctx->assigned_vifs,
 				    assigned_chanctx_list) {
 			n_assigned++;
-			if (sdata->reserved_chanctx) {
+			if (ieee80211_vif_has_in_place_reservation(sdata, ctx)) {
 				n_reserved++;
 				if (sdata->reserved_ready)
 					n_ready++;
@@ -1447,7 +1457,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		ctx->conf.radar_enabled = false;
 		list_for_each_entry(sdata, &ctx->reserved_vifs,
 				    reserved_chanctx_list) {
-			if (ieee80211_vif_has_in_place_reservation(sdata) &&
+			if (ieee80211_vif_has_in_place_reservation(sdata, ctx) &&
 			    !sdata->reserved_ready)
 				return -EAGAIN;
 
@@ -1517,7 +1527,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 				    reserved_chanctx_list) {
 			u32 changed = 0;
 
-			if (!ieee80211_vif_has_in_place_reservation(sdata))
+			if (!ieee80211_vif_has_in_place_reservation(sdata, ctx))
 				continue;
 
 			rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
@@ -1570,7 +1580,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
 					 reserved_chanctx_list) {
 			if (WARN_ON(ieee80211_vif_has_in_place_reservation(
-					sdata)))
+					sdata, ctx)))
 				continue;
 
 			if (WARN_ON(sdata->reserved_chanctx != ctx))
-- 
2.53.0



