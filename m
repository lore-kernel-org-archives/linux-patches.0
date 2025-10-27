Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BAA7330B3E;
	Mon, 27 Oct 2025 18:50:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591055; cv=none; b=AWQjF8MhAGWW729SeLNJu1oGiK1UaEzNfz5JfJMBtnqs2mOxiGVTuC0s6YZIn4Js8FFasuRt57g7e5wbmoRNBcvXbKCuO1lu/cLPO3PRBVwn3bP0oBnnQ1eOY4enxCzF2WezPE6TvYB2yGp4iAVxHrc3g5fqV1TicfFwD7OXzAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591055; c=relaxed/simple;
	bh=jqKO5wy40qphAaI4EBgtPcCmqwpFFGiBI7LXlMur64U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rJx8Ej3rlm4xci7X2eyAH7YmyjEMRfpRHBefGbiidPdiD6INDld56hU9Pfxn08g25/xUwJpJem6eHxr+FEhZXmBSMGjZobvfcUH3ECF6J3+DE5+CGc/wXQBGV2NtTaD5H+g7x/2BgMebJjjggFFlBkwex6FfKU2YXgW1zhpgL7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGObLa/w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGObLa/w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E6FEC4CEF1;
	Mon, 27 Oct 2025 18:50:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591055;
	bh=jqKO5wy40qphAaI4EBgtPcCmqwpFFGiBI7LXlMur64U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aGObLa/wUfQrDtaLgOrkXUUkSXfV7uhDpYVARjZYTamcqLuLhjKVssfqY5DzumpQ3
	 o+eKCyAy+eBNOFC0sOzKsZKwQIqtdr26arjWP7yQjBeoVLLvsLIW74pieVL4B/IY6I
	 bVeZ+IYzDubMQbSJRNBPd0C6TT5GQ9OM7WRyIPdU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 033/332] arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible
Date: Mon, 27 Oct 2025 19:31:26 +0100
Message-ID: <20251027183525.495361445@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit ffe6a5d1dd4d4d8af0779526cf4e40522647b25f ]

This devicetree contained only the SoC compatible but lacked the
machine specific one: add a "mediatek,mt8516-pumpkin" compatible
to the list to fix dtbs_check warnings.

Fixes: 9983822c8cf9 ("arm64: dts: mediatek: add pumpkin board dts")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://lore.kernel.org/r/20250724083914.61351-39-angelogioacchino.delregno@collabora.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts b/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts
index cce642c538128..3d3db33a64dc6 100644
--- a/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts
+++ b/arch/arm64/boot/dts/mediatek/mt8516-pumpkin.dts
@@ -11,7 +11,7 @@
 
 / {
 	model = "Pumpkin MT8516";
-	compatible = "mediatek,mt8516";
+	compatible = "mediatek,mt8516-pumpkin", "mediatek,mt8516";
 
 	memory@40000000 {
 		device_type = "memory";
-- 
2.51.0



