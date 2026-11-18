Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045191;
	b=RT0zkgSKfA9eN/ycAKjO72OJxZDB2MOCtARZ0GzyB1/nukU3RtYNPNFa78R6o4dH7YSW
	 ZAwB1jXd2ivFnW2IVWYjDPZX3+caZN8Su+xU633+xzSzMCEnEJzSXp8gDrLawmF0W+vId
	 QkFrGgv8PqVEuKf4Xh1Yd2i1hsv83ZNNGhMUsfs6EdCnh7ZiR61gmY8/Qc622KE8wjYm3
	 wsu+/trNkXn39TkC8IzNwEmZ/hAG82X3vhPfJpge3iPJnYEnb87yuradLf+7hH/mp/7jb
	 NQtohvnk766+YXxr3U7Ys6ncswMnrbyXgTiuCMjY/gpaI8+FKuCywhbcNpJFoIaIkuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045191;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0DxQHa6/1JsNH77PRn4WoYYzPd7asmWL/OsMNhKtSXA=;
	b=fVQTt0MZ1EhC6cyDe4K4NRsWWoxWscyg9dagC/5U9zDOKopddIzap6CNmRj2s6Vshiar
	 Cc46krWwZWn14kbvvKffNR5wN9gpymUdW6CryniCapoXCowU48iFZ1Qiu2IXu8fF1OPmB
	 XDfMLGvGJ9UAf2zg41zERkenqrVSCmK0s4P46Qrr5sdCIE/tanfAp8Nl3lVr8TN7kBcWc
	 VxkMc6asYHfuE1cClaDOM8ydJNWAIw+IbnK1mOu+GyDK2SWovRvzOPG7aR+ULGMmlVFZH
	 LsYHAsN/IpIg+YtxQ5wdLH5hhMlMzdzR8r70VCGG8q/ZZxXw1imdHCqnz6M8LiGqyhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udja5pOw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D8D7606A320;
	Wed, 18 Nov 2026 23:39:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Udja5pOw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648491F000C4;
	Wed, 18 Nov 2026 23:39:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045190;
	bh=0DxQHa6/1JsNH77PRn4WoYYzPd7asmWL/OsMNhKtSXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Udja5pOwWs8dKwXgO358eLSqOmW1flpXRHUDdYVQz3CCZ8FuoTiEIgjyk82X/KuaW
	 1KIpU6kOJWoYZQRWPYDAeAgvv/ovkGq69P+ud4rO89Oa/nFRbrjf6TZH20uUxNZB+d
	 uyotaPmO7oZkw7UlYgCiqpf4MmrNSlXeYM+Lu6Cs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0832/2857] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Wed, 18 Nov 2026 15:31:06 +0100
Message-ID: <20261118150231.528237515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index b0ec7f7790bab..06986086cc9bf 100644
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



