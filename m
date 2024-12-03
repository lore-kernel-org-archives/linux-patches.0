Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4397D1E3DF9;
	Tue,  3 Dec 2024 15:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238207; cv=none; b=IltGXM5UOn7HREvR1BA+zvFRV7W6JEJROzoCHj822TK8oTYOYvDh4Vpbqg9BHOsWOmMC7rb46L7mNJ59dmATDKTQdklNV0YC+u3Zk6/Kc75A7Dj+SsAtMlSJ+DOuwJ58CKsB02V3QN/iaCmT65ZZgwpjqxBGkLy0vOCO0+d4/UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238207; c=relaxed/simple;
	bh=lPhay12moMPc49NaIFUyAXdHfzxnkP3O+ImEML+n5dA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kLQKwC9gZfbHEE4emSTXiEt/EbWXFLOoWhyP97jV6y8hPn/MEAMUMBeGA+mAaHDxz6OS/j5KkLGJ6h3WU2J3odijT3pmJ/EUunVYKGFcI74YP6BXjiu8yk4V51XU6PLnIjlDrMk/o5whajwNSvWcAxLFNEwXrJL4yMEwF25Bc6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHfb6k8X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHfb6k8X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD989C4CECF;
	Tue,  3 Dec 2024 15:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238207;
	bh=lPhay12moMPc49NaIFUyAXdHfzxnkP3O+ImEML+n5dA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHfb6k8XzJSDZDor+ApKed4Wrin6erA8mxJlTPDImFzx3cSEkf08BeQOpoegnmVqM
	 Tw8QLXj/ikLdMsEoHgsk9d1Qkgk3rehfLgU3B0pKYRIEagWe988k5dYI69Yt6a1x4Y
	 9aZeOoGfSR6PfPS0/QP7od2k0CzF3K882IeLAiYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fei Shao <fshao@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 171/817] arm64: dts: mediatek: mt8195-cherry: Use correct audio codec DAI
Date: Tue,  3 Dec 2024 15:35:43 +0100
Message-ID: <20241203144002.406551841@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index d3a52acbe48a1..2960772cb9065 100644
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



