Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDBCE1F93D
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 16:11:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EEF6C433C7;
	Fri, 21 Jul 2023 16:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689955866;
	bh=Fu8Jpg4AgoVDMku3cdZKZI/BMvB0GgpcKEKjM5Vq7r4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o95iURtIg+tPIjoqIFoxEu7rouMV7LxMGb1sHVfNiiWK2MegA3Zfm6SDHcoFoa/iw
	 yfKttNtrpTaXsO8w5xIqsyPKdWiU/Ce2oBpmi2jRPsgB8WfSAMYk8Zxq77NvLgf9Xh
	 dei1qJojZKugEFDGwiKBoudbeX7cJQ6GIWlrgEjM=
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
Subject: [PATCH 6.4 058/292] udp6: fix udp6_ehashfn() typo
Date: Fri, 21 Jul 2023 18:02:47 +0200
Message-ID: <20230721160531.289147887@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160528.800311148@linuxfoundation.org>
References: <20230721160528.800311148@linuxfoundation.org>
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
index debb98fb23c0b..d594a0425749b 100644
--- a/net/ipv6/udp.c
+++ b/net/ipv6/udp.c
@@ -91,7 +91,7 @@ static u32 udp6_ehashfn(const struct net *net,
 	fhash = __ipv6_addr_jhash(faddr, udp_ipv6_hash_secret);
 
 	return __inet6_ehashfn(lhash, lport, fhash, fport,
-			       udp_ipv6_hash_secret + net_hash_mix(net));
+			       udp6_ehash_secret + net_hash_mix(net));
 }
 
 int udp_v6_get_port(struct sock *sk, unsigned short snum)
-- 
2.39.2



