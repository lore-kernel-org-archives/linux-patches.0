Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E75AE146A7A;
	Wed,  5 Feb 2025 14:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766977; cv=none; b=kvCqEkRD/Cm5U4MzGwvQV4zBsLdHewEhF4/Q+s7aAQnWkQNln+mzEyjorm1UvUVHKoSySF+remMIw7rZdJDu/dn59JyOKtdGiUFvisjLuMSQARAzafHGkmiKb2B/brXF4ruCA8/PI1kbJAvnR9BGnKPscOrVyBHMUWf9OPi0Wjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766977; c=relaxed/simple;
	bh=xZd0UNBlJxeiNevmw5XGiEsjBugxZkU1N80KTALVXug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nGKE8fKzmPD/ooqgoVkb0w/fUnD7E+RlGu05vbtOU511TG+1+VjdxCbUt52XEYRnIlp7QnjsiRVy/Z8Z9ox/r5dXEcsBGJaBPxCvyWMi5VkkR/uw8Yi9a54tR5E7NMrDRLsqJJtA0FUnJ8HI0mwQKH0+aahAhC0Wu+v98+JZ2fA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u+zLyytg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u+zLyytg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5223BC4CED1;
	Wed,  5 Feb 2025 14:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766976;
	bh=xZd0UNBlJxeiNevmw5XGiEsjBugxZkU1N80KTALVXug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+zLyytgoKmBrHtSb7LDByA4yx++1FJKtWjoTrKn7+9OrVykWjKMgY5PaFAKbtc2m
	 RZdPB4D+OoXD+LWib9C22Y4PuCkqi6/9xIgBGorI5+8XhKPV7caGFVqk+WVziQ85FX
	 94SrK8L3J6PZLc4ckIof2brHKmqidOa/cJR7+Wes=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 336/623] arm64: dts: mediatek: mt8516: fix wdt irq type
Date: Wed,  5 Feb 2025 14:41:18 +0100
Message-ID: <20250205134509.080958908@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index 4444293413023..098c32ebf6788 100644
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



