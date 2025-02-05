Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83681E89C;
	Wed,  5 Feb 2025 14:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767518; cv=none; b=YF4V9nsNQqK8FqgQ2OGchTehXzp9V5Zn+ESiTub6lNFvlPjoqli0PqVxynDHQgwWtSU9fg/iyp/gQi7OM1xvn+5j26R0bcL275BJn5zOJTnJtcrg0La0AT2kfc/BqxFEuJibcE2Z1LO8TXNW40g+wu41Oo69n4bgM+R9T19Fabc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767518; c=relaxed/simple;
	bh=5ryCB8tSQcEjFfKRKsWpuM5eT/5qozylZc2/uCXcUgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnNZkF070Xhp/nm/HFewcVOi+P7lM9yAtdzndtB/U9agTnC9XwQ8+IWHHnT28Vv/HDy2umZwUoEnLlfdp0w2QduebOuiXIMuUQFF9jADTm2CZo474fToJb2UbawN2zef996JQB4O+ryWPsnkm6PTk+Tk5htut+a8W5XbshOXIw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V1QVittg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V1QVittg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2574C4CED1;
	Wed,  5 Feb 2025 14:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767518;
	bh=5ryCB8tSQcEjFfKRKsWpuM5eT/5qozylZc2/uCXcUgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V1QVittgInoGtaFXJ/qNhHkeDLLASsCHLdL38zZHly5jF0JUNkVPuUM9TUahA8Oeo
	 Woq9XHjZ9HFsS8m8JRSHnF5k+26u1eWH6zYpWT5pj7dPkQPH3rSFVFaOCIoZNCtVwE
	 7RrFovwRELDkjt3DLdkDO5tImXntUGkR9jcntNoo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Mattijs Korpershoek <mkorpershoek@baylibre.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 415/623] arm64: dts: mediatek: add per-SoC compatibles for keypad nodes
Date: Wed,  5 Feb 2025 14:42:37 +0100
Message-ID: <20250205134512.100741077@linuxfoundation.org>
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
index 1afeeb1155f57..9af6349dbfcf1 100644
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



