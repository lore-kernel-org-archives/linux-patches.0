Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704394;
	b=KnkiLZYlCRHb2QrBJTRzn0FEgCpLwEfrn+hEW2u88apyzbeVDDyJJkmeGPzOhKau/YBh
	 26N3JDqPRoxtISnzFlv7SgmjtIKoZYPc/zemYWdEu+Yb1IyPhC0T+vlxYu7hHq/ePJ1Ih
	 TxIX3Ye3Fs7upobPAJqE9zvwHIi3yPVYEpZDZZZjyIv7WpPTzrpV/q9GW69WgZ82U+lqt
	 gVUqF8ZqIFKyj01gKNVlnVBXAJKDi/OUvSUcOxFrASswsqdV9gS8z5f7v6VggUDr7yGCP
	 8HxdKfNQYCnczUr50+u46aoucS/EneKpRpUxHNcT4XlbdUDJE7yttuJ6aKIdLD6ScVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704394;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AYbkFem9CND0x53W2espZMJOqiHGiR3fXkXQdRt1L+M=;
	b=HiyqvgH7uz8TPOTiIK+4lMVvzAx1jSYxZvc8hB+i4D5kgc1qZaeSXCTWAi8PQA7jhgAN
	 dITJPojiVF4RIvVZRp8Tknd96ZOsDoJbUG4G/iJUdIvHf4fym66VasrDSFD00nE7dK2tE
	 3Q/u5mfmNFTiQv2+Dah9S1uSkibvEvS0K04V/IkbjPKdiQFJW1YQ5R97R9w3Llsh3EJ+V
	 IMs6G1n7UbgdA8QiRSpuE73UtIcpGUeVadftUkXzurvE9g026aoYYcFdOiI6uCtA4j4ZQ
	 nQo5Q3VeGORWKsgL0uBRYiAbs1JtYZ6JyxQv7VXtaXW8wy2d8ue7h8Nxr2Y8xFSJadA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWZSn2wB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF872606A327;
	Thu, 26 Nov 2026 14:46:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EWZSn2wB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 347151F000C0;
	Thu, 26 Nov 2026 14:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704393;
	bh=AYbkFem9CND0x53W2espZMJOqiHGiR3fXkXQdRt1L+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWZSn2wB4CfyfbZw9FeVqg+tS3CkJmj3cvY221mvcVMg3x4MifSAbXdTBJ8HL4Rl0
	 C0fk5Nv7ujK+OJRhHI/5kpY7y9zNh+LmQEk+awNFjo7505c0BImUHbuYWTVnHl8S3E
	 Ztpma7d2hPtLRmK5J0mCo7mvHFAmUB/P/+S55wqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/265] ipv6: Check the Home Address option again before its address is used
Date: Thu, 26 Nov 2026 15:37:20 +0100
Message-ID: <20261126143612.735590926@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 30c71476d842b094651bd7712f6c8ee8716147d0 ]

ipv6_dest_hao() checks the Home Address option and sets IP6CB(skb)->dsthao
to the offset of the destination options header. Later mip6_addr_swap() and
mip6_destopt_reject() call ipv6_find_tlv() with that offset and use the 16
address bytes. They assume that the same header is still there.

But the seg6 and ioam6 lwtunnels, the End.B6 actions, ipv6_rpl_srh_rcv()
and BPF lwt progs move or rewrite the IPv6 headers and keep IP6CB(skb).
Then ipv6_find_tlv() parses other bytes. It returns when the type matches,
before it checks that the option is inside the header. Nobody checks the
length of the option again. Thus mip6_addr_swap() can write after the data
of the skb. mip6_destopt_reject() can copy that memory to an xfrm report.

