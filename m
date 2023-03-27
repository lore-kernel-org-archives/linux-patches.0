Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6A1379DD
	for <patches@lists.linux.dev>; Mon, 27 Mar 2023 22:22:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 423F6C4339C;
	Mon, 27 Mar 2023 22:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1679955727;
	bh=2Hped3KY6Uk2Oc/RHdUAUuvCu9fegBzwhk+dDaq1CSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lAyNd0WoR1WcvvMf+8Wb4XJei0r0zHaAMVOg+st4WmC77BMhUQBudfLNQ9S0JKafa
	 Y7uedc/ieLIIzblkbrx7ktwUd03utg9POvdqQGaX+sa+MeARGeEUtn7wT8oWlcGQvQ
	 V9Mmh1TZrB0phjvNmYyuB+vrGOzjTvm87qFwtB1s7ASHY3lRy6WWow0GsftwGTd3UV
	 RI/MRHDN3W+k6KlaQxsBlwqQ1slq4lSt+iVW22pW1uzTG9AQ2TGdH1MRF6x5tn0Gv5
	 KhKCL6qL/cpaWmgfqjb9YroXiVcBcpU5tzU6z7cunHwGOp8Yrp5lJ93uoCjbzsnJho
	 Vl9UGj8/5g0qA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com,
	Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH v3 10/11] dt-bindings: clk: Add KUnit clk_parent_data test
Date: Mon, 27 Mar 2023 15:21:58 -0700
Message-Id: <20230327222159.3509818-11-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.348.gf938b09366-goog
In-Reply-To: <20230327222159.3509818-1-sboyd@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe a binding for a device that provides and consumes clks in DT so
that a KUnit test can register clks based on the device node and test
clk_hw_register() with clk_parent_data.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../bindings/clock/test,clk-parent-data.yaml  | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/test,clk-parent-data.yaml

diff --git a/Documentation/devicetree/bindings/clock/test,clk-parent-data.yaml b/Documentation/devicetree/bindings/clock/test,clk-parent-data.yaml
new file mode 100644
index 000000000000..a2f927526405
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/test,clk-parent-data.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/test,clk-parent-data.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: Fake clk provider for clk_parent_data unit tests
+
+maintainers:
+  - Stephen Boyd <sboyd@kernel.org>
+
+description:
+  A clk provider to test the struct clk_parent_data implementation in the Linux
+  kernel.
+
+properties:
+  compatible:
+    const: test,clk-parent-data
+
+  clocks:
+    items:
+      - description: Fixed parent
+      - description: 50 MHz fixed parent
+
+  clock-names:
+    items:
+      - const: parent_fwname
+      - const: "50"
+
+  "#clock-cells":
+    const: 1
+
+required:
+  - compatible
+  - "#clock-cells"
+
+additionalProperties: false
+
+examples:
+  - |
+    clock-controller {
+      compatible = "test,clk-parent-data";
+      #clock-cells = <1>;
+      clocks = <&fixed_parent>, <&fixed_50MHz>;
+      clock-names = "parent_fwname", "50";
+    };
+...
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

