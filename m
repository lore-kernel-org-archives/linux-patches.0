Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30AE51C3F0A;
	Wed, 19 Feb 2025 09:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956363; cv=none; b=O/7ZC0m+CKAjJdV3NidGMzXa8Z2zSu27STFTJvCpCZY0C/zo0S+zTC+7/Uhn6RUXAJXxPy0Wvac4edYiA/sn5KrNqVEnnzKOW5yP4d93/CgwSF437tBDwbV+wa9BYUjziN3O7F5K0XVDBd4zmVcy0Gk1RaO2D4opJymMBTcz26k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956363; c=relaxed/simple;
	bh=4FvK16pjFoH+pwSVWqqHalZ0XzITYgpn5os7vjtCW+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L1EdB5rKRWThO72Ird4Jp6l9/7eq8qSfeHUvzNPe6hl1EBKKtoKHz3qWekQy96a2UuYGNzGy9huLU+u4zI0A1XBiEuT641R8Viz3BK2EtdT8Dwh+6xZlJ6eGCIH2/4T4dCIA59YZaWKKYdII2gUFu9XWZKYI7jAsYAPFAn7dFr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UgN/P+90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UgN/P+90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD595C4CED1;
	Wed, 19 Feb 2025 09:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956363;
	bh=4FvK16pjFoH+pwSVWqqHalZ0XzITYgpn5os7vjtCW+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UgN/P+90LMlagof7slgFsxNzYiZxijbZIbWrVVEKP8lglFujM0A9Kkwe622O2s8M4
	 0my/NFWMWoPqAww4zAmwLtrg/xP5IF+fPNiavRM35ZBDyiGMC7FRbWy737XANe5MPG
	 wXtU9XJFGv7RbTRhFeWXm99AM4XMwLya1MTf5gh8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/578] arm64: dts: qcom: msm8996: Fix up USB3 interrupts
Date: Wed, 19 Feb 2025 09:22:38 +0100
Message-ID: <20250219082659.032701502@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 9cb9c9f4e1380da317a056afd26d66a835c5796c ]

Add the missing interrupt lines and fix qusb2_phy being an impostor
of hs_phy_irq.

This happens to also fix warnings such as:

usb@6af8800: interrupt-names: ['hs_phy_irq', 'ss_phy_irq'] is too short

Fixes: 4753492de9df ("arm64: dts: qcom: msm8996: Add usb3 interrupts")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20241129-topic-qcom_usb_dtb_fixup-v1-3-cba24120c058@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8996.dtsi | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/msm8996.dtsi b/arch/arm64/boot/dts/qcom/msm8996.dtsi
index 3b9a4bf897014..b3ebd0298f645 100644
--- a/arch/arm64/boot/dts/qcom/msm8996.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8996.dtsi
@@ -2968,9 +2968,14 @@
 			#size-cells = <1>;
 			ranges;
 
-			interrupts = <GIC_SPI 347 IRQ_TYPE_LEVEL_HIGH>,
+			interrupts = <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 347 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 243 IRQ_TYPE_LEVEL_HIGH>;
-			interrupt-names = "hs_phy_irq", "ss_phy_irq";
+			interrupt-names = "pwr_event",
+					  "qusb2_phy",
+					  "hs_phy_irq",
+					  "ss_phy_irq";
 
 			clocks = <&gcc GCC_SYS_NOC_USB3_AXI_CLK>,
 				 <&gcc GCC_USB30_MASTER_CLK>,
-- 
2.39.5



