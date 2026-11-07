Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061925;
	b=GeTGLIJ2ARj0eqBRhkbhjRExY1sdUzSNDwxmTSbeMd0viZBCeby3MVO6J9r5O50IhDf1
	 snw2nyzXTIrR/7uO1XvVGlLVb2/QYlGIHtjTYEgIqPFSN1eN6K3nN5Zt/Vz4L61v8L/aW
	 dCKxtneCdRLoZxFojtLeOiWmCshYVyLNlO0UaDQVVmmA8xFBkv65pvOMbjY7SJlVBIz60
	 Bt6lcp4yhBmgrSoPcUNTNZ5GyFMuzGfHhNWOv8whdTHYM1qMXjt5y7otvlTrt44jkHAVn
	 jg6g9sQVbokA1JhwpNsqSHE1yg8Ov3eUcZ5IX/74g0E4NVqV0c6dtWJXPLJfFtOMwWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061925;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=chTjb8aC2NSqjyLs/hzzcg0QUdIH/ZR8Rlm25Yjg0tI=;
	b=ACHJNpkvQ4StOqWHy+59db4pr1Wr/poPVFQ1Ya/AaaFKMgQdzqgjgSuynWK/C689P7qE
	 bv8OmoltGlhkcTv7gAeLMQ1KWSRcKYkc56Y4B77csuXZ0+6vsCL6BmKtbatbHDZ4QOllT
	 Yr89UyvM8J8AaRK29gfTAOcL23/lUjt7yHwhDHxiCo47pNSDDk71O1Fg/g9/6ryFDoN2q
	 qlzs6zZZQDdaWsBWvDNxjkBR2kS2tAsLgijCag3yph6c8z6ISbRNRMF1gKNVps+xjQclp
	 NYVAl5C5kGHzaZBLfyDwHVs9JcbAHFZ02+cw1pGEITBxkHzFI/cLNkBwM9Evu3UZLRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFPgwYdH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9491606A32D;
	Sat,  7 Nov 2026 14:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zFPgwYdH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 682C21F0089F;
	Sat,  7 Nov 2026 14:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061924;
	bh=chTjb8aC2NSqjyLs/hzzcg0QUdIH/ZR8Rlm25Yjg0tI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zFPgwYdHIClnY0LpSxUgpPp1e1FUMokqaKKfoS6kj/CpKxznONapMJYgHMC7xi27B
	 355j5ofUukV5HULP2X8bLvAAksbHYAkH9h0gmC6lmUE6q2LZN6qBbL7ZC/pKEfCw9Z
	 Km3v3GIIdWHDruiRj5hiYtx6hq1C3C8Ck2hclzg8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Pesaresi <andreapesaresi82@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0930/1536] arm64: dts: mediatek: mt7986: correct timer frequency
Date: Sat,  7 Nov 2026 08:49:06 -0500
Message-ID: <20261107135023.769431261@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



