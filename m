Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831615;
	b=3W381XL0ZrtzV42Gs07ffRd5Ptaf8ZTdhsaVlUWylUpTzza7jsvLlU1mRY7dCvuawhgJ
	 Gr+v0eTCjQwWnR2R+5aOSsAdXiCoBwAOSmtjOT3+xGQ888ZgYZBI0rKg56w/Jf6ggL+yP
	 MWHeT9tfGEDhxKS9fJ5VKOJbhBiCC1ovGo9iM8mD0sOwYJ0copnszMdtMGY2N5ZnCqhmN
	 7mc5g8ulc/vHjRP/Lz9rN+vUCnypYTP676SI86WsTI5duSYaMlk3QAyPPEe12frbuqBrD
	 1IC1wx0Yyv8xJlvA48c7jUc4UmzNKIF6YYACT25mDzZqsfGSg6SL+u4CkBKSEQjBkFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LFuKzjDHMS/dl/Qk244Rb2aOYokJi6cY1bL+XFOnerM=;
	b=Hch4aHwprIDf+fkNRqufmp1IFaIcfDGncHfG+/1UdYJRXrCfdwtSd91vNTKUSIaGZghQ
	 vEYUECakRR840QDyjkXny44cOBjHFifFidWvXXdBkmO3OmIvBCNLRFhuSNAhy3NCAbJxQ
	 eZj4njZ58sphJZs0LntDCAnVb+JoMaWe2bIiXw0NlGFWKORwzEv+s8RrYOPfayoeOTuSy
	 JPQmgIHIabPGgold1Apa8unanRAnspCQSszkbf3+ZJrBhXiAfW49J6CLcJMuNcFNT+53L
	 Lq5e0M9BvlDWsXPzjREcTSXxgj9BDAKn4sK3SrftcsCE/gsLsZW3MjRXF/xUfHHH6Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcsGTW7G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01215606A326;
	Wed,  4 Nov 2026 22:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JcsGTW7G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFDB1F00A02;
	Wed,  4 Nov 2026 22:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831614;
	bh=LFuKzjDHMS/dl/Qk244Rb2aOYokJi6cY1bL+XFOnerM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JcsGTW7GdTVmW3+8btvfb1g9L4UstVyqfU2qrMnBzWmz27Pa6C4vvPLGhQVuQD69Y
	 VSQmsziZ950rQyMBUTVOWcf7yQhuwBb6hkeB34SZ2KwOXoMBma23jHm722mOLGPd5b
	 xSWNq9DWEJ8ThGGY8PydZ//6PB46yXbULEG8zcS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Ido Schimmel <idosch@nvidia.com>,
	Eric Dumazet <edumazet@google.com>,
	Justin Iurman <justin.iurman@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0812/1005] ipv6: Implement limits on extension header parsing
Date: Wed,  4 Nov 2026 16:09:05 -0500
Message-ID: <20261104211106.094616098@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 3744b0964d5267c0b651bcd8f8c25db6bf4ccbac ]

ipv6_{skip_exthdr,find_hdr}() and ip6_{tnl_parse_tlv_enc_lim,
protocol_deliver_rcu}() iterate over IPv6 extension headers until they
find a non-extension-header protocol or run out of packet data. The
loops have no iteration counter, relying solely on the packet length
to bound them. For a crafted packet with 8-byte extension headers
filling a 64KB jumbogram, this means a worst case of up to ~8k
iterations with a skb_header_pointer call each. ipv6_skip_exthdr(),
for example, is used where it parses the inner quoted packet inside
an incoming ICMPv6 error:

  - icmpv6_rcv
    - checksum validation
    - case ICMPV6_DEST_UNREACH
      - icmpv6_notify
        - pskb_may_pull()       <- pull inner IPv6 header
        - ipv6_skip_exthdr()    <- iterates here
        - pskb_may_pull()
        - ipprot->err_handler() <- sk lookup

The per-iteration cost of ipv6_skip_exthdr itself is generally
light, but skb_header_pointer becomes more costly on reassembled
packets: the first ~1232 bytes of the inner packet are in the skb's
linear area, but the remaining ~63KB are in the frag_list where
skb_copy_bits is needed to read data.

