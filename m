Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1D4D2C0277;
	Mon,  1 Dec 2025 11:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588552; cv=none; b=NxfYFXN0lu53GM8EpoaFi16FJ1fI91sv3NF4yBZDttlPh8aEleaj0dyfsiD1YeV0Lv+RaxW2AUZRcJ7uY0HolbL0J+z3Cc9hSIccxXfaFBFR/clAwFMtxz5HjeMmjljvZ8cLpVZmQzQjlHevcf2+O8zEhqt6BxoE8BlAZiUHpAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588552; c=relaxed/simple;
	bh=VxcjchgvQz9sx0gaFD+V+kgldpdPy3AljzrWbMF3NWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X1T9ph1Wv9xUhTiDQzfCncPlE1f2P1Oc8yV2O0GaGlHsRFUtW3quKRHjTIKhJEMalZz7UOjP7sJLMkE++An+2Ov4vA3aDdKUQaL3Ori5OvwvrSo1jAzR/gRVMrXsLeXYOjX69SeslCbxylnAelSgbKxCtFCZCHe+cgnnxWv2xoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hZ0gMt3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hZ0gMt3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C077C113D0;
	Mon,  1 Dec 2025 11:29:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588552;
	bh=VxcjchgvQz9sx0gaFD+V+kgldpdPy3AljzrWbMF3NWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZ0gMt3mHCgr6IbVPxFaGD9QIN13NdSynKOhNKoAMbXgeWnO8RexBtutoDFulUJ8g
	 3g8MCZdKHATLy+BM2wbQVJMNv+o1T/7lL5vzxAyRChrhrfdNOptM4QKOBJu50QPgvh
	 /Bm7G+9oU8R4QS3rGoOtJZDz3Szq84VvO8XdeOBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Andrew Lunn <andrew@lunn.ch>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 081/187] net: sh_eth: Disable WoL if system can not suspend
Date: Mon,  1 Dec 2025 12:23:09 +0100
Message-ID: <20251201112244.158284148@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 9c02ea544ac35a9def5827d30594406947ccd81a ]

The MAC can't facilitate WoL if the system can't go to sleep. Gate the
WoL support callbacks in ethtool at compile time using CONFIG_PM_SLEEP.

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250909085849.3808169-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/renesas/sh_eth.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/ethernet/renesas/sh_eth.c b/drivers/net/ethernet/renesas/sh_eth.c
index f808e60b4ee4f..113774999d57b 100644
--- a/drivers/net/ethernet/renesas/sh_eth.c
+++ b/drivers/net/ethernet/renesas/sh_eth.c
@@ -2397,6 +2397,7 @@ static int sh_eth_set_ringparam(struct net_device *ndev,
 	return 0;
 }
 
+#ifdef CONFIG_PM_SLEEP
 static void sh_eth_get_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 {
 	struct sh_eth_private *mdp = netdev_priv(ndev);
@@ -2423,6 +2424,7 @@ static int sh_eth_set_wol(struct net_device *ndev, struct ethtool_wolinfo *wol)
 
 	return 0;
 }
+#endif
 
 static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.get_regs_len	= sh_eth_get_regs_len,
@@ -2438,8 +2440,10 @@ static const struct ethtool_ops sh_eth_ethtool_ops = {
 	.set_ringparam	= sh_eth_set_ringparam,
 	.get_link_ksettings = phy_ethtool_get_link_ksettings,
 	.set_link_ksettings = phy_ethtool_set_link_ksettings,
+#ifdef CONFIG_PM_SLEEP
 	.get_wol	= sh_eth_get_wol,
 	.set_wol	= sh_eth_set_wol,
+#endif
 };
 
 /* network device open function */
-- 
2.51.0



