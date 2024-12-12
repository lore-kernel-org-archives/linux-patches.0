Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50F9C13CA93;
	Thu, 12 Dec 2024 17:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024190; cv=none; b=r6KOyuZWArJMR64tUdUt761fYNTq5UN5KGercnNNM1cOpv4Db7XDCGeBViUsDdDqqqrh0BxkmexNGMR9fQow8hXdMzUa5hJ+7tZdvjBaNlNZPbuRkVI1StYi8UCcd9U+tjCC66WEgzYxSPFexP3++ivjaIvEKnzsUcFzUxI9xVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024190; c=relaxed/simple;
	bh=Ba8oJWJWeWcQKNPT1qjcrA6Arv6VJNb6VKRZamDOFTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qrooWPoVEs86K/BKBDhXi3BTOMMdW/l48hnHjbB2AvZfxZc+0juT6xiyG9YKLRZBjwBxMNq5gWzuH826k53T5n6d4DxIk7JS2mTqFfbSk0ZaRXHqrINoCuZzTVEcg9LcyhczYo3W4MOor8VWROBiux5Gkd5nWXDBDIYab4RqsaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EC+MhXtB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EC+MhXtB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE68BC4CECE;
	Thu, 12 Dec 2024 17:23:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024190;
	bh=Ba8oJWJWeWcQKNPT1qjcrA6Arv6VJNb6VKRZamDOFTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EC+MhXtBauR0wXiMAKNV4/i0QcDJmLIDQBlb7GoeL8gXoV5cn//Mo6El/tShvxbkY
	 j5l0BZmovF3oqpbGhEp2b6Tye/r4XbtY6f2uyAob+wr41H3E86pYO4TgZzInqSzo0s
	 ouqSwlOQtaX253W70rrXjfIhYuwqRLsFChWyKQxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Hennerich <michael.hennerich@analog.com>,
	Lars-Peter Clausen <lars@metafoo.de>,
	Alexandru Ardelean <alexandru.ardelean@analog.com>,
	Rob Herring <robh@kernel.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 186/459] dt-bindings: clock: adi,axi-clkgen: convert old binding to yaml format
Date: Thu, 12 Dec 2024 15:58:44 +0100
Message-ID: <20241212144300.905057578@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexandru Ardelean <alexandru.ardelean@analog.com>

[ Upstream commit bd91abb218e0ac4a7402d6c25d383e2a706bb511 ]

This change converts the old binding for the AXI clkgen driver to a yaml
format.

As maintainers, added:
 - Lars-Peter Clausen <lars@metafoo.de> - as original author of driver &
   binding
 - Michael Hennerich <michael.hennerich@analog.com> - as supporter of
   Analog Devices drivers

Acked-by: Michael Hennerich <michael.hennerich@analog.com>
Acked-by: Lars-Peter Clausen <lars@metafoo.de>
Signed-off-by: Alexandru Ardelean <alexandru.ardelean@analog.com>
Link: https://lore.kernel.org/r/20201013143421.84188-1-alexandru.ardelean@analog.com
Reviewed-by: Rob Herring <robh@kernel.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 47f3f5a82a31 ("dt-bindings: clock: axi-clkgen: include AXI clk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bindings/clock/adi,axi-clkgen.yaml        | 53 +++++++++++++++++++
 .../devicetree/bindings/clock/axi-clkgen.txt  | 25 ---------
 2 files changed, 53 insertions(+), 25 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
 delete mode 100644 Documentation/devicetree/bindings/clock/axi-clkgen.txt

diff --git a/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
new file mode 100644
index 0000000000000..0d06387184d68
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/adi,axi-clkgen.yaml
@@ -0,0 +1,53 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/adi,axi-clkgen.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Binding for Analog Devices AXI clkgen pcore clock generator
+
+maintainers:
+  - Lars-Peter Clausen <lars@metafoo.de>
+  - Michael Hennerich <michael.hennerich@analog.com>
+
+description: |
+  The axi_clkgen IP core is a software programmable clock generator,
+  that can be synthesized on various FPGA platforms.
+
+  Link: https://wiki.analog.com/resources/fpga/docs/axi_clkgen
+
+properties:
+  compatible:
+    enum:
+      - adi,axi-clkgen-2.00.a
+
+  clocks:
+    description:
+      Specifies the reference clock(s) from which the output frequency is
+      derived. This must either reference one clock if only the first clock
+      input is connected or two if both clock inputs are connected.
+    minItems: 1
+    maxItems: 2
+
+  '#clock-cells':
+    const: 0
+
+  reg:
+    maxItems: 1
+
+required:
+  - compatible
+  - reg
+  - clocks
+  - '#clock-cells'
+
+additionalProperties: false
+
+examples:
+  - |
+    clock-controller@ff000000 {
+      compatible = "adi,axi-clkgen-2.00.a";
+      #clock-cells = <0>;
+      reg = <0xff000000 0x1000>;
+      clocks = <&osc 1>;
+    };
diff --git a/Documentation/devicetree/bindings/clock/axi-clkgen.txt b/Documentation/devicetree/bindings/clock/axi-clkgen.txt
deleted file mode 100644
index aca94fe9416f0..0000000000000
--- a/Documentation/devicetree/bindings/clock/axi-clkgen.txt
+++ /dev/null
@@ -1,25 +0,0 @@
-Binding for the axi-clkgen clock generator
-
-This binding uses the common clock binding[1].
-
-[1] Documentation/devicetree/bindings/clock/clock-bindings.txt
-
-Required properties:
-- compatible : shall be "adi,axi-clkgen-1.00.a" or "adi,axi-clkgen-2.00.a".
-- #clock-cells : from common clock binding; Should always be set to 0.
-- reg : Address and length of the axi-clkgen register set.
-- clocks : Phandle and clock specifier for the parent clock(s). This must
-	either reference one clock if only the first clock input is connected or two
-	if both clock inputs are connected. For the later case the clock connected
-	to the first input must be specified first.
-
-Optional properties:
-- clock-output-names : From common clock binding.
-
-Example:
-	clock@ff000000 {
-		compatible = "adi,axi-clkgen";
-		#clock-cells = <0>;
-		reg = <0xff000000 0x1000>;
-		clocks = <&osc 1>;
-	};
-- 
2.43.0



