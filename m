Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705416;
	b=2pl7ZjJAH2FvPAToQEv3MSCcKss0nHQNl2mDiLsJyDiaVdyRg0ndDxwwScf/7q+nisWF
	 BPd2SuKMlIYxHBSo3hZOeRQVnFb+3KV3mD8pscf65dNeGPvr3kdvPipcg8RfeF2/V0Qzt
	 hi1cm16FEdH9hTlJWxVP87WvzUzDApLoX8nLWocs5+pVlfgj/4bgxNYZeto0OtI9szrk1
	 YanN6bxguyac15uZLvTh2A0dXAZAzf59oP/5Qb12Fa0Bq4vj5JBVhDQ3Jho5Lyjq7Py1B
	 b7v6S8crd/AK6diF3vFwgRQ2MugX7moWMCirEUjoJBOWKNvXEAUlBumD92FwChjNr5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YsDOQvRhCBcUEe9YoO49zc40taW6BWl+xLa2RVLdSBc=;
	b=iZyw1wPEsyFB/EsJBCrRKMPWyCgMB8nLj3OdNkiiJK+Y10ZfuPNaONqzxwsdwtpYHlsK
	 pg++s1Nu0r8PZ0Ui4dibhLjeTAHEqH6hzFTQ5ZPxSAfLd4PtNOkGvDeg/WKmZdMKrYy4w
	 cqXNo4eKRfybedEdn0mocZbLvgPtSus5LVWAVyZC9YUtiV+kCzGhrLH9QaDx7kf4kL8HB
	 7LSKjG5cpg3vc1M2X4jQDVTa8KfeeF8QJWmOQCaZGr7GsvJWSc6V9sMO/EKW+KR7BLEJd
	 Gxiov3vORBk1NJ5iMmSB4fRDAUz52jJa35FO5HgYYPSyImL82s+BkR1HFhVnXVbKHHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4BqwNT+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2290B606A31C;
	Thu, 26 Nov 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v4BqwNT+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E91E1F000D0;
	Thu, 26 Nov 2026 15:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705415;
	bh=YsDOQvRhCBcUEe9YoO49zc40taW6BWl+xLa2RVLdSBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v4BqwNT+1CjBnOEJ2N+FoibwjaEYFHrYMr+jdcKW5qcrMjl8Sienk//O0ZaEOKqyq
	 3GDQrKsKgfuhCwhgoZ88mG4InF0SF1LSE3JbHGlf0/fJjjBGs/Qu3Y2m3Yakxg9ydw
	 n8t/7pT166KntpCuYD2uf+fwxeWdAO2tuhhJJem8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Sashiko <sashiko-bot@kernel.org>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	Hangbin Liu <liuhangbin@kylinos.cn>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 191/319] seg6: validate state in netfilter continuations
Date: Thu, 26 Nov 2026 15:39:19 +0100
Message-ID: <20261126144011.057008480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Zixuan Chai <petalzu987@gmail.com>

commit 549484dd3e80a721d51bd695f22a800d2e05bea1 upstream.

When nf_hooks_lwtunnel is enabled, End.DX4 sends decapsulated packets
through NF_INET_PRE_ROUTING. If DNAT changes the inner destination,
nf_nat_ipv4_pre_routing() drops skb_dst(), and the continuation then
dereferences the missing dst's lwtstate. This causes a KASAN NULL
pointer dereference and fatal exception panic.

End.DX6 has the same issue with IPv6 DNAT. In seg6_iptunnel,
POST_ROUTING SNAT with an outbound XFRM policy can replace the dst before
the continuation resumes.

Validate the current dst and expected lwtstate type in each NF_HOOK()
continuation before calling the existing handler. Drop packets with
missing or incompatible state while preserving direct no-hook paths.
The helpers return bool because callers only need a validity check.

Testing shows that the End.DX4 DNAT reproducer triggers a KASAN NULL
pointer dereference without this change and no longer does so with the
fix. The SNAT+ESP/XFRM reproducer also completes without the reported
fault. The in-tree End.DX4 netfilter forwarding selftest passes all four
bidirectional checks with nf_hooks_lwtunnel disabled and enabled.

Fixes: 7a3f5b0de364 ("netfilter: add netfilter hooks to SRv6 data plane")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260720204430.1886091-1-xmei5@asu.edu
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Reviewed-by: Hangbin Liu <liuhangbin@kylinos.cn>
Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/8574739acd6f5d9eb0a5640e893122619e9f79ef.1793726355.git.petalzu987@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/seg6_iptunnel.c |   46 +++++++++++++++++++++++++++++++++++----
 net/ipv6/seg6_local.c    |   55 ++++++++++++++++++++++++++++++++++++++++++++---
 2 files changed, 94 insertions(+), 7 deletions(-)

--- a/net/ipv6/seg6_iptunnel.c
+++ b/net/ipv6/seg6_iptunnel.c
@@ -18,6 +18,7 @@
 #include <net/ip6_fib.h>
 #include <net/route.h>
 #include <net/seg6.h>
+#include <net/dst_metadata.h>
 #include <linux/seg6.h>
 #include <linux/seg6_iptunnel.h>
 #include <net/addrconf.h>
@@ -58,6 +59,21 @@ static inline struct seg6_lwt *seg6_lwt_
 	return (struct seg6_lwt *)lwt->data;
 }
 
