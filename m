Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1458A1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 863E3C433C8;
	Tue, 25 Jul 2023 11:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284422;
	bh=tqEVskwNQDad8FStnfOLC9cLN4N4pJrCHgqrZpCo8nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dSZo5fkBCWcNkGE3dTMVuojPkkExTFzzJR0jvywTtcOauoaVpw0+S2Pg+5i4dA9Nd
	 zGYf/MZKkR4V3BPflU8ezgQiCX6Mu9DBPacC6msDWIpvq5lI5M8Kid3UJJsyExDXXf
	 bsL5rKCn5qy6OpgM0wLn6/7OHShLFk7sgNT25Y3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Klein <aksecurity@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Willy Tarreau <w@1wt.eu>,
	Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
	David Ahern <dsahern@kernel.org>,
	Hannes Frederic Sowa <hannes@stressinduktion.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 351/509] udp6: fix udp6_ehashfn() typo
Date: Tue, 25 Jul 2023 12:44:50 +0200
Message-ID: <20230725104609.805288337@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 51d03e2f2203e76ed02d33fb5ffbb5fc85ffaf54 ]

Amit Klein reported that udp6_ehash_secret was initialized but never used.

Fixes: 1bbdceef1e53 ("inet: convert inet_ehash_secret and ipv6_hash_secret to net_get_random_once")
Reported-by: Amit Klein <aksecurity@gmail.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc: David Ahern <dsahern@kernel.org>
Cc: Hannes Frederic Sowa <hannes@stressinduktion.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/udp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/udp.c b/net/ipv6/udp.c
index 19c0721399d9e..788bb19f32e99 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -87,7 +87,7 @@ static u32 udp6_ehashfn(const struct net *net,
 	fhash = __ipv6_addr_jhash(faddr, udp_ipv6_hash_secret);
 
 	return __inet6_ehashfn(lhash, lport, fhash, fport,
-			       udp_ipv6_hash_secret + net_hash_mix(net));
+			       udp6_ehash_secret + net_hash_mix(net));
 }
 
 int udp_v6_get_port(struct sock *sk, unsigned short snum)
-- 
2.39.2



