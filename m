Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7410E146A7A;
	Wed,  5 Feb 2025 14:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767498; cv=none; b=KgWHi6eqsJxee29bQIWfILN9VdgPJvpENcYA4Z7NAV1MpVlOGYqe6xxcbFC8oew1PGadJGNgBDbUV7yjqYpECRC0UMRanLbEVh1COfPXVFG/zGUj0YnvT+eEzjGQlc5l0cr+RNtkcNiJUWhPyZ+YEjLAWmTElt8BemuTiR/lpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767498; c=relaxed/simple;
	bh=BUkshUIobu1gOwlMGUyFPOe1do8H7FZv3EvhPU170xY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l0QTFolE+R0KKR9vdgHCKANh1nRf1fRofuoeylSr1zvGVvy6vL+vNwRNm/qPP5sNHPRmvQ8VxrsYnUfhJssBTHuKn2j2q8mUZQpiXzg5YnKrLnZeI+aHP7LceMk3UXUqmU68x21Nb4wYvYvUpM2323PO4mZsm7YIXx2iU8BmcOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uzUzN5Hw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uzUzN5Hw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA36C4CED1;
	Wed,  5 Feb 2025 14:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767497;
	bh=BUkshUIobu1gOwlMGUyFPOe1do8H7FZv3EvhPU170xY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uzUzN5Hw7GOn9v/IS+koCKHV7Sd9tk76F3nAYi5VHdE4gFbF0KpM381vG7q6Mt2Sj
	 ZJr+0vVxSdVqo4EbBhdA6NRuXxul1Zecu3reH6qS0GH5wmK9qElFGlbpXgNkaCcklW
	 uPsL9ia1SW+0qymLiTbXy2yX/raFuIqmnxpCpvbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Wunderlich <frank-w@public-files.de>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 412/623] arm64: dts: mediatek: mt7988: Add missing clock-div property for i2c
Date: Wed,  5 Feb 2025 14:42:34 +0100
Message-ID: <20250205134511.985871859@linuxfoundation.org>
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

From: Frank Wunderlich <frank-w@public-files.de>

[ Upstream commit e14b49db0087aa5d72f736d7306220ff2e3777f5 ]

I2C binding requires clock-div property.

Signed-off-by: Frank Wunderlich <frank-w@public-files.de>
Fixes: 660c230bf302 ("arm64: dts: mediatek: mt7988: add I2C controllers")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20241217091238.16032-6-linux@fw-web.de
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt7988a.dtsi | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/arm64/boot/dts/mediatek/mt7988a.dtsi b/arch/arm64/boot/dts/mediatek/mt7988a.dtsi
index c9649b8152768..73561c7a3ad26 100644
--- a/arch/arm64/boot/dts/mediatek/mt7988a.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt7988a.dtsi
@@ -162,6 +162,7 @@
 			reg = <0 0x11003000 0 0x1000>,
 			      <0 0x10217080 0 0x80>;
 			interrupts = <GIC_SPI 136 IRQ_TYPE_LEVEL_HIGH>;
+			clock-div = <1>;
 			clocks = <&infracfg CLK_INFRA_I2C_BCK>,
 				 <&infracfg CLK_INFRA_66M_AP_DMA_BCK>;
 			clock-names = "main", "dma";
@@ -175,6 +176,7 @@
 			reg = <0 0x11004000 0 0x1000>,
 			      <0 0x10217100 0 0x80>;
 			interrupts = <GIC_SPI 144 IRQ_TYPE_LEVEL_HIGH>;
+			clock-div = <1>;
 			clocks = <&infracfg CLK_INFRA_I2C_BCK>,
 				 <&infracfg CLK_INFRA_66M_AP_DMA_BCK>;
 			clock-names = "main", "dma";
@@ -188,6 +190,7 @@
 			reg = <0 0x11005000 0 0x1000>,
 			      <0 0x10217180 0 0x80>;
 			interrupts = <GIC_SPI 145 IRQ_TYPE_LEVEL_HIGH>;
+			clock-div = <1>;
 			clocks = <&infracfg CLK_INFRA_I2C_BCK>,
 				 <&infracfg CLK_INFRA_66M_AP_DMA_BCK>;
 			clock-names = "main", "dma";
-- 
2.39.5



