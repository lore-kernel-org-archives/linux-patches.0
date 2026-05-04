Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4565635A3AD;
	Mon,  4 May 2026 14:18:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904280; cv=none; b=FRK9TRncEynsafj8+hcP5FRFgeKRqRe21stkdwEnR/rIb27YDbvrm09Kh9KIKi7HWNFUzr+8tU9eqxFdzrhVkM3KOCS+DLJDo5TO8lrDM0uuZ0tUjkTJL2llep6wXju8UMAQDINkosAM/u5ermd5LBrRwSyO1lIP9RympKlU9EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904280; c=relaxed/simple;
	bh=eLynRla0t8fZLT4rNEEj4xhZSDgeEZc4FmE/gez5rVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=urgftmMM7+KqwJ1LJbmKyCbTxUFPFVun8VAhq8l3esbOBguZ1fBUu0anARRmd5bLUzpuifEG/e5JX09EXIfnd5j469Pr8YHVYg7olZNaVUjmh3w7ih6E+DLzr0NhaEq7V6QgEq9NbhdNpxxpHP1xazEepuoEDzhSKBDh1YlJqP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=URnvSUM+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="URnvSUM+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC58CC2BCF4;
	Mon,  4 May 2026 14:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904280;
	bh=eLynRla0t8fZLT4rNEEj4xhZSDgeEZc4FmE/gez5rVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URnvSUM+3lmthPdenzgalz0dlUhMJTjoTCzunf++Vu4UpT26T+qTL+pCFvmlcVKMx
	 B42EYtLZQrZ2TVjBTZ3zcBsR/rG2eYpKK/8e84W9iFcYG2xqBQSL0AJ2jKoXLslted
	 5eluLLyO4CmMZjAP7itVuDKG9PaTZLNa1Nig7NDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elson Serrao <elson.serrao@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 253/275] phy: qcom: m31-eusb2: clear PLL_EN during init
Date: Mon,  4 May 2026 15:53:13 +0200
Message-ID: <20260504135152.437528109@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Elson Serrao <elson.serrao@oss.qualcomm.com>

[ Upstream commit 520a98bdf7ae0130e22d8adced3d69a2e211b41f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
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
 


