Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CE933A702
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302093; cv=none; b=Tq6yZBrteD4rThui0coGlf8/tIvWs7mBvF2P4cvNDx/mB8KY9ATgh+7CjOu+/IGSPCoSD3UO2TTNlVct3w2VU6FOA0wSq0EqYW+UERNEqSFxTcmLArKuKHyUGxemzqOna6BA0gkZDWsicLN9NVOdhdTtZcZA8zrneqTLAVk6L74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302093; c=relaxed/simple;
	bh=lpPrQBQ2ep4MKsCW5FqJESbJ7IPUzMI9OTlm/fiiTCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q94g4tdOnfhmoS8xcJQTJWdS9fSazWCn7xukHDhLd8Q9/twci4QcrwcA0Wbu6dqAKGyGUmuIa0j+ZajvM+JKlWh4ecfx6zp2wvk2SQs4DfAC0trXyZ0Jx3R3OofTyoG2GEsgPTXuG/0qXR/k1qRrNWNcEDSU6m4uHL2qVU9utQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EYQU37rH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EYQU37rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611C6C19423;
	Sat, 28 Feb 2026 18:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302092;
	bh=lpPrQBQ2ep4MKsCW5FqJESbJ7IPUzMI9OTlm/fiiTCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EYQU37rHA6jFj0XTw/I+1b14cqHAuBbm7qd+JRrTlTlbZFviiujVgmtPlqv82L+x7
	 Ad9QQfko9psUaY9qM1YIfmj6ZyylxTzxJBcsMUxb9yWUDT675qLKHkmpleT8C2twx9
	 QwKP79BF5wu+Nz3LR05FqfeNikjxOiNv9WNYCmgmLgnmrc+30bQ5N9zaKVpA1lDuOD
	 L2lxFIKNSwCgKS4kExsjdKDcUcfHluPiF0GmFWL+OM2bMnmrpqzzEqMWNSRdqVlIDF
	 Fe5EWNFcE/WsHZUhpseQ9R2nq/McDKVLaglhKV60g1LTct9SaHZPqolbwd4SJIXtfB
	 IB4tN6VA/YNnw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 077/283] arm64: dts: amlogic: g12: assign the MMC A signal clock
Date: Sat, 28 Feb 2026 13:03:39 -0500
Message-ID: <20260228180709.1583486-77-sashal@kernel.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 3c941feaa363f1573a501452391ddf513394c84b ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clock to make sure it is properly configured

Fixes: 8a6b3ca2d361 ("arm64: dts: meson: g12a: add SDIO controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-6-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index cf2d073154f43..c5848363df37a 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2341,6 +2341,9 @@ sd_emmc_a: mmc@ffe03000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_A>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_A_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_b: mmc@ffe05000 {
-- 
2.51.0

