Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DDEF20DD51;
	Mon,  4 May 2026 13:56:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777902992; cv=none; b=Kug86tPd14/JfjPrQM1n8TKFObwmsD24+GWCts9QRk6gpr8QYC8oSasoquosC+e8KUbX+S3KwMh7wZrLKb/PswivRa3tiRG/c2XGD7ToLkyGkxaqBYJlGdbECjEwvxwnb1Xvm5WkHuVWLmATlv9cYPMiyOwmWL3ysCwjkR7RF/k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777902992; c=relaxed/simple;
	bh=1BsSI3d/zegQxs+vAOUAYfjlIWTyzDS9JgWR261Ejac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aeOxRHvrOJ0jnGYWcK9n52Kwkur++j0QubzPLtOsmJgCw3l/vCyhmv0Aqu6DLPjr2M3z3Vzkl18zOimYJ2nEpiwdKVrPuYVwVywbkdsLK9u3ejEEMeZITGNk4kuAJcKvUp6yTFO+6QhsX9O4LQ+nh82I4TN4FS+hUEk174wYmZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pYVzJNad; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pYVzJNad"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AAEC2BCB8;
	Mon,  4 May 2026 13:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777902992;
	bh=1BsSI3d/zegQxs+vAOUAYfjlIWTyzDS9JgWR261Ejac=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pYVzJNadkVeNFL7Ldcs8nb8b/RbmxyJ/7deSfSmD9TFBZM13aL6myLDqKqb0Ij9Dn
	 3yZw6GVmkY2hjdNzzRkBBLGj04SK49v44oaeWsYLp0juExM1rEWgKZC8bVzESDkkNp
	 mzOm0GgQYo45BKaETynFhJL00AC0XnbULzyx1wHM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elson Serrao <elson.serrao@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 7.0 060/307] phy: qcom: m31-eusb2: clear PLL_EN during init
Date: Mon,  4 May 2026 15:49:05 +0200
Message-ID: <20260504135145.078668285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

From: Elson Serrao <elson.serrao@oss.qualcomm.com>

commit 520a98bdf7ae0130e22d8adced3d69a2e211b41f upstream.

The driver currently sets bit 0 of USB_PHY_CFG1 (PLL_EN) during PHY
initialization. According to the M31 EUSB2 PHY hardware documentation,
this bit is intended only for test/debug scenarios and does not control
mission mode operation. Keeping PLL_EN asserted causes the PHY to draw
additional current during USB bus suspend. Clearing this bit results in
lower suspend power consumption without affecting normal operation.

Update the driver to leave PLL_EN cleared as recommended by the hardware
documentation.

Fixes: 9c8504861cc4 ("phy: qcom: Add M31 based eUSB2 PHY driver")
Cc: stable@vger.kernel.org
Signed-off-by: Elson Serrao <elson.serrao@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://patch.msgid.link/20260217201130.2804550-1-elson.serrao@oss.qualcomm.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/phy/qualcomm/phy-qcom-m31-eusb2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
+++ b/drivers/phy/qualcomm/phy-qcom-m31-eusb2.c
@@ -83,7 +83,7 @@ static const struct m31_phy_tbl_entry m3
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_CFG0, UTMI_PHY_CMN_CTRL_OVERRIDE_EN, 1),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_UTMI_CTRL5, POR, 1),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_HS_PHY_CTRL_COMMON0, PHY_ENABLE, 1),
-	M31_EUSB_PHY_INIT_CFG(USB_PHY_CFG1, PLL_EN, 1),
+	M31_EUSB_PHY_INIT_CFG(USB_PHY_CFG1, PLL_EN, 0),
 	M31_EUSB_PHY_INIT_CFG(USB_PHY_FSEL_SEL, FSEL_SEL, 1),
 };
 


