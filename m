Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030543;
	b=dzgWej15bCZJxRNKklAW0AIxADjVmqMLah2a1a/tLOL6OkKqc+tmOsOyBqMhbigj7lO+
	 U0RT8lBwtQaBDJdp++rcF0kLHar+ziARHHrRiJRhuS1UgpUQgtKkQDscFhpaAAht+py6b
	 D5bWL1JR0w74LDk/3c6zfJQqnMdjuPhF0HEAhSRgRYGQwibO8byPr8EJ0fZLLCSdBF5tv
	 XiYUEQPZAXe1I/jj9600zVELqgMpU3M+HsZzsoG5BCxguNhbmqW6TsHY5LvNvVJWRyU9K
	 GhHHj9T2QPNhc1j/5D7IJX5sPXKeCl2gqPhYkunr+EwGQXQms1Tvg3q8vNMqcFe5fJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030543;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MF4bYb3QL18t8QQA2IP07+qXbVPL4/MujRp0TN8DDhg=;
	b=Xmz48Mz8k/dP0T8l6zBFWNiN5tH2c/OAOfFFlaTd8SxJYAmyH2UNqxx1K/8l9gnbTv+Q
	 5EPy2PSC6eKMhh37+Rpld3xhsukb/nsX8c4cujzvpqpvnbXdZMEWNoqazWdF4IMy/PFhZ
	 f5+ABHAOOdAeL6IqWdsMZZ8OY7bp9RbUhMpVfpcwTLVViB74n3DuhK7Lw+m7BNItGG9EV
	 /OF9HJ1GKjyisP8kiExGm/fRgCUsHLlt+PziRSBgkavAON9SPcUXhW7XPcMGTZUXmSwZs
	 NFa9SycGE+12vat7hmENrR09TZb8NNn/tPy5uOgYzZDGST9f/kvZLrCFlHqwb94Gs9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8P0iGp0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8301E606B103;
	Wed, 18 Nov 2026 19:35:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D8P0iGp0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7BF51F000C6;
	Wed, 18 Nov 2026 19:35:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030543;
	bh=MF4bYb3QL18t8QQA2IP07+qXbVPL4/MujRp0TN8DDhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D8P0iGp0vhe7Svh+0ABLkCqnf9Qi5Xg5WigTXAg6pcCvEUqL0V1PfqcpTg4C4O6LW
	 gY8mwCYJZDYoyvaOtgSSDE8CsN+a2OyZn8KbTMzXm25caPS6yQTSi9KZ2Ciw0t2DmJ
	 Wvjtq1t1G83RaPl8vIksESq+RwdejJx7SU5iAXbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuya Kusakabe <yuya.kusakabe@gmail.com>,
	Andrea Mayer <andrea.mayer@uniroma2.it>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0735/1756] seg6: fix HMAC validation when an extension header precedes the SRH
Date: Wed, 18 Nov 2026 15:47:42 +0100
Message-ID: <20261118150038.904579344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Yuya Kusakabe <yuya.kusakabe@gmail.com>

[ Upstream commit f9cb4d296d81adb0923546ca5d54fae57a81af52 ]

seg6_hmac_validate_skb() derived the SRH from skb_transport_header().
That only holds while the two coincide, which is not true on the
seg6_local input path.

ip6_rcv_core() leaves the transport header just past the IPv6 header.
A Hop-by-Hop options header is consumed before the route lookup and
advances it, but a Destination Options header is not: the seg6_local
lwtunnel is entered through an input redirect from the route lookup,
which bypasses the extension header handlers. The transport header
then still points at the Destination Options header while
seg6_get_srh() has located the real SRH further down the chain.

