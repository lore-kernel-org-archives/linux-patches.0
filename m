Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A4235AC18
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302691; cv=none; b=ohEtGs1/hh569Zb19bY9SeA39muCDMa1F581/k4w48QNIM/iiLYl9GufNcOYzpCipBfXNbYPpHAHDMeXVjUmNqgWSoj1GLPEOo9HnvEbR8DnYnt5674/VYxlQa4XdroxhgWPyb+0xEd6UMCNmx6CRQSu1qwh1az3PhnpyCnl9bM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302691; c=relaxed/simple;
	bh=UgynX8NcwAB4h8tud9Gbzi/l/JMc6i2KN8SdRGUqXlM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKIH7ELnD0khNZ2Y3RxX/hbYJxe/FhbFmKrBhVZgbjEtav6z6F3/37zznaPhqYyRbmFzW6dHLnzhm/yTPRf3yirZ/D0sSo9r/9TX/Yv95KwsNshL/hwJ5kbhhqBkmbscoMzl7cTCdPPMqPOkSxnuP5IxCJHzGNqEJeoy4Iwx8Kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e3ECnDSd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e3ECnDSd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AAECC116D0;
	Sat, 28 Feb 2026 18:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302690;
	bh=UgynX8NcwAB4h8tud9Gbzi/l/JMc6i2KN8SdRGUqXlM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e3ECnDSdsQTwWYOnst6GdtHXaxEWvRZR52gzOxObKA+Ct55lpHBk9NtE1A4cA4Z2C
	 C/we5TiX7jL2+qhLwyDl9G3TQIaBedgpElacrRHT/3R7TW9mizO5ZPCvyvqooIe31m
	 h8ICHuxCVeJ4+8gexRGONL8jcdqR5hfV4Pd3uHhnhnDJER7Et4rQlm66vCqwMpkUSE
	 M1wjkJDN5+fPDWZE1YSfXRtfYn5C/51N48hCZnS0CxC5G16VB8Gjr9F9wBnV0ZT4P9
	 NL60VOS30NbB/A+VzAi12S5Fcoa9sXzRwXjNOmUUqwSAEJzwlzcgH69Xt2osRHPjoH
	 P4E11QfDH5Sbw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/147] arm64: dts: amlogic: g12: assign the MMC B and C signal clocks
Date: Sat, 28 Feb 2026 13:15:52 -0500
Message-ID: <20260228181736.1605592-44-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181736.1605592-1-sashal@kernel.org>
References: <20260228181736.1605592-1-sashal@kernel.org>
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
index 9dd9f7715fbe6..ff764f7b017d7 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -2335,6 +2335,9 @@ sd_emmc_b: sd@ffe05000 {
 				 <&clkc CLKID_FCLK_DIV2>;
 			clock-names = "core", "clkin0", "clkin1";
 			resets = <&reset RESET_SD_EMMC_B>;
+
+			assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+			assigned-clock-rates = <24000000>;
 		};
 
 		sd_emmc_c: mmc@ffe07000 {
@@ -2347,6 +2350,9 @@ sd_emmc_c: mmc@ffe07000 {
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