+static bool seg6_skb_has_lwtstate(struct sk_buff *skb)
+{
+	struct dst_entry *dst;
+
+	if (unlikely(!skb_valid_dst(skb)))
+		return false;
+
+	dst = skb_dst(skb);
+	if (unlikely(!dst->lwtstate ||
+		     dst->lwtstate->type != LWTUNNEL_ENCAP_SEG6))
+		return false;
+
+	return true;
+}
+
 static inline struct seg6_iptunnel_encap *
 seg6_encap_lwtunnel(struct lwtunnel_state *lwt)
 {
@@ -537,6 +553,17 @@ drop:
 	return err;
 }
 
+static int seg6_input_core_nf(struct net *net, struct sock *sk,
+			      struct sk_buff *skb)
+{
+	if (unlikely(!seg6_skb_has_lwtstate(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return seg6_input_core(net, sk, skb);
+}
+
 static int seg6_input_nf(struct sk_buff *skb)
 {
 	struct net_device *dev = skb_dst(skb)->dev;
@@ -545,10 +572,10 @@ static int seg6_input_nf(struct sk_buff
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, NULL,
-			       skb, NULL, dev, seg6_input_core);
+			       skb, NULL, dev, seg6_input_core_nf);
 	case htons(ETH_P_IPV6):
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, NULL,
-			       skb, NULL, dev, seg6_input_core);
+			       skb, NULL, dev, seg6_input_core_nf);
 	}
 
 	return -EINVAL;
@@ -623,6 +650,17 @@ drop:
 	return err;
 }
 
+static int seg6_output_core_nf(struct net *net, struct sock *sk,
+			       struct sk_buff *skb)
+{
+	if (unlikely(!seg6_skb_has_lwtstate(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return seg6_output_core(net, sk, skb);
+}
+
 static int seg6_output_nf(struct net *net, struct sock *sk, struct sk_buff *skb)
 {
 	struct net_device *dev = skb_dst(skb)->dev;
@@ -630,10 +668,10 @@ static int seg6_output_nf(struct net *ne
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_POST_ROUTING, net, sk, skb,
-			       NULL, dev, seg6_output_core);
+			       NULL, dev, seg6_output_core_nf);
 	case htons(ETH_P_IPV6):
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_POST_ROUTING, net, sk, skb,
-			       NULL, dev, seg6_output_core);
+			       NULL, dev, seg6_output_core_nf);
 	}
 
 	return -EINVAL;
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -23,6 +23,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <net/dst_cache.h>
+#include <net/dst_metadata.h>
 #include <net/ip_tunnels.h>
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
@@ -150,6 +151,21 @@ static struct seg6_local_lwt *seg6_local
 	return (struct seg6_local_lwt *)lwt->data;
 }
 
+static bool seg6_local_skb_has_lwtstate(struct sk_buff *skb)
+{
+	struct dst_entry *dst;
+
+	if (unlikely(!skb_valid_dst(skb)))
+		return false;
+
+	dst = skb_dst(skb);
+	if (unlikely(!dst->lwtstate ||
+		     dst->lwtstate->type != LWTUNNEL_ENCAP_SEG6_LOCAL))
+		return false;
+
+	return true;
+}
+
 static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 {
 	struct ipv6_sr_hdr *srh;
@@ -428,6 +444,17 @@ static int input_action_end_dx6_finish(s
 	return dst_input(skb);
 }
 
+static int input_action_end_dx6_finish_nf(struct net *net, struct sock *sk,
+					  struct sk_buff *skb)
+{
+	if (unlikely(!seg6_local_skb_has_lwtstate(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return input_action_end_dx6_finish(net, sk, skb);
+}
+
 /* decapsulate and forward to specified nexthop */
 static int input_action_end_dx6(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
@@ -448,7 +475,7 @@ static int input_action_end_dx6(struct s
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 			       dev_net(skb->dev), NULL, skb, skb->dev,
-			       NULL, input_action_end_dx6_finish);
+			       NULL, input_action_end_dx6_finish_nf);
 
 	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -482,6 +509,17 @@ static int input_action_end_dx4_finish(s
 	return dst_input(skb);
 }
 
+static int input_action_end_dx4_finish_nf(struct net *net, struct sock *sk,
+					  struct sk_buff *skb)
+{
+	if (unlikely(!seg6_local_skb_has_lwtstate(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return input_action_end_dx4_finish(net, sk, skb);
+}
+
 static int input_action_end_dx4(struct sk_buff *skb,
 				struct seg6_local_lwt *slwt)
 {
@@ -498,7 +536,7 @@ static int input_action_end_dx4(struct s
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 			       dev_net(skb->dev), NULL, skb, skb->dev,
-			       NULL, input_action_end_dx4_finish);
+			       NULL, input_action_end_dx4_finish_nf);
 
 	return input_action_end_dx4_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -1122,6 +1160,17 @@ static int seg6_local_input_core(struct
 	return rc;
 }
 
+static int seg6_local_input_core_nf(struct net *net, struct sock *sk,
+				    struct sk_buff *skb)
+{
+	if (unlikely(!seg6_local_skb_has_lwtstate(skb))) {
+		kfree_skb(skb);
+		return -EINVAL;
+	}
+
+	return seg6_local_input_core(net, sk, skb);
+}
+
 static int seg6_local_input(struct sk_buff *skb)
 {
 	if (skb->protocol != htons(ETH_P_IPV6)) {
@@ -1132,7 +1181,7 @@ static int seg6_local_input(struct sk_bu
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
 			       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
-			       seg6_local_input_core);
+			       seg6_local_input_core_nf);
 
 	return seg6_local_input_core(dev_net(skb->dev), NULL, skb);
 }


