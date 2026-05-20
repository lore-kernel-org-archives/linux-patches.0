Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 785B936B04E;
	Wed, 20 May 2026 17:31:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298308; cv=none; b=mi4THsAP3WvICXkiqKS16IOBy4sof9qK7u+Cbj0XfVK8ifHOUAviuyMZShKCKa0YBDZQMr6bgIM1mMaENZTZsSL1wMcWLBh/VeMDHy8dLZQfeV4MeAg8Wjf7Z26nKbip/9s/iNfch0pMjgsMZbbhs6tWHdeVpVTXVPg6FRH0MKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298308; c=relaxed/simple;
	bh=S28UKGPbz3pnsmxgphoAEiIrsAPwp6M9fT/TQSXeF6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bOPET4nPENmSMwrPGOtGNkOS/nN9cpqomOLrcTGagWOXW7A4szuiOBp8c56gDUc94gvGPU0IZxyWUHX0wOfloOjyq7Q3U8SaGp5Tv6F+tveBl07qzRBMPuiGZFWS0DK7m4dIayqWlQ+ZK52ftN6EgZx75jumJeXf3hL10rpkuKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlJBvVMS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlJBvVMS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB041F00893;
	Wed, 20 May 2026 17:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298307;
	bh=Ouw5vbRqsWbzFNupdoFHNh4cL8Az3D5Zvg1DoCPY8bQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VlJBvVMSa1Q5EGhhgZwiT2BE9R6biCxMhDTZI5DGEGfsCi9iWlox8E83QCKEAIg/A
	 rvSVSkS5zgUUjHb/4LX8rqR9cEFo0wTROCW5ZFpduNOqX6E32b/HFNiKaMhSeQR+0Q
	 dA2K3XLhQH9NnM4j91cHRNlbnHsoFwzhT0rDwfU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 362/957] ARM: dts: mediatek: mt7623: fix efuse fallback compatible
Date: Wed, 20 May 2026 18:14:05 +0200
Message-ID: <20260520162142.380388762@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 5978ff33cc6f0988388a2830dc5cd2ea4e81f36a ]

Fix following validation error:
arch/arm/boot/dts/mediatek/mt7623a-rfb-emmc.dtb: efuse@10206000: compatible: 'oneOf' conditional failed, one must be fixed:
        ['mediatek,mt7623-efuse', 'mediatek,mt8173-efuse'] is too long
        'mediatek,mt8173-efuse' was expected
        'mediatek,efuse' was expected
        from schema $id: http://devicetree.org/schemas/nvmem/mediatek,efuse.yaml#
arch/arm/boot/dts/mediatek/mt7623a-rfb-emmc.dtb: efuse@10206000: Unevaluated properties are not allowed ('compatible' was unexpected)
        from schema $id: http://devicetree.org/schemas/nvmem/mediatek,efuse.yaml#

Fixes: 43c7a91b4b3a ("arm: dts: mt7623: add efuse nodes to the mt7623.dtsi file")
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/mediatek/mt7623.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/mediatek/mt7623.dtsi b/arch/arm/boot/dts/mediatek/mt7623.dtsi
index fd7a89cc337d6..a60b1d6879ffe 100644
--- a/arch/arm/boot/dts/mediatek/mt7623.dtsi
+++ b/arch/arm/boot/dts/mediatek/mt7623.dtsi
@@ -328,7 +328,7 @@ sysirq: interrupt-controller@10200100 {
 
 	efuse: efuse@10206000 {
 		compatible = "mediatek,mt7623-efuse",
-			     "mediatek,mt8173-efuse";
+			     "mediatek,efuse";
 		reg = <0 0x10206000 0 0x1000>;
 		#address-cells = <1>;
 		#size-cells = <1>;
-- 
2.53.0



