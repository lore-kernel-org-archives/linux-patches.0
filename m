Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063889;
	b=ZQj0VnLdkKh9GnV4+0hydvPuaTtfU76boK6BJc/ZRr0a/zpS/bhp7sH+Voesd6mEN8HP
	 rTT3IZ6eY6dX6ftMeWHLW66kHP7eP29TY3iJUUwKjMVno4Ny1ZdjzmgHatB7G0xhkzK6v
	 ezhN2jX7jAWwXN/dDgi63PIB1aJpuMMwFm8Dmd1oaX+tIThnttrdC+Or8/30J0qNTX6oU
	 MF3JOakA24c4cdFcV+oezug+MUglgF1ttKAhfoW2x+QyUl8Zh3srZ4zw5Y0qSPqzvLabs
	 DujBRIyLMss2qbxjn8RmumoUu7h2DUKRHsAXvn+dwtGM+kbHJD7k8wGsfxEJi4EEmAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H+0fN6HAiA3ZHuD4LnMGyBWHNP2p8Rz+P25ARpFPfkI=;
	b=t22wphcZauN8gxCcqCu/WwpHpEuMDDo+izNfHkQx4s+RvEsGB2ucseBBvjySgf84BK59
	 lQxEfouJXm6Nu62cWji4Lp7ORO4RCNHKUrTVI9HMN2Gf/eyX/MnzdXzxq72zucVbq0bi4
	 3GsJQOsH7mEEChFwKga2qap+FIlgk3nkZmctY9r2oSIO0wOMi/TGNfjc7hHRsRxuNyyf8
	 tGC5swA8pKlSP9LPybVl9UCRwiFYYEvxiMnkCsrsOrEnhBPmnpJDMs+z8D9X+dkmda0Fp
	 f0FSlRYgGbPqHCgJhkrG5YXex1ROMAZOnUj7O7IOlZkQvIv7I+Q2h1Z0SdsM2l9aFAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="S/flTS9o";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC1DA606B8B4;
	Sat,  7 Nov 2026 15:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S/flTS9o
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B8F11F0089F;
	Sat,  7 Nov 2026 15:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063888;
	bh=H+0fN6HAiA3ZHuD4LnMGyBWHNP2p8Rz+P25ARpFPfkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S/flTS9oIUhc1/GM5zIAzdl8eyJmKvgta2xuyhkKrmt0phVU/1PAy3PqpeetB+FLH
	 SwXp3d0VjvBIB/QCaBBoVNdgUAZUJ545gC3ORJw6fD+FNS1OEHQ0YUkYhAqVRq7UxQ
	 Zh2dyNUKn78BCbQ3fqB6q1JKbtWFLzcVykSbaspM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0084/1257] arm64: dts: mediatek: mt7986: correct timer frequency
Date: Sat,  7 Nov 2026 08:39:40 -0500
Message-ID: <20261107134941.690148166@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Andrea Pesaresi <andreapesaresi82@gmail.com>

[ Upstream commit 1cf18e4b9815beaf0439c5b57b65b45151c82ad7 ]

The MT7986 architected timer runs at 12,986,200 Hz rather than 13 MHz.
Firmware reports 13 MHz through CNTFRQ_EL0, causing the system clock to
run slow by about 1062 ppm. This exceeds the kernel's 500 ppm NTP
correction limit and leaves clock discipline saturated.

The corrected rate comes from MediaTek's downstream OpenWrt feed, where
it is applied to both MT7986A and MT7986B. Since upstream mt7986b.dtsi
includes mt7986a.dtsi, add it once to the common timer node so the
architected timer driver uses the actual counter rate.

Fixes: 50137c150f5f ("arm64: dts: mediatek: add basic mt7986 support")
Cc: stable@vger.kernel.org
Link: https://github.com/mediatek/mtk-openwrt-feeds/commit/6a4c41c41410cd5042ad10c39da6593ba036283c
Link: https://github.com/openwrt/openwrt/issues/24789
Signed-off-by: Andrea Pesaresi <andreapesaresi82@gmail.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 9ebc196107e5a..318639a7c64e9 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -657,6 +657,7 @@ cpu_trip_active_low: active-low {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupt-parent = <&gic>;
+		clock-frequency = <12986200>;
 		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-- 
2.53.0



