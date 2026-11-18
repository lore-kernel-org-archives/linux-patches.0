Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018294;
	b=dLnF0DN1qzh/fKdj7PZjsVx0McrPU73Ub/XMddr4i30tn9ZgYqnIGxukz6cmjjN8ZvS7
	 Rh99LJf7JbhR710J9Ud8EOG0qEsl+6BBSinTyhrAn1xS1Fxt5QNlVwJT6aBO+3p0UNfIW
	 rOYY/LeXnZ7IT/q8FiBwNtL0RoxHbHCSdEHrS/8lSXL99UWEyAw2CgMszJFa18EoCSGJg
	 S2BDX8Wcmas5QINj2dphmfz91Zmli9GRmw0TEJAp6KsbBwLVo+gj1KbtDN6e65QBvWo1v
	 vQYQEtyNsaLm187yvRonb28sDkxe8yFIlX4MBQFq+LklPdofkt7Ls+JM/qLeZTeekdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018294;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L8h83HIS0EaocBkDOtUSlV/6pmwAsGZQv1X5LgjuLHo=;
	b=E1Xkq3HCP0/5XoA+A4UY00OFebIJl8thy7NqQUkWrmhUJTI4lV731kwP5U3CQo1d2hwd
	 xJ3dLym/pSuTGR78S9HObIwlfEqVqQmLVqD9DTBYaFd+JiBu+WjsUGHet7olzGM2P/CtY
	 6Tcep4w1cuuFZDZn3wyFI9/JxFj7N7QUVWGfVra90rgs0HtHBVhAkOMo7TGXjBzvcYnYU
	 qokzND8+dJ11zcKSKfZXwk02moMfjmiDM+zPdX5C9yYKbgumL5KEqtzIsaVJqKl+XZNqR
	 c0j0NrFn+qZASC/5f6uLS9d642afgE9FZUzA3EcNXLms7YyS1wVhK7J9Ihxvfiw3+4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlsKYEMl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A0A606A334;
	Wed, 18 Nov 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dlsKYEMl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F87F1F000C5;
	Wed, 18 Nov 2026 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018294;
	bh=L8h83HIS0EaocBkDOtUSlV/6pmwAsGZQv1X5LgjuLHo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dlsKYEMl2gSiZnljVLcAyNoMrv3gJ6Q1atvBEQpGIwGEEKGys9RLX21FOBd4sikS/
	 EaFW3jqkFB7fsGZeZx0A0TKBQzNvraZuC9d6FfdF9Onvst7dhzGR/t2vgdfMKNLEW5
	 9O3Pyf6/mtmB7Etno2R2/oy00IU98lvq9D8etWU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1190/2651] arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins
Date: Wed, 18 Nov 2026 15:40:30 +0100
Message-ID: <20261118150330.841848048@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 00609d2da6743..3135566df8803 100644
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
index 3ece30a0a1fff..c4b93d6619f25 100644
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



