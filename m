Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2197C36C9E0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302337; cv=none; b=gwF6DyKVI7Geeswh8V5ZlGPiiYKSbfO5KZTEa1ltbPn8XENPRn9GFa2rL4B4I5fzLC+IIAuesHpEM+UG0VelEKbrdDAnxhqiR7HiCk7IIoA3r+Ghc0ExeTdCuhBcDNRKRZRJf+Ybx2VH9t2HUQf/oJPOj/E53qhHx1DyIgcz2dY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302337; c=relaxed/simple;
	bh=KYiYQC0dnkMfSZYpzdS6byBo1Xm0ERqCHqJ1959Ppho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uq4QnSCOpZUkrDp+i+wCOG4CHOHddW25aRBA+KATzE/uQt5Ka3xrBpSsaIT19kXBAWdfXYTU+axs0oSsPYZYr4LZ/m6O/zZ6U5GMwVvjBt4FzScE7AKrM7lwBXAH4RWXKW7+6GO9OTw7OM5X7szxkYNtwA3pE0upx/y9lsGwyiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TSBXdklo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TSBXdklo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D1AC19425;
	Sat, 28 Feb 2026 18:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302337;
	bh=KYiYQC0dnkMfSZYpzdS6byBo1Xm0ERqCHqJ1959Ppho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TSBXdklopm2dbGFPrtebnCdTTN0evcFsKPuGbUxUiiWe4l6pnyUpogA4+y9y+20bs
	 5d3/pU17CXC5o1/SlzkYLMKjFz3uBpI/k4m0QlM6CzJJY3LhyS6AoeTRBrOL5gxWez
	 +OTmsu66dUo8ECZFSKhDqsoT62vKilDw9rhbEDJnJiXNxYjYDdC2nRyLU0I4uo4agl
	 tdalfBrqB0bqfcxHpOh3ra2IVfqjCA4hsJE/j4eNQXmZXFrUPdL+HRGxTQ4ZzjiT6k
	 tnqcG+tJUWyAd9bbrnUWsWub2wcVmrqo2JsYxtoeSDr2qH1+2K3TGuXJAkvYD7PsV8
	 J/yHygqCUVZRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 058/232] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Sat, 28 Feb 2026 13:08:31 -0500
Message-ID: <20260228181127.1592657-58-sashal@kernel.org>
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
index ac3db3d5d2bad..90bf359d0e2dd 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -230,6 +230,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

