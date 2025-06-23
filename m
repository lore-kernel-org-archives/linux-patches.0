Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1926822422F;
	Mon, 23 Jun 2025 21:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713473; cv=none; b=M/bHUHHCkjXLGnTw9rYHHNDIDRh2YouB74sb+I8eRwLrOUHvMFNjibMvw5tjM03RtqbT4ByC0oeivZl7mCYQcIRCT4WyCCN5tMmYN+cn2h9xCTo45pv29uU6ToDaezWN5ZX1hVAoH6l8Af6/MynFRSJEeP4VJrr/L0lxVJskvFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713473; c=relaxed/simple;
	bh=ULTUyBxtIMGypYywmkDgoHDVR6/jo4aGoGoogssOrVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cQ4Tt+POjWJG4i9ct1ZHHKKW37e/E1sESSkDJTX522EEKzw+0emGExNEuRsPzeDQAXNqjyZc9xG7RY9MqoFwG5RXpTuu2KFAaqNLfzcKtWiQzbNKYKedR2vEwRCJC5QQjOv+8vRVwwO5j+SKD7VBULRyQlzwhglVAHLeUsODpQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A25HmfGN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A25HmfGN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56F1C4CEEA;
	Mon, 23 Jun 2025 21:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713473;
	bh=ULTUyBxtIMGypYywmkDgoHDVR6/jo4aGoGoogssOrVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A25HmfGNBFoKEYPYmfbdyO338QNhmEybFJ7ZRjEQY/l2vmjvo8h0XqXLg5IY4e7FK
	 799IcFiJqPcIDHqUtkHeWtT9QIzS2XsPNpjzlEbsEVAUsHA8Ou92hhkINIFv3waN+w
	 1JVePMhefXjOBFMR/7V6LBiwnoXIz3lKHLVYDY28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julien Massot <julien.massot@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/508] arm64: dts: mt6359: Rename RTC node to match binding expectations
Date: Mon, 23 Jun 2025 15:02:50 +0200
Message-ID: <20250623130648.370250581@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

From: Julien Massot <julien.massot@collabora.com>

[ Upstream commit cfe035d8662cfbd6edff9bd89c4b516bbb34c350 ]

Rename the node 'mt6359rtc' to 'rtc', as required by the binding.

Fix the following dtb-check error:

mediatek/mt8395-radxa-nio-12l.dtb: pmic: 'mt6359rtc' do not match
any of the regexes: 'pinctrl-[0-9]+'

Fixes: 3b7d143be4b7 ("arm64: dts: mt6359: add PMIC MT6359 related nodes")
Signed-off-by: Julien Massot <julien.massot@collabora.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250514-mt8395-dtb-errors-v2-3-d67b9077c59a@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt6359.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt6359.dtsi b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
index ef6ab90b99f93..29e784bebb69e 100644
--- a/arch/arm64/boot/dts/mediatek/mt6359.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt6359.dtsi
@@ -293,7 +293,7 @@
 			};
 		};
 
-		mt6359rtc: mt6359rtc {
+		mt6359rtc: rtc {
 			compatible = "mediatek,mt6358-rtc";
 		};
 	};
-- 
2.39.5



