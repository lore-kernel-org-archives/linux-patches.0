Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062918;
	b=BaoyRrPW5X9y6FOfVEt5QE0AmJaQsanTCXLuQqdJCp48R+ys+h/i7miJ21Q1VM4Ubp23
	 eJcbxWa7c2i2Kb4jTG33RzrDIOtUDYxZCMLyVLEi4+a76Ac+vagqtyimNq2UO3Wk/IELc
	 KCbU5Tr1EPInxRsqt0Z8mhxEtCX0LDnRk/D/CECURm3aEk2prRsF6szge+dxcoUgeFoOV
	 xn6dLCnpXAQfhbZkehxMdGS9s6IOXxUGLY5uyPRdMqcRl48ZrU44+2Z854uUOt8FR6x97
	 7im62JDjSZ46FgQcbVOb+2FhMi62w1/JEIpB2h9TXXlnEz+l77S/WCWLUS+tokJ5gKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=t2JN/QQJNw8KXnIoBXzx8SDYyWMnbOdg7K6GeveqAyE=;
	b=FN43lag7liIIcWF8EgX2RKY3xoiIAVCtuG4sEBHkRu4W14M6hwvDdfwKixvmvl0uMJSr
	 UU2LS88MFZJYelZ932ZkDVrSwQyT50jR9M6Ln5tXtDoyQTXtI/AfF5phkf2/+8/P2/3DR
	 rw5q4xjix/xxmpwFCD0WIRMcc2Tm5U3mFN581uY9GIFdf2KK1q1WpD8tsyzGLXCcXT0tJ
	 K9YTwCM5p9sf028d1vWs7PG+/gvpp1iPjy/cIKnoAfbH9SQDYQ3e1YNaotexj/a5GfcCb
	 37cF7iQzsUlvy+1PrHVV65f4iRc81/Mj3w9mA9Wn2oaHudwnuk7OlP2jrftzgtfLR5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doRGz2Oc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34653606A326;
	Sat,  7 Nov 2026 14:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=doRGz2Oc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6C221F0089F;
	Sat,  7 Nov 2026 14:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062918;
	bh=t2JN/QQJNw8KXnIoBXzx8SDYyWMnbOdg7K6GeveqAyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=doRGz2OcZd+OPcKkUXK7ckgX+377GKnO6APzSwL5zMKqE8BoS/kKrtQaRaSsSs73V
	 0xfiEc58Sp8CfaPLBeID9DwrBNYVFnBo1ODY6uzItuzEinXTupQ7vhWJXO6Ek3F3X7
	 rmK0a46euuaD8zOM/mzeySJ5E5BG9c4wX7q3WyP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 193/869] arm64: dts: ti: k3-am625-sk-common: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:47:55 -0500
Message-ID: <20261107134858.613372196@linuxfoundation.org>
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

[ Upstream commit 8ef8a0e38d1377c6d51c06f95c64d87641b2c717 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: d19a66ae488a ("arm64: dts: ti: k3-am625-sk: Enable on board peripherals")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-11-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi b/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
index fe0b98e1d1055..d492ff34c5b11 100644
--- a/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am625-sk-common.dtsi
@@ -98,7 +98,7 @@ main_mmc0_pins_default: main-mmc0-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



