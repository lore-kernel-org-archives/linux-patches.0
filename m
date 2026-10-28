Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208966;
	b=vZd4X92r0tNoBVVCKDvNSVnOOTIus2LwPMrvlPbkQvVvCXYCnUZ5EIC+Mdg0IsmMyBOK
	 lZKEtS7fKK5nmIwES5i9e65nNgcGaYJpFAdLO2xdu1X6iVriHnNPHLPhzO/xnX3et/H9j
	 ZzBSEORV+cmQEeJDsHWxkRDZV7V38M6HiZ8oYB9nHFejFPxTdyR6SIK2yRvFxkDZq9BxF
	 ap20YTXlhHdfYF851xA1cB6pDRNmQNQJt6vdAqOIUezs9n3jrwqkE0pQilgyQrXtHHbiO
	 75lM9l0kNJaWBTOrr8VSNPJaKMMS3S+owo/obzEtEN1gsJCjgif60HTechMDSsnmh/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208966;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/QBxW1LaK7JRIoLWH8fztNjDmIam4+Ks2CxLEGd99Kc=;
	b=LAsF5C4P1ZXr8wYzxSJeweytBadwrRoJmG3Gn08s2Kp/xdxnFpdBfbjWv7qgG/ZZTkOd
	 qZ6txpElc0TnXr7PhyB2UY+Dv6o4N5aCtyG4cq+PJgoECDcaZnBlld1ZtyxWn+M+OR9Y7
	 jw1akInUWx7AdO3MfNcWdUlQ2Y7gULbxiL9gu0CWxF7y9lA48YWHQwAZrbiJHnNQFdoV0
	 R+zrCGSfRVl73WFctw9XGecFg4iP1FJ/Wr9gFZI+wOaofu1LFGAoDA0JuSUHs0qYcyYV3
	 GDOgk/FSuJzjc+EYU50YhJi4sgOrTYrqsrnqMaVXw8ucdiU5IdsVR2edJjM+gMJqhUQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUcSWOt3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AED9F606A31E;
	Wed, 28 Oct 2026 17:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jUcSWOt3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C5261F01825;
	Wed, 28 Oct 2026 17:36:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208965;
	bh=/QBxW1LaK7JRIoLWH8fztNjDmIam4+Ks2CxLEGd99Kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jUcSWOt3+avLx7nmYto/0Fkx4g/Bd1miC4vrCOfVXpg0sEtPJ/+2im9Bl19aaXjur
	 INNzpW8Ir0nghGerQXeUPWoBa94nqEVBpEW+FVmJnhF7u3y+KXiCGvphkprpkr2LAM
	 q3aVNjQzW6OYNnmWEOE4T/YbuFUTEBzOVmve3Ltk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zhiling Zou <zhilinz@nebusec.ai>,
	Johannes Berg <johannes.berg@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 305/516] wifi: mac80211: count only matching reservations in reserved switch
Date: Wed, 28 Oct 2026 17:57:37 +0100
Message-ID: <20261028170010.714943644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted per-link reservation handling to per-vif sdata helpers and list iteration. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 0d0bb18a77e79..e00090d909e72 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -1154,7 +1154,8 @@ ieee80211_vif_use_reserved_assign(struct ieee80211_sub_if_data *sdata)
 }
 
 static bool
-ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
+ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata,
+				       struct ieee80211_chanctx *ctx)
 {
 	struct ieee80211_chanctx *old_ctx, *new_ctx;
 
@@ -1163,6 +1164,9 @@ ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
 	new_ctx = sdata->reserved_chanctx;
 	old_ctx = ieee80211_vif_get_chanctx(sdata);
 
+	if (new_ctx != ctx)
+		return false;
+
 	if (!old_ctx)
 		return false;
 
@@ -1175,6 +1179,12 @@ ieee80211_vif_has_in_place_reservation(struct ieee80211_sub_if_data *sdata)
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
 
@@ -1225,7 +1235,7 @@ static int ieee80211_chsw_switch_vifs(struct ieee80211_local *local,
 		list_for_each_entry(sdata, &ctx->reserved_vifs,
 				    reserved_chanctx_list) {
 			if (!ieee80211_vif_has_in_place_reservation(
-					sdata))
+					sdata, ctx))
 				continue;
 
 			old_ctx = ieee80211_vif_get_chanctx(sdata);
@@ -1332,7 +1342,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		list_for_each_entry(sdata, &ctx->replace_ctx->assigned_vifs,
 				    assigned_chanctx_list) {
 			n_assigned++;
-			if (sdata->reserved_chanctx) {
+			if (ieee80211_vif_has_in_place_reservation(sdata, ctx)) {
 				n_reserved++;
 				if (sdata->reserved_ready)
 					n_ready++;
@@ -1353,7 +1363,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		ctx->conf.radar_enabled = false;
 		list_for_each_entry(sdata, &ctx->reserved_vifs,
 				    reserved_chanctx_list) {
-			if (ieee80211_vif_has_in_place_reservation(sdata) &&
+			if (ieee80211_vif_has_in_place_reservation(sdata, ctx) &&
 			    !sdata->reserved_ready)
 				return -EAGAIN;
 
@@ -1423,7 +1433,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 				    reserved_chanctx_list) {
 			u32 changed = 0;
 
-			if (!ieee80211_vif_has_in_place_reservation(sdata))
+			if (!ieee80211_vif_has_in_place_reservation(sdata, ctx))
 				continue;
 
 			rcu_assign_pointer(sdata->vif.chanctx_conf, &ctx->conf);
@@ -1476,7 +1486,7 @@ static int ieee80211_vif_use_reserved_switch(struct ieee80211_local *local)
 		list_for_each_entry_safe(sdata, sdata_tmp, &ctx->reserved_vifs,
 					 reserved_chanctx_list) {
 			if (WARN_ON(ieee80211_vif_has_in_place_reservation(
-					sdata)))
+					sdata, ctx)))
 				continue;
 
 			if (WARN_ON(sdata->reserved_chanctx != ctx))
-- 
2.53.0



