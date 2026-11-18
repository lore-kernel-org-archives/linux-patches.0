Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048961;
	b=Ef2P7+7N5XIc33Rfk4+Eo8XuUtaI9fT3XE2I9KgcJQa0AboDmy3C7rfVUvCzWsQtfrPU
	 LOPeOAldg/SQNSye+KwWeZWoaPppAJv/PmjeFmbV2N6aGwCa1Y9U+7THg6KZaHyug2mBJ
	 MuSuVomI/H/OiWfXJd6P28jrLF4PSNzXyU6KF3BiLTN9X/jlAzCiTqhEpzODS8Y3dXnpN
	 4SwPD/C6EwT1yXjFHmIR/PJR9y+6tE3WQE33dRQQD3XYiqANF6waeJUgPdkf3SlyV7XuC
	 GcZF8Y9yHBwlq5Ua0yxAKIfqftSFYw5xSWehykyrclNZNjnSVWHuK7PhIBatEd/7vkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048961;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E3eEFc8NhY0DieU4oDBWIu4I5k+DwD33VgtEoBLCq9I=;
	b=OGrZm6sfP77EOSwKYzSEmdVzDKZ541RyRtScIPiTxE/AP/LVVOvi+NDOfno9FTjjYeFU
	 W9IIXexH6FE72nlTIv8EmrjA4cJ0xkLaD5xMb7siUo8i2JBDwny+FUl2eiIp5QZ1hKOI6
	 nMGvalOkFBQM8HumMUIzHhw5OpBQs18RgTYXnGx5qmAdH5KgN/mODistzhrDt9IWwTLYx
	 Vx/1aJiHcrjEWzr6UJ0yB1ZKvqpcWkq5Kiz4Rk0Y60RiUqty7j2JB+OLApF1e/TQn4GZA
	 sL+RkmlXC8hUsDRR39JA47t01v9nyMJkjuXkJ02heXoLMPcRSyMfS8K5nC6lCT9476w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+9q6X8e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731ED606A325;
	Thu, 19 Nov 2026 00:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I+9q6X8e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79DD1F000C5;
	Thu, 19 Nov 2026 00:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048961;
	bh=E3eEFc8NhY0DieU4oDBWIu4I5k+DwD33VgtEoBLCq9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I+9q6X8eZ72XBhXC+kR4zQAVjrcUvGmgXPjoSmq31zhwkdrQdZwHsccBOHcebJi/4
	 OaI83pBVZpr15eYtryVNMqmOZevwPwtFeRtnTjh4a2yBUKjja1W79/p5/c36JqDD6N
	 OSkBgQ5AfZFea7JMwB7qnMuvTszRM+Xg6jktmBvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2182/2857] arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins
Date: Wed, 18 Nov 2026 15:53:36 +0100
Message-ID: <20261118150319.969980246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e930c49207dad..1084fc8385911 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -609,6 +609,15 @@ mux {
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
index 3d642d739c359..ffd2aef45617b 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -126,7 +126,7 @@ &sd_emmc_c {
 
 &spifc {
 	status = "okay";
-	pinctrl-0 = <&nor_pins>;
+	pinctrl-0 = <&nor_pins>, <&nor_hold_wp_pins>;
 	pinctrl-names = "default";
 
 	flash@0 {
-- 
2.53.0



