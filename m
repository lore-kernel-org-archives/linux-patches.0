Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062041;
	b=ePml1ivsof+uX+KR71nlF3qvXaQ1yfjIPZ20CNFfgZBCzKv33Nq5kk4Na1iu5vjMqOKG
	 6Dhp4+CMI7LEs0zpCj+1Hpbr204uPGFLMcrmwQe/eLp1UA5HC9n4T+IdvSISPS+Fr3y6H
	 Ou/g/fD/jXgsj6kmQu/sKCaVO+Qupmdmt0sYEYDCu16SClHDwFwIOg8MZEdJe0BO5i8XM
	 W0ydsnfBCj/qZdMhvHZM4Xz/l7i5SC7CA2SpWZ/g/NnytLuBL7S4LtPbaol/XWOqas4mF
	 w9FG3vOTIcZuqnyhTbC2OLHJMsaV/usv0MkX0EX0rGw5IqaIvvoi3yi5XJJQ5Li3APg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xZSYlTL4kxCfkkbheV/KxeBOqLZRVMtAC3l+DpuVteM=;
	b=UfenAldJeEOK7zamj0LlhOAaGp8u/gL1/V2FyV3ctzcOwQRm+7Z5jDoNf/8X+YGdcuaD
	 rRkyPgnp7JME7oDohVlaZLAIR8tL1kpwN9uGI6ujfv+4cw2NEh2+RjBPdBI4faKl4PbC7
	 dVpN4bVCCYTmxiMIlDc2NWXTM6UPOhzsgffmhNELe9613NiuuG1Gj0Vk51knSYrlsOII2
	 kXY5zS/apSdiZUAe8kN1W44Rp+x1kjL7I/0feoc2lJrV/tO3fqkD5WwieTMdnPUDHoUsH
	 62j/9/iEXYGPzQ2wZ1xt8LehCczK5SDpzz90wJuMvErTHlQm+roDJlF47AQzNWWztWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzDg2ZTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D03606A332;
	Sat,  7 Nov 2026 14:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BzDg2ZTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16841F0089F;
	Sat,  7 Nov 2026 14:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062041;
	bh=xZSYlTL4kxCfkkbheV/KxeBOqLZRVMtAC3l+DpuVteM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BzDg2ZTQElDEgc6pkvfmnJHomTInHwilvt6sEgu0okeiSvHFx7ag1sgR616odTDl2
	 JzpuSfvjR4a94/RHnRJ/szufUzTnLNOEEmMPBUj1RP2az28MFpeTS6yh830CUD6TJn
	 cP2sS8FDh1u/Cv1KiPa1Vf2UgrvGiesE4ZTv1fk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1023/1536] arm64: dts: ti: k3-am62a-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:50:39 -0500
Message-ID: <20261107135026.413483523@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

[ Upstream commit 4834050197f205a649e36661ca150e6ac8295008 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: d69383885576 ("arm64: dts: ti: Add basic support for phyBOARD-Lyra-AM62Ax")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-6-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
index 960a409d6fea7..2a78089d79b55 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
@@ -111,7 +111,7 @@ AM62AX_IOPAD(0x15c, PIN_INPUT, 0) /* (V13) MDIO0_MDIO */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x220, PIN_INPUT_PULLUP, 0) /* (Y6) MMC0_CMD */
-			AM62AX_IOPAD(0x218, PIN_INPUT_PULLDOWN, 0) /* (AB7) MMC0_CLK */
+			AM62AX_IOPAD(0x218, PIN_OUTPUT_PULLDOWN, 0) /* (AB7) MMC0_CLK */
 			AM62AX_IOPAD(0x214, PIN_INPUT_PULLUP, 0) /* (AA6) MMC0_DAT0 */
 			AM62AX_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AB6) MMC0_DAT1 */
 			AM62AX_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (Y7) MMC0_DAT2 */
-- 
2.53.0



