Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061714;
	b=R12BrY3hIZPPcVaTTRK54FOcTvBeC1px3P23NuTX5EGxOSlv6N5S07rILVDitID/OApg
	 fUHFh8nNpESR0ciopxeiZcEKkewQXRQCXk+zmFu488QEhYxiQrkLQau/FVlFl8miPMFCc
	 BDSwMP7kpbq7pUYRumzk08YpwQyLvd8QEqb6i7iCpyaPHeuc4epIkpCQTmINAUX2ry2ET
	 nMAkIOJF31bKPfoeCuxTE8U2G6mYKIbnI6W2USswZQaKbvFj9VhMkZcsySEiVVM6ad7Jb
	 Eye9YzxyvvoZ3GCqW5zicTPujzFo5GB8f/wbuGXW0cgLcPRQq/8GP1BULgLzkqh4Ffw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061714;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZL3+reOLfeNUrjWdVpw36U3ErhLmq5h8D09vl5/KLiA=;
	b=XG7w26ko56xZ7PA2sTaXYJfNmr/Iy0Bx6n02IpnLlkhK1MqFq4uBLTjmWvd3KBsOoIIR
	 SH5QQEXNcpk/quRRKzN4e4eZvovrKIGKYtfIK7pQFPVJK90WjYnNwuBKtiD1tqbel27hO
	 //VcZtUPnKA+2hoD3eTIQ2Cmoc/qNY0mSeG+KSo54kH6M/O8319UwG1T2MVVnJZ+2gf0i
	 nWIiLIMqvOdkmJ2TSOJedzLCK7hbPqGyalBQdlGuxbqnKHfT/tuRUwhjGhCxZ1Bmjjjyv
	 xO/7U1lRPRh3GvHbsu9iMtk+yOgq/0/bg1gDlEzVFdcsDLdyMBCgS5hcZmnQF3TSIOg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNVq0cwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D022C606A32C;
	Thu, 19 Nov 2026 04:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PNVq0cwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EEC1F000C6;
	Thu, 19 Nov 2026 04:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061714;
	bh=ZL3+reOLfeNUrjWdVpw36U3ErhLmq5h8D09vl5/KLiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNVq0cwWIiiZmhPGdPJqtlwrbNx8pHThHpVD11IkPjeZLkapysAsopuzcaHGHZEtq
	 Lxf5eXBm+6oRQGeI8vQcpzXk9TSvBCzTPfMnczAi8K8lV2S1NzAFMMl7AjK8GjTrgh
	 of5mn739BSSfCz1fEo/kGfkfYSp6s3wwruzOuPfI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1653/1848] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 16:01:31 +0100
Message-ID: <20261118150028.922283154@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d1315125b3315..86e5142d40c5d 100644
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



