Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026776;
	b=hsd3ctyoZxZ4KNS0GVIKO6cmR9/KhzpRuDu4BV895VkOFckJ4MY/yZJ5wCW7jGakLXIb
	 t/WvaUQhQFZ50q7fpvX4cGsjbFJHk3N0YK11jlnvgYMbxfBbpst7agB48qvmOe4PBEVCe
	 yTGCtgU/NHIr9BjJ2efvYRnvsb1jbvVrjHa7DaAOyys/GVO2vrzryW++d6P5nahyzWwRW
	 pDlW23cvLZGgFUWJN7774GBjQWUdajNzHtQDpAGBKC0g+pjxFw0cIp5PzoUIxqctlJJJC
	 ciCwis2BEwxXh60UQCTzWr3Tb5fYd/bb7pYPzviTFjyRBP/GwQpbJ8WWHL4qcXwZtow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026776;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SPaF/sRM+bs9YPmPQDFRvhLt9cI0hlH/zEhYbUFQtFA=;
	b=X6MIGcsz71Jy9iTUZb6EbCgXjceHKILckTvRC392f0kr/7h9ObhnDWWdWYPZ2+6qll57
	 HPni7VDHD/XUZIiDECXSDFDeaE7TlgFBH6pXCFHncIyPrsXiJ2aTwxZ7HJ97OFnh7bHl+
	 1RiNm9N6/oN3rk3+hE/f9+LinvQ016PSYvgZp4LXFrWqRBBT4dR7HMk9ev/suJsPAC+QJ
	 +oFv7JDMGN+vB1NYL/4gAu2r78FFLYADSF4+hWBkmeR+hbJaWA96t8UCXdKfeHAtwA3Pu
	 vVUkqI4dkWBalfT9xVpznWFg0bz52KdZbo6KY09di6yJ1fKUWB/axGhh/Km9Tn+vtoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSRfd6AY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4518D606A325;
	Wed, 18 Nov 2026 18:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lSRfd6AY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C4A1F000C4;
	Wed, 18 Nov 2026 18:32:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026776;
	bh=SPaF/sRM+bs9YPmPQDFRvhLt9cI0hlH/zEhYbUFQtFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lSRfd6AYXqk4/jHjfXw1SO+s4VNynmg3ZVBt1NCfZQmRcVkH+3N41pNHFAYyJm1NZ
	 QaxEUkRsEjcZn1PtddjBHYOh9B9NVkdTkuc+txAoNFwpPexVroFAvSsS+D9G6RZWdT
	 TDeHnI3RzsmZF2nyUV5J2yTgVfQaaubI903xCbaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1553/2151] net: stmmac: selftests: use skb_share_check() in the loopback receive hook
Date: Wed, 18 Nov 2026 15:54:48 +0100
Message-ID: <20261118150218.470581656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d922e32fe4fbc..aaa7e9f5ceea6 100644
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



