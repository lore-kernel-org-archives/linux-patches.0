Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020739;
	b=q3SN9OFaLEakWigg1sm89+mcMMMf96CD4jfebOF3AcS/nhmo7BfTmFvAgcIlbh/HHHfJ
	 uEVLqfGiHsgghCLKw9Vf6/4wbABJHnSdRVmbk9SPBI0yNrDbwHZsXjZfB9nR/yPTtPfk3
	 ElgaOOfYeyx8JcEhzAV0tq1YFmfsQReTMWN1TnutM1y5fSV2pCaMRlwahu78BTNuav0V1
	 +Z3+KCYPxx23XMgvknLHDVu+G4u4rG6cbfPTKCUNEHYpGsGgpQuqiig9Eemw8uU5unKVV
	 PIA37vUPvumKxM0koYwV5sNuFZ8uXuCq+TEFtpjw78jeN3WZtQCMALY5+RvkIIdLAVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CjdJeWt7na4Xo54p3vV7cUHFgshlDJD6PRuDLM6EDGo=;
	b=uLedEEORGF5J+0U4tyd7G0zzEdBoq3lrf/Fh/w3amcLqDMAKuJKAKL2GNEHfVD8kXXTN
	 UucMOS5aZ/F0sq8wTIFL83kPh9DcbeJo15JymOONNh/ouZwpHlv5hs79Cwc8xLtksTYUw
	 mKKt+hZT3JOpYk4UUpCfapf9TQp2EMBsZifugtDFztInZPpMfhznhQwT2aYaqtoSFZ2wo
	 Mby1b0zp+66QKpGyYQfZ8juzUzj5zKxnuA3MR/4wY2zmeUCD1ebLIj2Vsj4XNzoMtSNS1
	 1kbOwP8WQktSZ3TxWKWqryKCNWEt3N6cfnVS4PdV4x7C/jjxariE5boB5XSQE3dQ/tQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRJjjCPc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F460A263D;
	Wed, 18 Nov 2026 16:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NRJjjCPc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09C8B1F000CE;
	Wed, 18 Nov 2026 16:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020739;
	bh=CjdJeWt7na4Xo54p3vV7cUHFgshlDJD6PRuDLM6EDGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NRJjjCPcRqrqwKczFRfoL3xHGG9YHeA+QugJHzgwXgGWVdrCojOGa5NTORCopCvB7
	 XbvleRNE2zeAxhzAVHpMuyVKJSDPRlUWrcxcX5k82VZHToy5NwimuiKep+AlYEBYru
	 t3JDGp45idDp6e57WZ6krKTBPyx5YVAt5llpRtW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yongzhao Chen <yongzhao.derek@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2052/2651] net: phy: qcom: at803x: Apply IPQ5018 analog settings at probe
Date: Wed, 18 Nov 2026 15:54:52 +0100
Message-ID: <20261118150359.946114738@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yongzhao Chen <yongzhao.derek@gmail.com>

[ Upstream commit 17baf30a0e64cde0e8a30723b7c6d06417152514 ]

ipq5018_probe() pulses the PHY reset, after which the IPQ5018 internal
GE PHY starts autonegotiating with its reset-default analog settings.
ipq5018_config_init() writes the analog settings only when the MAC
attaches the PHY, usually when the interface is opened. On a board
where the PHY connects to a QCA8337 PHY without a cable, 1000BASE-T
does not come up in the meantime, SmartSpeed downshifts both PHYs, and
only the IPQ5018 side restores its 1000BASE-T advertisement at attach,
so the link stays down.

Apply the analog settings in probe right after the reset and restart
autonegotiation. Move the settings into a helper shared with
config_init() and return MDIO errors from it instead of ignoring them.
The values written do not change, only the time of the write.

Fixes: d46502279a11 ("net: phy: qcom: at803x: Add Qualcomm IPQ5018 Internal PHY support")
Signed-off-by: Yongzhao Chen <yongzhao.derek@gmail.com>
Link: https://patch.msgid.link/20261002210408.730-1-yongzhao.derek@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/qcom/at803x.c | 98 +++++++++++++++++++++++++----------
 1 file changed, 70 insertions(+), 28 deletions(-)

diff --git a/drivers/net/phy/qcom/at803x.c b/drivers/net/phy/qcom/at803x.c
index cacbadf1f4841..09105f1e37379 100644
--- a/drivers/net/phy/qcom/at803x.c
+++ b/drivers/net/phy/qcom/at803x.c
@@ -1019,10 +1019,10 @@ static int ipq5018_cable_test_start(struct phy_device *phydev)
 	return 0;
 }
 
