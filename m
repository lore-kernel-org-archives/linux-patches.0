Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD1B3451A7
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:02:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301726; cv=none; b=Thmx3T2vIeuiuX3Bc8ZF+RcWD7rBkSFutYVgp7hoSUySGA0UNQNkaCHFWBPmY8ak4+2VOFCt3xieu4DglD6yDYT5Zex5o01NvfefCd52zpUfqKQYmEdKRSq872C7YTbC4s3ubocW5UQWB+UK34ldaNqPljOBA49C6WIkKTrKScw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301726; c=relaxed/simple;
	bh=gzFM9PJe+T+i2J+2/OraawNJlB5Cb6Osvp4ZfBj1IWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o3R2r0wEwGGvJzAImGsegI4lJmJX0b4NhgwUkiUM+M8kxQMRyuCErF//cdv8lo5xEOyz9iOQecFnzewuxuyEUXYPQdSdetj+sqDxD4/MJsYaibbiUrW3tjYlGfh0z88JjX26qVkiZD1XJiFQeB5lgzcCISaIRxy3i+nhisnahD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MJIXepvJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MJIXepvJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C5F6C19424;
	Sat, 28 Feb 2026 18:02:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301726;
	bh=gzFM9PJe+T+i2J+2/OraawNJlB5Cb6Osvp4ZfBj1IWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MJIXepvJtRGa8XHmuGvGJm0zVD2KbMAwFuvDMsZRchEhZwqYiVuA2uqr4qKhLpX5n
	 i6bANeaxF/UlyB8I2C5LwFf7UZKm2wikg81u0Jwl/LXaRtMtcR+q9CQcqG6paqwPXy
	 CoGs08lFxB9r41BJvbbMDWi7yMtncrKFPcqZDXP9EvQ7Gp3VNEDykBeqRgX+KSGxyA
	 lrmCy/iwXGlDkbt5sjvhgJq5id8LPFHjVAVw6tp1FRP+znLCZyVLLhDIZ9q0ljIR+Q
	 2OH6EHK62zLgaspnRLkU83pSiDGXeDEir8B/12K2c2mjXP7QTPl48tkganG2vJLdGf
	 aJoZOgmokUCZw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/385] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Sat, 28 Feb 2026 12:55:46 -0500
Message-ID: <20260228180011.1568201-124-sashal@kernel.org>
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
index 276df1b078118..8f3b31a30e247 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -378,6 +378,12 @@ vreg_l21a_2p95: ldo21 {
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
@@ -1163,6 +1169,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 	qcom,ath10k-calibration-variant = "Thundercomm_DB845C";
-- 
2.51.0

