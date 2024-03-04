Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06F191C6AB;
	Mon,  4 Mar 2024 21:54:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709589275; cv=none; b=oo3ginTWKufMx2IHZ17AB+gjbjRHK8p53+5OO8l4P2mrLySpPg4kPiZwkv2ZtJTAmT7Wj6jlcob+90gYbQTz8033Hau42JUd7uVxDmFLzPxi2PRLkKGTYP8b3Sy0jJTggr3qzNaB7WWXVVWe1BESmN6hQtgadKZm4mrgllfNtp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709589275; c=relaxed/simple;
	bh=hmlFIvBYn/eEyKYhNXbTmVcsREXCVybG+0F68q0pCac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GcNM1o6wY/liqb5ZgjnMRFEhFgw5O+T63H4ATVyShb9xs1fSay54+TPQBjeiRs5P2xdayI3vnwo6ARo3MpbWG3RABxEkgaOcZvSjxIbFD+gormsivbL/9GZtgiFSyE8GzQbCfHhh2tmnWt9s4svBXU/gV8GSeHxg9YD4BIbD/5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XzyyaIeh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XzyyaIeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8DEC433C7;
	Mon,  4 Mar 2024 21:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709589274;
	bh=hmlFIvBYn/eEyKYhNXbTmVcsREXCVybG+0F68q0pCac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XzyyaIeh+FahB8+cg86xnsiBAmW5JrJxCZI1OWRZHwgvCAwmQyNhMnddFolVP28KW
	 hkjJckMGb3TEr+GhDyLx7kEjeHwfAicaYQMvUYW/hhOyO0p9C+dUcWAgfPMrJQBbYI
	 IEK1zpkUAqtODdTedpivEUmkjtY2FB3E0cgInRjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 22/84] netfilter: make function op structures const
Date: Mon,  4 Mar 2024 21:23:55 +0000
Message-ID: <20240304211543.068927166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211542.332206551@linuxfoundation.org>
References: <20240304211542.332206551@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit 285c8a7a58158cb1805c97ff03875df2ba2ea1fe ]

No functional changes, these structures should be const.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Stable-dep-of: 62e7151ae3eb ("netfilter: bridge: confirm multicast packets before passing them up the stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netfilter.h            |  8 ++++----
 net/netfilter/core.c                 | 10 +++++-----
 net/netfilter/nf_conntrack_core.c    |  4 ++--
 net/netfilter/nf_conntrack_netlink.c |  4 ++--
 net/netfilter/nf_nat_core.c          |  2 +-
 net/netfilter/nfnetlink_queue.c      |  8 ++++----
 6 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index 64acdf22eb4fa..5a665034c30be 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -376,13 +376,13 @@ struct nf_nat_hook {
 				  enum ip_conntrack_dir dir);
 };
 
-extern struct nf_nat_hook __rcu *nf_nat_hook;
+extern const struct nf_nat_hook __rcu *nf_nat_hook;
 
 static inline void
 nf_nat_decode_session(struct sk_buff *skb, struct flowi *fl, u_int8_t family)
 {
 #if IS_ENABLED(CONFIG_NF_NAT)
-	struct nf_nat_hook *nat_hook;
+	const struct nf_nat_hook *nat_hook;
 
 	rcu_read_lock();
 	nat_hook = rcu_dereference(nf_nat_hook);
@@ -459,7 +459,7 @@ struct nf_ct_hook {
 			      const struct sk_buff *);
 	void (*attach)(struct sk_buff *nskb, const struct sk_buff *skb);
 };
-extern struct nf_ct_hook __rcu *nf_ct_hook;
+extern const struct nf_ct_hook __rcu *nf_ct_hook;
 
 struct nlattr;
 
@@ -474,7 +474,7 @@ struct nfnl_ct_hook {
 	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
 			   enum ip_conntrack_info ctinfo, s32 off);
 };
-extern struct nfnl_ct_hook __rcu *nfnl_ct_hook;
+extern const struct nfnl_ct_hook __rcu *nfnl_ct_hook;
 
 /**
  * nf_skb_duplicated - TEE target has sent a packet
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 5396d27ba6a71..aa3f7d3228fda 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -632,14 +632,14 @@ EXPORT_SYMBOL(nf_hook_slow_list);
 /* This needs to be compiled in any case to avoid dependencies between the
  * nfnetlink_queue code and nf_conntrack.
  */
-struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
+const struct nfnl_ct_hook __rcu *nfnl_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nfnl_ct_hook);
 
-struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
+const struct nf_ct_hook __rcu *nf_ct_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_ct_hook);
 
 #if IS_ENABLED(CONFIG_NF_CONNTRACK)
-struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
+const struct nf_nat_hook __rcu *nf_nat_hook __read_mostly;
 EXPORT_SYMBOL_GPL(nf_nat_hook);
 
 /* This does not belong here, but locally generated errors need it if connection
@@ -662,7 +662,7 @@ EXPORT_SYMBOL(nf_ct_attach);
 
 void nf_conntrack_destroy(struct nf_conntrack *nfct)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 
 	rcu_read_lock();
 	ct_hook = rcu_dereference(nf_ct_hook);
@@ -677,7 +677,7 @@ EXPORT_SYMBOL(nf_conntrack_destroy);
 bool nf_ct_get_tuple_skb(struct nf_conntrack_tuple *dst_tuple,
 			 const struct sk_buff *skb)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 	bool ret = false;
 
 	rcu_read_lock();
diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 779e41d1afdce..2a4222eefc894 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -2145,9 +2145,9 @@ static int __nf_conntrack_update(struct net *net, struct sk_buff *skb,
 				 struct nf_conn *ct,
 				 enum ip_conntrack_info ctinfo)
 {
+	const struct nf_nat_hook *nat_hook;
 	struct nf_conntrack_tuple_hash *h;
 	struct nf_conntrack_tuple tuple;
-	struct nf_nat_hook *nat_hook;
 	unsigned int status;
 	int dataoff;
 	u16 l3num;
@@ -2833,7 +2833,7 @@ int nf_conntrack_init_start(void)
 	return ret;
 }
 
-static struct nf_ct_hook nf_conntrack_hook = {
+static const struct nf_ct_hook nf_conntrack_hook = {
 	.update		= nf_conntrack_update,
 	.destroy	= nf_ct_destroy,
 	.get_tuple_skb  = nf_conntrack_get_tuple_skb,
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index c427f7625a3b5..1466015bc56dc 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1816,7 +1816,7 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 			  const struct nlattr *attr)
 	__must_hold(RCU)
 {
-	struct nf_nat_hook *nat_hook;
+	const struct nf_nat_hook *nat_hook;
 	int err;
 
 	nat_hook = rcu_dereference(nf_nat_hook);
@@ -2922,7 +2922,7 @@ static void ctnetlink_glue_seqadj(struct sk_buff *skb, struct nf_conn *ct,
 	nf_ct_tcp_seqadj_set(skb, ct, ctinfo, diff);
 }
 
-static struct nfnl_ct_hook ctnetlink_glue_hook = {
+static const struct nfnl_ct_hook ctnetlink_glue_hook = {
 	.build_size	= ctnetlink_glue_build_size,
 	.build		= ctnetlink_glue_build,
 	.parse		= ctnetlink_glue_parse,
diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index 2731176839228..b776b3af78ca2 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -1120,7 +1120,7 @@ static struct pernet_operations nat_net_ops = {
 	.size = sizeof(struct nat_net),
 };
 
-static struct nf_nat_hook nat_hook = {
+static const struct nf_nat_hook nat_hook = {
 	.parse_nat_setup	= nfnetlink_parse_nat_setup,
 #ifdef CONFIG_XFRM
 	.decode_session		= __nf_nat_decode_session,
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f4468ef3d0a94..8c96e01f6a023 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -225,7 +225,7 @@ find_dequeue_entry(struct nfqnl_instance *queue, unsigned int id)
 
 static void nfqnl_reinject(struct nf_queue_entry *entry, unsigned int verdict)
 {
-	struct nf_ct_hook *ct_hook;
+	const struct nf_ct_hook *ct_hook;
 	int err;
 
 	if (verdict == NF_ACCEPT ||
@@ -388,7 +388,7 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 	struct net_device *outdev;
 	struct nf_conn *ct = NULL;
 	enum ip_conntrack_info ctinfo = 0;
-	struct nfnl_ct_hook *nfnl_ct;
+	const struct nfnl_ct_hook *nfnl_ct;
 	bool csum_verify;
 	char *secdata = NULL;
 	u32 seclen = 0;
@@ -1115,7 +1115,7 @@ static int nfqnl_recv_verdict_batch(struct sk_buff *skb,
 	return 0;
 }
 
-static struct nf_conn *nfqnl_ct_parse(struct nfnl_ct_hook *nfnl_ct,
+static struct nf_conn *nfqnl_ct_parse(const struct nfnl_ct_hook *nfnl_ct,
 				      const struct nlmsghdr *nlh,
 				      const struct nlattr * const nfqa[],
 				      struct nf_queue_entry *entry,
@@ -1182,11 +1182,11 @@ static int nfqnl_recv_verdict(struct sk_buff *skb, const struct nfnl_info *info,
 {
 	struct nfnl_queue_net *q = nfnl_queue_pernet(info->net);
 	u_int16_t queue_num = ntohs(info->nfmsg->res_id);
+	const struct nfnl_ct_hook *nfnl_ct;
 	struct nfqnl_msg_verdict_hdr *vhdr;
 	enum ip_conntrack_info ctinfo;
 	struct nfqnl_instance *queue;
 	struct nf_queue_entry *entry;
-	struct nfnl_ct_hook *nfnl_ct;
 	struct nf_conn *ct = NULL;
 	unsigned int verdict;
 	int err;
-- 
2.43.0



