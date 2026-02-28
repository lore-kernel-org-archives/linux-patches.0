Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DB07338939
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301729; cv=none; b=uwpScHoJmwIYRy0ynywAVfgYYKVqAWmiBUTEUf/x0vq2AczybbKUS2Jt5oJ+XgpWEJepm9hdgEjpP4lvV4sGVhTiBEN/duFDbOKGwHDCvVEevVf8B/oAwf2yQK4kwcUhw0RgYNVwe+ZOioRr9W9oftbexRLIR8M32U5Wc7sW90Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301729; c=relaxed/simple;
	bh=IzXyQrn4Zk7TmX6CDeV1EzZwhlsMaeUWV/1MqiYAFu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orLn9Id2mePmTmE5Ap9Zk2rSAee4MTmPjmiUrjeP+eMpfOj2d1onbjDwtOTaVZ0Odb2rFks2t1bXYBPfpQl2GVcY+QVy6NizOCVzuUp2s7SLsvwUNfr+qT8bCmPxdrm67a5W6naYplPQBJFXm+PCLGdB/JxkqXzfWYjxDpjD+JE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruEN+Jfx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruEN+Jfx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E077C116D0;
	Sat, 28 Feb 2026 18:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301729;
	bh=IzXyQrn4Zk7TmX6CDeV1EzZwhlsMaeUWV/1MqiYAFu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ruEN+JfxlenKPdniDTIRlBDThuG8Dtqf0SF0OKGZafRBr1e31TY9O3854dsv7Bteb
	 f/xyQyuruhcRNe2SWwe3J2tcuANmYZH3gbhTl2bEqbVcusS5uIlSlC2QdajVOoha/K
	 m/WmTPLMsnhE3wy9UKAC+2aNKK1TM6A0fo5jRfDCpkeYdXyV/8gXY2NrekJH9FI0Ja
	 8YWDbX+a+QejVdJO3PTelBimCA48dHxhguJplS7O5SyN6JN8EXt0ZxlR1GPb9Dmtv6
	 eyf/allakKGQDIGHS8EknlQyA4qxf+HxJymsjO4gP+DMcwbOPEFwGwikoot7assgv/
	 UmFaKboA3G6Ig==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 127/385] arm64: dts: qcom: sm6115: Add CX_MEM/DBGC GPU regions
Date: Sat, 28 Feb 2026 12:55:49 -0500
Message-ID: <20260228180011.1568201-127-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

[ Upstream commit 78c13dac18cf0e6f6cbc6ea85d4f967e6cca9562 ]

Describe the GPU register regions, with the former existing but not
being used much if at all on this silicon, and the latter containing
various debugging levers generally related to dumping the state of
the IP upon a crash.

Fixes: 11750af256f8 ("arm64: dts: qcom: sm6115: Add GPU nodes")
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-arm-msm/8a64f70b-8034-45e7-86a3-0015cf357132@oss.qualcomm.com/T/#m404f1425c36b61467760f058b696b8910340a063
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229-topic-6115_2290_gpu_dbgc-v1-3-4a24d196389c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm6115.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/sm6115.dtsi b/arch/arm64/boot/dts/qcom/sm6115.dtsi
index 4adadfd1e51ae..e33da2975240f 100644
--- a/arch/arm64/boot/dts/qcom/sm6115.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm6115.dtsi
@@ -1688,8 +1688,12 @@ usb_dwc3_ss: endpoint {
 
 		gpu: gpu@5900000 {
 			compatible = "qcom,adreno-610.0", "qcom,adreno";
-			reg = <0x0 0x05900000 0x0 0x40000>;
-			reg-names = "kgsl_3d0_reg_memory";
+			reg = <0x0 0x05900000 0x0 0x40000>,
+			      <0x0 0x0599e000 0x0 0x1000>,
+			      <0x0 0x05961000 0x0 0x800>;
+			reg-names = "kgsl_3d0_reg_memory",
+				    "cx_mem",
+				    "cx_dbgc";
 
 			/* There's no (real) GMU, so we have to handle quite a bunch of clocks! */
 			clocks = <&gpucc GPU_CC_GX_GFX3D_CLK>,
-- 
2.51.0

