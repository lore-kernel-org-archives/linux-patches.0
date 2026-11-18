Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055673;
	b=vyZzvwO6vtkWpr3v3W4tUZVpdezf0MB4UcseAo7YAHc2w8em4EAMYVfNjy65Pmef5tT2
	 ZuI94Ahicppd+A+aruTtP0moukBgfZTEA6LIPKGveMHbHnyoHBPLYWyN3KCPvqEKcshfu
	 1pzclnSubND4Mdc+WR8SewyluhMuxNzqnywDQ1huuxZnqI2TaRzMLBT3Nz86qkPWEsZ8L
	 Zyh/81juDVd7F1NV7wsnmLqntedAV0+DyVKLpQwpVPM8DJvQbuOae/hlN9qsdYbrCYFmq
	 QO4a8uaMoS60lfI5Z9Vm9NMDIclT2OlAHmd1GY0mKgjkPP3AnroqJGENgRnngwTLV6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055673;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wEmdJdFTdQ064gK7MWo6c58iO11egpFItGQ9xVW8wEk=;
	b=jwsxg5Y1NbX1YcwCh1YQydUQlg5wrql+A1PRGgM7JYxUiuL7VduYc/c/gQJSWWA8Fy8l
	 gvliwAP5fvegRa2huB4udjZZb5jZVM1leXru5vbQpTj6DpTfqPQCRHoSUYocn+mQR71/2
	 nWwr136X9ARvPD0Pr/BrP4/nkjEYIFR29K4kThe7oMnYLm+tSErMcd9YnQ6g0UsNfsqp+
	 sOMhPsLxcfWJLdZKlTuRMMsmWwh4jupkXY8s/pNjwrP9i11N091voSx0F16f8pzBsvq1K
	 oFqvcZYQyCYTNFiWbi4Auw0pQzQSnCUPQYzHS00yRogb1V7Na7KmO6XHl551SPd8RFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY+GyBfZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 025A8606A31C;
	Thu, 19 Nov 2026 02:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nY+GyBfZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0789C1F000C4;
	Thu, 19 Nov 2026 02:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055672;
	bh=wEmdJdFTdQ064gK7MWo6c58iO11egpFItGQ9xVW8wEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nY+GyBfZQLtLwYHsOCy6GmIeHo2jD94saGmEbU4hb4u/x4GUGTqMaVRJBwnC/H59A
	 SvhhZZrtOdKuNlKGR/humwP4JI3fCH9BYPV5Jb6pZNuRfZl5gQXXbELaKSIndK4vQq
	 NUKkqkjIfFO1ESKHXGjaLGDSng0gW0EM5Uk2Srik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1714/2214] arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins
Date: Wed, 18 Nov 2026 15:56:30 +0100
Message-ID: <20261118150120.320570367@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 20b4575594a03..3c9b4964289b1 100644
--- a/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
+++ b/arch/arm64/boot/dts/amlogic/meson-g12-common.dtsi
@@ -664,6 +664,15 @@ mux {
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
index 15fece2e63205..ef45ed4113110 100644
--- a/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
+++ b/arch/arm64/boot/dts/amlogic/meson-sm1-odroid-hc4.dts
@@ -126,7 +126,7 @@ &sd_emmc_c {
 
 &spifc {
 	status = "okay";
-	pinctrl-0 = <&nor_pins>;
+	pinctrl-0 = <&nor_pins>, <&nor_hold_wp_pins>;
 	pinctrl-names = "default";
 
 	spi-flash@0 {
-- 
2.53.0



