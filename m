Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 778FF3A3833;
	Wed, 20 May 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296976; cv=none; b=qebPIvRx8O8TJFiD1UM3EhaQhlTOPRelSYJjejuxHmGRnLFrxjRX4FfQmF69TSWucMdlW/9SJj30fN8W8MjNa8Ey/yyd86LdimEZeR2Jrv4SlwSEwyclRu5fX2KaYNyck6L7x+Shy/9oYN/9vn+HYMx+gb8skEoQIhiYZqOD61k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296976; c=relaxed/simple;
	bh=uwRPRCpkbtCcEmxPyssExzX5nILP7StXY5EcbnyWEg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G8so5NLJ2aWujy17zbbjs99gXiOTrX71dvAsMMRZic0j/CIhvovust369UxoJoGPedfuBe9q15JQdDyQGna5o3swSM8IzA+h3fi07QUQd5OsOvCWsa9IlrQV8NM+BIx0Zjle+TpZQBkpXgzdEBJmXmzrG9m/vVRrHi3go/0Bb2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gHwLUH8V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gHwLUH8V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD3041F000E9;
	Wed, 20 May 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296975;
	bh=8GvRlRGDYzE0GXGNQ8HbTmSQY51u8sFxUdiGBHFttX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gHwLUH8VEwfCIJt3qwVUHLSGjyxSmvoHYRpUZgzkLJrxNIwk8mj82R1UAWsUwyEca
	 1F4GDNsPRDYs9dkBBmyxI9tn29GGfg0SZImzdWWL/F3jT2nf/ZwB0Idb7i+m09xOPK
	 Hqw5xXO5ZFyVO/OvDAY3lo4q7E4UPUj/bqBnDxE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0961/1146] net: phy: dp83869: fix setting CLK_O_SEL field.
Date: Wed, 20 May 2026 18:20:11 +0200
Message-ID: <20260520162209.981333762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiko Schocher <hs@nabladev.com>

[ Upstream commit 46f74a3f7d57d9cc0110b09cbc8163fa0a01afa2 ]

Table 7-121 in datasheet says we have to set register 0xc6
to value 0x10 before CLK_O_SEL can be modified. No more infos
about this field found in datasheet. With this fix, setting
of CLK_O_SEL field in IO_MUX_CFG register worked through dts
property "ti,clk-output-sel" on a DP83869HMRGZR.

Signed-off-by: Heiko Schocher <hs@nabladev.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Fixes: 01db923e8377 ("net: phy: dp83869: Add TI dp83869 phy")
Link: https://patch.msgid.link/20260425031339.3318-1-hs@nabladev.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83869.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/dp83869.c b/drivers/net/phy/dp83869.c
index 1f381d7b13ff3..96a7d255f50fd 100644
--- a/drivers/net/phy/dp83869.c
+++ b/drivers/net/phy/dp83869.c
@@ -31,6 +31,7 @@
 #define DP83869_RGMIICTL	0x0032
 #define DP83869_STRAP_STS1	0x006e
 #define DP83869_RGMIIDCTL	0x0086
+#define DP83869_ANA_PLL_PROG_PI	0x00c6
 #define DP83869_RXFCFG		0x0134
 #define DP83869_RXFPMD1		0x0136
 #define DP83869_RXFPMD2		0x0137
@@ -826,12 +827,22 @@ static int dp83869_config_init(struct phy_device *phydev)
 		dp83869_config_port_mirroring(phydev);
 
 	/* Clock output selection if muxing property is set */
-	if (dp83869->clk_output_sel != DP83869_CLK_O_SEL_REF_CLK)
+	if (dp83869->clk_output_sel != DP83869_CLK_O_SEL_REF_CLK) {
+		/*
+		 * Table 7-121 in datasheet says we have to set register 0xc6
+		 * to value 0x10 before CLK_O_SEL can be modified.
+		 */
+		ret = phy_write_mmd(phydev, DP83869_DEVADDR,
+				    DP83869_ANA_PLL_PROG_PI, 0x10);
+		if (ret)
+			return ret;
+
 		ret = phy_modify_mmd(phydev,
 				     DP83869_DEVADDR, DP83869_IO_MUX_CFG,
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_MASK,
 				     dp83869->clk_output_sel <<
 				     DP83869_IO_MUX_CFG_CLK_O_SEL_SHIFT);
+	}
 
 	if (phy_interface_is_rgmii(phydev)) {
 		ret = phy_write_mmd(phydev, DP83869_DEVADDR, DP83869_RGMIIDCTL,
-- 
2.53.0



