Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1EF53E02;
	Mon, 11 Dec 2023 18:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zpUXLyW8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 384D4C433C8;
	Mon, 11 Dec 2023 18:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702319717;
	bh=WhJNlXQz9AGMma3kmAwhWwYzbrGNj7L8kqKLuq0Rnvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zpUXLyW83rR4wlgQdcPtSUqJK5+dR9Sg4UpfI4V8YVWovdb4LeWcBnWKIMlAM7Lcg
	 AHBUWGbmVgmHdJKfWmxqVPVA9mEs5/mxVlpDWeA3CGUon/mXrJjFrbTL0UbkaSflCb
	 mHSmBIf15Vl9JMqVtv65kJCkbe8CFNGFWnQxKmU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Woudstra <ericwouds@gmail.com>,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Subject: [PATCH 6.6 178/244] arm64: dts: mt7986: fix emmc hs400 mode without uboot initialization
Date: Mon, 11 Dec 2023 19:21:11 +0100
Message-ID: <20231211182053.922506721@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182045.784881756@linuxfoundation.org>
References: <20231211182045.784881756@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Woudstra <ericwouds@gmail.com>

commit 8dfe51c3f6ef31502fca3e2da8cd250ebbe4b8f2 upstream.

Eric reports errors on emmc with hs400 mode when booting linux on bpi-r3
without uboot [1]. Booting with uboot does not show this because clocks
seem to be initialized by uboot.

Fix this by adding assigned-clocks and assigned-clock-parents like it's
done in uboot [2].

[1] https://forum.banana-pi.org/t/bpi-r3-kernel-fails-setting-emmc-clock-to-416m-depends-on-u-boot/15170
[2] https://github.com/u-boot/u-boot/blob/master/arch/arm/dts/mt7986.dtsi#L287

Cc: stable@vger.kernel.org
Fixes: 513b49d19b34 ("arm64: dts: mt7986: add mmc related device nodes")
Signed-off-by: Eric Woudstra <ericwouds@gmail.com>
Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20231025170832.78727-2-linux@fw-web.de
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 24eda00e320d..77ddd9e44ed2 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -374,6 +374,10 @@ mmc0: mmc@11230000 {
 			reg = <0 0x11230000 0 0x1000>,
 			      <0 0x11c20000 0 0x1000>;
 			interrupts = <GIC_SPI 143 IRQ_TYPE_LEVEL_HIGH>;
+			assigned-clocks = <&topckgen CLK_TOP_EMMC_416M_SEL>,
+					  <&topckgen CLK_TOP_EMMC_250M_SEL>;
+			assigned-clock-parents = <&apmixedsys CLK_APMIXED_MPLL>,
+						 <&topckgen CLK_TOP_NET1PLL_D5_D2>;
 			clocks = <&topckgen CLK_TOP_EMMC_416M_SEL>,
 				 <&infracfg CLK_INFRA_MSDC_HCK_CK>,
 				 <&infracfg CLK_INFRA_MSDC_CK>,
-- 
2.43.0



