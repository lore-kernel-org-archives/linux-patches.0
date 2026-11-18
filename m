Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024586;
	b=N8kRsVv5rzWgECW/Yy/UirxscUg7kAKDBqMUTiCmUV9dNM1z1CX4IsNISzE6b+5UO/f7
	 jkAoPR7HYvA/7qQ1yZoIr3jLIYqxfnN1szv4R+DS7qi9x+34wUhJrtwBcgSeDEiW5qJ3N
	 rlY4GcjiFqs2W2jv8p9MRk5UUBo9SVNo9rTRxDnfHlRroD4O3qkunqqTXlnu9VpcJL/BP
	 1mfaUqrMRXGP/XSp04HGxfJWgXXLPB2MDdc2rdIplQdoD4xVyZexNKW49R+oPkinpwm/i
	 C8H6tdsYTe5YL3U+BV0n4SRZstElj/siwQsWEcz/i9hTedj9mCYozAs6gtLrLu0CdWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024586;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MjsbPnYeIx+a3klWyhZieummBXCGp+5dAaVw26gZS6k=;
	b=OO7SGQzYEHM2A32ycTUStSQwxJE0ozbLfS7SSgOcR7ZmZhijpFba0KD0UOjZnqyXIFOY
	 ZcEl2vj7MccvZ7hIxH4YuZPgjUI+BQ2uYhS/mpIYvzESs88lvifPKGndXDspS5HGsoGxc
	 9C+Pxb8+OQ5RNjkq6nMWNfRaAKGEMuZinP9t8IWdItZZnwNnABqgSUx33kktidObFhC7s
	 Jx64oK1Sg4TcsvUHdwr/2Vi0ZUxhapoAbpAgGOr7IQbFF5JXTP8/R3z45J6TPyF1ORWKn
	 Nd4U+IgCIYxV7qOqnfeT8C3SjQY1hBI55kuDW95gw2zdaf85sx8ce0dEB7hJyBUHm1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYjoIsUV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF582606A31C;
	Wed, 18 Nov 2026 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pYjoIsUV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 146561F000C6;
	Wed, 18 Nov 2026 17:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024586;
	bh=MjsbPnYeIx+a3klWyhZieummBXCGp+5dAaVw26gZS6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pYjoIsUV/E6RKTBqZ1D2/ekQ9SgdL4rHAgICkF/e2+RMnfn2x6aqONAgn+5ucCwmw
	 mF0LFsDmdVFIFKnpJS68D3Ije3tSWXoShTznFQMZqgMBHwA2GbmxFnMhfyrV4kkbxr
	 eR0f2r053x5Gz2JWQbsdlXShEeu3yFcryVtO4Kb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0776/2151] ARM: dts: gemini: Use a level-high interrupt for TVE200
Date: Wed, 18 Nov 2026 15:41:51 +0100
Message-ID: <20261118150150.397956233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 5bf1bb010712bba28eda926ed453db3cab91381a ]

TVE200's interrupt is configured as rising-edge. On the D-Link DIR-685,
this can stop interrupt delivery after the first vertical interrupt,
causing vblank and page-flip timeouts and delaying framebuffer console
startup.

The vertical interrupt can remain pending after acknowledgment. Use
level-high triggering so the pending condition is delivered again
without requiring another edge.

Fixes: d2b85241a9f5 ("ARM: dts: Add TVE200 to the Gemini SoC DTSI")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Message-ID: <20260921-gemini-tve200-fix-v1-2-8be03ac2a8f7@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/gemini/gemini.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/boot/dts/gemini/gemini.dtsi b/arch/arm/boot/dts/gemini/gemini.dtsi
index befe322bd7de9..c95faa197bcf1 100644
--- a/arch/arm/boot/dts/gemini/gemini.dtsi
+++ b/arch/arm/boot/dts/gemini/gemini.dtsi
@@ -428,7 +428,7 @@ dma-controller@67000000 {
 		display-controller@6a000000 {
 			compatible = "cortina,gemini-tvc", "faraday,tve200";
 			reg = <0x6a000000 0x1000>;
-			interrupts = <13 IRQ_TYPE_EDGE_RISING>;
+			interrupts = <13 IRQ_TYPE_LEVEL_HIGH>;
 			resets = <&syscon GEMINI_RESET_TVC>;
 			clocks = <&syscon GEMINI_CLK_GATE_TVC>,
 				 <&syscon GEMINI_CLK_TVC>;
-- 
2.53.0



