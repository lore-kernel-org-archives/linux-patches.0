Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E22F2236EA;
	Thu, 12 Dec 2024 16:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022167; cv=none; b=dvDCNCn0s1rLDgbCpgfqi5R6o8eM2yOIm8HmPBtrITh9zZiPumFFKwCmgfWdDEiUrHloVIYDK67hEh1iY+Fl9wkiRiF66VqPbE6pJ02JxOYKJbhcU5eBcCuTTj+bCg5hnSJJssH+MVGaMNlCCtY4P3KkCSJs4/lMnsTZ8n7Q6pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022167; c=relaxed/simple;
	bh=R/crO/NKGt7Abr2wMLExJe30ngcV9ZnL4w4YhUnTVto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNY4/EnYHonMg52yKT0AxOkLSzSLfWpUq45ruCN3cvxkr2HXtKV8KXvd1V8LH4cL3v1kEWSH2J9wSHNdjDymqBZ9PzscBLjj1JsQuQJuJ3oW352F6DY5fyu0Pa9GEDUrnnNpapQADY2mrNkrHCJl0k35iNnFfZGjQeboWLFOOFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x4nJfWdb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x4nJfWdb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82BEC4CECE;
	Thu, 12 Dec 2024 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022167;
	bh=R/crO/NKGt7Abr2wMLExJe30ngcV9ZnL4w4YhUnTVto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x4nJfWdbdqK4LY57+Dr3oR/r2JKfdWIJIyGfwMvfBJ6XCmFNgL4Dwq8dIGtwFLjZ3
	 23/1Y+ZQ3Q0h4yxIFKeBH+/oJHY0LNJpMk/A3OXHIkXqaOKbHEFSL0aegrr0tkAjbW
	 S9Wy6LuvJE7K2gLeVHhU/2H28/lZ1yvDQ2hKtBG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raed Salem <raeds@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 167/565] xfrm: rename xfrm_state_offload struct to allow reuse
Date: Thu, 12 Dec 2024 15:56:02 +0100
Message-ID: <20241212144318.078123712@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20ce2e1b3f61e..395d85eeb5d88 100644
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
@@ -246,7 +246,7 @@ struct xfrm_state {
 	struct xfrm_lifetime_cur curlft;
 	struct hrtimer		mtimer;
 
-	struct xfrm_state_offload xso;
+	struct xfrm_dev_offload xso;
 
 	/* used to fix curlft->add_time when changing date */
 	long		saved_tmo;
@@ -1885,7 +1885,7 @@ bool xfrm_dev_offload_ok(struct sk_buff *skb, struct xfrm_state *x);
 
 static inline void xfrm_dev_state_advance_esn(struct xfrm_state *x)
 {
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 
 	if (xso->dev && xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn)
 		xso->dev->xfrmdev_ops->xdo_dev_state_advance_esn(x);
@@ -1911,7 +1911,7 @@ static inline bool xfrm_dst_offload_ok(struct dst_entry *dst)
 
 static inline void xfrm_dev_state_delete(struct xfrm_state *x)
 {
-	struct xfrm_state_offload *xso = &x->xso;
+	struct xfrm_dev_offload *xso = &x->xso;
 
 	if (xso->dev)
 		xso->dev->xfrmdev_ops->xdo_dev_state_delete(x);
@@ -1919,7 +1919,7 @@ static inline void xfrm_dev_state_delete(struct xfrm_state *x)
 
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
index 60f3ea5561ddf..ff8159bae7bbf 100644
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -750,7 +750,7 @@ xfrm_dev_state_flush_secctx_check(struct net *net, struct net_device *dev, bool
 
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
 		struct xfrm_state *x;
-		struct xfrm_state_offload *xso;
+		struct xfrm_dev_offload *xso;
 
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			xso = &x->xso;
@@ -834,7 +834,7 @@ int xfrm_dev_state_flush(struct net *net, struct net_device *dev, bool task_vali
 	err = -ESRCH;
 	for (i = 0; i <= net->xfrm.state_hmask; i++) {
 		struct xfrm_state *x;
-		struct xfrm_state_offload *xso;
+		struct xfrm_dev_offload *xso;
 restart:
 		hlist_for_each_entry(x, net->xfrm.state_bydst+i, bydst) {
 			xso = &x->xso;
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index 1ebd54afe34c9..bb63b0dab87bd 100644
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



