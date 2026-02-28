Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBCF92737F2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:12:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302345; cv=none; b=QAXUO0m5LSGSLz1QBYelhIrGwbsZS3FTz/6cbnIKOwq5IYc/xcaCU8nmScgqHs/DjNlzyePUovrnmR1stdtdwIlojdMOMEs+mxQTSH2Lifl8QQFDB39jWQ8j2BeGemMLkraGQkkfWX07J1d7DLCze1qt9e2nfpDC9wS7T/ODiAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302345; c=relaxed/simple;
	bh=LSiE8aeAGpyimheg86gDckYkmuWmjVt1v3vq8DaGVhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0r1ibeBDZMfJqrbtVwcPpLM9vPZmSv+QJbqKZ/fQsasQNf0Kkc++DPJ7mmWa80Q7zEG/JB1+eJaNCCq7dk0cRAtmOR49VmAW4oIw63m2vT66KGVGVJsYw86zHuYOEJB0PEC7kZYNuhV34p6KybiV02MOrY6xeobWe/RI+X3YOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hR2BF60S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hR2BF60S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E73C116D0;
	Sat, 28 Feb 2026 18:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302345;
	bh=LSiE8aeAGpyimheg86gDckYkmuWmjVt1v3vq8DaGVhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR2BF60StkvzNgqtO8K4nNL7x8KqX0QM9zmzYaAHpwcDgQ8rJq679ueluJI6pH2sA
	 ch9RhSDd65UGRwI8000wu0kO0MDJ624ZC/t+eR0VFVl06SfJt+TObRLl1AD413oYl3
	 hiHgjBbtw2n3Yc2XULq//6eKzOqp4PAPHPVjBTmTyCCq2ivsmPms8T/hEHi7CkWtgR
	 EJ9R2WWOTRW5Wb9w2PMrJOxfxeKzJ6jmUNBhcqXk5lUArjb78owPsrHo29gTeLeHb5
	 KovHj1XdLYsnKYRbcE2M+kKhHQ43MVFCv245oumecf3fvhdSBj5TREpNomM8Zez1fw
	 OvyEhQMbhi5iQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 069/232] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Sat, 28 Feb 2026 13:08:42 -0500
Message-ID: <20260228181127.1592657-69-sashal@kernel.org>
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

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit be2ff5fdb0e83e32d4ec4e68a69875cec0d14621 ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 4759fd87b928 ("arm64: dts: meson: g12a: add mmc nodes")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-5-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 88b848c65b0d2..041f1c1ec49ec 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2336,6 +2336,9 @@ sd_emmc_b: sd@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2348,6 +2351,9 @@ sd_emmc_c: mmc@ffe07000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_C>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		usb: usb@ffe09000 {
-- 
2.51.0

