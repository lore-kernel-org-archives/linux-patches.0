Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048431;
	b=raSFI5H3Bh6+5lDCgSrr6Pmkn67o2bpXhnravOOjGV1G9LtBA9Yv3miXYOOPz2ZyXXWC
	 8JkStDfzChdvYD9T/6pd5hF86u0AS9hFrp3awuznrw48O/YN93OT745piWiC14dihT8z1
	 MOZIPEpvtNEXDT1hD6D6Mcf1iDpHnl+2GRLRb0b0TeH+iUOkBGiYFyKov+dVtyBKzkDFV
	 jmmOnhJcu0I/zQHYCEFI+mIU7Xf8dBQyky5CdB1OVyxpd4kzBKFXrOnFajsD8attkBdtd
	 JoAVbTeOIHE1GAfQWcgXnumWdCo7ZSgKL6YIEa6R4Qa+8YEaHzxpbT/33KNXGY6YI/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048431;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qB400jyz6dLTg9Efvcq/d/zrjxQKuaTiD03xMJ87gF0=;
	b=EqNylGHo8W03Yn/GuH2vq9OPhVsKx4ranHYqHe38517k8EuVVjbqu2Ti7BPSFUqId7bg
	 RbRiiZV82Viu3unG4tAzDWCaBEuxvr+4jZV9Fhm6tqKOAywZfLx8knY5zGUqnOeP+hbBW
	 GbG3Sy095MdU9dd/2ai/AUcLukzer0LQG/09wzXAXMp4QndzeSuZAAbs5+8hLzCHRUKU0
	 i2/NlXzwbxC461ehfed/eEeqpKI48mjsct+KRrsNmQN7dWA6yMqL7HExSCQkoqD34B+fz
	 uN5NMMFpOVKbm+0H98X+lajl1qq3FSNqMwFByWR8VrK4PC6J6eEERKAelOYnLPu2jgQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPpmJDI0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3508606A320;
	Thu, 19 Nov 2026 00:33:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cPpmJDI0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F4B91F000C4;
	Thu, 19 Nov 2026 00:33:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048431;
	bh=qB400jyz6dLTg9Efvcq/d/zrjxQKuaTiD03xMJ87gF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPpmJDI0a9vQQVahhEWHjtTz/VZZ6AmyITo+MpZ1TJ2LVi1alOY5PVoBlzw4auWD/
	 z7bxK3D/X3KZiEgEPVVStUVH3U+Rsv4mdiWrPEGmObk2SZp2wELwwbFLMBEPfxenOf
	 9opCzuW/3ZWoKmTsKWZ02K2aGoIyFV8xaFwWLDAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Icenowy Zheng <zhengxingda@iscas.ac.cn>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1951/2857] arm64: dts: mediatek: mt8173: Fix MFG_ASYNC power domain clock
Date: Wed, 18 Nov 2026 15:49:45 +0100
Message-ID: <20261118150311.658718514@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 256df3a2d8230..a426940d58639 100644
--- a/arch/arm64/boot/dts/mediatek/mt8173.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8173.dtsi
@@ -498,7 +498,7 @@ power-domain@MT8173_POWER_DOMAIN_USB {
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



