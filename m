Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F8A1F2381;
	Thu, 12 Dec 2024 17:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023891; cv=none; b=YlLIqvHAZOJC5s/ZD29vlNlJR3lQoMfoNndxd0tkT5vadmvoP8glMQpWZXII2dxOVZeGzyzagOHRrixsOxs3HXEPYQAZ9Kv9mR+AkOv2lXuHE6tn7T7h6Dq2YbL6PZZxR/uiU1OHRedvK3nWdx+ZP7ekVrpzTfzOhM1dZ0do+NU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023891; c=relaxed/simple;
	bh=gtH36b3X3tmiDMwXgjnCAzO29icPx189TIHc5uvmV8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCHh+1HEEBSYZRk798inwRPhmybSUQiEPtk0BzpI2eNB/KrEuvuhkFw3P+3rSylgEL13jOTcbLSmsmxId7adhDMUYqzhNidajn0lgA5h41yYUppdMwvzwMy2/a9/YwtkOGMCrQeIiYrVXk5gMRGZX74ITlLddMDAYThbyN3TzXw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y0JYh8az; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y0JYh8az"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F409C4CECE;
	Thu, 12 Dec 2024 17:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023890;
	bh=gtH36b3X3tmiDMwXgjnCAzO29icPx189TIHc5uvmV8c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y0JYh8azQw5eP7w8UnTqyZtasXE/PuNnlv1n5Evjb7H/Oq1vks0tO4UgOAj/Fj0t7
	 hxP0eNSNZs+CyKcT7e2PC/8AAclGg0/nGnvIO62A/HEjYEKtonSMxFDfGNhMJeIklH
	 FZ2uoN4N9xSj48Zqd67I6b17hiWjczb0pHp0n1sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 115/459] xfrm: rename xfrm_state_offload struct to allow reuse
Date: Thu, 12 Dec 2024 15:57:33 +0100
Message-ID: <20241212144258.056124839@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 87e0a94e60ea2e29be9dec6bc146fbc9861a4055 ]

The struct xfrm_state_offload has all fields needed to hold information
for offloaded policies too. In order to do not create new struct with
same fields, let's rename existing one and reuse it later.

Reviewed-by: Raed Salem <raeds@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Acked-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Stable-dep-of: 2cf567f421db ("netdevsim: copy addresses for both in and out paths")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xfrm.h     | 10 +++++-----
 net/xfrm/xfrm_device.c |  2 +-
 net/xfrm/xfrm_state.c  |  4 ++--
 net/xfrm/xfrm_user.c   |  2 +-
 4 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/xfrm.h b/include/net/xfrm.h
index 798df30c2d253..987c603806aee 100644
--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -126,7 +126,7 @@ struct xfrm_state_walk {
 	struct xfrm_address_filter *filter;
 };
 
-struct xfrm_state_offload {
+struct xfrm_dev_offload {
 	struct net_device	*dev;
 	struct net_device	*real_dev;
 	unsigned long		offload_handle;
@@ -240,7 +240,7 @@ struct xfrm_state {
 	struct xfrm_lifetime_cur curlft;
 	struct hrtimer		mtimer;
 
-	struct xfrm_state_offload xso;
+	struct xfrm_dev_offload xso;
 
 	/* used to fix curlft->add_time when changing date */
 	long		saved_tmo;
@@ -1892,7 +1892,7 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
 {
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 
 	if (xso->dev && xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn)
 		xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn(x);
@@ -1918,7 +1918,7 @@ static inline bool xfrm_dst_offload_ok(struct dst_entry *dst)
 
 static inline void xfrm_dev_state_delete(struct xfrm_state *x)
 {
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 
 	if (xso->dev)
 		xso->dev->xfrmdev_ops->xdo_dev_state_delete(x);
@@ -1926,7 +1926,7 @@ static inline void xfrm_dev_state_delete(struct xfrm_state *x)
 
 static inline void xfrm_dev_state_free(struct xfrm_state *x)
 {
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 	struct net_device *dev = xso->dev;
 
 	if (dev && dev->xfrmdev_ops) {
diff --git a/net/xfrm/xfrm_device.c b/net/xfrm/xfrm_device.c
index 4d13f7a372ab6..61aa0fd9d2a0c 100644
--- a/net/xfrm/xfrm_device.c
+++ b/net/xfrm/xfrm_device.c
@@ -225,7 +225,7 @@ int xfrm_dev_state_add(struct net *net, struct xfrm_state *x,
 	int err;
 	struct dst_entry *dst;
 	struct net_device *dev;
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 	xfrm_address_t *saddr;
 	xfrm_address_t *daddr;
 
diff --git a/net/xfrm/xfrm_state.c b/net/xfrm/xfrm_state.c
index ba73014805a4f..94179ff475f2f 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -726,7 +726,7 @@ xfrm_dev_state_flush_secctx_check(struct net *net, struct net_device *dev, bool
 
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
 		struct xfrm_state *x;
-		struct xfrm_state_offload *xso;
+		struct xfrm_dev_offload *xso;
 
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			xso = &x->xso;
@@ -810,7 +810,7 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 	err = -ESRCH;
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
 		struct xfrm_state *x;
-		struct xfrm_state_offload *xso;
+		struct xfrm_dev_offload *xso;
 restart:
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			xso = &x->xso;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index e28e49499713f..b12a305a2d7a4 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -843,7 +843,7 @@ static int copy_sec_ctx(struct xfrm_sec_ctx *s, struct sk_buff *skb)
 	return 0;
 }
 
-static int copy_user_offload(struct xfrm_state_offload *xso, struct sk_buff *skb)
+static int copy_user_offload(struct xfrm_dev_offload *xso, struct sk_buff *skb)
 {
 	struct xfrm_user_offload *xuo;
 	struct nlattr *attr;
-- 
2.43.0



