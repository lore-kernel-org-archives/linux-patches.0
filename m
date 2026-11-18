Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023709;
	b=IvZWs4hyh5ECN8wpOBfuq66t/EIYoIVWsyaWc1JqTo7hTl8eMtkINnGSMc8JglQMiKuV
	 BOf3/59NVButVcGlBo45A9Bvz7iFtaWlXQ+Yn2qdgM9fU/I84jHWiuXCUz2t7jJ6B/PXg
	 nNodVk1/i0ybGIYx/KS5h+uwZVTLwoZ7t+wZ21wTdCmzxjrf5s2paVQkwPIOuBfkw/Rhm
	 HoeZ9MnPMsRP5B2aDEFMidyTR8n/Yta7Kjc04Jl21b71UW6sOeZDvImbLa1UGXxKROVfJ
	 NRTUXrPasPO3vopET3Y/5rOfKfzi2M1ce5F4Ta7z6yACXj/iXmvYW90jAw+HFjRwh1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023709;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nXb48j0MjX4UFQRWFFh7mG1i2nTeqCe+88wkavBGx4U=;
	b=oJ4CuBlhhv+yj+kQHz+wyGvBFIU758HbVH4btGVverbJnNTqzN3R+iPYo3QDTSD/8kav
	 YZG75UHgMSDh+Ac0k8eJo/WZ9zuDI+hW9LkF767QBDjFiTMQHPSlkoTTUIFgp4/0/Fdy8
	 qW11/iVsg6pGxPjkx66B72AYjYQJl8S6czWkVfwG529Y1TbSlQhaa1sjNDReeDcZn0kxL
	 GN2Vvuw+Ii+LERE/GsiYln+82ll7ZmqUTNFjM7ndEQmU5z+ih6Ii6vOGl7T5pbK7zx2V+
	 oCeuOghXZVLAyEURxlXcB7JLAoP7IbcIOOncb7hzCa6vI9xB6NvDjcniETbB510edvg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDfCpyf9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2EB2606A31C;
	Wed, 18 Nov 2026 17:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SDfCpyf9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FB851F000C5;
	Wed, 18 Nov 2026 17:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023709;
	bh=nXb48j0MjX4UFQRWFFh7mG1i2nTeqCe+88wkavBGx4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SDfCpyf9M3Srm6DbgpxEdDkYzCTzomycK5XTIhK/HLK78PssQo7gFRJsqemRmUhL4
	 ru5qjJh9TfbqGGyuxeelPpAasDoMhH4ib/8V23dZzvAsCbZVGXTfP60zzvCC3JQCXR
	 g0s3IiyIDqeOU2c087t0Ms2vUpnhhnyzW9AYlogQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0465/2151] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:36:40 +0100
Message-ID: <20261118150138.957206383@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c9b3c82c9f1f86cdb2449d47e4ca66a19159ee12 ]

The MFG_ASYNC domain, which is likely associated to the whole MFG block,
currently specifies clk26m as its domain clock. This is bogus, since the
clock is an external crystal with no controls. Also, the MFG block has
a independent CLK_TOP_AXI_MFG_IN_SEL clock, which according to the block
diagram, gates access to the hardware registers. Having this one as the
domain clock makes much more sense. This also fixes access to the MFGTOP
registers.

Change the MFG_ASYNC domain clock to CLK_TOP_AXI_MFG_IN_SEL.

Fixes: 8b6562644df9 ("arm64: dts: mediatek: Add mt8173 power domain controller")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Tested-by: Icenowy Zheng <zhengxingda@iscas.ac.cn>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8173.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8173.dtsi b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
index 122a57c3780b6..aa6b04ef4aff7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -505,7 +505,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
 				};
 				mfg_async: power-domain@MT8173_POWER_DOMAIN_MFG_ASYNC {
 					reg = <MT8173_POWER_DOMAIN_MFG_ASYNC>;
-					clocks = <&clk26m>;
+					clocks = <&topckgen CLK_TOP_AXI_MFG_IN_SEL>;
 					clock-names = "mfg";
 					#address-cells = <1>;
 					#size-cells = <0>;
-- 
2.53.0



