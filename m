Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039926;
	b=BK/jx9hm70yYQCIpQc6lDukKnPMK62ipUeCtYWvTiV9OB0C2KBcDT+l1BNVPoEuByNat
	 wKa/cxoanbg8SugXNYeH2N4CtnEqp/DvmAwnM/JT+2Pm1D6HQhSdDDgpGtgfH6RJNYuEj
	 xh50pGIo7Zahk4Sh/scHYlUmM0KKic8qpEUmeSNwLk5ieS9tADuQRc3mq67kIwV7BfIRS
	 5AzOZXh8oa8PAf5h2bo2SWAhCUf3Ci3KRPUMKGihkhFCo/efwgIVau+vAldU3V/79et8I
	 Y9kDZ322cQcrugwrIm/yYNLsjPpabD33IBHE20YileDqbd9aIxBZ8d2dx4fbNCtFysQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039926;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rqBWWrlbSpyWL0nVn/z3SMBjt4V1ixx/0qyr2EL6cNc=;
	b=luVxnPVZatq9+H+amANUap1fY4TMkOAq1EQwJof2vf24mWX6uHheZyTAPb9F8j4SeiuD
	 AP+uLMjdDheJ3MwrVnY8WGC37UmI4Z77n8W2K76gEwioFy3XC72ZmTfRFcLa7GCLIqH4C
	 hPy1Ae9SUg8ssqi5dziEgNAbYN7bYuSWrCOsh24JmW3rV27yukozkLAWRWxVzvyN5KaL6
	 kKU2eI1/dwUXIv0NhUPY3Im37yIF1+aAwKLC8eJF+DkcSn96isTQG5y+Fker4ftkHgiOm
	 wdX/K+dJMde65GpDh1CL6x9IZLV0201xMvm0+CoR7pbv/yDxTXRFzWxMhZ923RwHJ2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nq0N3rgT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4FE4606A320;
	Wed, 18 Nov 2026 22:12:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nq0N3rgT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 264571F000C4;
	Wed, 18 Nov 2026 22:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039926;
	bh=rqBWWrlbSpyWL0nVn/z3SMBjt4V1ixx/0qyr2EL6cNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nq0N3rgTdnPVJUNT2EiVlDBK39aPoZKZGAlGSiA6DqmsixI+DaoWqGVEA+/lbkZ2s
	 LCXvR4IHfsVsgMf1O8dUiV3FVOmDHGtfHAEvdKvgBRJa0SbyWi9GzK1VBnIWue9sJn
	 Rle3l+TeQFl9X3kNKnUhL9nUOqdgDoCycp1PMl9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2233/3318] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:47:35 +0100
Message-ID: <20261118150428.859147324@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0582d75349ba7..3ae5b474d62b7 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -497,7 +497,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
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



