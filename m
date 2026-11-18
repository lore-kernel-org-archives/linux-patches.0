Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054523;
	b=ik1t5SlEu5MmhGc1xs8kq0DfCLLkQVitomEWuaT1sTJcljpmL1ShzdjdMQoxFtLAj5Vl
	 D1h9dZrEXd3AV0Nkr1S2SqoYZSfDWy5FXmCxzGC0hRh8Hy4WxcQzCT/8vc0ku3xLmwr9q
	 iNp0GL+4mPo5xk5yVnHdpBkkYE1drQe+Ged1xCrfAxpFMlowR8hTfcdJz5DdlQzil7/SL
	 IMt/F+tH14z+dwke5FMMuufzmnKntqPbh60XGNCSS8RjWrz61z1NCOa5kce2DIt6EQpHR
	 Gz03Wwz7NzWJh2L3605pR4rTVxPiaiQ/m3QuA7WHHFZIttxvhD7WkqnA12ooRFQVTQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054523;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aR9QZsZjhHBv8W/34h8v4QWjroIwsZ4ocu9TroGwIWg=;
	b=mZb1Npq30+nbEJW0mB1FZ+mMoQ9wZ59h+huBOI03c2D0PlZtDN79EV3LPy+OhyZdU0i8
	 91fGmq4+q3YAIw4wA4Z/mB6x7I0cLxUgq2gZMsEP6XkrQ/uLw8Ay00yQbVU8cNttj7FSG
	 LNfX3uIQvry4oOVi+VqrJBiXZC1TAnmyy2uaN8u89EJChKVPRP7KPOmUqoS0QFFQPyjJx
	 rpJp+MtbwdrdtCz/7oCWNDe+41PaFyW2PIv1JRhMTwVoOTQ0dbFM4vcgzpx80HtBCfIwV
	 rb5obBv1Gd33MY6dH6CHZZIj9gdhwzBEWyjuEcfgZDhSKh+LydsEweRRHRcRlXxsbeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNnOu3eo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014ED606A320;
	Thu, 19 Nov 2026 02:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qNnOu3eo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B08671F000C4;
	Thu, 19 Nov 2026 02:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054522;
	bh=aR9QZsZjhHBv8W/34h8v4QWjroIwsZ4ocu9TroGwIWg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qNnOu3eoOKKzi8M8GldvGpZr3TgBGQZ2uIt6Zf/L82BcusCqW+7hyZ6LEP0nMalyx
	 FsVYyNkbNzhLPvPmuWv4wcV253fOblSxZsV9Bxe2xX6LLcPdTqcec8Vg3IN7DXEGW6
	 SkgjAC/q8QV31vPgx2C07XvkuDq3WZ7oGct+VWyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongbin Wang <wh_bin@126.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1305/2214] xfrm: Drop unused argument
Date: Wed, 18 Nov 2026 15:49:41 +0100
Message-ID: <20261118150103.709594591@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

From: Hongbin Wang <wh_bin@126.com>

[ Upstream commit 0de1978852dff8643a80f20a8f44cef3f16c2db0 ]

Drop unused argument from xfrm_policy_match,
__xfrm_policy_eval_candidates and xfrm_policy_eval_candidates.
No functional changes intended.

Signed-off-by: Hongbin Wang <wh_bin@126.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 868f63c8bfaf ("xfrm: retry inexact policy lookup after node reinsertion")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_policy.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/xfrm/xfrm_policy.c b/net/xfrm/xfrm_policy.c
index 15d50b5a22ef1..9e18e8d2c1c5c 100644
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -1908,7 +1908,7 @@ EXPORT_SYMBOL(xfrm_policy_walk_done);
  */
 static int xfrm_policy_match(const struct xfrm_policy *pol,
 			     const struct flowi *fl,
-			     u8 type, u16 family, int dir, u32 if_id)
+			     u8 type, u16 family, u32 if_id)
 {
 	const struct xfrm_selector *sel = &pol->selector;
 	int ret = -ESRCH;
@@ -2033,7 +2033,7 @@ static struct xfrm_policy *
 __xfrm_policy_eval_candidates(struct hlist_head *chain,
 			      struct xfrm_policy *prefer,
 			      const struct flowi *fl,
-			      u8 type, u16 family, int dir, u32 if_id)
+			      u8 type, u16 family, u32 if_id)
 {
 	u32 priority = prefer ? prefer->priority : ~0u;
 	struct xfrm_policy *pol;
@@ -2047,7 +2047,7 @@ __xfrm_policy_eval_candidates(struct hlist_head *chain,
 		if (pol->priority > priority)
 			break;
 
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err != -ESRCH)
 				return ERR_PTR(err);
@@ -2072,7 +2072,7 @@ static struct xfrm_policy *
 xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 			    struct xfrm_policy *prefer,
 			    const struct flowi *fl,
-			    u8 type, u16 family, int dir, u32 if_id)
+			    u8 type, u16 family, u32 if_id)
 {
 	struct xfrm_policy *tmp;
 	int i;
@@ -2080,8 +2080,7 @@ xfrm_policy_eval_candidates(struct xfrm_pol_inexact_candidates *cand,
 	for (i = 0; i < ARRAY_SIZE(cand->res); i++) {
 		tmp = __xfrm_policy_eval_candidates(cand->res[i],
 						    prefer,
-						    fl, type, family, dir,
-						    if_id);
+						    fl, type, family, if_id);
 		if (!tmp)
 			continue;
 
@@ -2120,7 +2119,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 
 	ret = NULL;
 	hlist_for_each_entry_rcu(pol, chain, bydst) {
-		err = xfrm_policy_match(pol, fl, type, family, dir, if_id);
+		err = xfrm_policy_match(pol, fl, type, family, if_id);
 		if (err) {
 			if (err == -ESRCH)
 				continue;
@@ -2139,7 +2138,7 @@ static struct xfrm_policy *xfrm_policy_lookup_bytype(struct net *net, u8 type,
 		goto skip_inexact;
 
 	pol = xfrm_policy_eval_candidates(&cand, ret, fl, type,
-					  family, dir, if_id);
+					  family, if_id);
 	if (pol) {
 		ret = pol;
 		if (IS_ERR(pol))
-- 
2.53.0



