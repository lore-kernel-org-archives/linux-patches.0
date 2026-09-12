Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D49A2D0C75;
	Sat, 12 Sep 2026 12:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217483; cv=none; b=ueHZ8H2CEDvhclF1PV7AjDtZmZTHkpWyjw5TJaJJi+jLWTS78PMSh5vLaNZDoieh0E48ZkHqNPCb3+SaHjvfrmk4Wkuq0XhWi4UHpTmtlfwf7Sul7rdNOvepI1ozLUTugNmFrecKGq5zlktlk5OAsv01STiCjJ0KfbyJoy7M7RE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217483; c=relaxed/simple;
	bh=4i4YH8lVhlfpgVIg5xMHujfCrpXdCVrw1gNcVJXym0w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rWUfbpl42hN25YlU661vSHr1E5vpJcMaH+WrLjiAMh+/mPyiAECPnPcRAhP97RP6T+s4zF6zA05VBx41Fl9V5OFl2QqLek2DM3oZuqIw6AWNSvmCXmKytyX9E3jAuJVlaYdKGKKErEQl66dVb7c0USrj4I/AczwxnaMM9zJ/xAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7RfUQ1o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7RfUQ1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D6421F000FF;
	Sat, 12 Sep 2026 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217482;
	bh=aZWBaiIJ0zett3k/OaNGDJ+30u1/03rgnkZuQRDtUMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7RfUQ1ojKJPQx8LTB6aHXfU8q7Q+2Iv2EE+XfZQBBb7M1T/f9b6X8U+x+toBJ8A/
	 mGiQ7ETUIDcYvTvK4Ig6nmtViBGGByfL+Fs+w+gkmZmrnfCERmlXsqYULd8MHKM23i
	 Rey7b0Y79Xz1tTLJy2bbjnNf/tFEuxnSlDp8buBw=
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
Subject: [PATCH 6.12 0950/1376] phy: qcom-sgmii-eth: relax order of .power_on() vs .set_mode*()
Date: Sat, 12 Sep 2026 08:56:16 +0200
Message-ID: <20260912065628.732508939@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b1c82459c126..d46a5e4df830a 100644
--- a/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
+++ b/drivers/phy/qualcomm/phy-qcom-sgmii-eth.c
@@ -267,8 +267,17 @@ static int qcom_dwmac_sgmii_phy_calibrate(struct phy *phy)
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
@@ -293,6 +302,9 @@ static int qcom_dwmac_sgmii_phy_set_speed(struct phy *phy, int speed)
 	if (speed != data->speed)
 		data->speed = speed;
 
+	if (phy->power_count == 0)
+		return 0;
+
 	return qcom_dwmac_sgmii_phy_calibrate(phy);
 }
 
-- 
2.53.0



