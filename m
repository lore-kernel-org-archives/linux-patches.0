Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A94223C5E;
	Thu, 12 Dec 2024 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022423; cv=none; b=VY3ckUj2J74s79W+lCPK/bKjlYAcAj+iIFJbti6SkMP0R3VdtZWEhXJvKPtQIQrde6p7wzzeCpsf9VSbzf9EqnWCuC/r1Y0o2hH+S6DMQWX0iQY0ctVwH4UrLO27WCQujHji+VJieEZA0eGYbm26x3nACkXOuPeLARQ294YffSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022423; c=relaxed/simple;
	bh=wYWB6s1jcPEvv0m5TMb+AlO8UExbr45tbzr0STxI7Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IJsIdyf//1OWBB36IUomc+mkfqzozkzoSDoYtOVMN+uEtt8MkK1+wSNBaUWGRosxlZzq9yVQl/N1dUiqq6U4subpeuOX7kR5GlmFbb0xDnbUoeaXUIL5jvCEPrANhOfCZftEaCMpIILN0AKVmaQn974goz/11IyCAbAtV5+OyQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vKy+akWw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vKy+akWw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30DFAC4CECE;
	Thu, 12 Dec 2024 16:53:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022423;
	bh=wYWB6s1jcPEvv0m5TMb+AlO8UExbr45tbzr0STxI7Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vKy+akWwnrDeBRLKwrqskpY713omCXCYREJ4NqrZQQ2pxjA6l0M1Nv5W7BDePZpKO
	 iJvtHqLJ+Y5LEOLrWbV7Rq1H24vnNlEhAcocl1goyTAw5xwVq+CfvE+psIaLSrOt7x
	 2MWG5w35bnt5tFhCXjTCwNLgDnHrxG2/4iBZw778=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 237/565] dt-bindings: clock: axi-clkgen: include AXI clk
Date: Thu, 12 Dec 2024 15:57:12 +0100
Message-ID: <20241212144320.851197366@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 47f3f5a82a31527e027929c5cec3dd1ef5ef30f5 ]

In order to access the registers of the HW, we need to make sure that
the AXI bus clock is enabled. Hence let's increase the number of clocks
by one and add clock-names to differentiate between parent clocks and
the bus clock.

Fixes: 0e646c52cf0e ("clk: Add axi-clkgen driver")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20241029-axi-clkgen-fix-axiclk-v2-1-bc5e0733ad76@analog.com
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/adi,axi-clkgen.yaml        | 22 +++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
index 983033fe5b177..592285f616f57 100644
--- a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
+++ b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
@@ -26,9 +26,21 @@ properties:
     description:
       Specifies the reference clock(s) from which the output frequency is
       derived. This must either reference one clock if only the first clock
-      input is connected or two if both clock inputs are connected.
-    minItems: 1
-    maxItems: 2
+      input is connected or two if both clock inputs are connected. The last
+      clock is the AXI bus clock that needs to be enabled so we can access the
+      core registers.
+    minItems: 2
+    maxItems: 3
+
+  clock-names:
+    oneOf:
+      - items:
+          - const: clkin1
+          - const: s_axi_aclk
+      - items:
+          - const: clkin1
+          - const: clkin2
+          - const: s_axi_aclk
 
   '#clock-cells':
     const: 0
@@ -40,6 +52,7 @@ required:
   - compatible
   - reg
   - clocks
+  - clock-names
   - '#clock-cells'
 
 additionalProperties: false
@@ -50,5 +63,6 @@ examples:
       compatible = "adi,axi-clkgen-2.00.a";
       #clock-cells = <0>;
       reg = <0xff000000 0x1000>;
-      clocks = <&osc 1>;
+      clocks = <&osc 1>, <&clkc 15>;
+      clock-names = "clkin1", "s_axi_aclk";
     };
-- 
2.43.0