-static int ipq5018_config_init(struct phy_device *phydev)
+static int ipq5018_analog_init(struct phy_device *phydev)
 {
 	struct ipq5018_priv *priv = phydev->priv;
-	u16 val;
+	int val, ret;
 
 	/*
 	 * set LDO efuse: first temporarily store ANA_DAC_FILTER value from
@@ -1030,39 +1030,66 @@ static int ipq5018_config_init(struct phy_device *phydev)
 	 * is written to
 	 */
 	val = at803x_debug_reg_read(phydev, IPQ5018_PHY_DEBUG_ANA_DAC_FILTER);
-	at803x_debug_reg_mask(phydev, IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE,
-			      IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE_MASK,
-			      IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE_DEFAULT);
-	at803x_debug_reg_write(phydev, IPQ5018_PHY_DEBUG_ANA_DAC_FILTER, val);
+	if (val < 0)
+		return val;
+
+	ret = at803x_debug_reg_mask(phydev, IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE,
+				    IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE_MASK,
+				    IPQ5018_PHY_DEBUG_ANA_LDO_EFUSE_DEFAULT);
+	if (ret)
+		return ret;
+
+	ret = at803x_debug_reg_write(phydev, IPQ5018_PHY_DEBUG_ANA_DAC_FILTER,
+				     val);
+	if (ret)
+		return ret;
 
 	/* set 8023AZ EEE TX and RX timer values */
-	phy_write_mmd(phydev, MDIO_MMD_PCS, IPQ5018_PHY_PCS_EEE_TX_TIMER,
-		      IPQ5018_PHY_PCS_EEE_TX_TIMER_VAL);
-	phy_write_mmd(phydev, MDIO_MMD_PCS, IPQ5018_PHY_PCS_EEE_RX_TIMER,
-		      IPQ5018_PHY_PCS_EEE_RX_TIMER_VAL);
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS, IPQ5018_PHY_PCS_EEE_TX_TIMER,
+			    IPQ5018_PHY_PCS_EEE_TX_TIMER_VAL);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PCS, IPQ5018_PHY_PCS_EEE_RX_TIMER,
+			    IPQ5018_PHY_PCS_EEE_RX_TIMER_VAL);
+	if (ret)
+		return ret;
 
 	/* set MSE threshold values */
-	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, IPQ5018_PHY_MMD1_MSE_THRESH1,
-		      IPQ5018_PHY_MMD1_MSE_THRESH1_VAL);
-	phy_write_mmd(phydev, MDIO_MMD_PMAPMD, IPQ5018_PHY_MMD1_MSE_THRESH2,
-		      IPQ5018_PHY_MMD1_MSE_THRESH2_VAL);
+	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
+			    IPQ5018_PHY_MMD1_MSE_THRESH1,
+			    IPQ5018_PHY_MMD1_MSE_THRESH1_VAL);
+	if (ret)
+		return ret;
+
+	ret = phy_write_mmd(phydev, MDIO_MMD_PMAPMD,
+			    IPQ5018_PHY_MMD1_MSE_THRESH2,
+			    IPQ5018_PHY_MMD1_MSE_THRESH2_VAL);
+	if (ret)
+		return ret;
 
 	/* PHY DAC values are optional and only set in a PHY to PHY link architecture */
-	if (priv->set_short_cable_dac) {
-		/* setting MDAC (Multi-level Digital-to-Analog Converter) in MMD1 */
-		phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, IPQ5018_PHY_MMD1_MDAC,
-			       IPQ5018_PHY_DAC_MASK,
-			       FIELD_PREP(IPQ5018_PHY_DAC_MASK,
-					  IPQ5018_PHY_MMD1_MDAC_VAL));
-
-		/* setting EDAC (Error-detection and Correction) in debug register */
-		at803x_debug_reg_mask(phydev, IPQ5018_PHY_DEBUG_EDAC,
-				      IPQ5018_PHY_DAC_MASK,
-				      FIELD_PREP(IPQ5018_PHY_DAC_MASK,
-						 IPQ5018_PHY_DEBUG_EDAC_VAL));
-	}
+	if (!priv->set_short_cable_dac)
+		return 0;
 
-	return 0;
+	/* setting MDAC (Multi-level Digital-to-Analog Converter) in MMD1 */
+	ret = phy_modify_mmd(phydev, MDIO_MMD_PMAPMD, IPQ5018_PHY_MMD1_MDAC,
+			     IPQ5018_PHY_DAC_MASK,
+			     FIELD_PREP(IPQ5018_PHY_DAC_MASK,
+					IPQ5018_PHY_MMD1_MDAC_VAL));
+	if (ret)
+		return ret;
+
+	/* setting EDAC (Error-detection and Correction) in debug register */
+	return at803x_debug_reg_mask(phydev, IPQ5018_PHY_DEBUG_EDAC,
+				     IPQ5018_PHY_DAC_MASK,
+				     FIELD_PREP(IPQ5018_PHY_DAC_MASK,
+						IPQ5018_PHY_DEBUG_EDAC_VAL));
+}
+
+static int ipq5018_config_init(struct phy_device *phydev)
+{
+	return ipq5018_analog_init(phydev);
 }
 
 static void ipq5018_link_change_notify(struct phy_device *phydev)
@@ -1111,6 +1138,21 @@ static int ipq5018_probe(struct phy_device *phydev)
 
 	phydev->priv = priv;
 
+	/*
+	 * The PHY starts autonegotiation as soon as it leaves reset. Apply the
+	 * analog settings now instead of waiting for config_init() at attach
+	 * time, and restart autonegotiation so that it uses them.
+	 */
+	ret = ipq5018_analog_init(phydev);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "failed to apply analog settings\n");
+
+	ret = genphy_restart_aneg(phydev);
+	if (ret)
+		return dev_err_probe(dev, ret,
+				     "failed to restart autonegotiation\n");
+
 	return 0;
 }
 
-- 
2.53.0



