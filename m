Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064074;
	b=fLWPun9X+iiWBl3HgE75lDePyh9cRljYyz20ecRqQ/IL0e2H1irsBFJxQDWy/pyJa+2R
	 4/ZT8MqifyXtAM4iyE4ZuqeGOlf/rt8YBRUI+oLknbJIsMbMOpyvXI4FEDbQFX25HNDrd
	 //NS3esGQvGlbn19D0LWHNB+p1kTwZtxkKeDipe5idK1Nq2P3X852Ma5Zd2+3zP4fRKJC
	 vGCOWyzJTPCDYQDy2Rb/JV5HSlusc1n7IQbJkLFjTX32HbsNc9a3EWP6pTB9/8IjeCQG4
	 d4UjcTWl9k4jZGo8uCho4shDenwYYJo+vvXnTTghHxaH0QkG+gW50Pmq0Irwr5UlxTg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064074;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mLDu+Bn0tM28lA/E5XjMfDV/Lc4/V3X1UfzI8gYZSBI=;
	b=aTSDg3qj9dpCRFE+rNm0fL5pfqbGyIR+rTd5xQfoqx/5tUY6yjRko6lCuRaN/W1PWqrl
	 vCf6kQMBbEhyFH5PdyBjBedHpTdK0xRYmEWkJFMLU5QTJSdc+MA0ajUI9OliBpFmb9lI7
	 2BfyXba8c3ZKJKUV6FPJ3b/ltK6J7XO74nyH/UnivNcGquo8qGZkNQbyGkf2MoRrvmRUc
	 lJeLXGhXJn7pJWoLKWPmWhpG137sSBfoN2uqK0QFVwAorhlXYsuYIdj8V8Y7ejuE8BDCc
	 aROicgV4f1c1O1Wyyn1G92XwPOD9DU4xsPcicyYPypDGU5zJ1Fo1cML1tTMYxoorllA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P93w7DTx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E6606A9DA;
	Sat,  7 Nov 2026 15:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P93w7DTx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC021F008A1;
	Sat,  7 Nov 2026 15:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064074;
	bh=mLDu+Bn0tM28lA/E5XjMfDV/Lc4/V3X1UfzI8gYZSBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P93w7DTxCO0bon+JXZbYM33EELJWd5vHhHcx/TlZvZVYh0ZTZKk3/emShbwxuepd7
	 pgjcNXSWZP6M8K0K8TpMobXULnLGy+HVzn0ZG9HXH+1y4GtOlpXaYzPLhrbkNcg29J
	 8Kvtl4h0Oj0vN4W7P0flTMOjJ1R9EwuzHuKyoiOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Moteen Shah <m-shah@ti.com>,
	Wadim Egorov <w.egorov@phytec.de>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0240/1257] arm64: dts: ti: k3-am62-phycore-som: Set eMMC clock pin as OUTPUT
Date: Sat,  7 Nov 2026 08:42:16 -0500
Message-ID: <20261107134946.147908882@linuxfoundation.org>
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

[ Upstream commit a3c2b6c52e02d58941c0b91bfba052788aeff890 ]

MMC clock pins must be configured as OUTPUT-only per TRM [0] with
receiver disabled (RXACTIVE bit = 0). Change MMC CLK pins from
PIN_INPUT to PIN_OUTPUT to match documentation.

[0] https://www.ti.com/lit/pdf/spruiv7 Rev. C: Table 12-246. MMCSDi I/O Signals

Fixes: 3443c1c4ed61 ("arm64: dts: ti: Add basic support for phyBOARD-Lyra-AM625")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Reviewed-by: Moteen Shah <m-shah@ti.com>
Acked-by: Wadim Egorov <w.egorov@phytec.de>
Link: https://patch.msgid.link/20260909214743.899477-12-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
index 3baa653257bb6..ce3e5165bd310 100644
--- a/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
+++ b/arch/arm64/boot/dts/ti/k3-am62-phycore-som.dtsi
@@ -153,7 +153,7 @@ AM62X_IOPAD(0x15c, PIN_INPUT, 0) /* (AB22) MDIO0_MDIO */
 	main_mmc0_pins_default: main-mmc0-default-pins {
 		pinctrl-single,pins = <
 			AM62X_IOPAD(0x220, PIN_INPUT_PULLUP, 0) /* (Y3) MMC0_CMD */
-			AM62X_IOPAD(0x218, PIN_INPUT_PULLDOWN, 0) /* (AB1) MMC0_CLK */
+			AM62X_IOPAD(0x218, PIN_OUTPUT_PULLDOWN, 0) /* (AB1) MMC0_CLK */
 			AM62X_IOPAD(0x214, PIN_INPUT_PULLUP, 0) /* (AA2) MMC0_DAT0 */
 			AM62X_IOPAD(0x210, PIN_INPUT_PULLUP, 0) /* (AA1) MMC0_DAT1 */
 			AM62X_IOPAD(0x20c, PIN_INPUT_PULLUP, 0) /* (AA3) MMC0_DAT2 */
-- 
2.53.0



