Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036137;
	b=4IcVlSWrqGgUUPDvpnLpYNruV4wqRMiHeKeKyFgeDLf0bdAP8fssvGtA2ohEdwVPTpvS
	 JG21ObTQ9PFIN+kp571gA2ybfIcQar/3Q8ft1LY+CH8A/Kd8UTRMM4SuWXXBh2M/jKOCh
	 bYjahLXF4GJlEF/CjbMeYPhfIB6sSCouTc0MC6fE1OyNa1QhnmFnNaPc8bF+CfK5fR1yI
	 mvuy+8acO6CJIf5GG3EUDyuTnDIYv6+X0LDQCNV9hUxT4tHSePomRNHR+BtYqqnGulD4Z
	 ZhSuTRjLYz9fh39c4G4GNsHbjuCRZ3XvGdT2zCKKauXOIQZGbqyAp5RgE3tThKUfKUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036137;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5w+3FeRRc/UOrhoqBKW/s98kFKFqvgcy2cSmowsmb7I=;
	b=lVwC+81QWTfoqkIHefckBEgvtFAyoi2wR+GNYwK25HOKSXASBidNBpsP0v9dNd6QS5am
	 KWeJyIaGDs1ZzksEEBW04ZGCqDLgiia6J0lGWr0AxRusMUecU7761lvVcJ6jdapD7ibZx
	 u17lXRDVD1DINN8mQb8dZhQHCNyPboGMtWH36Z65XNVZgN2qjzLLrwMLABqlbehRIT3iJ
	 tfNBJElEF/shhbr+4LUbvj7jNKHRW1QGO12PhkcrQSzMoGgDcIn/RkXvsYLF4e7EpyZMv
	 ClnyTLvujBxZeeHKZDNawFTB/U59UAcl0ioGZZ7Nw2dwJ6AcSMcIhQtqgU925Yvh42A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZfaJMpF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F2D3606A325;
	Wed, 18 Nov 2026 21:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yZfaJMpF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8111E1F000C4;
	Wed, 18 Nov 2026 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036137;
	bh=5w+3FeRRc/UOrhoqBKW/s98kFKFqvgcy2cSmowsmb7I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZfaJMpF6k1vsGGMGix17gzcnhfeZOGrKcikguGZ6lE5SUQFFGAN7rU1eP5Haghct
	 pFvqQxj7Wq3YHZBOBndWmyABIY+3aaIiRWhIMNMK3eEWjbyCxzjMq9pHAokR8yd/9Z
	 /LrS+X4MwKPULWdJfZNH9fLHFEaJuDPVV1wzz/bY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0951/3318] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Wed, 18 Nov 2026 15:26:13 +0100
Message-ID: <20261118150348.143345366@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Piotr Kubik <piotr@kubik.pl>

[ Upstream commit 1ae2d094b0200f687923298c0e42579273558988 ]

ctnetlink_filter_match_tuple() rejects an entry when
!ipv6_addr_cmp(filter, entry) is true. ipv6_addr_cmp() is a memcmp() and
returns 0 for equal addresses, so the condition is true exactly when the
addresses match: a CTA_FILTER dump with an IPv6 CTA_IP_SRC or CTA_IP_DST
skips every entry that matches the requested address and returns all the
others. The IPv4 branch compares with != and behaves correctly.

Observed with libnetfilter_conntrack NFCT_FILTER_DUMP_TUPLE: a dump
filtered on src 2001:db8::10 returned only the unrelated entries, and a
dump filtered on ::1 returned every entry except the ::1 ones.
conntrack-tools does not use the tuple filter for -L, which is why this
went unnoticed.

Use ipv6_addr_equal() so the IPv6 branch mirrors the IPv4 one.

Fixes: cb8aa9a3affb ("netfilter: ctnetlink: add kernel side filtering for dump")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Kubik <piotr@kubik.pl>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_netlink.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 895b617bf33df..9ca1fbef08ac3 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1069,13 +1069,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
 		break;
 	case NFPROTO_IPV6:
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_SRC)) &&
-		    !ipv6_addr_cmp(&filter_tuple->src.u3.in6,
-				   &ct_tuple->src.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->src.u3.in6,
+				     &ct_tuple->src.u3.in6))
 			return 0;
 
 		if ((flags & CTA_FILTER_FLAG(CTA_IP_DST)) &&
-		    !ipv6_addr_cmp(&filter_tuple->dst.u3.in6,
-				   &ct_tuple->dst.u3.in6))
+		    !ipv6_addr_equal(&filter_tuple->dst.u3.in6,
+				     &ct_tuple->dst.u3.in6))
 			return 0;
 		break;
 	}
-- 
2.53.0



