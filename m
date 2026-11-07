Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062042;
	b=q513N6NpilkskESX4mtEgccP5IRudxDgwSjqwY0SIs8tRpZTrWG47ounOTh+rDKEDXWY
	 707ncNKijYM3g1Ij79oCS+8nlZNMkUv/fKi+eAJ4B4qq2mtx1KdCxg8NtuMs0r5y3ZyoV
	 bCpKG3PVAqHH6TsV9/Xs309huW0HMSTZCguWnXfozM8LmgsXQC0sxlI7sXTdiDzcsyqBa
	 hJjOJIpTqkh4bLnAwllbAcoFs2uLe6LVitR4WmD6OoX2yh2dXg54ATlUNq8dG/5YfqeLU
	 GJqHxuM26bQXTUkU0qhmXe1JQQqHD8UwRW4uRqYzE3H+AzOuHNI/3YApPkMS3JPm+ag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CbTcGQcPfvvszeuoY3s4QEH0WHYzbmhokhj9ZsCpmbA=;
	b=Hxyrr+47j9ywgkGq6Twyh2WQSR+mrwsUVGePVClCRQMJBoM8eI3eizC0PLdz8iQV5ow/
	 PlTeah9n+usVmfjSvH+n59YKJjRBDy/F5+LIcVnV8tJDCu/xzGBME7gjnjbOs0uChQ8G4
	 t5nIVRriIn7o1IjJNNyjN+ODsrPJVWL94AmxNq4Vma/7ZQk87edH1PhuKCAndhXAEhPlU
	 X31z/MKAwcWlCpB/FvwRK34aNiDHef1YTQeaejkHXkp1hsni5wc3UDUr3e+zsBl3PgVnM
	 qhZ9OMvbVK8spdzovbda4peyWc/rEeT1IXTBxyOIO69uaKmQYjVN0nMTzGKfqgqSlXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFVxRWCb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DEF0606A337;
	Sat,  7 Nov 2026 14:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YFVxRWCb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AC6B1F0089F;
	Sat,  7 Nov 2026 14:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062042;
	bh=CbTcGQcPfvvszeuoY3s4QEH0WHYzbmhokhj9ZsCpmbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YFVxRWCblLNcpZNuiFyIy8V4ce2yy2XytSX2Yo7Fa2efSfdcATO91Rlp2vIkVDqd5
	 nbLpBOifJOunfuv2B5WyQFkbXTkT7dHY+ZpniXK96AM3Vk+XdJrsiW5YMjlPJ5UQ8d
	 CVEVxJAvbDJF57rK1Wp6zmrVzn5QDJnoGfgXAeHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1024/1536] arm64: dts: ti: k3-am62-lp-sk: Set eMMC clock pins as OUTPUT
Date: Sat,  7 Nov 2026 08:50:40 -0500
Message-ID: <20261107135026.442261747@linuxfoundation.org>
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
index f050886e67c6d..cb5e8364c9731 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62-lp-sk.dts
@@ -78,7 +78,7 @@ main_mmc0_pins_default: main-mmc0-default-pins {
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



