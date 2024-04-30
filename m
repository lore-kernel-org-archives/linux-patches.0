Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441C512C550;
	Tue, 30 Apr 2024 10:46:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714473987; cv=none; b=Dt+WhEvTx5DDxv/Xgtdwu7DF83XopY7+RhuYvqSvvCQZY7VZakn6Jh3zKvHGqhNFpKIkzko2BtNOx7lpUBzSjooaIzKzYYnw55aXMxT+SUWMflyNFirRJ3U2yGENExozOFDmHiKUAaBfQ+Lzp/2Qb6KONme9wQuM3OE5NIgTS3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714473987; c=relaxed/simple;
	bh=jJtcFrFS/uMthklN2hyrDdzMaxMRTAOHlYpZmBE9MoE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aRz+ixYpR5dV6uLflYN0331aklD5lJs2rcJA/DIUHoNbmPHvozQViXjD//zRn7Yzxi89Huq3zrm9GfzHKYTcbIb2QMIy5/MGsc4+43p1LeYFlSlTsm/Rih10gICuSvD0fOo6ZykCjpmWmJGPn7/MpGh932GlV0I56IdUQSlp2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fGlMw5dd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fGlMw5dd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8A23C2BBFC;
	Tue, 30 Apr 2024 10:46:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714473987;
	bh=jJtcFrFS/uMthklN2hyrDdzMaxMRTAOHlYpZmBE9MoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fGlMw5ddDbYkOXJRn+WSvhCgVvkC84U94XhnLIdzEJb34hKiccRTZzh+gCT5C4cjz
	 4V6osHZX3E4mcBTLO1vczuEq5Uz++upkZpZTX/0xSRJmRY+UQA8qzKuWOXypQhfw3O
	 75VmfcJAEfM/+XMfdFp9imKM+UMWhu6b2F2x+s24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	=?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <rafal@milecki.pl>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 027/228] arm64: dts: mediatek: mt7986: drop "#reset-cells" from Ethernet controller
Date: Tue, 30 Apr 2024 12:36:45 +0200
Message-ID: <20240430103104.598124779@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



