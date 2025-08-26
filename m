Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 201E228000C;
	Tue, 26 Aug 2025 13:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213544; cv=none; b=TIhOUNSkGEeytwCpz/0VK4UlyrRZs/1yY4eaG3vfTjLl9SZ/gKcX1E3wvtckKPyTzhd2zd9J2pc/DU6uY7v9/9uHh/n93TUOmesTEgbu0YR8Mown9MMh+oEGOustxGVjAxSLK5cV3EFfbA9CvMWGVI7TG1vnQy72FS/Tqddlz7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213544; c=relaxed/simple;
	bh=ynzZZ1WveFX6Zdc9Pu3fkpgqS8OX/onsvj+UUny2NiA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JEtvGstM0tzXtQFyoR9RePYMCLV6Achp6EgeOwxW0CiYSyVNqIbD2xpsvWSoDJq0wBYKzxsS9U6IUbo2ZCLqr9Hk3AZGZv8Maa4ft6CVDB8WsdzVczbdXFHZjJj9sgxgm6eaYksqbAkgrHAbmwMsV1/ftvUIn13ONFT5Apju78Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CijGA5/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CijGA5/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB4CC4CEF4;
	Tue, 26 Aug 2025 13:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213544;
	bh=ynzZZ1WveFX6Zdc9Pu3fkpgqS8OX/onsvj+UUny2NiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CijGA5/OFgWPFmKVJFAep1p3qmYH+Ked6pgRFLq8uxAquqv8Md4U0qDpTcMFMnbMF
	 RQCmT0y1v9mQg2O0ki9C+YJhh6LxXKYUg6WFPCQ03xXR5MPB8Be7iImqjgUUokKMp5
	 a3Naju1nGKKKgLlTEmMehP0RklB14W83dlat12T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 388/587] phy: qcom: phy-qcom-m31: Update IPQ5332 M31 USB phy initialization sequence
Date: Tue, 26 Aug 2025 13:08:57 +0200
Message-ID: <20250826111002.785927543@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>

commit 4a3556b81b99f0c8c0358f7cc6801a62b4538fe2 upstream.

The current configuration used for the IPQ5332 M31 USB PHY fails the
Near End High Speed Signal Quality compliance test. To resolve this,
update the initialization sequence as specified in the Hardware Design
Document.

Fixes: 08e49af50701 ("phy: qcom: Introduce M31 USB PHY driver")
Cc: stable@kernel.org
Signed-off-by: Kathiravan Thirumoorthy <kathiravan.thirumoorthy@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20250630-ipq5332_hsphy_complaince-v2-1-63621439ebdb@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-m31.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/phy/qualcomm/phy-qcom-m31.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31.c
@@ -58,14 +58,16 @@
  #define USB2_0_TX_ENABLE		BIT(2)
 
 #define USB2PHY_USB_PHY_M31_XCFGI_4	0xc8
- #define HSTX_SLEW_RATE_565PS		GENMASK(1, 0)
+ #define HSTX_SLEW_RATE_400PS		GENMASK(2, 0)
  #define PLL_CHARGING_PUMP_CURRENT_35UA	GENMASK(4, 3)
  #define ODT_VALUE_38_02_OHM		GENMASK(7, 6)
 
 #define USB2PHY_USB_PHY_M31_XCFGI_5	0xcc
- #define ODT_VALUE_45_02_OHM		BIT(2)
  #define HSTX_PRE_EMPHASIS_LEVEL_0_55MA	BIT(0)
 
+#define USB2PHY_USB_PHY_M31_XCFGI_9	0xdc
+ #define HSTX_CURRENT_17_1MA_385MV	BIT(1)
+
 #define USB2PHY_USB_PHY_M31_XCFGI_11	0xe4
  #define XCFG_COARSE_TUNE_NUM		BIT(1)
  #define XCFG_FINE_TUNE_NUM		BIT(3)
@@ -120,7 +122,7 @@ static struct m31_phy_regs m31_ipq5332_r
 	},
 	{
 		USB2PHY_USB_PHY_M31_XCFGI_4,
-		HSTX_SLEW_RATE_565PS | PLL_CHARGING_PUMP_CURRENT_35UA | ODT_VALUE_38_02_OHM,
+		HSTX_SLEW_RATE_400PS | PLL_CHARGING_PUMP_CURRENT_35UA | ODT_VALUE_38_02_OHM,
 		0
 	},
 	{
@@ -130,10 +132,14 @@ static struct m31_phy_regs m31_ipq5332_r
 	},
 	{
 		USB2PHY_USB_PHY_M31_XCFGI_5,
-		ODT_VALUE_45_02_OHM | HSTX_PRE_EMPHASIS_LEVEL_0_55MA,
+		HSTX_PRE_EMPHASIS_LEVEL_0_55MA,
 		4
 	},
 	{
+		USB2PHY_USB_PHY_M31_XCFGI_9,
+		HSTX_CURRENT_17_1MA_385MV,
+	},
+	{
 		USB_PHY_UTMI_CTRL5,
 		0x0,
 		0


