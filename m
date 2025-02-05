Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E35F218D656;
	Wed,  5 Feb 2025 14:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766942; cv=none; b=H6n6E2+Ma2yHJlFj6n9s6+MTFJ66sBw9ZuOp6ja+yJzUAE6l3SABa7CYM9rsqn0JXwsCmFWFKFQzlcefrPF00orIJ3H/dYbfhlQ6FeDamgyBivAnLD2ts4adHvctdUkprNYoyZnhjZXmPy50G2D5KeWqPMWq//RNm9mTd9iqIvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766942; c=relaxed/simple;
	bh=W36YvPwS1vTkGt6y1YU539yM4cOUAAtikAxKOCf0cYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k9D8lvXp6imYyOUXcfV5MmjpVO+aZ5LV/EfqVgB5fqaQUuuwcJhQrSI+oQlvF1Sboy+GwCayz4b/Uy+fdDpaBxPhQa3T5eO8KfEJnBhSpvgNGWrSXkhVmTsGu9LUhd+nUsTfRBO0Xdu/kmoIotYRQjdc/C3GYZI2bvIGK0zYyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s/EbGoyv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s/EbGoyv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1A9C4CED1;
	Wed,  5 Feb 2025 14:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766941;
	bh=W36YvPwS1vTkGt6y1YU539yM4cOUAAtikAxKOCf0cYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s/EbGoyvd3FJUTfuzLPZO37wAjlUYj1G0MVzcCD+Gu2Dzqnux/kKnkhZZwpmD2FNu
	 akEi6jd/lMeJVcDpi3JTVcY4qQbrVlxFY0UYmkRVHtDtIKcwb9KP17879TBZp7BI+f
	 mlwy3GvmsCEu73Acp6Y4NpRT0jqeLR5pOXN9Lht4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 383/590] arm64: dts: mediatek: add per-SoC compatibles for keypad nodes
Date: Wed,  5 Feb 2025 14:42:18 +0100
Message-ID: <20250205134509.920255121@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit 6139d9e9e397dc9711cf10f8f548a8f9da3b5323 ]

The mt6779-keypad binding specifies using a compatible for the
actual SoC before the generic MT6779 one.

Fixes: a8013418d35c ("arm64: dts: mediatek: mt8183: add keyboard node")
Fixes: 6ff945376556 ("arm64: dts: mediatek: Initial mt8365-evk support")
Signed-off-by: Val Packett <val@packett.cool>
Reviewed-by: Mattijs Korpershoek <mkorpershoek@baylibre.com>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241225192631.25017-3-val@packett.cool
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8183.dtsi | 3 ++-
 arch/arm64/boot/dts/mediatek/mt8365.dtsi | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8183.dtsi b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
index 0a6578aacf828..9cd5e0cef02a2 100644
--- a/arch/arm64/boot/dts/mediatek/mt8183.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8183.dtsi
@@ -1024,7 +1024,8 @@
 		};
 
 		keyboard: keyboard@10010000 {
-			compatible = "mediatek,mt6779-keypad";
+			compatible = "mediatek,mt8183-keypad",
+				     "mediatek,mt6779-keypad";
 			reg = <0 0x10010000 0 0x1000>;
 			interrupts = <GIC_SPI 186 IRQ_TYPE_EDGE_FALLING>;
 			clocks = <&clk26m>;
diff --git a/arch/arm64/boot/dts/mediatek/mt8365.dtsi b/arch/arm64/boot/dts/mediatek/mt8365.dtsi
index 9c91fe8ea0f96..2bf8c9d02b6ee 100644
--- a/arch/arm64/boot/dts/mediatek/mt8365.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8365.dtsi
@@ -449,7 +449,8 @@
 		};
 
 		keypad: keypad@10010000 {
-			compatible = "mediatek,mt6779-keypad";
+			compatible = "mediatek,mt8365-keypad",
+				     "mediatek,mt6779-keypad";
 			reg = <0 0x10010000 0 0x1000>;
 			wakeup-source;
 			interrupts = <GIC_SPI 124 IRQ_TYPE_EDGE_FALLING>;
-- 
2.39.5



