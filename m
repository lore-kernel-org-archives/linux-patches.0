Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215692;
	b=QUcQcCLQ6k5nQQkKjocTxKb0oAatVcJgZJr7NrU1H9a/I8KeHx2mmbSvdoOwkcHcN+HY
	 jYXY+fz0fYacYXTxN0yiDLgR65iLcWr9VP/kOr1yrQIzQRSLvt3yBbZvb/eaOBxrbT3FT
	 iLM036krcFCLQrtzeSGocUeK0Da43q2wRZEAlNqUjnv4wBapEDzBBAizdlaIhQXepRq8Z
	 XISbN+7hZHaRbjHqM320k9RKaj5fhR9Ywy/eW6OGJCQ4f5aUKaNx34DLfx00knTEKduG1
	 TTNUVHEXDPj7QgLBIH8zYeS30UAnAM2DyfAokMI0/eQxlCWOGyyM7B3LjvF1/F/ySgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215692;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0K9TmcSl8xZZEag/MSo7UTFWo6iFgDirAxlJQhDSbY=;
	b=INUlIkPJrgw7gmgPhc9EDxDy1V58+qnEgrPdiQDtLKQ8pYj19Cf2beUypZul3LyYfbxv
	 tkR+Z7YZu65+fBb02HTVpaOLrTsAuhP31XkbOc+6531MhzZG51JA8K6yjmX7mDnuFXzOQ
	 yDVsUMtZaYCIHGgYvBL3FtecCiJLIU39nH6xubeO5IcbOKzjCiv9zgGORyH9JUfbNOziO
	 NStn9fRk2IZ2Ba1XLBSVD9asLnzaYoAU+fdIroaJ97r1S/l6AQap5deQADglFPp8lf/F2
	 YCsSYdn7WuU4BHougygUL821Nb2tAwGb46wUsT8S+ZLFgydzvVhy180S5zIS8lgY85g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu+Eja7+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CF2606A31A;
	Wed, 28 Oct 2026 19:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vu+Eja7+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0099C1F01825;
	Wed, 28 Oct 2026 19:28:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215691;
	bh=X0K9TmcSl8xZZEag/MSo7UTFWo6iFgDirAxlJQhDSbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vu+Eja7+BrkSBNTqGcG3/rth3H+P7dM17XOC9WWSHF5+IpNX/OMbafBAuhDIXmjUj
	 +NE2Acnom124Da+YngM9wb3l548Vib9Kw/XePM4+P2oCm8O+WIkgwnM6pKYc63+uTk
	 AS8GbZYTZar2NJjyZw0JPsoP8bwrWDFMikY1BhfM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Xue <feng.xue@outlook.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1299/1887] net/sched: cls_api: Always acquire rtnl_lock when destroying locked classifiers
Date: Wed, 28 Oct 2026 17:56:35 +0100
Message-ID: <20261028170528.987832868@linuxfoundation.org>
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

From: Jamal Hadi Salim <jhs@mojatatu.com>

[ Upstream commit a347304b2ca1a5377d5bd2d8a72e4b4f12afe648 ]

Another challenge with unlocked filters.
There is a short window in tc_new_tfilter where a tcf_proto can be found
and briefly referenced by a totally unrelated, unlocked classifier's request
and cause a race.

Feng created a poc which created this race with two threads, one creating a
u32 filter and other a flower filter in the same chain/prio:

1. Both threads enter tc_new_tfilter, both find the chain empty, both
   drop filter_chain_lock
2. u32 finishes tcf_proto_create("u32") first, calls
   tcf_chain_tp_insert_unique() -> inserts u32_tp into the chain
3. flower finishes tcf_proto_create("flower") later, calls
   tcf_chain_tp_insert_unique() -> tcf_chain_tp_find() now sees u32_tp
   already there, takes a reference on it, destroys flower's own tp_new
   and returns u32_tp to the caller.

