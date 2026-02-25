Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D86825E469;
	Wed, 25 Feb 2026 01:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983006; cv=none; b=hoKYLYUbpmcg59PXXk+8aaRyFgnMIdlprFK2UzIDEwxNLzSTeEh8UJm2/7y7rAnxKqf3XSq33ByabKPuTeAk+fbbRGoA9mTtdnsBrniNk81vvxixFkv31hZBj3r0u0dxijon+AyPCvn9ZdzI+kLV4rNBEEZR7eDdxZdPY4NgWQs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983006; c=relaxed/simple;
	bh=GL1XI+FsU9JIUIHCVCoZaF+5QqwS0UJvkZkvqCJp24w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EyIv1chWgU+m0HG9vY4DFZoNTmiSTGyjOtLjh0mEiZ46suMGZFG+1+z8xW8I07mr+dlZ7JIvaVs+fU+hGWvSYQX5Us+XkL0XBDMMbtIwmLubQS/xNhNGummAL8OPr/d/dow0twLjIQM3qXdSXzPDf54bkcoJqo9nFwVvLgw5100=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sIsi3dsj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sIsi3dsj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6BC8C116D0;
	Wed, 25 Feb 2026 01:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983006;
	bh=GL1XI+FsU9JIUIHCVCoZaF+5QqwS0UJvkZkvqCJp24w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIsi3dsjhwR3uEsSQ+HAiIz7w42O4BY/4YTIJXLWNqRruPGcshWzdSKWJiHWEaFql
	 iULiw6/BeH3s4WuWZNAwOIO+iYe9T1nk1Dw0mQ05/5fvcAXVv6SI0iv4UnDNBbHVUH
	 /bRXP/InNI7nu4AMBQnadl2KxCnrrPkuSf8wJaYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jerome Brunet <jbrunet@baylibre.com>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 176/781] arm64: dts: amlogic: axg: assign the MMC signal clocks
Date: Tue, 24 Feb 2026 17:14:45 -0800
Message-ID: <20260225012403.964030681@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 13d3fe2318ef6e46d6fcfe13bc373827fdf2aeac ]

The amlogic MMC driver operate with the assumption that MMC clock
is configured to provide 24MHz. It uses this path for low
rates such as 400kHz.

Assign the clocks to make sure they are properly configured

Fixes: 221cf34bac54 ("ARM64: dts: meson-axg: enable the eMMC controller")
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260114-amlogic-mmc-clocks-followup-v1-3-a999fafbe0aa@baylibre.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-axg.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
index e95c91894968b..cc72491eaf6f5 100644
--- a/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-axg.dtsi
@@ -1960,6 +1960,9 @@ sd_emmc_b: mmc@5000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_B>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_B_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			sd_emmc_c: mmc@7000 {
@@ -1972,6 +1975,9 @@ sd_emmc_c: mmc@7000 {
 					<&clkc CLKID_FCLK_DIV2>;
 				clock-names = "core", "clkin0", "clkin1";
 				resets = <&reset RESET_SD_EMMC_C>;
+
+				assigned-clocks = <&clkc CLKID_SD_EMMC_C_CLK0>;
+				assigned-clock-rates = <24000000>;
 			};
 
 			nfc: nand-controller@7800 {
-- 
2.51.0



