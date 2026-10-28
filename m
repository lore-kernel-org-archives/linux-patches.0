Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212416;
	b=e65Vi9w8qGp8HMR41IzuRLvM24gxubVsdQlybLuTde+UbAZtmLXi9gT7VJL6gWrHE5lS
	 B/5EoiZ7gtHG4d6A5Dl75JAVqYmFlh8oeEvLWiPlaseIcAyRJNjiFPXdfSrLtZwu2whNk
	 rzkwZRDQNK/tQjwrQ64k3EMtI+1HxgBUKAMfPQTDIShGJIFF6VAKxn46D2ofA57PnEQKB
	 XNcpxXblafOGpqFKPLqPDvQoJi5JA2NGRfOS0E9Gh5xP83EL+oSNMpiZj8B057iRu011N
	 6/KdAt9CpV6KTE0cBBxm7L+OiQxp4yKy1EvfJ1f3YG2oGfvrvu36U+uj89f3wHgPyqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=52jHojn1fbc7JcgUC6gpb4PbtmanR81LbVHbgARVvKE=;
	b=20Iwc1WHcV2Bf6m4dwvXxy11X5H2OnIsjizmcRZHhFKjbOrYMP3DHoweN/MP4H8G1mX4
	 HJ/6BzGHXCJxAobYt8dMSNK8p7FUt7cgGPct96ndhwWWAPaVXKkyXBIE713akqMmrJRG4
	 Urkda/DWOifS+xODtbBhKUyYntSbvp3wM+Nml5vvQvpfTh5LvmnVIOXIqZgl1vaPXg8VS
	 b6KJsqZjUQ3SMSp0lXrB9L4IWNP5GsVYfBGnE2mAexJm6Ja2wS7QBl3u0VTP8hvJ91efY
	 TAtT0PIZRFV2n8Eb9dcIKTmfW/SOwG7OxqJlb6yGizzbPg0kbytVewzsAKKNKaJFiAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqmWzp52;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3047B606A324;
	Wed, 28 Oct 2026 18:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iqmWzp52
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812211F031E0;
	Wed, 28 Oct 2026 18:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212416;
	bh=52jHojn1fbc7JcgUC6gpb4PbtmanR81LbVHbgARVvKE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iqmWzp52XncMUd2P/8eKFv4eIbtMcCDVXridIW1AO27YpfBWpAfy53b5Z/9fLmeCU
	 1T6j3KVvFLbq22XTbVp5xkw6m6r/LyzO5tStjX+OXdwRz68xXP2tY72LLf/gAH26xb
	 0gcrROx4O2oKXzI9pwkSLkW1Ca8X0HPQer2Zjsa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Aaron Conole <aconole@redhat.om>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0145/1887] openvswitch: prepare for stolen verdict coming from conntrack and nat engine
Date: Wed, 28 Oct 2026 17:37:21 +0100
Message-ID: <20261028170502.536525682@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

[ Upstream commit c7f79f2620b7776586c626edf21eb6ed6ed3d1eb ]

At this time, conntrack either returns NF_ACCEPT or NF_DROP.
To improve debuging it would be nice to be able to replace NF_DROP
verdict with NF_DROP_REASON() helper,

This helper releases the skb instantly (so drop_monitor can pinpoint
precise location) and returns NF_STOLEN.

Prepare call sites to deal with this before introducing such changes
in conntrack and nat core.

Signed-off-by: Florian Westphal <fw@strlen.de>
Reviewed-by: Aaron Conole <aconole@redhat.om>
Signed-off-by: David S. Miller <davem@davemloft.net>

[Stable 6.1 adaptation: retain the local NAT implementation, which already
updates the flow key only on NF_ACCEPT, and return before restoring skb
headers on NF_STOLEN. Rename the existing OVS helper and pass its existing
connection and ctinfo explicitly so the following helper-UAF fix can use
the upstream call signature without importing the shared-helper refactor.
Use a single-evaluation verdict_to_errno macro instead of adding a function.
Remove the dead add_helper flag and align the helper-call condition with
1a4151e6be57; the flag was set only for unconfirmed connections but tested
only for confirmed ones. The helper relocation itself remains in the target.]