Flower then hits the kind mismatch check (because it requested for kind
"flower" but tp->ops->kind is "u32") and goes through the errout path
which calls tcf_proto_put() on u32_tp. If the u32 thread has already
gone through its own errout (its change() call failed on the PoC's empty
options) and dropped its create and insert refs, flower's put is the
last one and drops u32_tp's refcnt to zero.

At this point tp->ops->destroy() runs in a context that never took
rtnl_lock. When that happens, it might cause a UAF like the following
(illustrated by the PoC):

[  +0.000710] BUG: KASAN: slab-use-after-free in u32_init (net/sched/cls_u32.c:393)
[  +0.000281] Read of size 8 at addr ffff888120022f00 by task poc_feng_xue/524

  Call Trace:
   u32_init (net/sched/cls_u32.c:393)
   tc_new_tfilter (net/sched/cls_api.c:2378)

  Allocated by task 526:
   u32_init (net/sched/cls_u32.c:378)
   tc_new_tfilter (net/sched/cls_api.c:2378)

  Freed by task 522:
   kfree
   u32_destroy (net/sched/cls_u32.c:662)
   tcf_proto_destroy (net/sched/cls_api.c:446)
   tcf_proto_put (net/sched/cls_api.c:459)
   tc_new_tfilter (net/sched/cls_api.c:2459)

Fix this by having tcf_proto_destroy() take rtnl_lock around
tp->ops->destroy() for locked classifiers whenever rtnl is not held.

To explain why I used a temp variable "not_lockless" I'd like to point to a
semi-related note on rtnl_held vs TCF_PROTO_OPS_DOIT_UNLOCKED (adding here
for future cleanup if deemed necessary):
The rtnl_held parameter and the TCF_PROTO_OPS_DOIT_UNLOCKED flag are
redundant sources of truth for whether rtnl_lock is held. Among the nine
classifier destroy(..rtnl_held..) callbacks, only flower consults the
rtnl_held parameter which it propagates to tc_setup_cb_destroy()
and tc_setup_cb_call(). The other eight (u32, flow, bpf, cgroup, route, basic,
fw, mall) ignore it entirely;-> those that call tc_setup_cb_destroy()
(u32, bpf, mall) hardcode true always instead of forwarding the parameter.

A future cleanup should remove the rtnl_held parameter from the destroy callback
signature entirely and have callers rely solely on their knowledge whether
they are running in an unlocked context.

Fixes: 12db03b65c2b ("net: sched: extend proto ops to support unlocked classifiers")
Reported-by: Feng Xue <feng.xue@outlook.com>
Tested-by: Victor Nogueira <victor@mojatatu.com>
Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
Link: https://patch.msgid.link/20260801125632.360365-1-jhs@mojatatu.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index ad8514da40c80..603b7caebad2b 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -338,7 +338,22 @@ static void tcf_chain_put(struct tcf_chain *chain);
 static void tcf_proto_destroy(struct tcf_proto *tp, bool rtnl_held,
 			      bool sig_destroy, struct netlink_ext_ack *extack)
 {
-	tp->ops->destroy(tp, rtnl_held, extack);
+	/* A locked classifier's destroy callback (e.g. u32_destroy) uses
+	 * rtnl_dereference() and mutates shared structures (e.g. the
+	 * tc_u_common hash list) that are only safe under rtnl_lock. When an
+	 * unlocked classifier's request (e.g. flower on ingress) loses the
+	 * tcf_chain_tp_insert_unique() race and ends up dropping the last
+	 * reference on a locked classifier's proto, destroy() would run
+	 * without rtnl held. Take it here in that case.
+	 */
+	bool not_lockless = !rtnl_held &&
+		!(tp->ops->flags & TCF_PROTO_OPS_DOIT_UNLOCKED);
+
+	if (not_lockless)
+		rtnl_lock();
+	tp->ops->destroy(tp, rtnl_held || not_lockless, extack);
+	if (not_lockless)
+		rtnl_unlock();
 	tcf_proto_count_usesw(tp, false);
 	if (sig_destroy)
 		tcf_proto_signal_destroyed(tp->chain, tp);
-- 
2.53.0



