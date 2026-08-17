Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548B332ED40;
	Mon, 17 Aug 2026 13:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973959; cv=none; b=t96WG+abI2nUySMzW1+14j2tOoEDkGRZ7Snibv82m/fkKi9gD7nhWmZm2DsD4c9xYIbvfXMQodteOcUAuo6+dZulh9qywFNeZpd3ceHik2Hz5gXLyqJG+W7MZn8C2h8C/XZrzpyFOlyxvgf9dFlhGr72nflsUXrS0LYW9OE/WOU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973959; c=relaxed/simple;
	bh=RANeOaLsD9km5j+EG3vta2HLZ5sLr5xhp5rL1XLELa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zf6N242F4I4Tb1d5W6Z/szEFerch217ZX/rEIfsDsNBxO/6vsDdOu0VJiu26XrU2KH9J0LjqjIKn3L0YZoxJLM+2Ic3jwsXaBqd5+cxnOr9RPzhRtJ+w/S6hJ+NXm2VRrvar2x0hufsNjIcg9Reh8BswXMWg5bQDliNCAZu4X8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X4xl0BE1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X4xl0BE1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 834181F000E9;
	Mon, 17 Aug 2026 13:39:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973958;
	bh=2G7jHO2VNM10GQEh4XM6o11au64pPxYmsLQVgCJsB0Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X4xl0BE12XvnDtVQY4PHqD+t2xXYiY9MyVt2MO0WpaF0q9wRIWSGFTbf9Ez/uKqy3
	 wuhdeYr1uXdNhIp3psvzWgljWgEow1XOmd9yaYj/YX8CjK+3x5NBuutDRTBxcKQ486
	 wIwnpCh0LZcDg7DFVRG/kLHjMegATXxk3KK6MkWw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 007/271] arm64: dts: qcom: glymur: fix PCIe SMMU interrupts
Date: Mon, 17 Aug 2026 15:28:52 +0200
Message-ID: <20260817132537.055855284@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>

[ Upstream commit 52c7084c8fe57c259e50ff0a7d4f99ccecfc4c7a ]

The PCIe SMMUv3 wired interrupts are routed to GIC extended SPI INTIDs
4100, 4098 and 4096. Describe them as ESPIs with the ESPI-relative
interrupt numbers instead of regular SPIs 964, 962 and 960.

Assisted-by: Codex:GPT-5.5
Fixes: 41b6e8db400c ("arm64: dts: qcom: Introduce Glymur base dtsi")
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260611-glymur-pcie-smmu-espi-v1-1-5effbaa3e1af@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/glymur.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/glymur.dtsi b/arch/arm64/boot/dts/qcom/glymur.dtsi
index 63df60b7e010e..468614d101c02 100644
--- a/arch/arm64/boot/dts/qcom/glymur.dtsi
+++ b/arch/arm64/boot/dts/qcom/glymur.dtsi
@@ -5626,9 +5626,9 @@ apps_smmu: iommu@15000000 {
 		pcie_smmu: iommu@15480000 {
 			compatible = "arm,smmu-v3";
 			reg = <0x0 0x15480000 0x0 0x20000>;
-			interrupts = <GIC_SPI 964 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 962 IRQ_TYPE_LEVEL_HIGH>,
-				     <GIC_SPI 960 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_ESPI 4 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_ESPI 2 IRQ_TYPE_LEVEL_HIGH>,
+				     <GIC_ESPI 0 IRQ_TYPE_LEVEL_HIGH>;
 			interrupt-names = "eventq", "cmdq-sync", "gerror";
 			dma-coherent;
 			#iommu-cells = <1>;
-- 
2.53.0



