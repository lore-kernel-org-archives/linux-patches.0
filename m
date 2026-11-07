Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062972;
	b=yTsLXctqs0g6+Iiw8I51gMlfkWoWbjm68i0C6Ax8D2uNFq+CwH2re5dUfrxGIx6PSvw3
	 PMpCTfXHOgMdiXVsg3RvsNojyn05YwecENTCy1mDJy6dHj4DvSdAP8mw2lQJGBBgbj8Fu
	 dPDLJupaRngge1M5qxIoWThqBVFPFBCJ/omvv8jjoORmJBvnCj3doQB+yBdxqLFDO9WQG
	 OCb48jzMi1qNRDxWSrasJhLc8s9joebhMG44VCHoLtuyTKfzrxmiP+dSttrCPA1vZysN5
	 6XjJEsSMP9txuc6DBoSyeCLvL0X8QqH/dI8aW831SwifNn3C8XxyEdB++H/UVeqrtbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lTBKzjnhrRu/ivxY4KOfvNEAimOwrXydFxjGYiKlwFQ=;
	b=MoA+foWCyf7iq9LrMyF53/rcbg3eriqOkKyqtqKbNWVjtv+Ibe5jknSSDxYDmBjDoD/G
	 ur0ODFQ9mePykCP5Qf2ZRjLOrfZhgXsGbOawx2ooi+ZuKqmV/1WB4bXX8xoW6UGCw47/b
	 Lg3uZT05BGNYJSnzMPWYaFFeu585vi3aOcepKbW2+ZYKQGe1gq2QfdlHgwYTuzPGuti5u
	 oYbfFI8PzcLp2p34f5LzbicqYNHV/oB7U4OK5N7XllFw9R43O/Axu3fkxbS2YZc2lljWA
	 q6XQDCy0++Vy/8sl+3RowKxAtmYV2sIizrhwB5Vs8Y/G5O5UHJQtcMeegRn2rFuzQ4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVGHCHHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DFE2606A32C;
	Sat,  7 Nov 2026 14:49:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rVGHCHHw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7701F0089F;
	Sat,  7 Nov 2026 14:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062972;
	bh=lTBKzjnhrRu/ivxY4KOfvNEAimOwrXydFxjGYiKlwFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rVGHCHHwwMLQBrvFKN5wOAoEaKMxAc8hUzHPFLrxDZxJQIbLVf8CQDikG+vOQ4oOg
	 U1pdRDpWcYji2UTg58U8TPVYbuqrqcbxbZL4TDVXziVe+S3kSx1uARlYOdPJNizk2E
	 bmKbYvX9WZ1iYbPQYCCFzBj/eNbc2KBfoWj8ESvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 188/869] arm64: dts: ti: k3-am62a-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:50 -0500
Message-ID: <20261107134858.474278286@linuxfoundation.org>
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
index b3d012a5a26aa..9da48a54855e0 100644
--- a/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62a-phycore-som.dtsi
@@ -120,7 +120,7 @@ AM62AX_IOPAD(0x15c, PIN_INPUT, 0) /* (V13) MDIO0_MDIO */
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



