Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E3B1E0B77;
	Wed, 19 Feb 2025 09:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956309; cv=none; b=Baw/zpPO16Gf22VIM5Ko1pQv+7Umh9BLkPcF6j9OJxO5RTlWSnA9Q3Nqj4AjjaVTuaDtP8Sw7Xn3UpcvSMerJEDyB0fwxcDX/Kwi389DCAoDLM9gNICFzOO0Xew+JjXDTS/mhM0hTr1rLnRHxQH+LxT4w1HME91jYvCzupauKuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956309; c=relaxed/simple;
	bh=ql/jVg7dCnuBk0hhbBl8vV1v2H6D0dUYabZtCvz1okI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VfE26J117/TqouC9qTPwctDRU2KO257JQFt2/Un27V33kMSu0FMxv3Jbb1JC1oRuNQhUUh4IVL8AgQkNpogHgBWZPSeRcci3GupnPQz/P4QjqOLqgiqSF1/8qeG+b9oRGCZvyzAAaMxBHTTCsc2gbIV+19W52jWqbRIYz8VCke8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n5iOKbIF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n5iOKbIF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F9FC4CED1;
	Wed, 19 Feb 2025 09:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956309;
	bh=ql/jVg7dCnuBk0hhbBl8vV1v2H6D0dUYabZtCvz1okI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n5iOKbIFHvXh7HRYrbRduws19V2OQ7v3Lkd1DRvwtqYFbN4Kk3HwNgFcFRB6RZBqj
	 aD9wgbFhsOWGOCwZzBbbqgF9GypUgaUl227f7EsCuQUD+F44pjVM51Z2aPfuyTSQ9E
	 odavFZIHDFQzpnB2tAeo1avrYapFXgcG0rcZxhrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 136/578] arm64: dts: mediatek: mt8516: fix wdt irq type
Date: Wed, 19 Feb 2025 09:22:20 +0100
Message-ID: <20250219082658.339041128@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 81ac7f2f710b4..558f7e744113d 100644
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



