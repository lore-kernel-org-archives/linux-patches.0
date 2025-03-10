Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF1B17CA12;
	Mon, 10 Mar 2025 17:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628882; cv=none; b=qx4B4AuAUWoQLlpu+oRDQ0NNQKIEe9sSs7IL+hfd5xGvLcHbmTYJwUN0J5FtsIOsJzT+Q6WgBrtEEPuNjNn0+Kj/F1ySFU5GU6fyeQhLOg1TKhzgv6k3/7yCUlAd1go9K6jlB3CHcZX5aYKR13Pzy1Q7/oxERl6Jc162k4DTx6U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628882; c=relaxed/simple;
	bh=vqDNWuVxj+42LpmnN9HK6qxVLoxIYDZdMfm3Fa8+yTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cP83nsxJ1vfLF2xf+9xxyEczNCsXNtXlmvCTSa/ofr3xm7736HILam9L24eqx9hrXDHUDXWAWTwhXQspG8iipkjcXjfHBCFQ/5DBPdS4EuRpapcU5bZ9IFhfAN/hOsupXwyjAI1lJwr62+Bxu3r9gFpPlQMP0KgU9coudB2Np3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhVn5Bpz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhVn5Bpz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2ADD5C4CEF1;
	Mon, 10 Mar 2025 17:48:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628881;
	bh=vqDNWuVxj+42LpmnN9HK6qxVLoxIYDZdMfm3Fa8+yTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhVn5Bpz4pgQ9aArCghz4kszMRl5aPttS+2cPjuwd6igdVB7bvVm4Sls+jdN9EugZ
	 +CUc7b7emtivRTEYdiWepny0/f174w3eKUjezZd75phKb9CGYh75QRLpmzoMI0KoU0
	 z5hDwPOiosC6cW7c9n/9NUD5eT2+q7TV1j7qby0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/620] arm64: dts: mediatek: mt8516: fix wdt irq type
Date: Mon, 10 Mar 2025 17:59:07 +0100
Message-ID: <20250310170549.591898384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 198a6c747a296..4d6c22e84540b 100644
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



