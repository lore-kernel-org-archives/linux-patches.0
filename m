Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056316;
	b=jHuKtoik6GfzrKNNR/F8FwOYrk9vqaGaOY6ddYxpgqDCmrmM6D4Eb4LIP0MfL/ZY35S0
	 y7gIXp3P6j9vifWZqQTw+YzLgCoMBmIcNgTbeL/B6x8X0X3mO0NDq1nXLUfopypz6YtHl
	 KRCq1uJEjBqowna+71wgozYyC5ihVPf7sQq22EeUeldaAjrnkDmcyZIxaE6bynLm80NwI
	 WVDiCgvcIsA6UxeDxWfbtsk9UxfSinKu8EHJSNnUoLrXqpig6Qo7zNp4mIyafrq79jn0F
	 zKCfnpxdRgewthBkUAsqaz6ezgDePjnZjD+q9q2j/d/QjV+mtg5gS/wuFyJSrFMu24g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056316;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OeAI5/9d8hllmzuY6T4YiGey0f5igPJxU8xyUn68ZTU=;
	b=YsFlNkkLn/CBN2CpF2A9EmrofLwNBgTGoCtYRtiw/craj3u5gRJc/JDiiw4a+LZ25FcB
	 KBKMnpXY9cPxIMbUzKR3xBh01UQli2+mOHg2f/jjqhkfUHss5lADg/nJzd0yy8hwfVMI2
	 AJJNKLS0IJZgRZLgy2pJ4LvC+T4M5pRY2/HIK0t6LzFY65NrdW0Rjxd3jUd7HurwzwFEb
	 gl6w3yl6y1n1nqo6yLjnh/1nrnp8jNiQ1ruh2QVr2TY4i1KDGXTLq4wOqxjtjfgvBhqvM
	 ELPLjHIzeT/GhUh125Pqd5xQXIkHbJXAMhT09VNmX6SybKNnQzB7b3ZBHN7yAFWCgGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNKPEulQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDE6606A31C;
	Thu, 19 Nov 2026 02:45:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yNKPEulQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B901F000C5;
	Thu, 19 Nov 2026 02:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056316;
	bh=OeAI5/9d8hllmzuY6T4YiGey0f5igPJxU8xyUn68ZTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yNKPEulQ8Pahp0Ocp+/HwZETFUXuJkBUCnHKcqO1DTHmO/kTRF5ndMld/NJZS6Khb
	 CmeWggX5d5ZmWz7FVo7CZmr/rwrjck+VIQmy2Y+xZ5ofZkioMLK3yqXd0PiB5bgjo2
	 N8qyQFtgfMKG5OwHS+O48fyuJOppx28rqAKoZN8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1942/2214] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 16:00:18 +0100
Message-ID: <20261118150128.706858514@linuxfoundation.org>
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

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit fbd3a301b1378423a5cfc23a42e3c0b04e26192c ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 3e1e58d64c3d ("net: add generic selftest support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-1-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/selftests.c b/net/core/selftests.c
index 63938efd5b55f..8dfbca2259321 100644
--- a/net/core/selftests.c
+++ b/net/core/selftests.c
@@ -190,7 +190,7 @@ static int net_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



