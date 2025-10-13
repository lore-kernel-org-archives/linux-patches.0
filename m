Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8412FE564;
	Mon, 13 Oct 2025 15:09:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368162; cv=none; b=Gt+M29XZQD5pAhqPGRuxj9YuZ1j+pkY6LNexsKOQNhESX82mMnjdVKAxAI0TGUHl4t+q8Wlr5Dyi6zKjtMuMiMPgcMuK4xcrRbz9Cjvwbo50voORJ1v1LedHftkKMxGcM350X398PTTJrh4gJCBrKELotsLgU9qaSNliaFvNB2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368162; c=relaxed/simple;
	bh=1su5Nfhgaxt+EEE0HHj2sn2J8H2bTvnXGA2Ht/tK9j4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qCQltS2Cny6lF06ZinDx18fCjKc6qBNiCWEzO9dKdjUrTaNwy/GjBM5gJGe33J1PHYPAeRMwB5JV3SpTM8AeFyrd77wefIW5Wyj430YbGWrcHNKYhlJs3BpJFeg8CFoq35oRcFHFMDjjHzCZS49h23EZk0KDn/WdCdiENYjjZhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKYylAZr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKYylAZr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D60D7C4CEE7;
	Mon, 13 Oct 2025 15:09:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368162;
	bh=1su5Nfhgaxt+EEE0HHj2sn2J8H2bTvnXGA2Ht/tK9j4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKYylAZry7EMs0eHT9Gf8PcdS9tq+RLUUW1m7lTPYleezoMYTjr+JaZO1wgJztOZP
	 xC8Q94SwJAskJDE6gygrYQNWpDeAIA/PSNZoIxj7gZ/G40PBahEh88JVBTLVtMlTOu
	 4GaZ9XlERYlaiyQlh+8NhtzMJLOUjqbtPMB20Edc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 064/262] arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible
Date: Mon, 13 Oct 2025 16:43:26 +0200
Message-ID: <20251013144328.433392319@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



