Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040615;
	b=tt/KuuM78Wl/EaY+QC1Huny0gU57WAiKur7aac8zQSOnKr2ViHZFfM/JBMNr/oJJtQOM
	 9I68LiEyK63gTaVLAUd8+Hv9ucPXqntVY2tY4VHM2cfRa8hLtWjn03LjNzaTEBeTUTLhj
	 dfRZr23pSNWd+xmA0WuEXr8Rcw5kcP6A/j0Th/dfD3t016SqJzahEo/YR5ctLnm2Pcgo5
	 oC7jiZsca2pQmzRePNVpw6yHaoV9zoetBN4qR04dkTFSQNiL82Y9MelXmomPpR85W3gzD
	 9gUrpsavTc3sN55EZNUJfIiRzmwb08XbeAmxoJRhuWu1nknpbp4LLj2yKcHL15539bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040615;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LycP3wgqPvD2GsgaJAX9L04SdboMgGVUVz2whmfPP4M=;
	b=UaH9hR43JyM1ZHcl4EdG4Zk8AVVHeUZm9l0PXtrw8dmF58tDAAnKm6Kdqnb0F2+M8s8p
	 UT4/ntR1PmfKRY4U/s+33L/eJJ2fz/sbI3TcvobDd/KGQiRF57BqjJsHT6Jg9sbjD9JA3
	 YKG3JYlxNKnQKjZkjo8VQptWs3/tlqOL15LTwfuaatK4NPDyWbvuGF/79zxsHfrcFs7YZ
	 gUY9raV6EAuCNndy6LrseC4Npyc3hI7NUnna6AGd8Xcmhef0c7/Wk1Z2gMNDWln1DGfBm
	 XVcjtsavzUflo0OkhyCp9BNM/VQRzFaoVA75nCAwuAr6Y67H8LUgK129ndp2L+fxqZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbniTujX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D62606A32F;
	Wed, 18 Nov 2026 22:23:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cbniTujX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B49571F000C5;
	Wed, 18 Nov 2026 22:23:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040615;
	bh=LycP3wgqPvD2GsgaJAX9L04SdboMgGVUVz2whmfPP4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cbniTujX0xBXnxbqQTY7T4GbPzafgpr1L5Gpu1saSxW/fD/Uj0cwOhPLdJBizom+5
	 k9lQ8HFBTLXeQqcHGjtp2vHwbWPgK0WwycpnCiQFlbzKNNkdF603L0o6WTsOhINLE2
	 2BDc9mgIpoDf6XxaJ9XnXL0bl2+QKFITHdKwHo2E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Velkov <iav@iav.lv>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2520/3318] arm64: dts: amlogic: meson-sm1-odroid-hc4: mux the SPI NOR HOLD# and WP# pins
Date: Wed, 18 Nov 2026 15:52:22 +0100
Message-ID: <20261118150436.967027996@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c5848363df37a..e8a2bc3e256cf 100644
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
index 846a2d6c20e53..dd29856a49f02 100644
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



