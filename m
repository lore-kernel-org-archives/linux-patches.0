Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC014518146;
	Thu, 17 Sep 2026 17:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789664448; cv=none; b=RWkJh8I67gM84sovVmtmwNcVmKgAPpJwXMOXxCWH+xHpDLniOVciboKYKxXtwddqHJ3w6OaZrd4D8PlkzaLA5WkTxmdVHNPWHLKcqo7GZkDtk+KW7fn8ZATHmAfV5srJmj98EAuPjY/dFGc1qExPo34RWqvIwE0uhPQk85id2Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789664448; c=relaxed/simple;
	bh=XFP65YnJC1tUveGbvddu1087TO8yADAn8cwSuUBS2e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U+nEFHJqSPUlPg4Yh2beP6bXslSZTaWqaocR2h1SgkFZ1QxnYGIbN6rxd69ZkqfgW5hPxAVYM9la8BtBb29dI70ntDPTeX7KbabxuLebmZaEapOUzAjPkLYjNr1sRRESQHAz5emoro0wpHEvwhyMnVXBw0FyvzGUdzLGEbQAHcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QVXhhNp9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QVXhhNp9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D17B1F000FF;
	Thu, 17 Sep 2026 17:00:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789664446;
	bh=SgeEb6B3PVWOLnZ6F0Fe8B8WS9znfPXC2/na+0CSJWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QVXhhNp9lk8OA4CmttaqJaMag6iMP7zIMomPbF0zcbk8yBkZi4tIlpVDiGgr5pzGM
	 xgm4Qrw1XqzL/WeDYU/YyAfW2Wa2RX5/cCX2MWzjE8h2N1hE2co+qCgP9Tc+cpnaY5
	 5JdntcUcOLY6XzGRFtWeHHFM7eZJyp+yaOUgpmK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	George Moussalem <george.moussalem@outlook.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0375/1250] net: dsa: qca8k: Add support for force mode for fixed link topology
Date: Thu, 17 Sep 2026 16:02:50 +0100
Message-ID: <20260917151602.217649941@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index a36b8b07030e3..4c928983b8623 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -1538,7 +1538,7 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
 {
 	struct qca8k_priv *priv = pcs_to_qca8k_pcs(pcs)->priv;
 	int cpu_port_index, ret, port;
-	u32 reg, val;
+	u32 mask, reg, val;
 
 	port = pcs_to_qca8k_pcs(pcs)->port;
 	switch (port) {
@@ -1611,11 +1611,21 @@ static int qca8k_pcs_config(struct phylink_pcs *pcs, unsigned int neg_mode,
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
index d046679265fa4..ed8f0b49812c4 100644
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



