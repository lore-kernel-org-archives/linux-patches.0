Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D96379ED5
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301728; cv=none; b=Uq/+DTC8Tznd/SHZTEELIUwQyE7hfxEGepfoCpVTeNOJn6GCzbDzVR/rTRKUZ2aJGadhOuqF+wsU7/RUV/rHz5bNIJ++5Zi2s2EBRaQ3bRMb7F65x2fnl8Ibw3mlJPNA1mnoLerK+gSZt7sG8by3Usp+Fe4TCSrHZxWI+7wJzCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301728; c=relaxed/simple;
	bh=7ObWGwtHY6eqgT1kSzApBIYRsjhClRXIH0tdYKtLzIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qf3y21kHKMTNBCbBrE5yVcbmdxzG4+F3infVal9+k2ZtOqEVjB8v7Wy5KWwLDJwbVxeotmLXUkh92uj9t4JzGWvGbzzTXpyZZZT1n5NdEmjmCbV59HUmqHElDAaOk0py0dz1P3THjm1ghI6UjxA9meqxf+iu8MkypjGF2tdeeD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u7pJqlsM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u7pJqlsM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F8DC116D0;
	Sat, 28 Feb 2026 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301727;
	bh=7ObWGwtHY6eqgT1kSzApBIYRsjhClRXIH0tdYKtLzIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u7pJqlsMywmWU4rlBiMLgTK+FRVDdtbgvEJXlUsg3oVozekTCP2NS1arPagzlRuzD
	 3xVOea79TIiN9hixxi63TUlm95Ug+O12ARQETHa6/QmAG+l3MGYNXD0ONsrcXKxmC0
	 GC2l2ujDzxHnJmrgzIj+Edr6PTzzYDnemGosdrGk68xPq/LWbTUlMCTjtSz1lo+olU
	 h54BV22IgHy3NxuesRWK8jouWgtbmRCteARADihutg0fZLqDqCyYGVjoy6gG+I30Kq
	 mp1i+AMIsBokvBwv+rPevNcn4v16RZpQy0Rx1+oYiLWe+iBeh4zkBnOCQqdRc3azGY
	 vbhdMbJyUhAJQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Akhil P Oommen <akhilpo@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 126/385] arm64: dts: qcom: agatti: Add CX_MEM/DBGC GPU regions
Date: Sat, 28 Feb 2026 12:55:48 -0500
Message-ID: <20260228180011.1568201-126-sashal@kernel.org>
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

[ Upstream commit 0fdcc948929a6d673bd0f90631dd6e42090c3dbd ]

Describe the GPU register regions, with the former existing but not
being used much if at all on this silicon, and the latter containing
various debugging levers generally related to dumping the state of
the IP upon a crash.

Fixes: 4faeef52c8e6 ("arm64: dts: qcom: qcm2290: Add GPU nodes")
Reported-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Closes: https://lore.kernel.org/linux-arm-msm/8a64f70b-8034-45e7-86a3-0015cf357132@oss.qualcomm.com/T/#m404f1425c36b61467760f058b696b8910340a063
Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Reviewed-by: Akhil P Oommen <akhilpo@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251229-topic-6115_2290_gpu_dbgc-v1-2-4a24d196389c@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcm2290.dtsi | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcm2290.dtsi b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
index e75e6354b2d52..dbc78b2d5095a 100644
--- a/arch/arm64/boot/dts/qcom/qcm2290.dtsi
+++ b/arch/arm64/boot/dts/qcom/qcm2290.dtsi
@@ -1434,8 +1434,12 @@ usb_dwc3_ss: endpoint {
 
 		gpu: gpu@5900000 {
 			compatible = "qcom,adreno-07000200", "qcom,adreno";
-			reg = <0x0 0x05900000 0x0 0x40000>;
-			reg-names = "kgsl_3d0_reg_memory";
+			reg = <0x0 0x05900000 0x0 0x40000>,
+			      <0x0 0x0599e000 0x0 0x1000>,
+			      <0x0 0x05961000 0x0 0x800>;
+			reg-names = "kgsl_3d0_reg_memory",
+				    "cx_mem",
+				    "cx_dbgc";
 
 			interrupts = <GIC_SPI 177 IRQ_TYPE_LEVEL_HIGH>;
 
-- 
2.51.0

