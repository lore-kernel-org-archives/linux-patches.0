Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025160;
	b=LZ9VpyZjLxFsESViLxCJuyylfkfb20j9u1reLHxE1IXPcAk7MyYP4MhltmPbQ9v45dTm
	 IqYgJIMA/HiX/Bnk3W23R7X+87HRcjBVppv4jut/Ka4e6gJrSUnUFi7EVMZQOvcp7oMtK
	 f0JnQlitinAOhmXgYsBqusb2e0X5UxVkRpjQl+YNEc7+7TuJb+60kNyfPiyeOb368hXLP
	 jkvO0Yf9N1X2NLJYhorQpTouCn+OR9aYaUQ5Xbi0MyeAlOxTjQmlwjjuq745BNuMs8z9Q
	 P20opJeBMlOsUlm19CwHdtuLm66Sq/gMKcnZ64M0crjFxU1RJ/QBNU/ZWdZ+YCsq7+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025160;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2lmxxoP9QjQYbXMpcy21qLcyzSlgF4R8i+ZkeuhXOmw=;
	b=0J9eKd0G3Q6isHX1j4XEbhV/XmJTBQWiQnJwSFj5HU7BHC6zwEA5FR3GqYRJzix08hOL
	 kxMAkr8F8vCGnSeBQuUYDboELSsiWvv4YfPyywT9NkC9Rm+bcjiAaf1VDo9sOWFl5nc4S
	 uBgFM/zdsCc464WJzPGnN6gFHTbn99kpcb1sSoIktuxyj416t20XrzrHiB1S2yhRAVkCB
	 zepy6uSSVbVxDCg1MeTE5oRsenyNBjzhuSGcNJPwQp/14cKK48J+eGBFyooXpE5Z9YgF/
	 5do7D3rd6CFdDIgCWSB7nWtL9Th9A+iNsEVDHWxjziyGSv0jBQSao6YPGsPEFNZnx2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLOLgkNF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC76E606A320;
	Wed, 18 Nov 2026 18:06:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pLOLgkNF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11C871F000C4;
	Wed, 18 Nov 2026 18:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025160;
	bh=2lmxxoP9QjQYbXMpcy21qLcyzSlgF4R8i+ZkeuhXOmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pLOLgkNFvj36OMvUNdmrTcxWULGIgqANxyAaOWBX5VDgB3KLjZ3L3yIj3+k+frH9U
	 0Wr5hQ7Qcn3mmB9skORNVVRGwFMCRL7VMNkZs9FdQ2mVO+GRrqLWlfofxr7FnM79ME
	 K8sj22GTcq+tISLHhFjaDfSLr7/4BCxKHLPsSxuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0982/2151] arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins
Date: Wed, 18 Nov 2026 15:45:17 +0100
Message-ID: <20261118150158.253390180@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Igor Velkov <iav@iav.lv>

[ Upstream commit 0b825126590879812321cdab53786fcd906f7761 ]

The SPI NOR flash uses six lines, but nor_pins covers only four: data,
clock and chip select. Nothing claims HOLD# (BOOT_3) and WP# (BOOT_7),
so they keep the boot ROM setting. After a boot from SPI they are in
the nor function and the flash works. After a boot from SD with the
button under the board, they stay eMMC data lines pulled low, and
spi-nor reports "unrecognized JEDEC id bytes: 00 00 00 00 00 00".

Add them as a separate group in meson-g12-common.dtsi rather than to
nor_pins: whether HOLD# and WP# reach the SoC depends on the board. The
HC4 has eMMC disabled and takes both groups.

Tested on ODROID-HC4: with BOOT_3 and BOOT_7 set back to eMMC with
pull-down and spifc rebound, the flash fails as above without this
patch and probes as a 16 MiB mtd0 with it.

Fixes: 7178f340e929 ("arm64: dts: meson-sm1-odroid-hc4: add spifc node to ODROID-HC4")
Assisted-by: LLM
Signed-off-by: Igor Velkov <iav@iav.lv>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20261002-hc4-spi-nor-v2-1-8366a4f91049@iav.lv
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi    | 9 +++++++++
 arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts | 2 +-
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
index 8d8ab775404d9..20556d1ef6831 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -615,6 +615,15 @@ mux {
 						};
 					};
 
+					nor_hold_wp_pins: nor-hold-wp {
+						mux {
+							groups = "nor_hold",
+							       "nor_wp";
+							function = "nor";
+							bias-disable;
+						};
+					};
+
 					pdm_din0_a_pins: pdm-din0-a {
 						mux {
 							groups = "pdm_din0_a";
diff --git a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
index 0170139b8d32f..68d0bf032efd4 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -124,7 +124,7 @@ &sd_emmc_c {
 
 &spifc {
 	status = "okay";
-	pinctrl-0 = <&nor_pins>;
+	pinctrl-0 = <&nor_pins>, <&nor_hold_wp_pins>;
 	pinctrl-names = "default";
 
 	flash@0 {
-- 
2.53.0



