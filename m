Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FB1814D424;
	Tue, 23 Jan 2024 00:21:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969280; cv=none; b=LMDwNI3tfaZI5BxHDTok6vRDgM+pFWSuePPYI4d5EHO1TKwjDQlqyWBGbj+LWjapbGokUojsnZzFLOcmqzqWt9sRVerFP4pN2fz9G5CbiaD2kVzrrcuafhGP/Lyxt6hmikuxujpH7//005UY0EdHaNwn42H3D7zr2JGb1eybLLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969280; c=relaxed/simple;
	bh=uyDTYyvdJNFJwXIZG9ka5FiE70liZ7oT5dvAXH0mKS4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=meoYcaqwemHhY4xlnyY/OOS9wDFW0d8B4zXAKF2/LqvN4/zR44zi5ri0SBc4NWSGK8fAQqtoV/6zLafzUUM7oEp8obKKImVelZscvFO1GWYFkO436zYYZEEqaP/k50mVviBIGv4/8oSPv0ZxwuwEFPQ525Et+uRDx2U8ifDJY8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jA9cnVF2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jA9cnVF2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2157C433F1;
	Tue, 23 Jan 2024 00:21:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969280;
	bh=uyDTYyvdJNFJwXIZG9ka5FiE70liZ7oT5dvAXH0mKS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jA9cnVF2m5JKPb6huthUN8Geaqec4TqSSjAxF8uW2KA4c1o4yguXNRrwlssxgJgaq
	 JMWrRFYRsteOs+Mf/h9JVwX0FMkY6Un2eFAFOSfrMSuKprFcbsNNFE6DMkVsBY39gI
	 nBVp0VeA7IDsGvOmuC2ELLwqjePSixsuAvkN76ZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 141/641] arm64: dts: qcom: sc7280: Fix up GPU SIDs
Date: Mon, 22 Jan 2024 15:50:45 -0800
Message-ID: <20240122235822.462355858@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Dybcio <konrad.dybcio@linaro.org>

[ Upstream commit 94085049fdad7a36fe14dd55e72e712fe55d6bca ]

GPU_SMMU SID 1 is meant for Adreno LPAC (Low Priority Async Compute).
On platforms that support it (in firmware), it is necessary to
describe that link, or Adreno register access will hang the board.

The current settings are functionally identical, *but* due to what is
likely hardcoded security policies, the secure firmware rejects them,
resulting in the board hanging. To avoid that, alter the settings such
that SID 0 and 1 are described separately.

Fixes: 96c471970b7b ("arm64: dts: qcom: sc7280: Add gpu support")
Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
Link: https://lore.kernel.org/r/20230926-topic-a643-v2-2-06fa3d899c0a@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sc7280.dtsi | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/qcom/sc7280.dtsi b/arch/arm64/boot/dts/qcom/sc7280.dtsi
index 6d01262199dc..ea183eadf700 100644
--- a/arch/arm64/boot/dts/qcom/sc7280.dtsi
+++ b/arch/arm64/boot/dts/qcom/sc7280.dtsi
@@ -2598,7 +2598,8 @@ gpu: gpu@3d00000 {
 				    "cx_mem",
 				    "cx_dbgc";
 			interrupts = <GIC_SPI 300 IRQ_TYPE_LEVEL_HIGH>;
-			iommus = <&adreno_smmu 0 0x401>;
+			iommus = <&adreno_smmu 0 0x400>,
+				 <&adreno_smmu 1 0x400>;
 			operating-points-v2 = <&gpu_opp_table>;
 			qcom,gmu = <&gmu>;
 			interconnects = <&gem_noc MASTER_GFX3D 0 &mc_virt SLAVE_EBI1 0>;
-- 
2.43.0



