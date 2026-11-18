Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041784;
	b=5Fn0qaKT/5tsuzU8vpgG3FP3QiCloVN5pGULRmAasAyesyvoZWGbYgT4qbdWsREfasqN
	 oCKj6OGx+DqgFrp6rsfsp/oLk3kvOy3uixs0aaSF3FpKal6h2WcAul4MZx5UkWtOJOar3
	 N25iVXnV9Y8CTb0A1Kj+RF7jvMSAuGC7ZANRfg9v/I80tfo77HHUEniqCxwU2ztZpi7ty
	 W2Rf0lnm99Smyf0BpMGg1FYNV1McSCXBchlBmNUCc91jqclUpXpJ/9sdo49ChtnsyQJ10
	 NfTiB2O8Vg5wJzHGuAh8mMbI/ugp9FyZvXzYd/bnoaR3ZGQrUCiuzVFbnMmClzWUx0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041784;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sGpcAfv65OYC0fQxM8rZJn0w1Fpu+z0MS59vExOklLo=;
	b=mSfrntlPGgor+zv01lwrq/SUZ/N0jBjX6M2Po/glpOLsCajNekm/5dyTF/g0ARIILLlX
	 vO62yVhDP4Yf8QHC8KxCU3QsdRQAqMt5zMrfwzX+AceHSDIz+1dFRe9p2zjVT3SQxsJy0
	 BKMBocRcMzUsXBJIiTFR7Jo4/5MoieAKtuMmJFvm+p8aUKsX/xipqckzKcwJ29bzuDZSs
	 qOTsaDuQZs6C4Vr30trAixy2VlXX/NIOBX3bI861PVAN8Zfn8sCDDWel7RlgmIaB1Y7Ey
	 +qzYAogsb0lReBt4RRIE0uPXxogTI0FrScF2Zu6dcd1uzcNeZ7W7N5VvxnHE1teS7dQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=glQCBqSe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B48B606A31C;
	Wed, 18 Nov 2026 22:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=glQCBqSe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 921321F000C4;
	Wed, 18 Nov 2026 22:43:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041784;
	bh=sGpcAfv65OYC0fQxM8rZJn0w1Fpu+z0MS59vExOklLo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glQCBqSe7yhzITJbbeGD/0eW8WbMqAON49VEz/djqI1HD9gqEVm2p1TjrYN5e8JY6
	 HH0nzR0Mil+hF131yTsqjqiQa+9zrk471Z9leFS9O6gEmIZ4ssRVXaxKuNkW7BHfqr
	 aZinNeVeIPPIOxaB6iE7Oh8+bLXhGKxVZ9C/yuQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2895/3318] net: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:58:37 +0100
Message-ID: <20261118150447.346938646@linuxfoundation.org>
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
index 946e92cca2111..78c2c6acad427 100644
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



