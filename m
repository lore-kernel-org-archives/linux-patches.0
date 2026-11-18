Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055224;
	b=KCWLLO6R+9KUMkvdjrHTNUVdcRqYvAqJ1SBGllB29ywMTRueOcqd6hK9ZAbPRAP7q+Lg
	 95GcZEqHCKEEVbUfdnTlpDcTN+9dBsU+Jw2HJNFNEU07G/7uWQqObfBzq9NkPqGRgxoNG
	 RWMPmKVB/fZ6h/srlqiZ0ZGha1ROTfKVP2mluikLApQHPVUTHiMn1OSYEFOuRxUZJAjkK
	 fhJmsFyfpXTt1FWUa4xMJvZnNB/HuYWHLQd2ttU/3mBIcBX0jKVE0CpeYnNS5gbI1lYXf
	 UGOqq0krcZCY65OGu3qErqiy5dJ8Z2O6CGhXB1Boq/6W7Kg7+5MDhMCwHwhANrcc6ng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nvTgJBNqTO6nE7fyvkY0mJy7AAhMbn+Gmo9M5OHduJs=;
	b=l0jYv1bNHF2a9yStXgoNFCOJybYc8JMa9A5UOwISp5x82l73OwoY+2LCwJz5rnKabbs8
	 Iatv2C8FiIBsueakhcnbfTGUMFTGzNE8TyyYnxj/1U3YxCnfxMpaPhPTGazaVo05C22JI
	 c11n2XUxkpaeV1ZmPqAuA3yuN75+s3CJnhAI9wd0TD+e2GyZ9zh0yLrt0MxU8z83uJhLt
	 bdEWBoe/m+VjXn/72JtjtoUltAH2++2miY2tFV9DK5dv0mygW4yR2/Qrje8O2dO/BFOrz
	 /U3sa03WsY1/keVUKPELD9dfgfTSPO+Z6h9qNRiDGkox4Lg8Gk+azNNJ6VYXz20+Vtg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJUHdirz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57031606A320;
	Thu, 19 Nov 2026 02:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XJUHdirz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88C91F000C4;
	Thu, 19 Nov 2026 02:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055224;
	bh=nvTgJBNqTO6nE7fyvkY0mJy7AAhMbn+Gmo9M5OHduJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XJUHdirziH4TbGlwfYarosDsUNOdSQyMxHXm0G2TJz1a4kOPFHk/pH8oCSWnAvP+4
	 n04MlWKY38Q6DnNEP6ie6hNsGu9joUKpXFZ9Ql8gnIfRqTTAEbb3f8Q38DpfxuBXhD
	 Gm2cJZNkrxuv49S+gP45ly5BcmiD31K6yy7Wr83U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1514/2214] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:53:10 +0100
Message-ID: <20261118150112.589577308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 9d05f908ddef5..75a7e40698bbf 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -506,7 +506,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
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



