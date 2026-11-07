Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062913;
	b=tneJCGStgbWE0uVOX3Ow9E02onsHd3y4ZWStbu4gx+eL4IDCm/wPaEfwl2uo2UvPnSRE
	 LPzG2j84iNgkCgUyLYhn1J66qzLx9h9gpQtSVmtEQWv5ly08eUwDwLfUAkqtw9M6w4ke0
	 D/91wahNyCdOzF5ODfTzRiWI2mXnoQcORZsubsBEeBewauDrwb0fumwFZoJVr+I67xwrj
	 STU/oK9+EZZlAipI7XsKQeUr4bPswuGDFAOzTwpLlqtJavgZC2SUluPyPhniHbipTBJYu
	 /0uVoQkyonG7fmh8f0V/TOWzNLBxRCvbw+bNykRnExkAFh0USm2Mo61o8h3nxpGY9QQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=03SPRXFKR/Myd6c+QL2WSOzW2OoG2leMCg/Lcq4M0mk=;
	b=Dqf00rz19goFdXo5Cn4BaessdrgBcIHwQP4LWRYLDWtSEaTTfKn+gpHPuiv+/fEZD7vh
	 VJCrFDsy1EpbcY8s6rrjA4rSTRUMqpssAhu7Xee51BLdFV3RdWb1I4s6XagBNGorweoU0
	 zTVkkA9/f9mRs5yYss9Tw3Cmw1aBFPqCEfDGGla2PDjJMNBIcD/C48cXWV5B/IYeIv9+u
	 rORGinhctPgkw+7E1C3n8xe55aY4vILMpdCgnu0LrgrcZlxmb3NQGMB5NE4Sp7KDWIDB1
	 IpwtFmZeo03tKEHWHitiPVOQRUEsztMlooNqgD8Qqjpr46+3DqZwwn4wEuXnAUxbDKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yK1CgbUQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D24BA606A326;
	Sat,  7 Nov 2026 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yK1CgbUQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670671F0089F;
	Sat,  7 Nov 2026 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062912;
	bh=03SPRXFKR/Myd6c+QL2WSOzW2OoG2leMCg/Lcq4M0mk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yK1CgbUQRVLoxNFFJ8/RXbjGW5wGvjYRuiOniW2nnNWkF6/jGMgj3dixO8zZA3j32
	 7aWYPBoJaZHL5neCXqxbg/KxSVAUfkuHbtAJqOz86QzPtfOQtoPlA6xSMzGkbQPkOb
	 ee5Y+8kKJPW8F1fO6EZQCuUCJGHCGzLFnSk0CwSc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 189/869] arm64: dts: ti: k3-am62-lp-sk: Set eMMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:47:51 -0500
Message-ID: <20261107134858.503273997@linuxfoundation.org>
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

[ Upstream commit 156f4c2208c8e5e04002402494de28c21c0afcbc ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: e6a51ffabfc1 ("arm64: ti: dts: Add support for AM62x LP SK")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Link: https://patch.msgid.link/20260909214743.899477-7-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
index 5ed757c19db60..fc79641d7bb5f 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
@@ -86,7 +86,7 @@ main_mmc0_pins_default: main-mmc0-default-pins {
 		bootph-all;
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT, 0) /* (V3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT, 0) /* (Y1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT, 0) /* (Y1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT, 0) /* (V2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (V1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (W2) MMC0_DAT2 */
-- 
2.53.0



