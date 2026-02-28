Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541DF34252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301707; cv=none; b=s+qG7tmvNtpcuWW3Yzk82pbqAMW+wrbAX/iVRaWGrCNCEDwHjeHXGsTyQY4VdAbFYbuSPlnjjk140v8ZCBUe0TiZGWPP/hsuHBil5dOl2BGisA52Pg+RIfJxjDHoSqFSP1uTXPSY5O37EG0YBdUKioQDTJJGNDFjju8ogru/lKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301707; c=relaxed/simple;
	bh=fOr4Dz4dQmuRrn7oQMLfVyPaE1JmsQRhGvE+xnyZujo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVqwHsAtXvneb4EO7e1DR9SbI1+4WuK5D+y/B7Y77DpcYqtaqVZc7COM+Hdtnegx352yXcKvMdRVml3eZ+s4np2jtKKxOdsk4EgJcCDFb5Qut6b34e3c8H+zp+zUVHoSEDRScJnT9SPmgT+sLlcAYT9v5Q+R+EfnDkvzvmuHs+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YmbfRfWY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YmbfRfWY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ECFFC116D0;
	Sat, 28 Feb 2026 18:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301707;
	bh=fOr4Dz4dQmuRrn7oQMLfVyPaE1JmsQRhGvE+xnyZujo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YmbfRfWYcdxkRsIxXpvioCIi7BiR5ykbZC4M+1rtxANaMSBC4k4f5GNs8whIr9Qws
	 PGHn9in3S1L9lDhAGVpnk5MuBm0BLwFerdBDH/EScKSuYjk8xvFbkSRqMzWBbG7Rl1
	 pSaKbKEUjY62EOrLKl75UFKiiaEWEqpguz+yhafcspJFDzguP+HVdSYbjiFGRNkWyK
	 lkuu8GKDR9gxxaLK31jbbooXA6rqsYb6sTC7wyyiiTdFm+jI3VUvmXZAluEpTQefGN
	 Mt2nxkyQcBa5sX8IyHyqEu/aP/TEfHwjzemTxLb2pyr5rQb42/C1NiLMJMfmi1Plxq
	 s4GphaoVMFtww==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/385] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Sat, 28 Feb 2026 12:55:23 -0500
Message-ID: <20260228180011.1568201-101-sashal@kernel.org>
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

From: Casey Connolly <casey.connolly@linaro.org>

[ Upstream commit ad33ee060be46794a03d033894c9db3a9d6c1a0f ]

This regulator is used only for the display, which is enabled by the
bootloader and left on for continuous splash. Mark it as such.

Fixes: 288ef8a42612 ("arm64: dts: sdm845: add oneplus6/6t devices")
Signed-off-by: Casey Connolly <casey.connolly@linaro.org>
Signed-off-by: David Heidelberg <david@ixit.cz>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Link: https://lore.kernel.org/r/20251118-dts-oneplus-regulators-v2-3-3e67cea1e4e7@ixit.cz
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
index 3b47baa011c23..9d71623faa40a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -252,6 +252,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

