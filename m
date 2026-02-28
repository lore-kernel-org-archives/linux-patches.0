Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E83A34A3C1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302692; cv=none; b=fCcIos3QjYg6iptXDFAx6LRck6HdK8qthrsTFFC4ymoSniGfuDiVXTt4hQoTtvr/nuuwVNhPfTWMr4fznp/zS258Tf3AVfB7TgHwY8n2RfecLzdG5MQ8NJraEmYBubrXw0ciKP6wIdatiXa4XyowO52HqJSZWesUHxiFioFwtBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302692; c=relaxed/simple;
	bh=6zSGf+r/ugP1lexIZLV/RmjjjdeGVcnojqsvewazfg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vqo/tyh0QnxAcTAuvcTHFapemgO1j45lhXT2XeKgzPhlZ3X8Jkx8QYUib/EiuJz5mgdUVlf+t5NmRTXXqWpetAHCfFaWktTh2qZc7eMj97jeZNT4iEtkSvhU3kzlzg5UDr7SGTkDMHraAVFiXZ8Qm+jofw14NRzRdbRPne1QSDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHs8ci4E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHs8ci4E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE14AC116D0;
	Sat, 28 Feb 2026 18:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302692;
	bh=6zSGf+r/ugP1lexIZLV/RmjjjdeGVcnojqsvewazfg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHs8ci4EEf3ZEh/yKQ0R/VAmVArfVj0ZlRtcCGuHc+87yTYMq6BvjLSMXUDNijHkz
	 tjbpz1LOfDmTT+QEuLZ+1zFJrCTjh3NMECFSx/yKhtL5N1HfYOmY38rbVXUzJs6hlT
	 gTt0MLMqNmPw0Zfgydd2BdJAjtyxMUZRLt4sYPZN3bF0ss0TtceC8U1T9SKkCLRLTB
	 ltySz2CIURGKjFmBOsPLdCpaqSh2e0NhoLuci6xwub8YoiCrZ2pGuuyFP+0BLy9Lcq
	 eJ1TiCI/ZsGEwhRkOuGGgWvGt4O0CvIrwvuHD0mkvlx2E9wZzPIVrLlzdg3zuwTiDQ
	 6/RiplbL4+1Vg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 046/147] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Sat, 28 Feb 2026 13:15:54 -0500
Message-ID: <20260228181736.1605592-46-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>

[ Upstream commit c303e89f7f17c29981d09f8beaaf60937ae8b1f2 ]

Specify power supply for the second chain / antenna output of the
onboard WiFi chip.

Fixes: 3f72e2d3e682 ("arm64: dts: qcom: Add Dragonboard 845c")
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20260106-wcn3990-pwrctl-v2-8-0386204328be@oss.qualcomm.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
index 31f4f05750940..e327e398d99ed 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -342,6 +342,12 @@ vreg_l21a_2p95: ldo21 {
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
 		};
 
+		vreg_l23a_3p3: ldo23 {
+			regulator-min-microvolt = <3300000>;
+			regulator-max-microvolt = <3312000>;
+			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+		};
+
 		vreg_l24a_3p075: ldo24 {
 			regulator-min-microvolt = <3088000>;
 			regulator-max-microvolt = <3088000>;
@@ -1039,6 +1045,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 };
-- 
2.51.0

