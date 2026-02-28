Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0367539B94B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302538; cv=none; b=hPRsq5BxdF/vuwVQtBWezDYT8SeQEwY8t+ujc2STMuxVe0xu164eFkk7q4WPewSszJmwaYoH8nvcNpx0ZA0gYgHSQBvgtfFzTFhgYL8ug81QemdRW5Qo6fKGhrGga4264YSZRKmfX630bNdWTYcLyzdeXM2Ap/PnsxlEb7vKr20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302538; c=relaxed/simple;
	bh=6+1dtEgnaqLzbb+Y86Tb3ZmHc4NU0VNxRyPTTvvHJYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X5LNjjt8Cf+a0TyReD1+GHob8IKQjPoXY4bmhREiTCMzq/vz1XfoFihFTTIBhRbAnNMev5sU/I/hFPcoQN/emqH+7Wb/KVQo15NPOuGqC+iCU1TdVTgUwngnXatYSeLfOOUXYhe4AonH3W3u15vsU05sq4lYujJnbGLvxMBzJbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mV2m6Wtb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mV2m6Wtb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DA7EC19423;
	Sat, 28 Feb 2026 18:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302537;
	bh=6+1dtEgnaqLzbb+Y86Tb3ZmHc4NU0VNxRyPTTvvHJYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mV2m6WtbugCxcarAdZMBtAKnDaQWUkxKEvW1k6umvadgc1qK3jIPcq8Fwjxktkbhs
	 LMAsYIjf/TjlPxxg16tPk5/neLwqYXi9OvfCoe9NySn+1kjXpNDT/E9qUccQM6s8GI
	 8szRxhLyirC+pSyJtfoXIwA8GGCEPeVGclRXqXeo2pT0lZChtuanU5YrXW19LKEsUi
	 eOHjQpve4e7pr/RywKyF59cuQz1mQsDpRbu1qTeynQYMD9+t+Zv/ApI5lXrd+3hnve
	 d0lQ8Bqknd2ZN5Kep+y5SxwwdLgegwVvuzbeKJCQNBBVrfD8uyWCzICOOIa6PDboEB
	 h48vGoQrbH9bg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Casey Connolly <casey.connolly@linaro.org>,
	David Heidelberg <david@ixit.cz>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/164] arm64: dts: qcom: sdm845-oneplus: Mark l14a regulator as boot-on
Date: Sat, 28 Feb 2026 13:12:57 -0500
Message-ID: <20260228181505.1600663-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181505.1600663-1-sashal@kernel.org>
References: <20260228181505.1600663-1-sashal@kernel.org>
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
index 1a1e344f870ef..a079706f1829d 100644
--- a/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
+++ b/arch/arm64/boot/dts/qcom/sdm845-oneplus-common.dtsi
@@ -232,6 +232,7 @@ vreg_l14a_1p88: ldo14 {
 			regulator-min-microvolt = <1800000>;
 			regulator-max-microvolt = <1800000>;
 			regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
+			regulator-boot-on;
 		};
 
 		vreg_l17a_1p3: ldo17 {
-- 
2.51.0

