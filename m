Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061077;
	b=3n1JUyF66Ut3iT6aUTiy5TytsOQ3Xdrt16qq2Akl1kUzAhj2TRJObK2OyiC1M9Du+sds
	 WIEYBvH2OcoVUrAL6VcLsL7t1tCdMvxVmGRMPe46zDz1TyELRXrsmfJWO1fjtuW80WxLr
	 h1wmgPL2C+fG2gvbLuWkZP38zfuNMcTsQQlvtBDtrfKwoLiKQ97D2gi7ZMltuecsaNpPQ
	 519klFoOQwGSA04pBB/Vn0hsYheTujogf6Fv9So+P3tLd9QklpHUNBrqskmeFMb1EaE5T
	 Po5atMBtKiye+t51PfxhV31mSaOHAU4q0Jq/3N8Wt8+re2uniKl4iIkXfxk9WEyighg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3yxTbbXqFmot6gMc9kgYd2k0NYXGpIG2R2TsYJZHTcQ=;
	b=jgN4KeabffV/JIDex/J0SSMoR364nkIpCdpV/BdShk98HuGShSaI7c1nIcuQfy4ybpGD
	 l0tDkd5nwHIJe4zoCp0STBEDOtmUdJPAWDjT4UHRBZ5sHYTOWF/TsWKEFnGyk1J0H0laU
	 1K8LQNZ4LLpO4DVwh4nBWXODHkRZrfIe934b1osyjZ9dP8jv7865OiZ7fGJiafSJjljN3
	 zexpN9AhmQaDE9Bn1Rnq0GKPy0KtPd2a2moVsEL/X8lZUF5+IOYbgl8Yb0KjYdudIP2XX
	 Pb8S5aLQXTvmBERvQ8FOhx2ZE+dGnjDPekj0LLDWd7+/b5l4PjdQQBdBRr7Z9d2H8fg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lytv5eDB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34BDF606D81B;
	Sat,  7 Nov 2026 14:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Lytv5eDB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5DDD1F0089F;
	Sat,  7 Nov 2026 14:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061077;
	bh=3yxTbbXqFmot6gMc9kgYd2k0NYXGpIG2R2TsYJZHTcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lytv5eDB9TbXKd9xhC3v6qCRsGIMMxcwfjYq0DsfmnaX8pHBZV2GEtrqHPnF/oUIp
	 r0iUgqnxWP2I4Fd+rtj5KMOX/zwrOrHFYWVaaOJG5NL14frR6Tbl7VPgF9FNjEySF5
	 N81XVR9HKa3k4ocXbfW792g7oW9BfmPwRHiUK2/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0401/1536] netfilter: tproxy: use DEBUG_NET_WARN_ON_ONCE for protocol fallbacks
Date: Sat,  7 Nov 2026 08:40:17 -0500
Message-ID: <20261107135008.850033519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 1f0391aea883e99d402d0f77ba3530e4e879350d ]

Replace WARN_ON calls with DEBUG_NET_WARN_ON_ONCE in the default switch
blocks of nf_tproxy_get_sock_v4 and v6. Unsupported transport protocols
are already safely handled by returning a NULL socket pointer. This
prevents unnecessary system panics when panic_on_warn=1 is enabled in
production systems.

Link: https://patch.msgid.link/cover.1786968834.git.zhilinz@nebusec.ai/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/netfilter/nf_tproxy_ipv4.c | 2 +-
 net/ipv6/netfilter/nf_tproxy_ipv6.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tproxy_ipv4.c b/net/ipv4/netfilter/nf_tproxy_ipv4.c
index 73e66a088e25e..9b51e84606040 100644
--- a/net/ipv4/netfilter/nf_tproxy_ipv4.c
+++ b/net/ipv4/netfilter/nf_tproxy_ipv4.c
@@ -138,7 +138,7 @@ nf_tproxy_get_sock_v4(struct net *net, struct sk_buff *skb,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
diff --git a/net/ipv6/netfilter/nf_tproxy_ipv6.c b/net/ipv6/netfilter/nf_tproxy_ipv6.c
index 52f828bb5a83d..ead5d161464cb 100644
--- a/net/ipv6/netfilter/nf_tproxy_ipv6.c
+++ b/net/ipv6/netfilter/nf_tproxy_ipv6.c
@@ -137,7 +137,7 @@ nf_tproxy_get_sock_v6(struct net *net, struct sk_buff *skb, int thoff,
 		}
 		break;
 	default:
-		WARN_ON(1);
+		DEBUG_NET_WARN_ON_ONCE(1);
 		sk = NULL;
 	}
 
-- 
2.53.0