Initially, the idea was to add a configurable limit via a new
sysctl knob with default 8, in line with knobs from commit
47d3d7ac656a ("ipv6: Implement limits on Hop-by-Hop and Destination
options"), but two reasons eventually argued against it:

- It adds to UAPI that needs to be maintained forever, and
  upcoming work is restricting extension header ordering anyway,
  leaving little reason for another sysctl knob
- exthdrs_core.c is always built-in even when CONFIG_IPV6=n,
  where struct net has no .ipv6 member, so the read site would
  need an ifdef'd fallback to a constant anyway

Therefore, just use a constant (IP6_MAX_EXT_HDRS_CNT). All four
extension header walking functions are now bound by this limit.

Note that the check in ip6_protocol_deliver_rcu() happens right
before the goto resubmit, such that we don't have to have a test
for ipv6_ext_hdr() in the fast-path.

There's an ongoing IETF draft-iurman-6man-eh-occurrences to enforce
IPv6 extension headers ordering and occurrence. The latter also
discusses security implications. As per RFC8200 section 4.1, the
occurrence rules for extension headers provide a practical upper
bound which is 8. In order to be conservative, let's define
IP6_MAX_EXT_HDRS_CNT as 12 to leave enough room for quirky setups.
In the unlikely event that this is still not enough, then we might
need to reconsider a sysctl.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Justin Iurman <justin.iurman@gmail.com>
Link: https://patch.msgid.link/20260429154648.809751-1-daniel@iogearbox.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dropreason-core.h | 6 ++++++
 include/net/ipv6.h            | 3 +++
 net/ipv6/exthdrs_core.c       | 7 +++++++
 net/ipv6/ip6_input.c          | 5 +++++
 net/ipv6/ip6_tunnel.c         | 4 ++++
 5 files changed, 25 insertions(+)

diff --git a/include/net/dropreason-core.h b/include/net/dropreason-core.h
index de74e537b4ede..811057ae8ed25 100644
--- a/include/net/dropreason-core.h
+++ b/include/net/dropreason-core.h
@@ -101,6 +101,7 @@
 	FN(FRAG_TOO_FAR)		\
 	FN(TCP_MINTTL)			\
 	FN(IPV6_BAD_EXTHDR)		\
+	FN(IPV6_TOO_MANY_EXTHDRS)	\
 	FN(IPV6_NDISC_FRAG)		\
 	FN(IPV6_NDISC_HOP_LIMIT)	\
 	FN(IPV6_NDISC_BAD_CODE)		\
@@ -508,6 +509,11 @@ enum skb_drop_reason {
 	SKB_DROP_REASON_TCP_MINTTL,
 	/** @SKB_DROP_REASON_IPV6_BAD_EXTHDR: Bad IPv6 extension header. */
 	SKB_DROP_REASON_IPV6_BAD_EXTHDR,
+	/**
+	 * @SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS: Number of IPv6 extension
+	 * headers in the packet exceeds IP6_MAX_EXT_HDRS_CNT.
+	 */
+	SKB_DROP_REASON_IPV6_TOO_MANY_EXTHDRS,
 	/** @SKB_DROP_REASON_IPV6_NDISC_FRAG: invalid frag (suppress_frag_ndisc). */
 	SKB_DROP_REASON_IPV6_NDISC_FRAG,
 	/** @SKB_DROP_REASON_IPV6_NDISC_HOP_LIMIT: invalid hop limit. */
diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index b03467b337f4f..dffa1b7b96be0 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -90,6 +90,9 @@ struct ip_tunnel_info;
 #define IP6_DEFAULT_MAX_DST_OPTS_LEN	 INT_MAX /* No limit */
 #define IP6_DEFAULT_MAX_HBH_OPTS_LEN	 INT_MAX /* No limit */
 
+/* Hard limit on traversed IPv6 extension headers */
+#define IP6_MAX_EXT_HDRS_CNT		 12
+
 /*
  *	Addr type
  *	
diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index ce3724f49e33a..4a9748338cf40 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -73,6 +73,7 @@ int ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 		     __be16 *frag_offp)
 {
 	u8 nexthdr = *nexthdrp;
+	int exthdr_cnt = 0;
 
 	*frag_offp = 0;
 
@@ -82,6 +83,8 @@ int ipv6_skip_exthdr(const struct sk_buff *skb, int start, u8 *nexthdrp,
 
 		if (nexthdr == NEXTHDR_NONE)
 			return -1;
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return -1;
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (!hp)
 			return -1;
@@ -190,6 +193,7 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 {
 	unsigned int start = skb_network_offset(skb) + sizeof(struct ipv6hdr);
 	u8 nexthdr = ipv6_hdr(skb)->nexthdr;
+	int exthdr_cnt = 0;
 	bool found;
 
 	if (fragoff)
@@ -216,6 +220,9 @@ int ipv6_find_hdr(const struct sk_buff *skb, unsigned int *offset,
 			return -ENOENT;
 		}
 
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			return -EBADMSG;
+
 		hp = skb_header_pointer(skb, start, sizeof(_hdr), &_hdr);
 		if (!hp)
 			return -EBADMSG;
diff --git a/net/ipv6/ip6_input.c b/net/ipv6/ip6_input.c
index 673c6f0ce617d..be8836cc70e73 100644
--- a/net/ipv6/ip6_input.c
+++ b/net/ipv6/ip6_input.c
@@ -363,6 +363,7 @@ INDIRECT_CALLABLE_DECLARE(int tcp_v6_rcv(struct sk_buff *));
 void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 			      bool have_final)
 {
+	int exthdr_cnt = IP6CB(skb)->flags & IP6SKB_HOPBYHOP ? 1 : 0;
 	const struct inet6_protocol *ipprot;
 	struct inet6_dev *idev;
 	unsigned int nhoff;
@@ -447,6 +448,10 @@ void ip6_protocol_deliver_rcu(struct net *net, struct sk_buff *skb, int nexthdr,
 				nexthdr = ret;
 				goto resubmit_final;
 			} else {
+				if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT)) {
+					SKB_DR_SET(reason, IPV6_TOO_MANY_EXTHDRS);
+					goto discard;
+				}
 				goto resubmit;
 			}
 		} else if (ret == 0) {
diff --git a/net/ipv6/ip6_tunnel.c b/net/ipv6/ip6_tunnel.c
index 2560c0f8b2930..a6499f654e85a 100644
--- a/net/ipv6/ip6_tunnel.c
+++ b/net/ipv6/ip6_tunnel.c
@@ -400,11 +400,15 @@ __u16 ip6_tnl_parse_tlv_enc_lim(struct sk_buff *skb, __u8 *raw)
 	unsigned int nhoff = raw - skb->data;
 	unsigned int off = nhoff + sizeof(*ipv6h);
 	u8 nexthdr = ipv6h->nexthdr;
+	int exthdr_cnt = 0;
 
 	while (ipv6_ext_hdr(nexthdr) && nexthdr != NEXTHDR_NONE) {
 		struct ipv6_opt_hdr *hdr;
 		u16 optlen;
 
+		if (unlikely(exthdr_cnt++ >= IP6_MAX_EXT_HDRS_CNT))
+			break;
+
 		if (!pskb_may_pull(skb, off + sizeof(*hdr)))
 			break;
 
-- 
2.53.0



