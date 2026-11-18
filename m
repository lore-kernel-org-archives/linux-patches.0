Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036009;
	b=bertScSC5C3E5KXTfdKgz4hG55mlEAIxEKTMdfrOQEqYzfB17KntMtmmBVMvPS7lul65
	 2TwJt9VO2tnxgRWKbO6mytPT9A1jZVi5/MOWNqasc8y1+zbStvfOYLxa/hFlhFagKGc2+
	 vP8GWHecaEmpgLZWoCWyhpHh22H4lwTTZu/itRb8VMf2C2RMhoDMQDBQAbXG3CGrMDqVI
	 wZfkki1gZvC/cdK/ZNItUVObO3YXHYqT+axDU3nXU7hRnXQJO2BVvEeCC8SbMi/dOlK8W
	 giqN1nsW1irgwWwW3WZbzExfOQLu1iADyq3E8bF4yQ6+lKXb4A5Ylo/MUnumX0UBw0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036009;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bRhfKALuenc6dddyrOaOlnwaQdoIw7DNGmdFkwaH7Uk=;
	b=Yd3DvKD2gmd1J2Qae5ZisvWpAifTWBHidV0/eY0tMiet79Y4yIMFdp0xRhNKE3dXfxJL
	 tAEZuHzx2RI6OoO+o+WRHSkCev8lFTl/0qwFYYwXYjbv/DAdDvTJshFQojk1lu3HW56jq
	 j3nNoe+uQnod8uWmaJl722f1IGliiCgL++mZUiWngXal8rLIyuxPFibyesA4b7MCnzOPD
	 FOcLRMGzwgERZP6BlmIYvNMJH59ojB3uc8w7a/MU7ELwBWo5zTgFGF/lSYZIA05+gNYn2
	 +clE5nyXxwhWZxPEOswf/stedCiun6DLln9jX13MR1kaFPU8CwWBuDgg/W2xg6pmaTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDbBfUhX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFA0606A31C;
	Wed, 18 Nov 2026 21:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jDbBfUhX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1C7F1F000C5;
	Wed, 18 Nov 2026 21:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036009;
	bh=bRhfKALuenc6dddyrOaOlnwaQdoIw7DNGmdFkwaH7Uk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDbBfUhXwM2Wv4yGrMTMkAAzDQuByli2T90Ncc+IpZUVPulqTtvyAQyPsYC+QIPWx
	 bAGXFWZn+kY39cmg3b1BNaXBZPcbLhH5rARpGUh0nUzfv6cuWS08e8PWb/u8QM4pZH
	 YR7mmBCAEwXsTWP+OAqNkbsFB4YRTNRslKjXAShM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0905/3318] arm64: dts: ti: k3-am62x-sk-common: Set SD clock pin as OUTPUT
Date: Wed, 18 Nov 2026 15:25:27 +0100
Message-ID: <20261118150346.650801310@linuxfoundation.org>
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

From: Judith Mendez <jm@ti.com>

[ Upstream commit 1e2e5016bda94b2bcd86258b5eb77fe3006639a0 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-10-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
index 0f8c0f6a0f573..8d608c7ee2b12 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-sk-common.dtsi
@@ -184,7 +184,7 @@ AM62X_IOPAD(0x1f8, PIN_INPUT, 0) /* (AC2/V4) MMC0_DAT7 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT, 0) /* (A21/C18) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT, 0) /* (B22/A20) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT, 0) /* (B22/A20) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT, 0) /* (A22/A19) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT, 0) /* (B21/B19) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT, 0) /* (C21/B20) MMC1_DAT2 */
-- 
2.53.0



