Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA171E50A;
	Tue, 30 Apr 2024 11:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475209; cv=none; b=q3JKWm55bJQ/+3CySUWQcIPjlmwKJHWkVBfUrKvyKpZjUdV4QNXpX2ELWQYRHlfMoOt65P7nblde9PLG9ipGpGvJ0qB4RxuW6yMya7sSNS9e3l9eJ+x/68PgYq124KvW4X38WaOYqFpiXXyiA+NbPzsglbn4CjHSR6YvyV5Z830=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475209; c=relaxed/simple;
	bh=x7P6F0DKKDQR7BDiIm+YlGFzqvf5xaYF6LeOOYk8A2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=o3uH3z4tvNTjvQbCayDSrcwT3rRlfw+ghjZ/QxqM/Uw0jgem3Kcl2DdKCsfb5SFybf0llbTuIiGpbGuUrAO4xpOR9eYROsm9aZQcpSdaGmDyv15sGBe7JfqawNRgt/Kkpqk1ey1ufjuEcq5cAwAZdjM7CD6/iPSJ56/uEbDEqlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PJ+FIYQ5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PJ+FIYQ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4764C2BBFC;
	Tue, 30 Apr 2024 11:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475209;
	bh=x7P6F0DKKDQR7BDiIm+YlGFzqvf5xaYF6LeOOYk8A2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PJ+FIYQ5UtIi6Cuq+ntUhrwFhqdVg531xB5G7DbZoZWzuet5GnttLSoMMVZv2739u
	 hwmnaZzqY79nBG9+X5MmQAxBud1sfqoCNSr3KtbHVmyWOaGlwr+51wUz5+ngXwCA00
	 3vpa2wbOT1zSlYsvBvYVFw2C94yGRf780dDKXnBY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 027/186] arm64: dts: mediatek: mt7986: drop "#reset-cells" from Ethernet controller
Date: Tue, 30 Apr 2024 12:37:59 +0200
Message-ID: <20240430103058.816307777@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafał Miłecki <rafal@milecki.pl>

[ Upstream commit 9bd88afc94c3570289a0f1c696578b3e1f4e3169 ]

Ethernet block doesn't include or act as a reset controller.
Documentation also doesn't document "#reset-cells" for it.

This fixes:
arch/arm64/boot/dts/mediatek/mt7986a-bananapi-bpi-r3.dtb: ethernet@15100000: Unevaluated properties are not allowed ('#reset-cells' was unexpected)
        from schema $id: http://devicetree.org/schemas/net/mediatek,net.yaml#

Fixes: 082ff36bd5c0 ("arm64: dts: mediatek: mt7986: introduce ethernet nodes")
Cc: Lorenzo Bianconi <lorenzo@kernel.org>
Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240213053739.14387-2-zajec5@gmail.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7986a.dtsi | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
index 850b664dfa13d..5c2fe2f43a142 100644
--- a/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7986a.dtsi
@@ -577,7 +577,6 @@
 					  <&topckgen CLK_TOP_SGM_325M_SEL>;
 			assigned-clock-parents = <&apmixedsys CLK_APMIXED_NET2PLL>,
 						 <&apmixedsys CLK_APMIXED_SGMPLL>;
-			#reset-cells = <1>;
 			#address-cells = <1>;
 			#size-cells = <0>;
 			mediatek,ethsys = <&ethsys>;
-- 
2.43.0



