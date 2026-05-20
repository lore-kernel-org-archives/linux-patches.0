Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7493FB7FC;
	Wed, 20 May 2026 18:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302781; cv=none; b=DR9rqhtDY+6NcAu14GxPTOMuw9WCG3UueqOskzKgLmRjimbfGSAyNbHy3dEAPtsA5tkLSQ8Wy4T/ze57jiQ0MWTV7sWLR2KI+3NWL9wePoTziIsD8cDPf85NA5PjI0/0FxJAeSHkYPtoEBw7ve3voa2+RIEMfHgZEJnPHqz1eTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302781; c=relaxed/simple;
	bh=j62D+Qzs9DaZGgsSLSPAr/wScl0FABJ6lHQnPS/3XFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk1q7BsbW12DZQe+ki+7jGXlqD+olk+g6mUg/Qsb3HQyvMO8wjpIno54LUCuTL4cPPh1cGeW9S1baoST/O0RcRsEAK59LYb9glmxFBBP2K72iz7bxNwjobj9Mv4MZMpa0f2v4snhdQek60tqD7qwaYbLf/5G7FE3ttHeg5df/Dc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r5kSdZt6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r5kSdZt6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFFF01F000E9;
	Wed, 20 May 2026 18:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302780;
	bh=f76BcmtqcolDI3ROc6AeRmizE5ktj06nwMvzoqLrBR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r5kSdZt6X3BXDnV7ZAfR9tgWWLOiItqJUW4gKkztufPZVTm6OV/XaG1p7Pn6l/P91
	 MoWRZVVMK+23PYMCcx2MULhqdPaFTEpeyvkZoyaQ3VdB9kob8q8YXh7Y2omzJOG2Ik
	 eJoSbjNHpf7kc+DnOAT7PT9OBv09uF1hKY0OASkg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heiko Schocher <hs@nabladev.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 398/508] net: phy: dp83869: fix setting CLK_O_SEL field.
Date: Wed, 20 May 2026 18:23:41 +0200
Message-ID: <20260520162107.237644003@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5f056d7db83ee..760785160ab49 100644
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
@@ -814,12 +815,22 @@ static int dp83869_config_init(struct phy_device *phydev)
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



