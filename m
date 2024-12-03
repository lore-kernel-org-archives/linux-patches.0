Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE3F1F76AE;
	Tue,  3 Dec 2024 15:00:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238054; cv=none; b=oFzjDEcNJqilS7am/cL8sO/D9EwvtQ4rITbkygL0cDjflhycGqSDljbkKd1uz8550M2BLVDfuAyKIVeCtwei27v4KGGCqVdTWxuo2vvF291u4Tccla14gDj0lICPLbg+ty7qcvlL1hjsZJmgMwGB/HR8sFu2iYXXNJcEmgjD6mQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238054; c=relaxed/simple;
	bh=C6SQ+NFphTNO00OVCE9hGIYc4MZF0ADJhpP2FVXRHfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m+zzLh/Ma0wn6YwFEEZkhRdJWRS72sywWAhx6N8qFpsN6/40ZGxkkbV/LW4a6HaavcGSs5RjykfRjH7XigouZb2V5OCpsTek8N9Exifm1GmFzAAvn3CxEWBHgJV0IbaPeAEQAylY7gMeS6qtJV5Z8CothZeB6Ba5HZPH4jkhSZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l5wgpEuC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l5wgpEuC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E484C4CECF;
	Tue,  3 Dec 2024 15:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238054;
	bh=C6SQ+NFphTNO00OVCE9hGIYc4MZF0ADJhpP2FVXRHfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l5wgpEuCyXBOrrRHrJx+1OHABm9esavV2cyAlxyisBIhaqcCMXiieWXzsAKFHAzvB
	 vs3Cl1Vs7/hurAOe+U2vi2NGbXY3dz+qZI8cdv0+Y3+qUoSfqAhSj/JK5cdfhKBMJ/
	 D3sqb5oqkeoZv46w/B0AoNT9C4ryW7P3exuj/Ac8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Macpaul Lin <macpaul.lin@mediatek.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 147/817] arm64: dts: mediatek: mt8395-genio-1200-evk: Fix dtbs_check error for phy
Date: Tue,  3 Dec 2024 15:35:19 +0100
Message-ID: <20241203144001.466748592@linuxfoundation.org>
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

From: Macpaul Lin <macpaul.lin@mediatek.com>

[ Upstream commit 752804acea010959bb3a00c65acdf78086a8474c ]

The ethernet-phy node in mt8395-genio-1200-evk.dts was triggering a
dtbs_check error. The error message was:
  eth-phy0@1: $nodename:0: 'eth-phy0@1' does not match
              '^ethernet-phy(@[a-f0-9]+)?$'
Fix this issue by replacing 'eth-phy' node to generic 'ethernet-phy'.

Fixes: f2b543a191b6 ("arm64: dts: mediatek: add device-tree for Genio 1200 EVK board")
Signed-off-by: Macpaul Lin <macpaul.lin@mediatek.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241002051620.2050-3-macpaul.lin@mediatek.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
index a06610fff8ade..33ad8c8205f1b 100644
--- a/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8395-genio-1200-evk.dts
@@ -187,7 +187,7 @@ mdio {
 		compatible = "snps,dwmac-mdio";
 		#address-cells = <1>;
 		#size-cells = <0>;
-		eth_phy0: eth-phy0@1 {
+		eth_phy0: ethernet-phy@1 {
 			compatible = "ethernet-phy-id001c.c916";
 			reg = <0x1>;
 		};
-- 
2.43.0



