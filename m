Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F732701BB;
	Mon, 13 Oct 2025 14:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367052; cv=none; b=V3T7JKp4JejHcjrl+VQh1+w+dMVEjpVgsU58IQLXJMuAh2DLGOcs8j8HG9q32Fn9sGTcW9KH2KNKK54Zrxv8JljgevDB2xxafrbgINyT2/f0R0EJVt8c3PNg55tWnB0olq9SP3CLisktMqbEDZ/gojTYNPvTfWsF39lVLCezpKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367052; c=relaxed/simple;
	bh=VN2JkLohh+8h937wy8zKJ+1DjVMsRkQCVVeJDHwfrKM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SBpNd/H2SB2jzmap5oJhcNlN0hz+9QBq3AVVus22eBiPJkai7f3SMS5lW3MxCcx/DdCg9hetDINEpalR68OIh1LGoZ0afFjFEDi02wnLU2lh/YbEJD00UdlG8NuCQeYr02xxLWhf1//lXwTkIn9YGHoj1ZMoC1szwnTZBKEpgVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWQAmg9s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWQAmg9s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F251CC4CEE7;
	Mon, 13 Oct 2025 14:50:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367052;
	bh=VN2JkLohh+8h937wy8zKJ+1DjVMsRkQCVVeJDHwfrKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWQAmg9sNYHQOVNSVgd/Tc+ymvv+Rbu5D4u50XHB/LRMVyT0aV2f1xRh3E1DSDEkr
	 XNdhT2Qc8vf2l8xWrHkyYmlcEgc5uTdORkbIgyvzG56Ku6nVzDg+z3RmQRgbZMelMW
	 +ogXNlt9X0GPVvOrWvjj+ufZmNImpTkbykEraJuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 075/196] arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible
Date: Mon, 13 Oct 2025 16:44:08 +0200
Message-ID: <20251013144317.290693392@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



