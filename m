Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A06D9EA8
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25C5C433D2;
	Thu,  2 Mar 2023 01:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1677721109;
	bh=/l+SZdmlEj6k/2KkGkyZGLbEgxbQ4jmIkEvZrUe5VZs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m6Rk22s1o6bU0lm2Ynjuyb6MIDTN+qyyMJiFSr1BXExoXWkZqzXLDKkf3hBns0OQD
	 Fu4gxDGugxNn39ZJXiGN7GkSXKt1MXixXjLBeHmxivEWKLYO0ah4cVvjRUfCjitHEW
	 SoDckBVLBvh9sQ/m/4Ge6IM8Q2lmBIP05Fnmx8dPmB/FPFYgaY6Ms85AcXzLcaoRHm
	 9GcPolkHoK8M0Nva04vWUO28cKR4sK6L2xGZpGvvWmouuf965qHjBXYXeVn2xFFHLo
	 67whL7JZkCIevfHzUd7nHEJqYyhLjmMB2N5Nuw4ZzC0tgLGjFqEYRVAYNK+kesBJje
	 QOI7UAvT1e9LA==
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
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Vincent Whitchurch <vincent.whitchurch@axis.com>,
	Rob Herring <robh+dt@kernel.org>,
	Frank Rowand <frowand.list@gmail.com>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	devicetree@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-kselftest@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: [PATCH 7/8] dt-bindings: clk: Add KUnit clk_parent_data test
Date: Wed,  1 Mar 2023 17:38:20 -0800
Message-Id: <20230302013822.1808711-8-sboyd@kernel.org>
X-Mailer: git-send-email 2.39.2.722.g9855ee24e9-goog
In-Reply-To: <20230302013822.1808711-1-sboyd@kernel.org>
References: <20230302013822.1808711-1-sboyd@kernel.org>
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
 .../clock/linux,clk-kunit-parent-data.yaml    | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/clock/linux,clk-kunit-parent-data.yaml

diff --git a/Documentation/devicetree/bindings/clock/linux,clk-kunit-parent-data.yaml b/Documentation/devicetree/bindings/clock/linux,clk-kunit-parent-data.yaml
new file mode 100644
index 000000000000..29609e07c115
--- /dev/null
+++ b/Documentation/devicetree/bindings/clock/linux,clk-kunit-parent-data.yaml
@@ -0,0 +1,47 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/linux,clk-kunit-parent-data.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: KUnit clk provider for clk_parent_data unit tests
+
+maintainers:
+  - Stephen Boyd <sboyd@kernel.org>
+
+description: |
+  A clk provider to test the struct clk_parent_data implementation in the Linux
+  kernel.
+
+properties:
+  compatible:
+    const: linux,clk-kunit-parent-data
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
+      compatible = "linux,clk-kunit-parent-data";
+      #clock-cells = <1>;
+      clocks = <&fixed_parent>, <&fixed_50MHz>;
+      clock-names = "parent_fwname", "50";
+    };
+...
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