In ipv6_find_tlv(), check the length of an option before its type. The
returned option is then inside the header, and the header is inside the
linear data. In both callers, ignore an option with a length other than 16,
as if ipv6_find_tlv() found none. Then the ICMPv6 error goes to the source
address of the IPv6 header, and the xfrm report has no XFRMA_COADDR
attribute. Nothing changes for a header that ip6_parse_tlv() accepted and
that is still in its place. For the other callers an incomplete option is
now absent:

 - ip6_find_1stfragopt() and mip6_rthdr_offset() can return another offset
   for the fragment header or the xfrm header, also in a forwarded packet.
 - calipso_skbuff_optptr() returns NULL. netlbl_skbuff_getattr() and
   netlbl_cache_add() then see no option. calipso_skbuff_delattr() returns
   0 and the packet continues unchanged. Today it returns -EINVAL and
   SELinux drops the packet. It already returns 0 when an earlier option is
   incomplete. The receiver drops such a header in ip6_parse_tlv().

The code that moves the headers still does not reset the offset or the
other fields of IP6CB(skb). If the bytes there look like a header with a
Home Address option of length 16, both callers still use its address.

The first tag also covers ipv6_find_tlv(), because its early return did no
harm before mip6_addr_swap(). The second tag is for mip6_destopt_reject().

Fixes: 793832361fe7 ("[IPV6] MIP6: Revert address to send ICMPv6 error.")
Fixes: 70182ed23d25 ("[IPV6] MIP6: Report to user-space when home address option is rejected.")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20261102064922.2636027-1-alexei.starovoitov@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/exthdrs_core.c | 7 ++++---
 net/ipv6/icmp.c         | 7 ++++++-
 net/ipv6/mip6.c         | 9 ++++++++-
 3 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/net/ipv6/exthdrs_core.c b/net/ipv6/exthdrs_core.c
index ce3724f49e33a..f5b6e25580e83 100644
--- a/net/ipv6/exthdrs_core.c
+++ b/net/ipv6/exthdrs_core.c
@@ -135,9 +135,6 @@ int ipv6_find_tlv(const struct sk_buff *skb, int offset, int type)
 		int opttype = nh[offset];
 		int optlen;
 
-		if (opttype == type)
-			return offset;
-
 		switch (opttype) {
 		case IPV6_TLV_PAD1:
 			optlen = 1;
@@ -150,6 +147,10 @@ int ipv6_find_tlv(const struct sk_buff *skb, int offset, int type)
 				goto bad;
 			break;
 		}
+		/* Some callers read the option, so it must be in the header. */
+		if (opttype == type)
+			return offset;
+
 		offset += optlen;
 		len -= optlen;
 	}
diff --git a/net/ipv6/icmp.c b/net/ipv6/icmp.c
index 714a7792c97f0..9ac91e473aa3a 100644
--- a/net/ipv6/icmp.c
+++ b/net/ipv6/icmp.c
@@ -342,7 +342,12 @@ static void mip6_addr_swap(struct sk_buff *skb, const struct inet6_skb_parm *opt
 		if (likely(off >= 0)) {
 			hao = (struct ipv6_destopt_hao *)
 					(skb_network_header(skb) + off);
-			swap(iph->saddr, hao->addr);
+			/*
+			 * The header can have moved or changed after
+			 * ipv6_dest_hao() checked the length.
+			 */
+			if (hao->length == 16)
+				swap(iph->saddr, hao->addr);
 		}
 	}
 }
diff --git a/net/ipv6/mip6.c b/net/ipv6/mip6.c
index 878fcec149494..c7793bb92fb23 100644
--- a/net/ipv6/mip6.c
+++ b/net/ipv6/mip6.c
@@ -211,9 +211,16 @@ static int mip6_destopt_reject(struct xfrm_state *x, struct sk_buff *skb,
 
 	if (likely(opt->dsthao)) {
 		offset = ipv6_find_tlv(skb, opt->dsthao, IPV6_TLV_HAO);
-		if (likely(offset >= 0))
+		if (likely(offset >= 0)) {
 			hao = (struct ipv6_destopt_hao *)
 					(skb_network_header(skb) + offset);
+			/*
+			 * The header can have moved or changed after
+			 * ipv6_dest_hao() checked the length.
+			 */
+			if (hao->length != 16)
+				hao = NULL;
+		}
 	}
 
 	stamp = skb_get_ktime(skb);
-- 
2.53.0