Stable-dep-of: 1a4151e6be57 ("net: openvswitch: conntrack: fix helper UAF due to extensions realloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/conntrack.c | 56 ++++++++++++++++++++++---------------
 1 file changed, 34 insertions(+), 22 deletions(-)

diff --git a/net/openvswitch/conntrack.c b/net/openvswitch/conntrack.c
index a7bb9e360ed37..8c5f6602af44a 100644
--- a/net/openvswitch/conntrack.c
+++ b/net/openvswitch/conntrack.c
@@ -435,16 +435,14 @@ static int ovs_ct_set_labels(struct nf_conn *ct, struct sw_flow_key *key,
 }
 
 /* 'skb' should already be pulled to nh_ofs. */
-static int ovs_ct_helper(struct sk_buff *skb, u16 proto)
+static int nf_ct_helper(struct sk_buff *skb, struct nf_conn *ct,
+			enum ip_conntrack_info ctinfo, u16 proto)
 {
 	const struct nf_conntrack_helper *helper;
 	const struct nf_conn_help *help;
-	enum ip_conntrack_info ctinfo;
 	unsigned int protoff;
-	struct nf_conn *ct;
 	int err;
 
-	ct = nf_ct_get(skb, &ctinfo);
 	if (!ct || ctinfo == IP_CT_RELATED_REPLY)
 		return NF_ACCEPT;
 
@@ -799,7 +797,7 @@ static void ovs_nat_update_key(struct sw_flow_key *key,
 
 /* Modelled after nf_nat_ipv[46]_fn().
  * range is only used for new, uninitialized NAT state.
- * Returns either NF_ACCEPT or NF_DROP.
+ * Returns NF_ACCEPT, NF_DROP or NF_STOLEN.
  */
 static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 			      enum ip_conntrack_info ctinfo,
@@ -874,6 +872,9 @@ static int ovs_ct_nat_execute(struct sk_buff *skb, struct nf_conn *ct,
 
 	err = nf_nat_packet(ct, ctinfo, hooknum, skb);
 push:
+	if ((err & NF_VERDICT_MASK) == NF_STOLEN)
+		return err;
+
 	skb_push_rcsum(skb, nh_off);
 
 	/* Update the flow key if NAT successful. */
@@ -951,6 +952,14 @@ static int ovs_ct_nat(struct net *net, struct sw_flow_key *key,
 }
 #endif
 
+/* Translate netfilter verdicts without evaluating the argument twice. */
+#define verdict_to_errno(verdict) ({					\
+	unsigned int __verdict = (verdict) & NF_VERDICT_MASK;		\
+									\
+	__verdict == NF_ACCEPT ? 0 :					\
+	__verdict == NF_STOLEN ? -EINPROGRESS : -EINVAL;			\
+})
+
 /* Pass 'skb' through conntrack in 'net', using zone configured in 'info', if
  * not done already.  Update key with new CT state after passing the packet
  * through conntrack.
@@ -1001,7 +1010,7 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 		err = nf_conntrack_in(skb, &state);
 		if (err != NF_ACCEPT)
-			return -ENOENT;
+			return verdict_to_errno(err);
 
 		/* Clear CT state NAT flags to mark that we have not yet done
 		 * NAT after the nf_conntrack_in() call.  We can actually clear
@@ -1015,8 +1024,6 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 
 	ct = nf_ct_get(skb, &ctinfo);
 	if (ct) {
-		bool add_helper = false;
-
 		/* Packets starting a new connection must be NATted before the
 		 * helper, so that the helper knows about the NAT.  We enforce
 		 * this by delaying both NAT and helper calls for unconfirmed
@@ -1028,9 +1035,12 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		 * the key->ct_state.
 		 */
 		if (info->nat && !(key->ct_state & OVS_CS_F_NAT_MASK) &&
-		    (nf_ct_is_confirmed(ct) || info->commit) &&
-		    ovs_ct_nat(net, key, info, skb, ct, ctinfo) != NF_ACCEPT) {
-			return -EINVAL;
+		    (nf_ct_is_confirmed(ct) || info->commit)) {
+			int err = ovs_ct_nat(net, key, info, skb, ct, ctinfo);
+
+			err = verdict_to_errno(err);
+			if (err)
+				return err;
 		}
 
 		/* Userspace may decide to perform a ct lookup without a helper
@@ -1045,7 +1055,6 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 							    GFP_ATOMIC);
 			if (err)
 				return err;
-			add_helper = true;
 
 			/* helper installed, add seqadj if NAT is required */
 			if (info->nat && !nfct_seqadj(ct)) {
@@ -1055,15 +1064,15 @@ static int __ovs_ct_lookup(struct net *net, struct sw_flow_key *key,
 		}
 
 		/* Call the helper only if:
-		 * - nf_conntrack_in() was executed above ("!cached") or a
-		 *   helper was just attached ("add_helper") for a confirmed
-		 *   connection, or
+		 * - nf_conntrack_in() was executed above ("!cached"), or
 		 * - When committing an unconfirmed connection.
 		 */
-		if ((nf_ct_is_confirmed(ct) ? !cached || add_helper :
-					      info->commit) &&
-		    ovs_ct_helper(skb, info->family) != NF_ACCEPT) {
-			return -EINVAL;
+		if ((nf_ct_is_confirmed(ct) ? !cached : info->commit)) {
+			int err = nf_ct_helper(skb, ct, ctinfo, info->family);
+
+			err = verdict_to_errno(err);
+			if (err)
+				return err;
 		}
 
 		if (nf_ct_protonum(ct) == IPPROTO_TCP &&
@@ -1291,10 +1300,9 @@ static int ovs_ct_commit(struct net *net, struct sw_flow_key *key,
 	/* This will take care of sending queued events even if the connection
 	 * is already confirmed.
 	 */
-	if (nf_conntrack_confirm(skb) != NF_ACCEPT)
-		return -EINVAL;
+	err = nf_conntrack_confirm(skb);
 
-	return 0;
+	return verdict_to_errno(err);
 }
 
 /* Trim the skb to the length specified by the IP/IPv6 header,
@@ -1357,6 +1365,10 @@ int ovs_ct_execute(struct net *net, struct sk_buff *skb,
 	else
 		err = ovs_ct_lookup(net, key, info, skb);
 
+	/* conntrack core returned NF_STOLEN */
+	if (err == -EINPROGRESS)
+		return err;
+
 	skb_push_rcsum(skb, nh_ofs);
 	if (err)
 		kfree_skb(skb);
-- 
2.53.0



