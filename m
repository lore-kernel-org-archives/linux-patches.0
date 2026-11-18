Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046645;
	b=WnqyXsWsagAzwp7mjMpe0wcsAMXgZisGe2NNfiHIIIvRoByo0vlkHCZTBoortanDKxre
	 meUBIMn4QAZCoza/uRNeq0uKFJ2D/ax/vFI7vbFl3h1Xq7j5QyT7biD2gxPoop1xeKBaD
	 H3fmQFDTmlTQr+DGEkKwm1gkMtsdtAxc0Aa2PIFeshOLGg7X6ajNkJ9Sq2IzpaPzwVCdY
	 ylBsfr6mebXFb8WKu3/zH4dfi1WRgRBtOge12KPF4bDHS7Xf98vIbZ7Dd85m5f/IfrBzF
	 E5YJ0CcuuG7cxpYzYfXHNDWDH/SZn5FIEtI9fFmDf+pMhfg6LT9GtI39PlPFx6SIjOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046645;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=GS8sxhSF8w4Bw+EuX8FnBAJJV4ZsMUqw3xWdqf9xwds=;
	b=i2mM3ROuqwZBrlsCocz4JAaHGUBzL1OYMSynk2Ld/+dilvtCfbgvUzknYsABqRPyPGDS
	 S/o1tO+NMxnPXV8KJ6KBLglMOaMnL9yKXkewkeREKo0nN9sgwHF5QYjHKnuB++8HG+Jvp
	 6v3jM5w/0u07Hm/P7FOpStxBoBMpFoIzkR5871NO6JnFLs1xAtaB7Yy0KAXxoI7QNZVfw
	 6Y/ubq4I3E/1bWyrysVgVD3Dz93WCLNxMiyHTHERtJS/f8Ee2I0Qq3UWfeMw/gcLwqll5
	 JVWUgMnc3RZDgwnyMq9ZXBFkLQ3yyI0f+aE1BnpBRDpVQlAvVtzVNoFAYl3CK7zkIoA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z65CioPY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CA85606A32A;
	Thu, 19 Nov 2026 00:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z65CioPY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58FF01F000C4;
	Thu, 19 Nov 2026 00:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046644;
	bh=GS8sxhSF8w4Bw+EuX8FnBAJJV4ZsMUqw3xWdqf9xwds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z65CioPY0YSQpbgoZwMTbVKZpXujIv0fdLeHTY5EE9/bhi1DWWee6gtcskzAOXJuG
	 zayhAblgoioLu7ieQHEQP6N1aY53x6wJsMlRf3QnCNnYW53YTsMwRxfBDgYfUVu8Fn
	 LQMt7cm5uATsIhTWwzFN8kBsGEg3eKHwSIL9157M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1355/2857] arm64: dts: mediatek: mt7986: correct timer frequency
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118150250.198131754@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adjusted context for the timer node’s earlier location because the upstream node reordering is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index c647d99c9554a..b595c08701658 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -81,6 +81,7 @@ wmcpu_emi: wmcpu-reserved@4fc00000 {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupt-parent = <&gic>;
+		clock-frequency = <12986200>;
 		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-- 
2.53.0



