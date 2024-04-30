Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3812312C550;
	Tue, 30 Apr 2024 10:46:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473984; cv=none; b=eSTHK2GS++lP7h0KFjevx3+u/dZlKGoA8TQ9CrvriL9re2vPee5WDZcCbjjz8rTFkUZXyh9syMqjqXo7I0s219zZHNcs6WvAcRqXJaDVcekkFSTMC+UJBc1iFBEyV9W2KSHf4JCqrzcPr8JP10omF8XWxg7XwoM3aTZ8U/FxQF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473984; c=relaxed/simple;
	bh=KHOSa0unNt5G4olUPW92JSqPM03aW30jZopSn9CvkMU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e5TR1yttJzkUZYUXERM6Acgoqjqk24gCY1sNMx48//4h72wSb813MvsMs+CbF/K908F57s9um3LeF6P6iHMnAqE72W/IHcNyOoSHz/fzIXBYNtdajwCtYH55qOsn6iU4PHyCNPmT/yGIz2FZpAxPuRFoAa/hAfH5W/4xHCI26hM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yuIlTVDf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yuIlTVDf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3FBAC2BBFC;
	Tue, 30 Apr 2024 10:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473984;
	bh=KHOSa0unNt5G4olUPW92JSqPM03aW30jZopSn9CvkMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yuIlTVDfKxFSDDYxwNhNtdxF4tN4j3xJ1GEZh9sg25bhNyBzxKC06T1N8o2Dsov/v
	 u9JAcIvRpzCyxmVGfSgKBMea4VTo5IfvQIdUqwZdHaCevO56XjALRgFKfF8ouqGn/n
	 OVB3ql+up9XBHauHG3xGTgjE93vwcMCrrcmVOCzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sam Shih <sam.shih@mediatek.com>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 026/228] arm64: dts: mediatek: mt7986: drop invalid properties from ethsys
Date: Tue, 30 Apr 2024 12:36:44 +0200
Message-ID: <20240430103104.568859711@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 3b449bfd2ff6c5d3ceecfcb18528ff8e1b4ac2fd ]

Mediatek ethsys controller / syscon binding doesn't allow any subnodes
so "#address-cells" and "#size-cells" are redundant (actually:
disallowed).

This fixes:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: syscon@15000000: '#address-cells', '#size-cells' do not match any of the regexes: 'pinctrl-[0-9]+'
        from schema $id: http://devicetree.org/schemas/clock/mediatek,ethsys.yaml#

Fixes: 1f9986b258c2 ("arm64: dts: mediatek: add clock support for mt7986a")
Cc: Sam Shih <sam.shih@mediatek.com>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240213053739.14387-1-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index eba5e27a1bbea..850b664dfa13d 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -501,8 +501,6 @@
 			 compatible = "mediatek,mt7986-ethsys",
 				      "syscon";
 			 reg = <0 0x15000000 0 0x1000>;
-			 #address-cells = <1>;
-			 #size-cells = <1>;
 			 #clock-cells = <1>;
 			 #reset-cells = <1>;
 		};
-- 
2.43.0



