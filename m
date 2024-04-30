Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979488801;
	Tue, 30 Apr 2024 11:16:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475774; cv=none; b=Q3P4iEGUivmISBAZIYFG0zaG8Ix078X1ICMfEvYop+aoAbW126AbfSD2usta4Qvx8q1inPPH2tmtLrgEWk7cC/+o6AyBM9knra+Onvt6AUbTfqbd+vwXOESU4jn7nYSd2YLvgH5Ggq9jgjM4vy0nDo/Bpc/E1b5/Lbs8cDPjAR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475774; c=relaxed/simple;
	bh=J3eA7GYb1BH6z60Ou6DRaGHpmCK1+JFscjhNZo+9r8E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=l61jqKbq0v5nfH8QOrLYozUIBvZZOThlMVpuVWRe0Ud7C/DlQvUppkLT0iZXEXtw3r0Dnf/9hl5WqJqzAsj8Qdxvu4QfFB7EUByNhOTULv6pgsygb1rJrIbX1Zy6kVaH7NxHDwn5pBEvkpeGxaAtComatZbIhcDBZxrg5NUZcRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wm4wvyd1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wm4wvyd1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3212C2BBFC;
	Tue, 30 Apr 2024 11:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475774;
	bh=J3eA7GYb1BH6z60Ou6DRaGHpmCK1+JFscjhNZo+9r8E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wm4wvyd1wRKLmX4R/uQKMCC3vN/dd2KTDiIvMftfmInNL43V53u/bJqzk7yB+Vau6
	 XJs3sDqvChXVBPWB6LYrmJ6+wz9RrsE/C1Vq1U75/9fl6FurMl+NdtTrXp+LJc4w1a
	 C96jCOpZsoSEnyyD0YJQvUoV6NhOgShmR3HSNrcA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/80] arm64: dts: mediatek: mt7622: fix ethernet controller "compatible"
Date: Tue, 30 Apr 2024 12:39:46 +0200
Message-ID: <20240430103043.833345106@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 208add29ce5b7291f6c466e4dfd9cbf61c72888e ]

Fix following validation error:
arch/arm64/boot/dts/mediatek/mt7622-rfb1.dtb: ethernet@1b100000: compatible: ['mediatek,mt7622-eth', 'mediatek,mt2701-eth', 'syscon'] is too long
        from schema $id: http://devicetree.org/schemas/net/mediatek,net.yaml#
(and other complains about wrong clocks).

Fixes: 5f599b3a0bb8 ("arm64: dts: mt7622: add ethernet device nodes")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240317221050.18595-4-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7622.dtsi | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7622.dtsi b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
index f3bc89ac0bef4..7a54af96e1d90 100644
--- a/arch/arm64/boot/dts/mediatek/mt7622.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7622.dtsi
@@ -935,9 +935,7 @@
 	};
 
 	eth: ethernet@1b100000 {
-		compatible = "mediatek,mt7622-eth",
-			     "mediatek,mt2701-eth",
-			     "syscon";
+		compatible = "mediatek,mt7622-eth";
 		reg = <0 0x1b100000 0 0x20000>;
 		interrupts = <GIC_SPI 223 IRQ_TYPE_LEVEL_LOW>,
 			     <GIC_SPI 224 IRQ_TYPE_LEVEL_LOW>,
-- 
2.43.0



