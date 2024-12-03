Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCBF1FA174;
	Tue,  3 Dec 2024 15:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240439; cv=none; b=OIGKr25aPekioyzjgRkR8Eu/TAD3w2KnH/EfIwCQyLw03bXTG2TyWbnDnW/GND844hvRSWgzgH0xCy8rgcQqKx/FafGcdcx0w/huPBKNTdi0hhVKSGyMFpVfKmIUqk7bVRyBi5tOGDBpczeg3nkViihDlSKroB4QzfUEaT22d0w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240439; c=relaxed/simple;
	bh=ve/xHqJHe+Z8AMdJyRoBYKUEZLpvse36nACSSRHh/mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r/q2P+z35vrA8GsgzgD5W+DEhhoIXUZZTl/0XVjBfWfxYYBqN40Ou1HKh3xOaJ5sHUChU2VCPTFd6RFLKbXUH2W1QFlXIehtM29BX6oIwTHQzLIeDHoGzGQDG9XpeQnalY3JcJNAd3a/FiSqUMCpn+iWLFEsdoUkVaxb03ZnjhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=neeyKlHU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="neeyKlHU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65716C4CECF;
	Tue,  3 Dec 2024 15:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240438;
	bh=ve/xHqJHe+Z8AMdJyRoBYKUEZLpvse36nACSSRHh/mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=neeyKlHU0tFFHsazRAjwSKobKFL5cT0zqBNDOXvlQmpcSsv7FjSKihXNz2R8sPCIE
	 px1JGPqHgUNmwNrjKq44pruOgEEbMYcDKgcGi8tAihIWEqCUBGJr93vWo2E8NFnLhN
	 8qjhoZcw9uGEq9rdzuct7CU+7Yzk/c++XYKSPV0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/826] arm64: dts: mediatek: mt8195-cherry: Use correct audio codec DAI
Date: Tue,  3 Dec 2024 15:37:41 +0100
Message-ID: <20241203144748.969863171@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fei Shao <fshao@chromium.org>

[ Upstream commit 7d5794e6d964940e46286fadbe69a3245fa51e44 ]

The RT5682i and RT5682s drivers describe two DAIs: AIF1 supports both
playback and capture, while AIF2 supports capture only.

Cherry doesn't specify which DAI to use. Although this doesn't cause
real issues because AIF1 happens to be the first DAI, it should be
corrected:
    codec@1a: #sound-dai-cells: 1 was expected

Update #sound-dai-cells to 1 and adjust DAI link usages accordingly.

Fixes: 87728e3ccf35 ("arm64: dts: mediatek: mt8195-cherry: Specify sound DAI links and routing")
Signed-off-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20241021114318.1358681-1-fshao@chromium.org
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
index 75d56b2d5a3d3..2c7b2223ee76b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195-cherry.dtsi
@@ -438,7 +438,7 @@ audio_codec: codec@1a {
 		/* Realtek RT5682i or RT5682s, sharing the same configuration */
 		reg = <0x1a>;
 		interrupts-extended = <&pio 89 IRQ_TYPE_EDGE_BOTH>;
-		#sound-dai-cells = <0>;
+		#sound-dai-cells = <1>;
 		realtek,jd-src = <1>;
 
 		AVDD-supply = <&mt6359_vio18_ldo_reg>;
@@ -1181,7 +1181,7 @@ hs-playback-dai-link {
 		link-name = "ETDM1_OUT_BE";
 		mediatek,clk-provider = "cpu";
 		codec {
-			sound-dai = <&audio_codec>;
+			sound-dai = <&audio_codec 0>;
 		};
 	};
 
@@ -1189,7 +1189,7 @@ hs-capture-dai-link {
 		link-name = "ETDM2_IN_BE";
 		mediatek,clk-provider = "cpu";
 		codec {
-			sound-dai = <&audio_codec>;
+			sound-dai = <&audio_codec 0>;
 		};
 	};
 
-- 
2.43.0



