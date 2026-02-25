Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 041FD1F5858;
	Wed, 25 Feb 2026 01:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983890; cv=none; b=XiMDJJthmsAkqQ/nCgn+70pXmoF+hsNh7uoJJ7AgnSL/0vHGV5OyKOfbqB/l/vBrE2BR0Ob0dSgpOobWuppsrWpS+0Mh+h+MCSHZNwa9NlKsyzLyC6u66HUFnuGnqpzGwrFAzfn+PVfjEL4Z/LNaHBy4SeX+KyxqjHqBdBrHtCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983890; c=relaxed/simple;
	bh=udgGf8BrNKf5HzT9nyIu65fVwD2GLe4z48dxDdJcTBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VBFOrW/xsZhqtpDkjBKQvM37OK1zCwtLs9uhsgjitM/b5LujGwTfKHqrR9c93vsIU+h4BbYzeLR/kIfTHwQIeuax+3nTtSFZRiLvrXrFBEx/XiphsOByN0mQBDmxWG4YklCLj02jyaOa0riJlPhXbDbJXaQfbuMzvQXkEZoUqbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKp1vf8y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKp1vf8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF3AC19423;
	Wed, 25 Feb 2026 01:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983889;
	bh=udgGf8BrNKf5HzT9nyIu65fVwD2GLe4z48dxDdJcTBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKp1vf8y/o34QdFUtiSgh1ya9mKCSQV7Ta7Dys+K+4GUhu+kILTkyLNtD6hiYeeuw
	 PCRm6pvzW4xtMeKK3trN9rRIt7tB/Mx4x4x5LkjSi52NQ14f0Xs7Qgjzz4MNDbEiMz
	 WPjZQ3i+RxuqmR5iGIaTe4oKqeAcfMZRfvym8xT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/641] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Tue, 24 Feb 2026 17:18:08 -0800
Message-ID: <20260225012352.992553039@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 384be2f8b1411..5147d6d3cc26b 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -379,6 +379,12 @@ vreg_l21a_2p95: ldo21 {
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
@@ -1155,6 +1161,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 	qcom,calibration-variant = "Thundercomm_DB845C";
-- 
2.51.0