The HMAC is therefore computed over the Destination Options header,
and a packet carrying a valid HMAC TLV is dropped when
seg6_require_hmac is set. Such a packet is legitimate: RFC 8200 allows
Destination Options before a routing header, and get_srh() has walked
the header chain since commit 5829d70b0b6c ("ipv6: sr: fix get_srh() to
comply with IPv6 standard "RFC 8200"").

With a Fragment or an Authentication header in front of the SRH, the
same mistake also reads past the data pulled by seg6_get_srh(). This
happens before seg6_require_hmac is read, so the default configuration
is affected.

Reproduce by giving a node a seg6local End SID with
net.ipv6.conf.<dev>.seg6_require_hmac=1 and a key installed with
"ip sr hmac set <keyid> sha1", then sending

  IPv6 -> Destination Options -> SRH (carrying a valid HMAC TLV) -> payload

to that SID: it is dropped, while the same packet without the
Destination Options header passes.

Fixes: 5829d70b0b6c ("ipv6: sr: fix get_srh() to comply with IPv6 standard "RFC 8200"")
Assisted-by: LLM
Signed-off-by: Yuya Kusakabe <yuya.kusakabe@gmail.com>
Reviewed-by: Andrea Mayer <andrea.mayer@uniroma2.it>
Link: https://patch.msgid.link/20260926-b4-seg6-hmac-transport-header-v2-1-8087b76f6375@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/seg6_hmac.h | 3 ++-
 net/ipv6/exthdrs.c      | 2 +-
 net/ipv6/seg6_hmac.c    | 5 +----
 net/ipv6/seg6_local.c   | 6 +++---
 4 files changed, 7 insertions(+), 9 deletions(-)

diff --git a/include/net/seg6_hmac.h b/include/net/seg6_hmac.h
index 24f733b3e3fe9..0544e0595ff5d 100644
--- a/include/net/seg6_hmac.h
+++ b/include/net/seg6_hmac.h
@@ -48,7 +48,8 @@ extern int seg6_hmac_info_add(struct net *net, u32 key,
 extern int seg6_hmac_info_del(struct net *net, u32 key);
 extern int seg6_push_hmac(struct net *net, struct in6_addr *saddr,
 			  struct ipv6_sr_hdr *srh);
-extern bool seg6_hmac_validate_skb(struct sk_buff *skb);
+extern bool seg6_hmac_validate_skb(struct sk_buff *skb,
+				   struct ipv6_sr_hdr *srh);
 #ifdef CONFIG_IPV6_SEG6_HMAC
 extern int seg6_hmac_init(void);
 extern void seg6_hmac_exit(void);
diff --git a/net/ipv6/exthdrs.c b/net/ipv6/exthdrs.c
index 5d1e98ae18187..c4c541b1ef5d8 100644
--- a/net/ipv6/exthdrs.c
+++ b/net/ipv6/exthdrs.c
@@ -390,7 +390,7 @@ static int ipv6_srh_rcv(struct sk_buff *skb, struct inet6_dev *idev)
 	}
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (!seg6_hmac_validate_skb(skb)) {
+	if (!seg6_hmac_validate_skb(skb, hdr)) {
 		kfree_skb(skb);
 		return -1;
 	}
diff --git a/net/ipv6/seg6_hmac.c b/net/ipv6/seg6_hmac.c
index 214d137d545e7..fe3f12c2e6d9e 100644
--- a/net/ipv6/seg6_hmac.c
+++ b/net/ipv6/seg6_hmac.c
@@ -234,13 +234,12 @@ EXPORT_SYMBOL(seg6_hmac_compute);
  *
  * called with rcu_read_lock()
  */
-bool seg6_hmac_validate_skb(struct sk_buff *skb)
+bool seg6_hmac_validate_skb(struct sk_buff *skb, struct ipv6_sr_hdr *srh)
 {
 	u8 hmac_output[SEG6_HMAC_FIELD_LEN];
 	struct net *net = dev_net(skb->dev);
 	struct seg6_hmac_info *hinfo;
 	struct sr6_tlv_hmac *tlv;
-	struct ipv6_sr_hdr *srh;
 	struct inet6_dev *idev;
 	int require_hmac;
 
@@ -248,8 +247,6 @@ bool seg6_hmac_validate_skb(struct sk_buff *skb)
 	if (!idev)
 		return false;
 
-	srh = (struct ipv6_sr_hdr *)skb_transport_header(skb);
-
 	tlv = seg6_get_tlv_hmac(srh);
 
 	require_hmac = READ_ONCE(idev->cnf.seg6_require_hmac);
diff --git a/net/ipv6/seg6_local.c b/net/ipv6/seg6_local.c
index 191b99b073b06..9259b2d2da059 100644
--- a/net/ipv6/seg6_local.c
+++ b/net/ipv6/seg6_local.c
@@ -222,7 +222,7 @@ static struct ipv6_sr_hdr *get_and_validate_srh(struct sk_buff *skb)
 		return NULL;
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (!seg6_hmac_validate_skb(skb))
+	if (!seg6_hmac_validate_skb(skb, srh))
 		return NULL;
 #endif
 
@@ -239,7 +239,7 @@ static bool decap_and_validate(struct sk_buff *skb, int proto)
 		return false;
 
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (srh && !seg6_hmac_validate_skb(skb))
+	if (srh && !seg6_hmac_validate_skb(skb, srh))
 		return false;
 #endif
 
@@ -768,7 +768,7 @@ static int end_flv8986_core(struct sk_buff *skb, struct seg6_local_lwt *slwt)
 	srhoff = srh ? ((unsigned char *)srh - skb->data) : 0;
 	pinfo = seg6_get_srh_pktinfo(srh);
 #ifdef CONFIG_IPV6_SEG6_HMAC
-	if (srh && !seg6_hmac_validate_skb(skb))
+	if (srh && !seg6_hmac_validate_skb(skb, srh))
 		goto drop;
 #endif
 	flvmask = finfo->flv_ops;
-- 
2.53.0



