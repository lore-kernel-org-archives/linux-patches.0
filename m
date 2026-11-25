Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619628;
	b=X4FyExBuaKyyxfgUWzixmoQ3EM/MkFdEdThspPZ/ZN/3IhmMDFGr080fHK+/9hpTUGx0
	 Cqp/lcUs4F8kpVE8zQ46zTXpw4iXndrBNCXCjmujJKRIXpwP2vnhHZCYZGBZfzLBDMPFe
	 yy+U46TqwTd8ea0XrXXWSrgudK1yzglR3hXL00uHIjgntohPZgEFqFN/eciELyHYtCqwI
	 8bo1DFcHkh5s3Mz+OXhxEFqorXn6cB0QQOo4tpvLlpTOdDksdDU3k3nz4TxgApLZmhZvv
	 cf0MaGy97cNOhdCZ9qUumQU57+aKrZIRmfyoJXz1v5YX2qSfJ9JlsJY0RwYawKRXUqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619628;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3oZUyBU4F4B/aLskWSHAvGg+HsIvKK1m7wqq63e1vwc=;
	b=b2eKJVp5tQqXwrToZHoCT0mLoRGHbH4370nGuUtg0VqSPJ7TqMiPE5/TJM0k/YAkehs2
	 hyUuwFDtzssfuC6PU/G6XeQ0AQ4Arc6+WGZEeKqNVSbGS3IfE5CfbVGSFeUAQ/EVncs0W
	 2BOcAWSypechHAVSfExMfAMwT73AMaAecK8B3lmoNQtY7IvDr/P4al0tfTCFglXm6+Rhf
	 7ZBBUBuMGtEGrdLpt61tjj12yCbBlPTa4VfZO5xmFyAF4I06Yb1MzVFhdldZK6MBeucpb
	 N1eDOGyuqwWbtQiSV8+5SRBbIExKQzUUhQsFnI7/ueqyCuk+4Dbtxn2nVUK+wMzQpgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op3hnB5x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F51606A321;
	Wed, 25 Nov 2026 15:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Op3hnB5x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FCB1F000CF;
	Wed, 25 Nov 2026 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619627;
	bh=3oZUyBU4F4B/aLskWSHAvGg+HsIvKK1m7wqq63e1vwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Op3hnB5xY4eLqyH7sQZjWyogTwdmDoxQHByNoftld41VyBvzIb1XE47+SvDmG1Z/Z
	 +GbAIKZb5Aa4TITAwsc6xOXz0+6LNdZJlzaSY1DnKzBit5BjlusZZg/U1rUxbngDY/
	 NUnqqIpuaY2EjshLpakFBizlkqHnGid8H9YDPaZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Luxing Yin <root@tr0jan.top>,
	Zihan Xi <zihanx@nebusec.ai>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 7.3 0659/1005] netfilter: nf_dup: preserve guard across NFQUEUE reinjection
Date: Wed, 25 Nov 2026 15:33:17 +0100
Message-ID: <20261125143837.185709076@linuxfoundation.org>
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

From: Zihan Xi <zihanx@nebusec.ai>

commit 82052e5b5ec36504fe1b9c3c28a711a78fcacf37 upstream.

NFQUEUE can suspend traversal of a duplicated packet while the task-local
duplication guard is set. The output call then returns and clears the guard
before a later verdict resumes hook traversal.

Save the guard in the queue entry and restore it while reinjection
continues hook traversal. Preserve and restore the verdict task's prior
state, including nested synchronous reinjection.

Fixes: cd58bcd9787e ("netfilter: xt_TEE: have cloned packet travel through Xtables too")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Co-developed-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Luxing Yin <root@tr0jan.top>
Signed-off-by: Zihan Xi <zihanx@nebusec.ai>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/netfilter/nf_queue.h |    1 +
 net/netfilter/nf_queue.c         |    1 +
 net/netfilter/nfnetlink_queue.c  |   17 ++++++++++++++---
 3 files changed, 16 insertions(+), 3 deletions(-)

--- a/include/net/netfilter/nf_queue.h
+++ b/include/net/netfilter/nf_queue.h
@@ -23,6 +23,7 @@ struct nf_queue_entry {
 	struct net_device	*physout;
 #endif
 	struct nf_hook_state	state;
+	bool			in_nf_duplicate;
 	bool			nf_ct_is_unconfirmed;
 	u16			size; /* sizeof(entry) + saved route keys */
 
--- a/net/netfilter/nf_queue.c
+++ b/net/netfilter/nf_queue.c
@@ -219,6 +219,7 @@ static int __nf_queue(struct sk_buff *sk
 	*entry = (struct nf_queue_entry) {
 		.skb	= skb,
 		.skb_dev = skb->dev,
+		.in_nf_duplicate = current->in_nf_duplicate,
 		.state	= *state,
 		.hook_index = index,
 		.size	= sizeof(*entry) + route_key_size,
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -44,6 +44,7 @@
 #include <net/sock.h>
 #include <net/tcp_states.h>
 #include <net/netfilter/nf_queue.h>
+#include <net/net_debug.h>
 #include <net/netns/generic.h>
 
 #include <linux/atomic.h>
@@ -365,21 +366,30 @@ static void nf_reinject(struct nf_queue_
 	const struct nf_hook_entry *hook_entry;
 	const struct nf_hook_entries *hooks;
 	struct sk_buff *skb = entry->skb;
+	bool old_in_nf_duplicate;
 	const struct net *net;
 	unsigned int i;
 	int err;
 	u8 pf;
 
+	DEBUG_NET_WARN_ONCE(current->in_nf_duplicate &&
+			    !entry->in_nf_duplicate,
+			    "%s called with unexpected duplication guard",
+			    __func__);
+	local_bh_disable();
+	old_in_nf_duplicate = current->in_nf_duplicate;
+
 	net = entry->state.net;
 	pf = entry->state.pf;
 
+	current->in_nf_duplicate = entry->in_nf_duplicate;
 	hooks = nf_hook_entries_head(net, pf, entry->state.hook);
 
 	i = entry->hook_index;
 	if (!hooks || i >= hooks->num_hook_entries) {
 		kfree_skb_reason(skb, SKB_DROP_REASON_NETFILTER_DROP);
 		nf_queue_entry_free(entry);
-		return;
+		goto out;
 	}
 
 	hook_entry = &hooks->hooks[i];
@@ -402,9 +412,7 @@ next_hook:
 	switch (verdict & NF_VERDICT_MASK) {
 	case NF_ACCEPT:
 	case NF_STOP:
-		local_bh_disable();
 		entry->state.okfn(entry->state.net, entry->state.sk, skb);
-		local_bh_enable();
 		break;
 	case NF_QUEUE:
 		err = nf_queue(skb, &entry->state, i, verdict);
@@ -418,6 +426,9 @@ next_hook:
 	}
 
 	nf_queue_entry_free(entry);
+out:
+	current->in_nf_duplicate = old_in_nf_duplicate;
+	local_bh_enable();
 }
 
 /* return true if the entry has an unconfirmed conntrack attached that isn't owned by us


