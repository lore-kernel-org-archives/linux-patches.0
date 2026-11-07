Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062767;
	b=OaYgrDg5axF35D1hHhWoIvZTLqkSFSZMZntKFjQJCzx2USXc45mw78KrgqTuLd7v/zfc
	 Qye6hSrtlB6xK+rnM6v0tWAcbqGqgFtywZfBVJ+XbPRB+hAUTnAbDTrHzkj2zpndUmVOl
	 TLvzGaiWFazpN6fSC79EBb3qiJGgmm6wgvj+8EINA/D4rXhx/zhLkiPtEpiU1D/oI4SR+
	 B6FulYFmcnL0MoocLSWerhepNPslsEgGbZ1z4d0VNe0E0DyhssFHtaLIpNs2saFH37g9C
	 d5pC/gRkKielKg33eNSjp719ZJc9BB914m9EClLLEzFrk7t4+x5U5B4Udaq2MzWTj0g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062767;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HpMrf6vDJbaBzCgItnjp7dXNyA5DoSPIN6zATa0rrYU=;
	b=kpooTg/TbWe11wut7lvoNHy6FwYZbPEZg2DwAvRih60w7rQujepTKuzLuBPO7IhmGxmR
	 IHNSkPN8PLdFBZXae4kPEFQBo2elTURNnr9v/OcQPpIxEumQMP2GOsJNlLC3luiGGqfqj
	 2hGpdt6Ry07YIxnep05gRVU/T82goSB3PELetAXvzN7R/pIhVrx2TRFG38Mz5gRvGpi86
	 dEJCbZCJjO7L1S3IJsN4VwnqVijMNa/YPV68dds5U4Gpw0cv+Fv1pi2RJEKHOfo8+p46i
	 APkwRh9uFnHQxhhtMZfdbNOsDWZJOq9UJ3760I7qRLKBb1XEmpWq8P2Kccl7hM8/SGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="O/Jj5E3m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E3DB606A32F;
	Sat,  7 Nov 2026 14:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=O/Jj5E3m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FD91F0089F;
	Sat,  7 Nov 2026 14:46:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062767;
	bh=HpMrf6vDJbaBzCgItnjp7dXNyA5DoSPIN6zATa0rrYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=O/Jj5E3m3rpJoTLTVryxnvDc9B2oxVvPPEWFFSZlGSPSWqPZ80cKC2ooyeVF+DVnK
	 cYnyhdG8ROuc+x6R0gnxJHfnMtWU5J8FXtG1Lh/RbdVzQ4hzjxG/+EvKh7WMfLkr+/
	 Vbna/lRZa7JVsQjImrAUxk0upnYsNGmq1qt+wIb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 076/869] arm64: dts: mediatek: mt7986: correct timer frequency
Date: Sat,  7 Nov 2026 08:45:58 -0500
Message-ID: <20261107134855.321971424@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 6786e5b590e85..df5f7d831d819 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -653,6 +653,7 @@ cpu_trip_active_low: active-low {
 	timer {
 		compatible = "arm,armv8-timer";
 		interrupt-parent = <&gic>;
+		clock-frequency = <12986200>;
 		interrupts = <GIC_PPI 13 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 14 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_PPI 11 IRQ_TYPE_LEVEL_LOW>,
-- 
2.53.0



