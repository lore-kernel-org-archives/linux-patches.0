Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAB61D7E5C;
	Sat, 12 Sep 2026 14:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224968; cv=none; b=rEJAfwis1GERqr0+Yq0aBQDALbU+cQNapmy1SzyzTpwH6WYGbpx3NvD67u8MPbAn+CvHY2HWeRKKJrG3xpGJhBae2JZyith6e3WwdmPg72Q5WvPEsW6ri2jY/CEUDuPoJpBDoJ4ug/F3bU7KZZohcMejWxignxtNdTiG3F+cKZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224968; c=relaxed/simple;
	bh=Kcx6qlXV9y3kgN1XqRegevGrTHWvTxl6oVgWf8w+EQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OKO9pqXkS4P3KmHq0iuVpgREp72MW2JcMbcadFcibjIh5/pxhbXaMD1l/daNxNpZm5GKwqGMxuCU7RWrd4ssgSC5C/dx1t7dEA0FpzSeGu3r/mHwecoPFy5IuJpnuCbTJ/aXN0Xm4VuyFZJXpj0dP8qEqpNfJ3OdGL8XVaj7MvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okGpA7Dc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okGpA7Dc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736621F000FF;
	Sat, 12 Sep 2026 14:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224967;
	bh=RVEkP56ykDslVlht2TYK8Qc98MV9ndlZcjqG5IL3dVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=okGpA7Dc66q3h3e0zsQHGHCIZJDw0gnC579szdOdHdgrP2y5c5qDf3zHxFNvjPxo4
	 euEd2+f8x5uCLQ1htTi1Tu73qa3o+3YObmGI9lKf8EHnIxl0M9fW6+ayW1Q6pmpKpw
	 LKdhKA0gzvleqYODucvV8LsaNXo5SZj/9dlKXxLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1103/1424] phy: qcom-sgmii-eth: relax order of .power_on() vs .set_mode*()
Date: Sat, 12 Sep 2026 08:58:55 +0200
Message-ID: <20260912065632.006490015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

[ Upstream commit ebe8b48b88ad012cf6067226e184e9173b7ea9d6 ]

Allow any order of the .power_on() and .set_mode*() methods as per the
recent discussion. This means phy_power_on() with this SerDes will now
restore the previous setup without requiring a subsequent
phy_set_mode*() call.

Tested-by: Mohd Ayaan Anwar <mohd.anwar@oss.qualcomm.com>
Acked-by: Vinod Koul <vkoul@kernel.org>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/E1vxS4P-0000000BQXs-0vGB@rmk-PC.armlinux.org.uk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 4f81684a1d10 ("phy: qcom: sgmii-eth: vote for both voltage rails with correct current loads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/phy/qualcomm/phy-qcom-sgmii-eth.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
index 03dc753f0de1f..43ff0c5551e3b 100644
--- a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
+++ b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
@@ -346,8 +346,17 @@ static int qcom_dwmac_sgmii_phy_calibrate(struct phy *phy)
 static int qcom_dwmac_sgmii_phy_power_on(struct phy *phy)
 {
 	struct qcom_dwmac_sgmii_phy_data *data = phy_get_drvdata(phy);
+	int ret;
 
-	return clk_prepare_enable(data->refclk);
+	ret = clk_prepare_enable(data->refclk);
+	if (ret < 0)
+		return ret;
+
+	ret = qcom_dwmac_sgmii_phy_calibrate(phy);
+	if (ret < 0)
+		clk_disable_unprepare(data->refclk);
+
+	return ret;
 }
 
 static int qcom_dwmac_sgmii_phy_power_off(struct phy *phy)
@@ -372,6 +381,9 @@ static int qcom_dwmac_sgmii_phy_set_speed(struct phy *phy, int speed)
 	if (speed != data->speed)
 		data->speed = speed;
 
+	if (phy->power_count == 0)
+		return 0;
+
 	return qcom_dwmac_sgmii_phy_calibrate(phy);
 }
 
-- 
2.53.0



