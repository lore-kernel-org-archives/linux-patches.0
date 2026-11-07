Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062606;
	b=JIOPmbU7IjEm8ARVXeGXFM94vKGUJSjdilZZO8QLRqClR5uU/0qiZ5fPjp6HK1YWJkqL
	 /kUjYan5rE3MqOSEK5plJ4UvmUeY5X5U9Urup3vZrOzxh5bUeHIh7OJn+vrLLQkLMsw1z
	 eVX8d+lNZioiael21FLfLXHrsZLKwfeAYEn3o4xAezFXaHFqUY3Y3Hc55UiS8RzWJyKfV
	 gzzMGtBu17VK83stthYesfYDSDTn5i6xChXPgEjLaYQAER9OBGvfkRbOihj3qyjPaV0Rq
	 zWUvwH0uPBP2vBpJmaDKFdTrSOO+HJxdU6Emj+IZKqtRHaQ1Z9u0ERjSLAWqRxz5vmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062606;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wnHlo24Qu3y/jXpAqHDxpy14bO3jWPs2vXWc623i6RY=;
	b=XukqJTMTDdY8Ndr8O/E5ULi99nAsC4DkI3x6W/GkxzMaNhWa1KztKIJl3mLnQCC/GBF2
	 w/xeRbcgHw8WWtg/isuF8lLT39rA7MVTNtOrlHT5J2DgM2g5rGaDv4kgpNHFc/CsPgSQj
	 NbDLyMTp89TPvo/B9gPsKD3nRskvKMyEu4AObmDR9mOLLSxfSsq0IJrXriUe2X3H7ra7g
	 93qDipcyO8NrbG5cCTw1pUMZ1FeNptW7NRvwESV3eyXetvxMzp71Swj0wyFucldmzG8rl
	 SVCBW1GGFXJvQn84zKfPH8K92Gfq27EP2Umz+VMWXAE8BqaloIVzGqh4kjE1KeVW67A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+ucT4MU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83929606A334;
	Sat,  7 Nov 2026 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q+ucT4MU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 053A41F008A1;
	Sat,  7 Nov 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062606;
	bh=wnHlo24Qu3y/jXpAqHDxpy14bO3jWPs2vXWc623i6RY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q+ucT4MUEw68u9zBxi1AK9DSgHOkfcFustn605fkFsIohor5hkHFiRWiJHA1QxM3i
	 +VouKEIHVOzQBYP42gIzmloR9TDkEF3lYlMh5vtnVyQhNaEVkAszhErQPOI2u/YDtD
	 8+OCH3cnqtgudLehHnAJmdJMfOJ6vRmXG4omgaOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1479/1536] dt-bindings: clock: ma35d1: Document the missing crystal inputs
Date: Sat,  7 Nov 2026 08:58:15 -0500
Message-ID: <20261107135039.390542626@linuxfoundation.org>
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

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit ea1f41802312e77b58113146a060fb0546b2234d ]

The MA35D1 clock controller takes two crystal oscillator inputs from
the board:
- HXT, a high-speed 24 MHz crystal for most of the system
- LXT, a low-speed 32.768 kHz crytal for the RTC and low power modes

So far the binding was expecting a single crystal. The example named it
HXT, but no real definition for it was given. LXT was not even
described. In order to remain backward compatible, we will continue to
allow either one (HXT) or two (HXT then LXT) input clocks. I propose to
give those phandles a name to clarify what these entries expect, but I'm
not listing the clock-names property in the required block, for backward
compatibility. The rates are fixed by the TRM, so even if the second
oscillator is not described, the OS can make an educated guess.

Fixes: 2f8b5eb589cb ("dt-bindings: clock: nuvoton: add binding for ma35d1 clock controller")
Cc: stable@vger.kernel.org
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://patch.msgid.link/20260930-perso-ma35d1-upstream-clk-v6-2-48937ee6c9bb@bootlin.com
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/nuvoton,ma35d1-clk.yaml       | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/nuvoton,ma35d1-clk.yaml b/Documentation/devicetree/bindings/clock/nuvoton,ma35d1-clk.yaml
index 8f0c43683729b..9649feda8d7a5 100644
--- a/Documentation/devicetree/bindings/clock/nuvoton,ma35d1-clk.yaml
+++ b/Documentation/devicetree/bindings/clock/nuvoton,ma35d1-clk.yaml
@@ -29,7 +29,18 @@ properties:
     const: 1
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+    description:
+      The controller takes 2 crystal oscillator inputs from the board.
+      HXT is a 24 MHz crystal feeding the internal PLLs. LXT is a 32.768
+      kHz crystal, for RTC and low power operations.
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: hxt
+      - const: lxt
 
   nuvoton,pll-mode:
     description:
@@ -58,6 +69,7 @@ examples:
         compatible = "nuvoton,ma35d1-clk";
         reg = <0x40460200 0x100>;
         #clock-cells = <1>;
-        clocks = <&clk_hxt>;
+        clocks = <&clk_hxt>, <&clk_lxt>;
+        clock-names = "hxt", "lxt";
     };
 ...
-- 
2.53.0



