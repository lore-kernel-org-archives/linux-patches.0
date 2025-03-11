Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8566C25E804;
	Tue, 11 Mar 2025 15:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706485; cv=none; b=ZOHXCPot4VMXqvZ5L7Jxww1SWAUCqw9FHQwjk6+KBel0QmWJ/V2SkrdtczLXiAieI2qUZo0jZhsftSXx1YMTBwVxaC56pi5Gj3W5LOXyIWsY7uvPRR2ijW508so3gHd9O8stfOP5pHIIB1XXj4/mGX1OLrorG62bEkwhT+1s7+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706485; c=relaxed/simple;
	bh=4AVoYSkoFKgzrLLCkIbBZDqqUK9mhwaZh+8AatT6GzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bcIMrlS9ijarPafQjSO4cRL5THYXh8nAfa0++LmnM6OgC+3ctlSd6HeOB09M0sZssrNDShwBzABr9weVPnMOtki+0fp8BIrLx1GA/KAc2S21/QHeYVXVdYd/Z2udEmS6HWESzsVEHYYFqDB95OCjN+rAn8nQuJFH3ev85gZbKaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsZIC59Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsZIC59Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10294C4CEE9;
	Tue, 11 Mar 2025 15:21:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706485;
	bh=4AVoYSkoFKgzrLLCkIbBZDqqUK9mhwaZh+8AatT6GzM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dsZIC59ZNL+xFZkGsVnU/iSbfNbSBtOrkcVZta461gmf5upZJQk/xUGWfey8WW4a4
	 Ij4ovliWrgLiqP9+H2jdPKg+N/WzXlqvqZrkYFA04SIJxfuz47Q1YkV3p2KFZRAmEG
	 JPLueJQHVBD5NtYNQ/VfxzVvQ3T+Bl9h+YW0kcx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/462] arm64: dts: mediatek: mt8516: fix wdt irq type
Date: Tue, 11 Mar 2025 15:55:30 +0100
Message-ID: <20250311145800.881032517@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 03a80442030e7147391738fb6cbe5fa0b3b91bb1 ]

The GICv2 does not support EDGE_FALLING interrupts, so the watchdog
would refuse to attach due to a failing check coming from the GIC driver.

Fixes: 5236347bde42 ("arm64: dts: mediatek: add dtsi for MT8516")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241204190524.21862-3-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516.dtsi b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
index 6d2804065ca89..247e89ee2f88e 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8516.dtsi
@@ -206,7 +206,7 @@
 			compatible = "mediatek,mt8516-wdt",
 				     "mediatek,mt6589-wdt";
 			reg = <0 0x10007000 0 0x1000>;
-			interrupts = <GIC_SPI 198 IRQ_TYPE_EDGE_FALLING>;
+			interrupts = <GIC_SPI 198 IRQ_TYPE_LEVEL_LOW>;
 			#reset-cells = <1>;
 		};
 
-- 
2.39.5



