Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062921;
	b=0f4ry/kcdNJBdzZYjAjsenMrWxuPKOwX4WX5UyuGhrAQx6aKdGwUqYZg/KcDlVKkHnKy
	 Ysv+IEUpEct31dxh6BHYcowM1YXzSPh2FpwkAEjKraNf6TYlPinxDu3vkrGORS2lH2LFZ
	 fAudVnmff0SUeTlIorKrxLLIxcbWXEotq635EK9u3H/5b2/GyqrKmAPZ4C/nZ+xqbwt3f
	 tdsf2VbNVifwZpfsm2BTXMesMnZPD2FUstyy9tGv16MAuRcIPceULbrLLIqvyty88ysvC
	 bOnqBH5lzTuDiZzZ5L2cH982EQHF+bZNNGJTdyGaJSShvXKpU27oDzBU2skC90nzC0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062921;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ORMwn3ulzlqaKeqxO+uPvHyn7KVOltgOcNdINWqWppg=;
	b=NosG6nIeWzK0W7r7yclmnCLkrZGqyOgTA7NAXXGaVrQ6vrYUhunFm54CD61SAoeYMFvE
	 SyjkpegqyZeu4b9OFWqMAE4CEf6R9ns1fLow8hd4lqT6YaAOvYpbcLvSIjx4WURjawH2M
	 Is/zZlrPmjyu+V4b8E66V7Ezd5oFHxhtLT7IKw2FtzSck3tHggzkOUM07y6QRpG8C/tWO
	 +rePFbRUx5oQX0NqyDniHXGWRLOcIbdsVTZk7C1NmmybDIIU9JON7Uzp+jVbSOkUkJ/wP
	 TLsOpsDjmFaA0b5U9RVA1rHibvTCRf4JRE0JV1TAB4b7GvjGkLwshP788wJNyr9ITUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXx7ynSA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8E2E606A330;
	Sat,  7 Nov 2026 14:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NXx7ynSA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 747FC1F0089F;
	Sat,  7 Nov 2026 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062920;
	bh=ORMwn3ulzlqaKeqxO+uPvHyn7KVOltgOcNdINWqWppg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NXx7ynSAo2c1O5sgSySyQhPaxm9x545no7gLbiQ8djuAdj2oNYqlFsKGLvkt9Frwv
	 Fo70yfExKRpNdIaH0MFyNqwJ2GkNUqap1Sos4L2YF7hsZi2wmlyovGDMFPytvg2VXe
	 afqa9qB4t66RY5ljBX6Btgx2WehsnyBYaHc9OWuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 195/869] arm64: dts: ti: k3-am62x-phyboard-lyra: Set SD clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:57 -0500
Message-ID: <20261107134858.670966701@linuxfoundation.org>
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

[ Upstream commit 1d62ef8d47b535d31fb9cf38e5c36eb55b0189a4 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: f1b3adade045 ("arm64: dts: ti: Add am62x-phyboard-lyra carrier board")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-16-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
index aab74d6019b0a..5a09b4c1b659a 100644
--- a/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62x-phyboard-lyra.dtsi
@@ -227,7 +227,7 @@ AM62X_IOPAD(0x068, PIN_INPUT, 3) /* (R21) GPMC0_AD11.MCASP2_AXR3 */
 	main_mmc1_pins_default: main-mmc1-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x23c, PIN_INPUT_PULLUP, 0) /* (A21) MMC1_CMD */
-			AM62X_IOPAD(0x234, PIN_INPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
+			AM62X_IOPAD(0x234, PIN_OUTPUT_PULLDOWN, 0) /* (B22) MMC1_CLK */
 			AM62X_IOPAD(0x230, PIN_INPUT_PULLUP, 0) /* (A22) MMC1_DAT0 */
 			AM62X_IOPAD(0x22c, PIN_INPUT_PULLUP, 0) /* (B21) MMC1_DAT1 */
 			AM62X_IOPAD(0x228, PIN_INPUT_PULLUP, 0) /* (C21) MMC1_DAT2 */
-- 
2.53.0



