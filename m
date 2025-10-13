Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 258ED3081B4;
	Mon, 13 Oct 2025 15:25:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369136; cv=none; b=nEioalgRT+9stFcwD3BYxS6ziYDf2JQqkvqfBGInged9//EexnFzR9WoVRC6brXQyBdD8u6P8piGhPFZexYxXjnJn+adS/7i9/+agch2w5c/m8zmwW6ydPhaEWC7RYHdNeiEPNBZeifqL8ywPNXsoR0ew3m11jRd1pzaJsrqOU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369136; c=relaxed/simple;
	bh=I5/u7paM7pjZ+7egrkxK9v/EAQJMbbHSz22lz39vQqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh+BxH+ODbYovSJYhXGOifITT+KmJCofR0Sl7OiFsBr+sW93BkzHgtqPdgDsmEcbExf4jkSudPdPkzDolLPEx0mqbM0J0F9SD0/F73tTFdoUfsVgzLR2id97RzQraZSDXKhwXvRQJlrYyNAWiyINghbe8BKzErla768HGQDAkS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZFWaSd7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZFWaSd7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A247EC116B1;
	Mon, 13 Oct 2025 15:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369136;
	bh=I5/u7paM7pjZ+7egrkxK9v/EAQJMbbHSz22lz39vQqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZFWaSd7xnDd26qtpuS8lIHKv3oyoDWy71YSYkNS3RTmMPCponUAWbcygLvbtKpgJR
	 in9Vb95YdNiiNeFIpfY/cydyfZMfTynW9yA31ORSaT0MLQpEwONPWenzP6Pn6II97V
	 A7HztYqGkOktex5HfmQv/uofpcbRZQheTvdOEy8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 141/563] arm64: dts: mediatek: mt8188: Change efuse fallback compatible to mt8186
Date: Mon, 13 Oct 2025 16:40:02 +0200
Message-ID: <20251013144416.400776578@linuxfoundation.org>
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

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c881d1c37b2c159d908203dba5c4920bc776046f ]

The efuse block in the MT8188 contains the GPU speed bin cell, and like
the MT8186 one, has the same conversion scheme to work with the GPU OPP
binding. This was reflected in a corresponding change to the efuse DT
binding.

Change the fallback compatible of the MT8188's efuse block from the
generic one to the MT8186 one. This also makes GPU DVFS work properly.

Fixes: d39aacd1021a ("arm64: dts: mediatek: mt8188: add lvts definitions")
Fixes: 50e7592cb696 ("arm64: dts: mediatek: mt8188: Add GPU speed bin NVMEM cells")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20250610063431.2955757-3-wenst@chromium.org
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8188.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8188.dtsi b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
index 202478407727e..90c388f1890f5 100644
--- a/arch/arm64/boot/dts/mediatek/mt8188.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8188.dtsi
@@ -2183,7 +2183,7 @@ imp_iic_wrap_en: clock-controller@11ec2000 {
 		};
 
 		efuse: efuse@11f20000 {
-			compatible = "mediatek,mt8188-efuse", "mediatek,efuse";
+			compatible = "mediatek,mt8188-efuse", "mediatek,mt8186-efuse";
 			reg = <0 0x11f20000 0 0x1000>;
 			#address-cells = <1>;
 			#size-cells = <1>;
-- 
2.51.0



