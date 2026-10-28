Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216122;
	b=3hFo5vZSuqJp8tqd8Y2KajH/wS6rspzJMe042E8vRVYt8QWnq9DsO32HbEZM9lGPwXh2
	 sfh3hPnMI0hrAsdk8lkfzHadC7KIJx8VPolnOrZcIOfOuODOI1K78qRPkAnUzGDrKz+3g
	 VsB2PgmtzsELLFQukRgeQaizGg1Mlka9PrqkuMAQ81/iah4PCMsMQcQp+czBgWkyQeI/w
	 TXeDNgZCOYq0mvhfgB2GwwFZ/k759oyn1yBtfA5UD32uKWEVgKnqFhVfwUkTSoFVFdCyF
	 HSAPZkCyfDVcUkMYJ6tBMGUIxRvG3/rgTwcLOLnWqCfjv6TzXOyeEBBXU/BM+2S1h+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216122;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+l/EMqtnV/RDV60Y0Lvxb5gVMz+XwpgcJ9blwkdKrzI=;
	b=MtOCyOA/hZ3u9cFxOxC9oJbRNTZC30VCCzXKM/5AHKEr7vD0Jd1lrWHGGH+OolU+kfkj
	 5i1Cx2RuW/7eeWe8WRBUSXVSBrb99jQsNRippsEd4PdLvBEB0vEExysT0sk9hvNDr9S2d
	 M3gZXLMDdovGQZmlLadVJu0vW56AnigQeN0EZ/tKO0ZJsvwjRu/zf6fdQjEI3AcyUksyf
	 zE+L1nnY4cyqLvR8GVpaVhYuHgps8DvsPusNPhqBpTyI3kG7RxSW1NOfPdalk+nb8JOTf
	 yVCiWo164dw/aIApHqcx3i1E0o4aexWq8K7O5UyZ34MJ6YefX1HAENr/pK76D80SyHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrchpRXH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12F6606A31A;
	Wed, 28 Oct 2026 19:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IrchpRXH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AA141F01825;
	Wed, 28 Oct 2026 19:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216121;
	bh=+l/EMqtnV/RDV60Y0Lvxb5gVMz+XwpgcJ9blwkdKrzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IrchpRXHA2eQ3Os2VCRnLKNBebUJvm7D8c2XwC2K8BZyl4ShZ8cfWIy5PopHedHd+
	 pOdu+rWLGiSF/VFvV2EVgIvjz2PVbNt5HABqoBaxOO2RZAtYHGHv8l/fSLj2YYEOUA
	 wg9Fc9QZ7ozUfJmCAkTjaYNY/9OP2LoBZvcs2T0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1447/1887] netfilter: nf_tables: clone set on flush only
Date: Wed, 28 Oct 2026 17:59:03 +0100
Message-ID: <20261028170532.389278696@linuxfoundation.org>
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

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit fb7fb4016300ac622c964069e286dc83166a5d52 ]

Syzbot with fault injection triggered a failing memory allocation with
GFP_KERNEL which results in a WARN splat:

iter.err
WARNING: net/netfilter/nf_tables_api.c:845 at nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845, CPU#0: syz.0.17/5992
Modules linked in:
CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
RIP: 0010:nft_map_deactivate+0x34e/0x3c0 net/netfilter/nf_tables_api.c:845
Code: 8b 05 86 5a 4e 09 48 3b 84 24 a0 00 00 00 75 62 48 8d 65 d8 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 63 6d fa f7 90 <0f> 0b 90 43
+80 7c 35 00 00 0f 85 23 fe ff ff e9 26 fe ff ff 89 d9
RSP: 0018:ffffc900045af780 EFLAGS: 00010293
RAX: ffffffff89ca45bd RBX: 00000000fffffff4 RCX: ffff888028111e40
RDX: 0000000000000000 RSI: 00000000fffffff4 RDI: 0000000000000000
RBP: ffffc900045af870 R08: 0000000000400dc0 R09: 00000000ffffffff
R10: dffffc0000000000 R11: fffffbfff1d141db R12: ffffc900045af7e0
R13: 1ffff920008b5f24 R14: dffffc0000000000 R15: ffffc900045af920
FS:  000055557a6a5500(0000) GS:ffff888125496000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb5ea271fc0 CR3: 000000003269e000 CR4: 00000000003526f0
Call Trace:
 <TASK>
 __nft_release_table+0xceb/0x11f0 net/netfilter/nf_tables_api.c:12115
 nft_rcv_nl_event+0xc25/0xdb0 net/netfilter/nf_tables_api.c:12187
 notifier_call_chain+0x19d/0x3a0 kernel/notifier.c:85
 blocking_notifier_call_chain+0x6a/0x90 kernel/notifier.c:380
 netlink_release+0x123b/0x1ad0 net/netlink/af_netlink.c:761
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455

