Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065449;
	b=C2lN6t3BzaOljven8p6D8huhJELfM9pZ+Te0Mv1pO/mf9kV2n/BlCV5LY8zg/in2XRHp
	 0GRwy2buxJbIOSQmb+hL5tswruw0N6Me17z5Ec1359C/W7aeZW/P/720rD/Al8S7PSEk5
	 23E/4B1K+8MZXpzv++tXE5o0xE3pR7Z1ISBRh/uGMZcaVtxdTqo1KSvCWr+mW/58j5Dhx
	 Ap5voVnmeOMW4Z7XFYQDwOXwvBVt1ADpmApFJSjOc3dEjrdY3rDM11vjsul9XQQmciGKd
	 c0mgHw5KuOau2I5jcFLCPw5y21elW6G4fntdv4n9kqafsOz9YlNoU24PnaFskAz5hYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vUDD95VYK5/bjJjFKtvPSfYPZBGryG/pee/IgQAYMZg=;
	b=mxjn8hYV5hrTG3i44XTsCRuHFn4LAVIy7lTyw73652hIITvCX8Kj5HOFUwwYxdoOVDRC
	 gJ6uQdYuFvPBR45m8E4oiTsBE6ZDB2+1jdEtV6EeMQ0/ZfJHPh87Eq4zE7dJkua7+mAd3
	 O608c05j4evftvC1gvZ/S7IQnkX7RNxBoPvZ3pRHOmzlP0F9iwrAGfJZl5Vsizkl82lsl
	 DXBYXYD06dsI1vCJvSOHMtbbt7DOb9tTByDodU2Xb34Jj8GP8EaavMIauGypkpAJzvCAM
	 uz3VQftQ2+Jf2Zwh5deHBsfXRX5dewTNr8K8odLRZbtfYQws18nANaGbUVYFnWWNmkg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsQgMxGi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AC65606D804;
	Sat,  7 Nov 2026 15:30:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vsQgMxGi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3986C1F0089F;
	Sat,  7 Nov 2026 15:30:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065449;
	bh=vUDD95VYK5/bjJjFKtvPSfYPZBGryG/pee/IgQAYMZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vsQgMxGi6FFh17nP7euTacRC19gHrF7sbIATeqd+ix6Nz2jk6Mjm6v+9bqn2b7rzO
	 ytsQIPUKHgqWpvxNtwMazOhoXwc1dJbWXbXwKb7hvcQOHp8TRGZl1sWmfsfQaRQwJf
	 MHgwh8uiXu8F5CpLlu2aShrEbrcirEDB7vdpTsnc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1152/1257] dt-bindings: clock: ma35d1: Document the missing crystal inputs
Date: Sat,  7 Nov 2026 08:57:28 -0500
Message-ID: <20261107135011.026521947@linuxfoundation.org>
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



