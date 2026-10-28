Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215714;
	b=jQ0tw2sopntHbuy6ydJP6KgPm7WZbJUSbDjRIm4XNEO10cUsxqztsEVfqTC2t9/nEG0i
	 s87Zbl88OreU3Q5ggYcBJFsWrKKFGPgHvoup0RqmtgvKMU/U841IUFhTzNmt9ucAQn33/
	 frmppxtV6XMOxsPavZ9guAW+xrt9TjVfiA7d8k0ainUJ0dptMwi71RISo6I4dGyT8SL/O
	 5PYYsExHiRpa8nmwH5RuHD9UZxmK3ckqhuyhsgPIR79+pez+/2sTHL9QFBo5oyffu3oii
	 XOmPuPT5SU4wFTMja9cBdBb/CcxbkQdmWteh9hIBxsi6gv/DDhSi32YgsdkesgYIp2A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Jrubzk59NfibXJfAAG1/JonaFuMrekmGUBcRAY8rQw0=;
	b=LYAZxu6UDnJPdTiut6tB126MlYdxqgkl2riCRxnJ4P4CtXuFTRxmM297k4LcG5wyWwK8
	 aoovFDJjAqJzxMpidiD2nNnuc2shxftW6a8BNXb2/3g7z/FvzsrKrZg6E0SYzcFxMEifc
	 o3REWAyQBr1QAdIpJtFYOHmyK2vTbiHqhB+eHQd0/GhP5pdx09RG9sY/IfPdp4MQJ66vk
	 gl0iWeb72UClqHj5QA6RVWVluU8EznKu0ArPXrRt/IRNFFD/b2mg/4MpHrRJ8uMgHSl+o
	 EN8YV1vuHKrvupkHjgpk811QfAVZnz4o2Nc9CyBfy9rrgw03Q+XgjIEjq6HrPIr5f6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l65+3PWn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B0A1606A31F;
	Wed, 28 Oct 2026 19:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l65+3PWn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58821F01825;
	Wed, 28 Oct 2026 19:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215714;
	bh=Jrubzk59NfibXJfAAG1/JonaFuMrekmGUBcRAY8rQw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l65+3PWnAAiEsfQzBFd00gQMm8A5rRziFVPZXxbyXIvvhVr41H/JFlrQj8CGQ67Ow
	 IBinNEH4fU7CeZ3M0IHsfJC3XqBzMnbFfZY0DSTnKyfZ5guOKjBixpJmQcwPRxR1K+
	 yPHEQ45W9CKzS3gIagZssBbRfSBmGEKAIJRxm54M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1306/1887] net, sched: Make tc-related drop reason more flexible
Date: Wed, 28 Oct 2026 17:56:42 +0100
Message-ID: <20261028170529.150194985@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 54a59aed395ce0f4177b5212e5746a6462de3ad9 ]

Currently, the kfree_skb_reason() in sch_handle_{ingress,egress}() can only
express a basic SKB_DROP_REASON_TC_INGRESS or SKB_DROP_REASON_TC_EGRESS reason.

Victor kicked-off an initial proposal to make this more flexible by disambiguating
verdict from return code by moving the verdict into struct tcf_result and
letting tcf_classify() return a negative error. If hit, then two new drop
reasons were added in the proposal, that is SKB_DROP_REASON_TC_INGRESS_ERROR
as well as SKB_DROP_REASON_TC_EGRESS_ERROR. Further analysis of the actual
error codes would have required to attach to tcf_classify via kprobe/kretprobe
to more deeply debug skb and the returned error.

In order to make the kfree_skb_reason() in sch_handle_{ingress,egress}() more
extensible, it can be addressed in a more straight forward way, that is: Instead
of placing the verdict into struct tcf_result, we can just put the drop reason
in there, which does not require changes throughout various classful schedulers
given the existing verdict logic can stay as is.

Then, SKB_DROP_REASON_TC_ERROR{,_*} can be added to the enum skb_drop_reason
to disambiguate between an error or an intentional drop. New drop reason error
codes can be added successively to the tc code base.

For internal error locations which have not yet been annotated with a
SKB_DROP_REASON_TC_ERROR{,_*}, the fallback is SKB_DROP_REASON_TC_INGRESS and
SKB_DROP_REASON_TC_EGRESS, respectively. Generic errors could be marked with a
SKB_DROP_REASON_TC_ERROR code until they are converted to more specific ones
if it is found that they would be useful for troubleshooting.

