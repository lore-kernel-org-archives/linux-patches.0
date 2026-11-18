Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035802;
	b=mt5xIZGLHZfIDvsuQPnn4xThRCPJ7bthBvqgvZiazAEIcI0gPYb5q4qRVUlqWchg1rrm
	 31qT6x7s4Yen8FnofW0yIhTjZUaTmRsXM32Bh7jDtULL+/oUQ3oLZ46DqRUEPPBlzy+JQ
	 2vNSr674VJtroy23gWPKEJVliY4KAopxjgA+wxYwei6zXvZP4VN0tsOHPSJoQgwEuuVnt
	 JDXz1khHtIZrUhtqD7PkOIhXLANTwtUMKWB/kk/3NKE8SkCQzZrSYk11ElURs63ms+v3t
	 avt0KDHeqdF2/B6xFXufWx8gxNzm8qyc+cRuUQgzD80PzL8ytstUc7hMoIREnPOtdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=z/k/6oDGERWzihd9fuuTlhdr2bC6r+4/OJREEriVqHI=;
	b=TCCTnsq+ZZ56HblLuxNtw69csq++o13Zv7Bqaw0b+b4l+GdHH4yupxBowP/fXnV5qpkN
	 yxaNio+uc4Qm8bSHqrtZt15kz0yidWvvHzOlcNxSvDi3QRxiemT0JzMSq6Fc7DStjrjCi
	 XLzT3cH4EcLfcYcTsl5iijCTzTEHzt994H0o5h+NSjgs9VwXQbCC2J3RwUvLp0J0yNUSd
	 ST5WCW9zmjUDRjQepDXGUxXc3RZ2/h3vYYy4Z5Gcl999Pa6XtxMIyoxHP6e/hgjw1KcHM
	 wtXBZq/3B5XWuLerUB+2O1dCYQFb/3YXJCxHykfyWibTOXysDZ2AM6N3LpF6hbDeUuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvB4337c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06FA606A320;
	Wed, 18 Nov 2026 21:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jvB4337c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24A21F000C5;
	Wed, 18 Nov 2026 21:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035801;
	bh=z/k/6oDGERWzihd9fuuTlhdr2bC6r+4/OJREEriVqHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jvB4337cgo/YPJzyKhZ2rFsJKfZLkTapJ50YY4oHeFpwjbLhJWFXud5z3Epf9k9hM
	 M5gTeEWPrLKYy6Ospy/RcJefXa/swmRaqVEO2OG3/llcLzundKfZoDVAFXCp0bwr/7
	 bDgB7W1xkrrJ3Dos60c5QH0eO3y0s5+McooGSGsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0830/3318] arm64: dts: mediatek: mt7986: correct timer frequency
Date: Wed, 18 Nov 2026 15:24:12 +0100
Message-ID: <20261118150344.005194770@linuxfoundation.org>
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
index 05bd2938242fc..60c4c2f24c515 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -637,6 +637,7 @@ cpu_trip_active_low: active-low {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupt-parent = <&gic>;
+		clock-frequency = <12986200>;
 		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-- 
2.53.0



