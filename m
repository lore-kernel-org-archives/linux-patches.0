Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B527327BEC;
	Wed, 30 Sep 2026 18:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794502; cv=none; b=KBtLF6SZhsrD9uFMy61c9ZYsy1ewqTqA2lTdvZz/Iuhbg/5Inc/m7/AQKk47SeIj5mbx5v/4wRE4OfA+Ns6Rz//wI6f7kLKQA83oG86G8jXfiRvKki8gUAWI6dT2MXtnJiKE27caIEcmchZHn1SXL/ta8WCsBgw3l+9c0bQXTLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794502; c=relaxed/simple;
	bh=McGehtSIEdeLSZy/53Orim8Foso3QuTe4ZWlIkjeUjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q+c7lv48ReGCxQedHZUggXG5KDyansvfCVTc21ns3I8jeSoJiGzWI584rTsDWdgdVtLW1hr+rUMbjNBDvWg1HNhDdnx59BXa7LDDbpJBsbgABtdDWpdCfuxTcg2BbgvETFLx2oAGXoana09jG3XCGKrX2+kA5kXmlU6rOZOSZdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoKNe4md; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoKNe4md"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 914CC1F000FF;
	Wed, 30 Sep 2026 18:55:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794500;
	bh=65PvnagmNk9HR5rlsZ4OpxRslnLtTAh3pClcutEdKHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xoKNe4mdde/xtxLNGPMo46k+oYTcaldMdNnn4x1JOJZ3mBeZZBryAr2aJA/Auvw69
	 qyVpO6qfznNtSYVdwBA1wE72jBOfRkuZgIQE8fAqzgKno8a/ztKP2+ZVj17zhaKjN0
	 K8x45c7k8AsTsaZ6iD/mavHcnISyXDSsKzUJoVMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	George Moussalem <george.moussalem@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0199/1193] net: dsa: qca8k: Add support for force mode for fixed link topology
Date: Wed, 30 Sep 2026 17:14:43 +0200
Message-ID: <20260930152438.628078188@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: George Moussalem <george.moussalem@outlook.com>

[ Upstream commit e0a77b1ed9001bdd0c73b99c67abb90f4bd7d7f5 ]

A fixed link topology is commonly used to connect this switch (on port
0 or 6) to a SoC's MAC over SGMII. When inband negotiation is not used,
the switch needs to be configured to operate in force mode. As such,
enable support for force mode.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: George Moussalem <george.moussalem@outlook.com>
Link: https://patch.msgid.link/20260605-qca8337-force-mode-v2-1-d9a6b6545bfa@outlook.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 22 ++++++++++++++++------
 drivers/net/dsa/qca/qca8k.h      |  1 +
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 384ae32c05b1c..872ae4aaae53b 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1526,7 +1526,7 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 {
 	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
 	int cpu_port_index, ret, port;
-	u32 reg, val;
+	u32 mask, reg, val;
 
 	port = pcs_to_qca8k_pcs(pcs)->port;
 	switch (port) {
@@ -1599,11 +1599,21 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 	if (priv->ports_config.sgmii_tx_clk_falling_edge)
 		val |= QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE;
 
-	if (val)
-		ret = qca8k_rmw(priv, reg,
-				QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
-				QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE,
-				val);
+	mask = (val) ? (QCA8K_PORT0_PAD_SGMII_RXCLK_FALLING_EDGE |
+			QCA8K_PORT0_PAD_SGMII_TXCLK_FALLING_EDGE) : 0;
+
+	/*
+	 * (Un)set force mode on QCA8337 only, don't include it in the mask for
+	 * others. It is written to the PORT0 PAD register for both port 0 and 6.
+	 */
+	if (priv->switch_id == QCA8K_ID_QCA8337) {
+		if (neg_mode == PHYLINK_PCS_NEG_OUTBAND)
+			val |= QCA8K_PORT_PAD_SGMII_FORCE_MODE;
+		mask |= QCA8K_PORT_PAD_SGMII_FORCE_MODE;
+	}
+
+	if (mask)
+		ret = qca8k_rmw(priv, reg, mask, val);
 
 	return 0;
 }
diff --git a/drivers/net/dsa/qca/qca8k.h b/drivers/net/dsa/qca/qca8k.h
index 8f88b7db384d0..65ba0b2f9ee42 100644
--- a/drivers/net/dsa/qca/qca8k.h
+++ b/drivers/net/dsa/qca/qca8k.h
@@ -58,6 +58,7 @@
 #define	  QCA8K_PORT_PAD_RGMII_TX_DELAY_EN		BIT(25)
 #define   QCA8K_PORT_PAD_RGMII_RX_DELAY_EN		BIT(24)
 #define   QCA8K_PORT_PAD_SGMII_EN			BIT(7)
+#define   QCA8K_PORT_PAD_SGMII_FORCE_MODE		BIT(3)
 #define QCA8K_REG_PWS					0x010
 #define   QCA8K_PWS_POWER_ON_SEL			BIT(31)
 /* This reg is only valid for QCA832x and toggle the package
-- 
2.53.0



