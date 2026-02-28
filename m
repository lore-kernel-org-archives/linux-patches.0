Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AF542737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302348; cv=none; b=mMvLzvT9CQjYJxAkZcvfe6sbr0NtcYkUnnllAfZQSZlG39UW/7vV5VwZP26+3EBglB9t12UERAVVSSCP1NmGPGwCuBW/bTLNIxS9yJ0bhlgYl3TUGt6YGG04Y8jNUowue7IgCFYkhp068dxf9zTNKgpJA/9E2Pq5r8GlP62xTx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302348; c=relaxed/simple;
	bh=XIT/mpmJXtu58AAJVUr9ZzQ/E8jcKEOqVMcx9oguzlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYbNCmU0sY1tjOpL2qt0l6CTULqXwZiIdGX+gyzXQVVRauORzUSVzAg/vhEnSXFhTSsOr+WYeKoHhA+MOCEbel57vPlEYFY9NYgwrXiY2oJWPS9IcMQaydJpcmkpidcVpr0LczgvxlwlLt+BH7sj14Xjz/iB6mHCy8ggFgPYF5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V7vsaZwI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V7vsaZwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8323C19423;
	Sat, 28 Feb 2026 18:12:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302348;
	bh=XIT/mpmJXtu58AAJVUr9ZzQ/E8jcKEOqVMcx9oguzlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V7vsaZwIcjjGFQgZlVj7zISBAxXFNWURx0knbkKTZr7JKw2Z5Q0AK7tdpLwp9sJ8h
	 s3kk0G5IXJYfxkQ9CTTB9goTRE3rUNsYhIf2g2vsMUiARNuqb5R5snDu2w5x1etZQB
	 NHte69chdlCqmXfxYMcuorizwB3/cHKIrhLN4CwweZQh73ftgCr8xnZoE5iTS7nh0R
	 w16eNac2bf+NKc4eI4uX0u7vPgRDOhiYEiwPRCiozOKkTKFpn41vjx6A6mMO4Tk2Hm
	 uYRGb9K4cNTw56PuJCtII+RCat4sd5dB9FIraE/UQmjWQQjyCOH0jMqy9hMehPZz8T
	 EYfbDnNqC7fqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/232] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Sat, 28 Feb 2026 13:08:45 -0500
Message-ID: <20260228181127.1592657-72-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index feb75ad70d570..5a5ecae073010 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -365,6 +365,12 @@ vreg_l21a_2p95: ldo21 {
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
@@ -1124,6 +1130,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 	qcom,ath10k-calibration-variant = "Thundercomm_DB845C";
-- 
2.51.0

