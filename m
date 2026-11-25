Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625655;
	b=OhnLXuJp7QWMvGXqZZ67iFIltEj0tlSHIL1zbj2wOy5qhrH13tGIIz1mqIczQ8F23j/B
	 JZcNwCDeWXXJqFZotafi99iGctSG9SD4vobSV3b+4ZL0F58WaLpwLSs2xWrxFRftYAhF2
	 AqIhV2HngMJMfkRV8hHv66rMpcJF6/e84FoJrJi9oTx7tPG3ZFrelZtnaxFXZZSCoUmR8
	 itmRc9BjxZSReL2XTeHCLRR4E+Tcn7HxE5ykiY19Nq3XXanf7lLxxXQAAhDdzUGI1ynzo
	 tVfEYiWMn99VYeJED7CVkbd6sVo+BrWCP/kzW8sMrluEB7HOFH9AuULHCxy/Rp5WtpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ynax06NJnj67JedT6YOr2/IHfcimQuFuxsynJ1mFiME=;
	b=E4InPTKU9A2Be5wvHiVjm4MnqBDP13zKkGNjj0z4VlvZMFLh0s5hhu4iMGLGNl3xhUL/
	 DxPzErpUba9EifY1JyfpJ72ZrzKDAuVN1/xzMPDe1ub+OcMvU5QYRHzvIFJxmNCBYb8aB
	 jmPT7qjwuTM3VZcb8XhlevpSjmHVk4MBhWTzlQEZ72OFH3vtWf13dl66/cugnHYOgAFka
	 tQrZYFqLgHU/8nC9XOe6buypCYyAr2CR1oV6P3G0ivcPOk2SbDLYOuRqjMzs1zOe3P5Q8
	 dQXVq/jV91LxEdAEYKIXGEBzivH3eb0kkruUbh9IBziGRZGKVzM+8kc7pyDviP5bGyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drGOI7Fv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D54F606A327;
	Wed, 25 Nov 2026 16:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=drGOI7Fv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F32D61F000D4;
	Wed, 25 Nov 2026 16:54:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625654;
	bh=ynax06NJnj67JedT6YOr2/IHfcimQuFuxsynJ1mFiME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=drGOI7FvEdeyDUKIn+lG7OgqnxHaXU++miXNaDaMS4IVaEzXrnUysf1RfBoAK++Co
	 GukEWvYAC4UXd1i2DspJXEMjWN1ZGvsZQuBjCIgWvCmtt4xbo9R1grGou0JYjzNEzQ
	 Lwd0fOPJaD1y7psSQzQO73BXFUFW3MS0n+SlwFMM=
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
Subject: [PATCH 6.12 588/816] seg6: validate state in netfilter continuations
Date: Wed, 25 Nov 2026 15:35:36 +0100
Message-ID: <20261125143902.789229984@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -538,6 +554,17 @@ drop:
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
 	struct net_device *dev = skb_dst_dev(skb);
@@ -546,10 +573,10 @@ static int seg6_input_nf(struct sk_buff
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
@@ -624,6 +651,17 @@ drop:
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
 	struct net_device *dev = skb_dst_dev(skb);
@@ -631,10 +669,10 @@ static int seg6_output_nf(struct net *ne
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
@@ -24,6 +24,7 @@
 #include <net/addrconf.h>
 #include <net/ip6_route.h>
 #include <net/dst_cache.h>
+#include <net/dst_metadata.h>
 #include <net/ip_tunnels.h>
 #ifdef CONFIG_IPV6_SEG6_HMAC
 #include <net/seg6_hmac.h>
@@ -211,6 +212,21 @@ static struct seg6_local_lwt *seg6_local
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
@@ -939,6 +955,17 @@ static int input_action_end_dx6_finish(s
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
@@ -959,7 +986,7 @@ static int input_action_end_dx6(struct s
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_PRE_ROUTING,
 			       dev_net(skb->dev), NULL, skb, skb->dev,
-			       NULL, input_action_end_dx6_finish);
+			       NULL, input_action_end_dx6_finish_nf);
 
 	return input_action_end_dx6_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -1027,6 +1054,17 @@ static int input_action_end_dx4_finish(s
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
@@ -1047,7 +1085,7 @@ static int input_action_end_dx4(struct s
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV4, NF_INET_PRE_ROUTING,
 			       dev_net(skb->dev), NULL, skb, skb->dev,
-			       NULL, input_action_end_dx4_finish);
+			       NULL, input_action_end_dx4_finish_nf);
 
 	return input_action_end_dx4_finish(dev_net(skb->dev), NULL, skb);
 drop:
@@ -1680,6 +1718,17 @@ static int seg6_local_input_core(struct
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
@@ -1690,7 +1739,7 @@ static int seg6_local_input(struct sk_bu
 	if (static_branch_unlikely(&nf_hooks_lwtunnel_enabled))
 		return NF_HOOK(NFPROTO_IPV6, NF_INET_LOCAL_IN,
 			       dev_net(skb->dev), NULL, skb, skb->dev, NULL,
-			       seg6_local_input_core);
+			       seg6_local_input_core_nf);
 
 	return seg6_local_input_core(dev_net(skb->dev), NULL, skb);
 }


