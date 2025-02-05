Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9CE17C21C;
	Wed,  5 Feb 2025 14:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766629; cv=none; b=Ir3Z/C5MaujBGlinoUpYBPDiFNifpoAwRkz6HygFkhc0vs0l640iF2lFLp4QGF8JKwybvT/Uu4brx9SpAnLEPSQGNILZJI9L94yPuA99+0bdEY9YDYOjKr+US4mZRlfOHT87WbOTbhtrxE6L2jP8SkQufnZOmkefKKsw6f9/b2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766629; c=relaxed/simple;
	bh=EW8L8hlmplUVWyrGOWHmNUt6+PsLoys8s2g4k2gHoIY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvLKj+PuWU+Ux0lC+Ez4OKQZOpjhehMsJCauSJ1zu3i+BGzLkM4IH7uWkQEdI43Snct45LZo6pzDB2JM99L7KGGkFcz2a4ctorVYW9e8SFjdH86D/F4NpZhtrbX+7c1WgSTZs+Jd22ZPEfma6GFjHaikdNacsTe+9aqfo79BwIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HdRRWcFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HdRRWcFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A6B6C4CED1;
	Wed,  5 Feb 2025 14:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766629;
	bh=EW8L8hlmplUVWyrGOWHmNUt6+PsLoys8s2g4k2gHoIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HdRRWcFnsj9qnNCGQGY5r42K7/BQ5Q9UInmojWTRqw3ezjfXQQHymTtj+bENBsuXy
	 vRBdRZDXcbVJk3sEmu5xevYwMEDkTKGf1ntyAhhGE7VxXLIhHG/tz/MOLCyCmr+N3m
	 5k7hzOk4YCWMyLB4NcTlLv3GrMMyWo67cmDETYgs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Petr Vorel <petr.vorel@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 341/590] arm64: dts: qcom: msm8994: Describe USB interrupts
Date: Wed,  5 Feb 2025 14:41:36 +0100
Message-ID: <20250205134508.319885799@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit c910544d2234709660d60f80345c285616e73b1c ]

Previously the interrupt lanes were not described, fix that.

Fixes: d9be0bc95f25 ("arm64: dts: qcom: msm8994: Add USB support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Tested-by: Petr Vorel <petr.vorel@gmail.com>
Link: https://lore.kernel.org/r/20241129-topic-qcom_usb_dtb_fixup-v1-4-cba24120c058@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/msm8994.dtsi | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/msm8994.dtsi b/arch/arm64/boot/dts/qcom/msm8994.dtsi
index fc2a7f13f690e..ed2b90148d9f7 100644
--- a/arch/arm64/boot/dts/qcom/msm8994.dtsi
+++ b/arch/arm64/boot/dts/qcom/msm8994.dtsi
@@ -437,6 +437,15 @@
 			#size-cells = <1>;
 			ranges;
 
+			interrupts = <GIC_SPI 180 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 311 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 133 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_SPI 310 IRQ_TYPE_LEVEL_HIGH>;
+			interrupt-names = "pwr_event",
+					  "qusb2_phy",
+					  "hs_phy_irq",
+					  "ss_phy_irq";
+
 			clocks = <&gcc GCC_USB30_MASTER_CLK>,
 				 <&gcc GCC_SYS_NOC_USB3_AXI_CLK>,
 				 <&gcc GCC_USB30_SLEEP_CLK>,
-- 
2.39.5