While drop reasons have infrastructure for subsystem specific error codes which
are currently used by mac80211 and ovs, Jakub mentioned that it is preferred
for tc to use the enum skb_drop_reason core codes given it is a better fit and
currently the tooling support is better, too.

With regards to the latter:

  [...] I think Alastair (bpftrace) is working on auto-prettifying enums when
  bpftrace outputs maps. So we can do something like:

  $ bpftrace -e 'tracepoint:skb:kfree_skb { @[args->reason] = count(); }'
  Attaching 1 probe...
  ^C

  @[SKB_DROP_REASON_TC_INGRESS]: 2
  @[SKB_CONSUMED]: 34

  ^^^^^^^^^^^^ names!!

  Auto-magically. [...]

Add a small helper tcf_set_drop_reason() which can be used to set the drop reason
into the tcf_result.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jamal Hadi Salim <jhs@mojatatu.com>
Cc: Victor Nogueira <victor@mojatatu.com>
Link: https://lore.kernel.org/netdev/20231006063233.74345d36@kernel.org
Reviewed-by: Jakub Kicinski <kuba@kernel.org>
Link: https://lore.kernel.org/r/20231009092655.22025-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: f60b396ee174 ("net/sched: act_api: fix TOCTOU NULL deref on a->goto_chain")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/pkt_cls.h     | 6 ++++++
 include/net/sch_generic.h | 3 +--
 net/core/dev.c            | 6 ++++--
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index 2ef3c220d52ca..5671a05b744b0 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -181,6 +181,12 @@ __cls_set_class(unsigned long *clp, unsigned long cl)
 	return xchg(clp, cl);
 }
 
+static inline void tcf_set_drop_reason(struct tcf_result *res,
+				       enum skb_drop_reason reason)
+{
+	res->drop_reason = reason;
+}
+
 static inline void
 __tcf_bind_filter(struct Qdisc *q, struct tcf_result *r, unsigned long base)
 {
diff --git a/include/net/sch_generic.h b/include/net/sch_generic.h
index 9310e02d27c88..e16c97cd6ef91 100644
--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -327,7 +327,6 @@ struct Qdisc_ops {
 	struct module		*owner;
 };
 
-
 struct tcf_result {
 	union {
 		struct {
@@ -335,8 +334,8 @@ struct tcf_result {
 			u32		classid;
 		};
 		const struct tcf_proto *goto_tp;
-
 	};
+	enum skb_drop_reason		drop_reason;
 };
 
 struct tcf_chain;
diff --git a/net/core/dev.c b/net/core/dev.c
index 06f4f0f2421b4..1bf404303565e 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -4080,6 +4080,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	/* qdisc_skb_cb(skb)->pkt_len was already set by the caller. */
 	tc_skb_cb(skb)->mru = 0;
 	tc_skb_cb(skb)->post_ct = false;
+	cl_res.drop_reason = SKB_DROP_REASON_TC_EGRESS;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -4090,7 +4091,7 @@ sch_handle_egress(struct sk_buff *skb, int *ret, struct net_device *dev)
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
 		*ret = NET_XMIT_DROP;
-		kfree_skb_reason(skb, SKB_DROP_REASON_TC_EGRESS);
+		kfree_skb_reason(skb, cl_res.drop_reason ?: SKB_DROP_REASON_TC_EGRESS);
 		return NULL;
 	case TC_ACT_STOLEN:
 	case TC_ACT_QUEUED:
@@ -5273,6 +5274,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 	tc_skb_cb(skb)->mru = 0;
 	tc_skb_cb(skb)->post_ct = false;
 	skb->tc_at_ingress = 1;
+	cl_res.drop_reason = SKB_DROP_REASON_TC_INGRESS;
 	mini_qdisc_bstats_cpu_update(miniq, skb);
 
 	switch (tcf_classify(skb, miniq->block, miniq->filter_list, &cl_res, false)) {
@@ -5282,7 +5284,7 @@ sch_handle_ingress(struct sk_buff *skb, struct packet_type **pt_prev, int *ret,
 		break;
 	case TC_ACT_SHOT:
 		mini_qdisc_qstats_cpu_drop(miniq);
-		kfree_skb_reason(skb, SKB_DROP_REASON_TC_INGRESS);
+		kfree_skb_reason(skb, cl_res.drop_reason ?: SKB_DROP_REASON_TC_INGRESS);
 		*ret = NET_RX_DROP;
 		return NULL;
 	case TC_ACT_STOLEN:
-- 
2.53.0



