Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 541166112
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 18:37:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF6CEC433A4;
	Wed, 15 Mar 2023 18:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678905455;
	bh=hFEwMRM75Gh9vFWXQy+p8pjvVTIDQeLRyGLEW21bVp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nG9+XV+g0cLGaGP512GRzzmUD+Atp4ZSqggcxnqeJIyykyfRIVDK1hYgVdUir5f79
	 NSqxZFkpvAob1R2OA2Ed1raIYn8OY63gCmkgfzO9gHlkoHZFUSmtWm4D10TzTKk3oC
	 8wCUR2IXTo79e87UgiFCcmVx09kaVlph5Nb1jpBB5TNUv+HyUnggbmSSY94UBJ7eN1
	 +zwJtVHa0/lELTnmaKwbN0f4NDum7qRWSSPF+GXMWxUcu19LNSg1iBRGMnJ32ot3Z0
	 9L5dVTk6T9RtOy/n51FsYWLfCI9Ex05Z0U7Ah4IwnXWFWZl1VMC46V6xF/hsicRVT6
	 1DjOlGODFSmbg==
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
Subject: [PATCH v2 07/11] dt-bindings: kunit: Add fixed rate clk consumer test
Date: Wed, 15 Mar 2023 11:37:24 -0700
Message-Id: <20230315183729.2376178-8-sboyd@kernel.org>
X-Mailer: git-send-email 2.40.0.rc1.284.g88254d51c5-goog
In-Reply-To: <20230315183729.2376178-1-sboyd@kernel.org>
References: <20230315183729.2376178-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Describe a binding for a device that consumes a fixed rate clk in DT so
that a KUnit test can get the clk registered by of_fixed_clk_setup() and
test that it is setup properly.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../kunit/test,clk-kunit-fixed-rate.yaml      | 35 +++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed-rate.yaml

diff --git a/Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed-rate.yaml b/Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed-rate.yaml
new file mode 100644
index 000000000000..58d7826d9c14
--- /dev/null
+++ b/Documentation/devicetree/bindings/kunit/test,clk-kunit-fixed-rate.yaml
@@ -0,0 +1,35 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/kunit/test,clk-kunit-fixed-rate.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: KUnit clk fixed rate test clk consumer
+
+maintainers:
+  - Stephen Boyd <sboyd@kernel.org>
+
+description: |
+  A clk consumer of a fixed rate clk used to test the fixed rate clk
+  implementation in the Linux kernel.
+
+properties:
+  compatible:
+    const: test,clk-kunit-fixed-rate
+
+  clocks:
+    maxItems: 1
+
+required:
+  - compatible
+  - clocks
+
+additionalProperties: false
+
+examples:
+  - |
+    clock-consumer {
+      compatible = "test,clk-kunit-fixed-rate";
+      clocks = <&fixed_clk>;
+    };
+...
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

