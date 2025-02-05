Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDB91519AA;
	Wed,  5 Feb 2025 14:18:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765110; cv=none; b=D3rrNnWT6p0LMmP042MdJRsNrfQrBtgX8LEDxanaCvLvEzAOlG7kxoqafUhtj3IBSL7Q3JhKr6NCHnuXw/6HzUwnapwptBZRPysLbvEKm9Yhm5/1jBlIT141mUSHbpvMxVWM5U/dTy8cYpmM6J3KOu68cHBoF0imWqzosb3tCAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765110; c=relaxed/simple;
	bh=uxLTZPRFtK/t9CH2PA7ugg/CITYxZcMVNLnQAHsnY0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vBGAMOUTZ9MbJ8ud2QHXOv+HBCZd4Dg9G/9vYgHz+5wKP5K1I1gVoqn0wGwxmztHOJG8I9mIl7vE2jjlLlqELvDA9PIfR9NegKOhAQOM+nrqd6UWUhtbTxyCkuZpFLfjshrevhs7z4evUqmO4vB/w+9bcGuJZsU+XBJhU8sMfKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=darzI3WV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="darzI3WV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D40C4CED6;
	Wed,  5 Feb 2025 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765109;
	bh=uxLTZPRFtK/t9CH2PA7ugg/CITYxZcMVNLnQAHsnY0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=darzI3WVpfnJKabYNbaeh4Lx+D1TmnHgHG/pmO7GcIp8jnD1R9ypnEZKVa7SkBbvX
	 PLW8sSlmF+/oqnVvLF1VJiZlsnvIuFFup+aLYAf7uLwoaaexytUxnOWP+lhfzbTci/
	 JG7O+iiLPUA08oOSaWU5u4bcXArcjTOEmFkC+lcs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Petr Vorel <petr.vorel@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 233/393] arm64: dts: qcom: msm8994: Describe USB interrupts
Date: Wed,  5 Feb 2025 14:42:32 +0100
Message-ID: <20250205134429.222386891@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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
index c3262571520d3..875d50c574e95 100644
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



