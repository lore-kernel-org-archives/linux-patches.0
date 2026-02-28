Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE13D346AC1
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302094; cv=none; b=UG3EXAb965v9cbSrJ7mYmw0I+PnJruGclThaXgeZ3xYjc/DFCWHu5+rSfJ0s3De0Rn8AOcSGMkOr2WIvPz9W7eN6RFyFLUiX7Bitn8DpmiKb+ySpJDhHP3I6YKbtkv0k3+OTeopNix4SqUeJn6JQGT+nR8gtL9hPKazXph51N70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302094; c=relaxed/simple;
	bh=Wly4csatesflYHNNl52dtmeu0PiMQv739oB8LQ1q9As=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAenXweEycWWbVURn63SRkFcpV3IVTqA/bZwY39Y2lFwwNj9k3KtK8xe094BMKU0XlaxU9j+NTYuZgg/ldNd0/esezGh++vtAG+CsvLBi7dzVO9j2R2NewZc3AEF4PgDmOQoekse9qwm0pqkNcUNDErx1BYEEN1lADwFuLcBPAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c2mBIlbj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c2mBIlbj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 009D4C19423;
	Sat, 28 Feb 2026 18:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302094;
	bh=Wly4csatesflYHNNl52dtmeu0PiMQv739oB8LQ1q9As=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c2mBIlbjNYQglUv+fIdI1bKcnz3diByjsm95SIHtk2KpRbeTt9tr1FMfu1arX87Se
	 +dVpi9zdWNq1wcKgbhNBfdPQaBal7Ww8Yd5kNMSQPQRfGQyse77r2RRhbQX1VG2wrc
	 OIfeehqvQWnytbF8LlQ0FBguYzurhWgTmW6cF7fFwIxqi1nFWGHXrwZ60Z6ofKavYx
	 W1z+IdIZPF3uPkZpXCo/QlxhxT+u+Djc0Fgm+vpEp9vUk3xGnUtp9h0VzPMXtq3yq4
	 YWqf9cX8IrQ8tY5gpcrYGK0WI5rX3Uixtr66zBez4FSMq/7wzf8tYkYV7llH1eTm2M
	 5FjbbvPMLF+hQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/283] arm64: dts: qcom: sdm845-db845c: specify power for WiFi CH1
Date: Sat, 28 Feb 2026 13:03:41 -0500
Message-ID: <20260228180709.1583486-79-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index d2924abd91d22..1164f2cf5bc96 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
+++ b/arch/arm64/boot/dts/qcom/sdm845-db845c.dts
@@ -372,6 +372,12 @@ vreg_l21a_2p95: ldo21 {
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
@@ -1157,6 +1163,7 @@ &wifi {
 	vdd-1.8-xo-supply = <&vreg_l7a_1p8>;
 	vdd-1.3-rfa-supply = <&vreg_l17a_1p3>;
 	vdd-3.3-ch0-supply = <&vreg_l25a_3p3>;
+	vdd-3.3-ch1-supply = <&vreg_l23a_3p3>;
 
 	qcom,snoc-host-cap-8bit-quirk;
 	qcom,ath10k-calibration-variant = "Thundercomm_DB845C";
-- 
2.51.0

