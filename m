Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052386;
	b=eO5AE8PF32BlsqG9BhNn4EhCLDTKm5N7BrntTaqImCNBeB6AISSa/OufwDPGZUhVUoY+
	 tnDj1bSwyt3nPb6VmpPTNad622flx4rmvhGnmm9EEbKaAPVP3ccTMsvNLg48CHNXpLIto
	 Afdf+H0ryNBNFpXqtEX/w1fwLSYpxbFSoxhX22OEgD6ll+JbT0aNOKyoskygrCTI2x9tX
	 xLjAnTMmnR8oEw+WkjhZHfEfX2pkJ4wqdPYfza2t35XIuJbFKnDXyqytPSkgyti4ipZ2b
	 UeBLoqBZ0+6oXa+7Xw3HpTjJSbus4yROy9xlWF2bpU8lbC6ZNcFJxOaICKnbG7wh/jg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052386;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=evqI1LeYmRFGWqoGd1kNsEmxFINqmLXDpokqJuRUxI4=;
	b=AyNrSByX1O8odFXJ/4nXz1NWPd0Vix61ICtI/lwCZyB9yYbwyWHthgkhknipCTqO5R9+
	 VMhX0ZADoMmf5N4f4zgmybn1Gf1QO1Dd5TWrHX8MuTE9nRbdExfkVZQ4mXIfrZz2T+ft9
	 M728oiDsY04+5rUacCv2jINYcjq1N3IzFj4J2FDxF/Lm07Qbo6+e2BCWcNJze+cLDHfzY
	 f69oRlxv7GnjW8SgCICD0CWkvarpo2N0X/ctA1mQkICTKdAzimxCt1dsH1UYMe52edd+t
	 khtkonBZuqqQIPHZa+9cJ5e465IXqzkBabMv05do31rOzxiU5tPhMbVAW6k6ENejbhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4Vk3jVL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4B72606A31C;
	Thu, 19 Nov 2026 01:39:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K4Vk3jVL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECF281F000C4;
	Thu, 19 Nov 2026 01:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052386;
	bh=evqI1LeYmRFGWqoGd1kNsEmxFINqmLXDpokqJuRUxI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K4Vk3jVL2+BX5B+8e3qjah7Jh70vHAPS/l7G4jzJW/pNnUgPwBqprH8dhQAisz+Sx
	 7GVOLVb9w260jKoaxF35q5+0Cgzh/wZD9LW/hZW4uBR7mEUKMQoL5AR6l3zl4qrvva
	 MnnRO604aO4hntKYsRXtjzEUdEJt7Z6ytfCH+XfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Piotr Kubik <piotr@kubik.pl>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0545/2214] netfilter: ctnetlink: fix inverted IPv6 address match in dump filter
Date: Wed, 18 Nov 2026 15:37:01 +0100
Message-ID: <20261118150032.822028259@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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
index a984799f27562..2661c4cee113e 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1058,13 +1058,13 @@ static int ctnetlink_filter_match_tuple(struct nf_conntrack_tuple *filter_tuple,
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



