Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041787;
	b=YgTazOFOXL1X7+tBIgwGdD+goQV0lAhWxRkuoeoZbKRTiQB+e+b+PuRq4Ann3tYZssev
	 ZHskfHzyTvWj2VJFKRiG9JaTjYR37GdF6pYcRRACXphKhBDAwSI4g7PfpCJMVqMkzpar2
	 RgbGHGMhNYHajf9J0qi355DEJwE56iDIBWMHm7qZmmDWkkfs3wfbmkKDmeaOY6Ixcgrfb
	 CfFc5+2t91uRPx+2PNPjV+azqcVQwCl1mE6aL03BULqY5K73wKkL995Lssl4gyn4OP2Vi
	 MDhZIsTYIUqbHhuDUgZ7kipZjQCY7/QId8b35O8c25Fwdal1TU/T1k/sjALbGEP6pYw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9vDX3u9c5PFhGF9HByPHAaeZGK+0Wq7Dc2PuQjZg5gw=;
	b=5a2Cwv41zX9gB3KDev6tLv26dXceeoYldkkfMAQjmenvjDRIBqYQjApVSIpjboG6P8Y5
	 j3XoKSzTzg5qVLGGnkwgWDHQhWzZAnngGPKJXMNaMLY/gDGRu+KGqz3Bif9d6Zwh3zpuX
	 qQYpe+L7SutmjgYbYtNaVuPi1tPLw/oY+UemrF1wO3fRubnwISUE6Wv4hZroYnlvwb53a
	 xKVtYIeRAsdXnJfUivv5wC1qr7PMwGKEtM1yduo9jVUWAREVQdzp+LY26KDgH37H4c1zl
	 zwh6PlPVahX7y1JD6advNvXWb10XKIdjpBukN5DrwdIvhjTCmrPxJunKmZJR/y/qMQA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3T1mgiw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9AEB606A31C;
	Wed, 18 Nov 2026 22:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v3T1mgiw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5A31F000C5;
	Wed, 18 Nov 2026 22:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041787;
	bh=9vDX3u9c5PFhGF9HByPHAaeZGK+0Wq7Dc2PuQjZg5gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v3T1mgiwF8R3n+PKsm+6lSvl8ctS3IPJC4hPkVrTtsCUEUSw308+0h54ayk1yUQet
	 X9D61XAzTgxBbzS3wmO1zriPjUIpEH7WALItot6AA6jDiqAcfwiFtoyz0NKJe5cQXs
	 YI8dUcSybKXJ/Ueb9sGN9Z257PR3CrU+1SnPhB2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2896/3318] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:58:38 +0100
Message-ID: <20261118150447.374990585@linuxfoundation.org>
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

[ Upstream commit a7a89019bac0e8810bde7f1419f4adf9adc23d41 ]

The loopback hook gets a shared skb when another ETH_P_IP handler is
bound to the device. skb_unshare() does not unshare it, so
skb_linearize() on a non-linear frame hits BUG_ON(skb_shared()).

Use skb_share_check() instead.

Fixes: 091810dbded9 ("net: stmmac: Introduce selftests support")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20261007-nb-net-selftest-shared-net-v1-2-458369bfa1ba@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
index ef957df26be56..90f082856450b 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_selftests.c
@@ -262,7 +262,7 @@ static int stmmac_test_loopback_validate(struct sk_buff *skb,
 	struct tcphdr *thdr;
 	struct iphdr *ihdr;
 
-	skb = skb_unshare(skb, GFP_ATOMIC);
+	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (!skb)
 		goto out;
 
-- 
2.53.0