Restrict set clone to the flush set command in the preparation phase.
Add NFT_ITER_UPDATE_CLONE and use it for this purpose, update the rbtree
and pipapo backends to only clone the set when this iteration type is
used.

As for the existing NFT_ITER_UPDATE type, update the pipapo backend to
use the existing set clone if available, otherwise use the existing set
representation. After this update, there is no need to clone a set that
is being deleted, this includes bound anonymous set.

An alternative approach to NFT_ITER_UPDATE_CLONE is to add a .clone
interface and call it from the flush set path.

Reported-by: syzbot+4924a0edc148e8b4b342@syzkaller.appspotmail.com
Fixes: 3f1d886cc7c3 ("netfilter: nft_set_pipapo: move cloning of match info to insert/removal path")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c     | 10 +++++++++-
 net/netfilter/nft_set_pipapo.c    | 14 ++++++++++++--
 3 files changed, 23 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ab228acb04c4c..b2e49f3b2bf1c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -309,11 +309,13 @@ struct nft_set_elem {
  *
  * @NFT_ITER_READ: read-only iteration over set elements
  * @NFT_ITER_UPDATE: iteration under mutex to update set element state
+ * @NFT_ITER_UPDATE_CLONE: clone set before iteration under mutex to update element
  */
 enum nft_iter_type {
 	NFT_ITER_UNSPEC,
 	NFT_ITER_READ,
 	NFT_ITER_UPDATE,
+	NFT_ITER_UPDATE_CLONE,
 };
 
 struct nft_set;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index afc7f369b8f69..1a47904c377f7 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -628,6 +628,11 @@ static void nft_map_catchall_deactivate(const struct nft_ctx *ctx,
 	}
 }
 
+/* Use NFT_ITER_UPDATE iterator even if this may be called from the preparation
+ * phase, the set clone might already exist from a previous command, or it might
+ * be a set that is going away and does not require a clone. The netns and
+ * netlink release paths also need to work on the live set.
+ */
 static void nft_map_deactivate(const struct nft_ctx *ctx, struct nft_set *set)
 {
 	struct nft_set_iter iter = {
@@ -7076,9 +7081,12 @@ static int nft_set_catchall_flush(const struct nft_ctx *ctx,
 
 static int nft_set_flush(struct nft_ctx *ctx, struct nft_set *set, u8 genmask)
 {
+	/* The set backend might need to clone the set, do it now from the
+	 * preparation phase, use NFT_ITER_UPDATE_CLONE iterator type.
+	 */
 	struct nft_set_iter iter = {
 		.genmask	= genmask,
-		.type		= NFT_ITER_UPDATE,
+		.type		= NFT_ITER_UPDATE_CLONE,
 		.fn		= nft_setelem_flush,
 	};
 
diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.c
index 2e98592a04288..13cb3059744e5 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -2200,13 +2200,20 @@ static void nft_pipapo_walk(const struct nft_ctx *ctx, struct nft_set *set,
 	const struct nft_pipapo_match *m;
 
 	switch (iter->type) {
-	case NFT_ITER_UPDATE:
+	case NFT_ITER_UPDATE_CLONE:
 		m = pipapo_maybe_clone(set);
 		if (!m) {
 			iter->err = -ENOMEM;
 			return;
 		}
-
+		nft_pipapo_do_walk(ctx, set, m, iter);
+		break;
+	case NFT_ITER_UPDATE:
+		if (priv->clone)
+			m = priv->clone;
+		else
+			m = rcu_dereference_protected(priv->match,
+						      nft_pipapo_transaction_mutex_held(set));
 		nft_pipapo_do_walk(ctx, set, m, iter);
 		break;
 	case NFT_ITER_READ:
@@ -2387,6 +2394,9 @@ static void nft_pipapo_destroy(const struct nft_ctx *ctx,
 	if (m) {
 		rcu_barrier();
 
+		if (!priv->clone)
+			nft_set_pipapo_match_destroy(ctx, set, m);
+
 		for_each_possible_cpu(cpu)
 			pipapo_free_scratch(m, cpu);
 		free_percpu(m->scratch);
-- 
2.53.0



