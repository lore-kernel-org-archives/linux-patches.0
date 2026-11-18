Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037093;
	b=s9JYpY/0Q3k2u6Pv4tFznWQz4ZC5str2fl5deQov/yoIRi0o998UqPxFuIPEAC2HOK7t
	 Gm99k1igid5LJ/0GuW0J4DDWzAB2e9ccuVhvEgD81JJa0+USJe2G4U6OI5v4OAxbcdnf8
	 stmPDFVPN+vS1mg6pax0UiCnTmz1717m9Mjb0pw5wE9kmgFlmJYu/zDll6RRZezuluZpT
	 ErpGWJrBZ9KqrxhyKFMdpLh30QjjlyUt0eVVyDt6cqN8tN7o7a+APi4TSriUiDZwwfA2Q
	 713Zhw8ZQo6k6KadBmQd/IkSuFIr/Dx4bCGiHy4gL7+f5+wmuANBAOzdXDa9RGjDS3A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037093;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=M/sdEjRhlKEtRlBh5R+SMmdmagLfZP56Irshx3i6/wM=;
	b=nKxhmYk47m1Z8L0lzWWXd4i7svr6gFkdqqtw3LTWI/wZw2j5ga8Mqf0qPFXu8IPxQgLA
	 RGDj0i1IsM8bhUQYmoDIo0VO7oM2iUiMSBW0C0hSviVdJpdlWjNy5MQbvEtRoykp+KE2c
	 Zm3mfgSKeUI5KVe0PP4b90U+DDWpphrotdjbnHtUzuHBHFmF1lAxerkK9i0LUNctXOSRx
	 mAoOY2f1K0PoYfKMZwEuHKw0j+ukTQ20L7LUqLd24W74gIzIyGpUwyjfSoYzKRmNDAwRG
	 uCAkZ+Bw5MHLV4FwtRzp1tStmQE7PllH297LDPGaTPSdnL8WaQzqOxR3i77sw87ypDg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU2YZGM4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 902D7606A325;
	Wed, 18 Nov 2026 21:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NU2YZGM4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7D11F000C4;
	Wed, 18 Nov 2026 21:24:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037093;
	bh=M/sdEjRhlKEtRlBh5R+SMmdmagLfZP56Irshx3i6/wM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NU2YZGM4pRUKTLD9Jo8k658Vn6A0YwYYn0b9YXj4yD/jrhhKl0p+EcwZnFhZjEvgF
	 2YT3PvvGsRigd9Hdksri4sTsvHzf/hpZD+N3p3W/fFjH2QKMBKI2w0RM3sP1Gh+pPv
	 neujGpcKm9MSak+yAJXluFAlB7yD9JuiaI5OPJy8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1249/3318] dt-bindings: clock: ma35d1: Document the missing crystal inputs
Date: Wed, 18 Nov 2026 15:31:11 +0100
Message-ID: <20261118150357.663436199@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



