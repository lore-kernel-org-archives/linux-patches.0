Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C70F1917DF;
	Tue, 30 Jul 2024 16:15:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722356111; cv=none; b=O8bgAI0mtX4N3XhAwYAHmiB+KHexfEgAue6pPvVqY5Nn78IxaFD0XR5iSyKfqr11KqJbb73wruXAXiiB1+tA+FnInFe3wX1ewq24boxGlqzQO5Mnx0XCLufVzCpobl3DNWZSRHmnks8S49RqNc1W9Zmpr++HxD11ausMWBxQlH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722356111; c=relaxed/simple;
	bh=txyCNnTqPZmG0Cfc6XTAUtr3V78GlXmaBJ1noHDjKRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bEOMgcydG1xwZxoQkz34pLbui1F8wAl/yosDQ6yTlE86JKsLkF5OdQncYyjGMaXVT/1qCJx3HuDTFkStLSsTgDsnPtpoi5VuGtqujKxRqYE5uLN0Q4Nf2SNP5H8ym4BHv+ZTt8FgH9bCaZProtsvVncaggCP27XDsaYhr6tjRxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Yf9qSnaM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Yf9qSnaM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B62C32782;
	Tue, 30 Jul 2024 16:15:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722356111;
	bh=txyCNnTqPZmG0Cfc6XTAUtr3V78GlXmaBJ1noHDjKRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Yf9qSnaMKw18y2T4r+z8KxEvvfCyDihxLLNHhiInsoq+3TpsDQAKdGZf8uTSVj2AG
	 IwFmdfnM9vsYk3eRLwTpiHnn1uWhp8pwtpsJ/aH8qdThVwX97te9rhPzjQcdVzvhXx
	 oKeSEXsCTfjUldPIdxrcD2xv9maTDIQM+he0AYeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 099/809] arm64: dts: mediatek: mt8195: Fix GPU thermal zone name for SVS
Date: Tue, 30 Jul 2024 17:39:35 +0200
Message-ID: <20240730151728.541662328@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b2b6f2edb82a08abe8942535bc77da55a0f43e14 ]

This SoC has two GPU related thermal zones: the primary zone must be
called "gpu-thermal" for SVS to pick it up.

Fixes: 1e5b6725199f ("arm64: dts: mediatek: mt8195: Add AP domain thermal zones")
Link: https://lore.kernel.org/r/20240410083002.1357857-2-angelogioacchino.delregno@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index 5d8b68f86ce44..2ee45752583c0 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -3880,7 +3880,7 @@ vpu1_crit: trip-crit {
 			};
 		};
 
-		gpu0-thermal {
+		gpu-thermal {
 			polling-delay = <1000>;
 			polling-delay-passive = <250>;
 			thermal-sensors = <&lvts_ap MT8195_AP_GPU0>;
-- 
2.43.0



