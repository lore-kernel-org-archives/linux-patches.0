Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064177;
	b=bIffBdAziyXo/ZVGlocv6qd0L/k4UMc7k7ZNYHyQeHgbziBLOroTa+TBfvz5v+4umTDJ
	 KZxY2+hr4FEdy5ZAgXIwVFE6jKYeDumQShN+NWtL3iHMl+ZNX+l+jnb30NFLV+n7xxBmk
	 SINuYHnfqOw8bru5nUUwPHy+1WyVP5IZklheSgyRxZXKXqCxjxgtX7vVc8MgA4jIjqMrd
	 nvSJ0jIDsMyAOmPIJwlZMTiP8iX8QQeDzPcKdD3Sd8jTRuZ0cnT0AWXnWgJdj96mmhcmL
	 1tF0y68hVmwUSzuPDLWYUSE7R3+YdLaH/dabCLuL3S9SR9AIDeO6g6+Pp6u/CXBHONA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064177;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f1BWSabXsgYCvq7Bgz8oEA6OeIPFLH96BFYojYRs1JU=;
	b=oBmctRIZTcw86DDzoyMDn38QZq+jGzyy4r4oS7Nwm3jNh+e3olZEIHWIJQcaWfmRg4rY
	 kgbrZcShLZ2D+RnwI6apd7XC1YCp9fLmMMIh9TZD02wZmllSSx/wDqjF6rFUCXiws+xhr
	 YunIiW+OZUlD51S+TccEagzHPjeEKY3IKTmMDGuJ1HU+JLFJbt/aUYmptNe25AgW/gGAb
	 IIP0gipBg76FZEzxXw56ynCqaJ+h6YJUNJHojzNDhJYWRTrOSoN4HIrNnOEFEE5p1/LGW
	 4j/eOLYrzYfE+7qsjf9T8G/jzj14W8NqtB2E8x44cpeX1gOFL3XHOwU0XRI+lXqBUSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="f/xbaCa6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23EAE606A335;
	Sat,  7 Nov 2026 15:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f/xbaCa6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A4891F0089F;
	Sat,  7 Nov 2026 15:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064176;
	bh=f1BWSabXsgYCvq7Bgz8oEA6OeIPFLH96BFYojYRs1JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f/xbaCa6AfKwmIjIoaKYRJ+ZYXQY15XyPAmidf+1U6HZgIndF9xFAGd87l5cY9zBZ
	 YH5CwckV3l5ttsFV3sHXUqBHHsxEI2cXn/wGa68Aa6lhZuw8lflguKPjBJAfQlxCCb
	 pxWaq35Nn7eGv1pHY+WFaNZ7fRvDuXMxlG/uZTsU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0321/1257] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Sat,  7 Nov 2026 08:43:37 -0500
Message-ID: <20261107134948.293313992@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 4e5d7c7014368..e8477f792c957 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1098,13 +1098,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
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



