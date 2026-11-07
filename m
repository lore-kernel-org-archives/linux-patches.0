Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064066;
	b=HAyM4BXpjF9LEzZQ0zoxRzHVKSDtyZHcN2TujssxGP7QXDemgqfkDCxETtm7PzJtEnz0
	 0GIrmbFpZLMQNprIWCgllOAkwJguc/p1k3RQnAUmbsdNFNfG8thFSZVUIM19MaK70IzXR
	 AKA00xs3Np+z42IHlB/WnGLam8/9EN/JhcetLyoaiyLleP6mnvpuVEmU9BzB1SBCi2Bpz
	 f0erv4Sl6WQgdLqSWYGhjwmHds/cotc+56BOfPfdPTL44KlNzqJQEqp7qJfWQFc6LKcwL
	 ji6ogdJwvka5KLBovIZOU7XTL0zGbNevCJsaQI4LKbHwd2s2kZT9M4MwBOmvz1pzZHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064066;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SRty75gGloC6dsv4OobJcZE+2E2j3YICz6qyqxuR8gY=;
	b=o5KjfrTx31FNC8zw/OTPZDlX2TVwgp77p4J5KXbDk7G5zxjpWZUYvIIf78yDAZZLTX7y
	 9lePcqgN7YCYHYpfUXUkMGzYhdm1D/48SWzjgoK7/YJ0z01pAPKblE1W/noUfMAuqPuNc
	 gSk957taLhzn8rbnL9fpR/KzzrhQ1h3dCjjX0cCl+FrMQ1CpppWDlUB7ftQB9plpq1Ffk
	 w6ZXXrwLNnUczlEs2GYIEux5sZgomBaMqFf+XM8hU70919urj2UvugI84ZghhSvMy2moj
	 J2G/CFQ1s5f3iN+jC5T6JamqZxcT1FD0k1lL5fXFU3kQ9zbvl1iDPgmMZ+A/LjZl+jw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eaqcu36e;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F4B606C02C;
	Sat,  7 Nov 2026 15:07:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Eaqcu36e
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F41F31F008A1;
	Sat,  7 Nov 2026 15:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064066;
	bh=SRty75gGloC6dsv4OobJcZE+2E2j3YICz6qyqxuR8gY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Eaqcu36eYSVqa3hms9JQaLmxHJWIAC+f3+mhSP/kPTC5zpzezWs0C/HusnPRNEl4E
	 /F5rSlwSiSqKL1oQBNe5yV9sZP1V4bzwfsiTc4vL3iSPuApDZqcg4NRebg65H8xI0o
	 i8MjLayeRg36ft3yS+aSxTZEHIovgReL0IgQW0dQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0235/1257] arm64: dts: ti: k3-am62-lp-sk: Set eMMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:42:11 -0500
Message-ID: <20261107134946.011695096@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index dfd65c00f5b95..7fd508f4eddf1 100644
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



