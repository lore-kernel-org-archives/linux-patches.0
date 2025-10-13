Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356F330CD9D;
	Mon, 13 Oct 2025 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369165; cv=none; b=Pkxyh/r4Inr3mC5OdMKta89hlJYrWEqS7rCF6smMtxICWHQUWmAdmZrtftyGBPeZXyudS9hVEr45+UKGCr2aTMPlCQummlqgtGWWmy7eH4h6rxa0PF2R/SdlU/XEAn80oPTmjmE8ZumC805o5XHY3Ghz1cjDWLycaZvBfzsV6fs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369165; c=relaxed/simple;
	bh=rJin859nnPn+jR+NZqjOXKNiV/oQLG3VZpxP6PR6N3s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YQ6sCCyHgt7jenvWy0YDLaNXXkDtFITJw2ZytS6mPeO9kvlH5wwep2aiyWXw0Wcs8t9LBdY4LcoN24QdtLvEy4iU3D6wi85pYfTOZLPiH0vzc0sS7q+u5BgXxTX0N0QKskWAPJrnufLWyFxfjbsej/nOp6qH/wX1PWFXCSZ7/vw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PknxODS9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PknxODS9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71C9EC4CEE7;
	Mon, 13 Oct 2025 15:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369164;
	bh=rJin859nnPn+jR+NZqjOXKNiV/oQLG3VZpxP6PR6N3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PknxODS9Wy9dpinJNncUDHrH41xoV1cI1yYeCFlii/hZZ5GMbBiqCJgSUgQE+HYWt
	 xtH1HhAZHnXAf/AoQgoIKJF6E+aKpd/OeRGVL/FnPiSIzyM+fE26kh/IkCgQRykxRH
	 0V24yptnVFrqCjSuO3NShrTzTXd23XXcxaaHJ8oA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 150/563] arm64: dts: mediatek: mt8516-pumpkin: Fix machine compatible
Date: Mon, 13 Oct 2025 16:40:11 +0200
Message-ID: <20251013144416.724689925@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



