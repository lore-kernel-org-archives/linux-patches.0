Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703A0346AF8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302084; cv=none; b=b5xDkimDTLKJWL04/0wqLbhuKfWC86fxNuGc8NlsLQPFCvJwmvLCTQ3ScQc/tawjCCIrrgsqWWfIyPlcylnm59VgQxC0+hKvbydiKh+TiRHnVktMIVg7bzl0a5iAMlKgtPUrCjC1M49qywshRifG29ic0YNiFlNPNT991kcr3P8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302084; c=relaxed/simple;
	bh=YG7WnCD7iKMfs+/GEyJh4n3N89TTKM299OtP1nd3V94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzRReAgQ06dcyKGUZ2WTBO3KBLL7FypoM/ZP/3MCILvjNs2Rti1MDW2fG+5ieuDe44xmf1w8TufLcvTEUvQIA7sA8sihxC6dl8WhnUTfgrm75SBPCP9aOgYK3yN8+rd6T0S3OvKkEX63TgFlJhLbswvzxTEp7h8amW08jIuxLXQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwXW0W2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwXW0W2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE137C116D0;
	Sat, 28 Feb 2026 18:08:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302084;
	bh=YG7WnCD7iKMfs+/GEyJh4n3N89TTKM299OtP1nd3V94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jwXW0W2KWVvekGWt4IE7i4a5LMHkG+Jhu/XyqWr4TN7gwtvHLQ+GodvExPTkUJxd3
	 wBOyMHhQxDtDrK0GFI/qIZxqHKLNkP3Ryvl8f6XMKIpihyz6QgN0D7jooSaNGeR6Ru
	 maMpQQTlKGv+mZqBvF6qLpWfadEPDwZXi5Wk+uLseT0xCcNNRI51zagYTc2A9Fi63f
	 QR1QDIBE9FdMAWFyHrWfv8SGqafwfSh8fvtWTlEWTkzVu6nsghCTyQLyc+jbJ/LVTE
	 aPC6u7t9DoSxxcMB80rBMlQfXD1kNkzzoh4bvnEfJ5XoCaNNYVm+EomOc2kU/PwZYG
	 P8x3KXEkIl0pQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 066/283] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Sat, 28 Feb 2026 13:03:28 -0500
Message-ID: <20260228180709.1583486-66-sashal@kernel.org>
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
index 4e335c9fd8185..894fd3395189a 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -251,6 +251,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

