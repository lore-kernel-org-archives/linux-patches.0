Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062971;
	b=AjACCGSzo4YnYIO9UnqF255RmmJmpx+IwnTTQkCFUcafZQmBwT6lPe2zXNJ7MFvj4hLA
	 D/ZQ7tBuGYJ0NYtFQ9hhFqGnK2Df8oEwlZVQL4meOjaxiSBc6I7qyZhZhv9BPe7fC3ojH
	 lzzW61qurWXXOCCVaYIErcZEb56LTyZTc2WT2sTnEoU4q8e3M2Tp2NTgdTkmdIVQvDj8T
	 VWRd4N7/bnysQwbc43BPc5Xh/ePKPGOlt6OYtrDcLK8rfEVX/jDENsMtmPIWiDE5qcIRN
	 ICRocRb+uV2gD7tngUQj+2YlIqbKhRC2fkLLTfP4tvN0GolHpl4SgIbqr/LXsLCIT0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062971;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybn/SfJOsoXaeBnExD3jrT4o95Q8juUPfUOu4lVLncY=;
	b=2H86Xv48fosXu0lPHWhu+bsT2UczBmkInAstypiNFZRlL4MHSVgoLhArRCbvhLOx9k00
	 5itLx081qe0duXppmuPMgaBalOdfAo2YgIsm+tZDq3OFEfSGVnGSg7z/VCd/tfBFarmoJ
	 lZTkyk0zXYRL7d/FcS0HQec/yaN4vF+DragkrSjwBK1UJo6jwom7OL69Qupr9ZlBLHhjt
	 33eYlOqmMauI33jwSoFjHlx/WDbriCw6a+UFgfzJPLpYOlHqEGL/kmqPEoif4omnJ6l2r
	 SmSwTmSUh67HwPUdPdgNP6O47RvT1IdX7UX7dDHOlkb9CeOfb9ywtX7AuCHYSOKynew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vf86Ra0z;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7221606A32C;
	Sat,  7 Nov 2026 14:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vf86Ra0z
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901251F008A1;
	Sat,  7 Nov 2026 14:49:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062970;
	bh=ybn/SfJOsoXaeBnExD3jrT4o95Q8juUPfUOu4lVLncY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vf86Ra0z3nQrzrpfArIX5VCj3xSnehTL3YDS9CwC10QrQSz68Yr7v6rTbe0El1ZzR
	 9sY/tuqlTcSXpC7QRhMSAd6vcIJysgnfB59h359zXXO0xqFzKkxuCk2h1SJZysBwgp
	 spzZaHlipxD4TKsBfyW3yiT8eZNLto2sG4inFWTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 187/869] arm64: dts: ti: k3-am62a7-sk: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:49 -0500
Message-ID: <20261107134858.445861304@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit cfad4f39124b218c2cbbbe17e742971abc9ac8b4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruj16 Rev. C: Table 12-257. MMCSDi I/O Signals

Fixes: 38c4a08c820c ("arm64: dts: ti: Add support for AM62A7-SK")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-5-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
index a9141640c35e6..17ae6f0ceecfc 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -329,7 +329,7 @@ AM62AX_IOPAD(0x1f8, PIN_INPUT_PULLUP, 0) /* (AC2) MMC0_DAT7 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62AX_IOPAD(0x23c, PIN_INPUT, 0) /* (A21) MMC1_CMD */
-			AM62AX_IOPAD(0x234, PIN_INPUT, 0) /* (B22) MMC1_CLK */
+			AM62AX_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22) MMC1_CLK */
 			AM62AX_IOPAD(0x230, PIN_INPUT, 0) /* (A22) MMC1_DAT0 */
 			AM62AX_IOPAD(0x22c, PIN_INPUT, 0) /* (B21) MMC1_DAT1 */
 			AM62AX_IOPAD(0x228, PIN_INPUT, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



