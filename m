Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E1B6110
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 18:37:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E51AC433EF;
	Wed, 15 Mar 2023 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678905453;
	bh=cJdEtVm6ODIXJfM6lGV664xSH31/t/E20tGUJ18IXTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sEp1zFiDnCcpNjIbJvqLNDY0r52uXKTzoTgUGECmJCfamQJLhTuinwfCDEfiM1F25
	 MGKwL5EjGDuPPjWHbq6p3vJh+qZVWtkweEySohmgalsA6LHrG3wRYIftkodt3dlALs
	 fRHTiDNzuoqLqwhvdiJHZGCHdMN99XBpgq8DnDWw+Gp1qLnOVkUXc4lHwOFn1qSshB
	 ywoe2Pk48NlQrDT53b3Nkc7U4LWy6CpN2a26CMT/QTtAVgKkbnmWy8VxMum9uE30MC
	 m2snV7OBoCjdaf2UdN7pRId2e8Yl/58bzR4Bd9ki0qqfGogkUTEVdBgNKS4YcEyqSb
	 ARBTGzL60SV+w==
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
Subject: [PATCH v2 04/11] dt-bindings: test: Add KUnit empty node binding
Date: Wed, 15 Mar 2023 11:37:21 -0700
Message-Id: <20230315183729.2376178-5-sboyd@kernel.org>
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

Describe a binding for an empty device node used by KUnit tests to
confirm overlays load properly.

Cc: Rob Herring <robh+dt@kernel.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>
Cc: David Gow <davidgow@google.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../bindings/test/test,kunit-empty.yaml       | 30 +++++++++++++++++++
 1 file changed, 30 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/test/test,kunit-empty.yaml

diff --git a/Documentation/devicetree/bindings/test/test,kunit-empty.yaml b/Documentation/devicetree/bindings/test/test,kunit-empty.yaml
new file mode 100644
index 000000000000..592fd06031b8
--- /dev/null
+++ b/Documentation/devicetree/bindings/test/test,kunit-empty.yaml
@@ -0,0 +1,30 @@
+# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+%YAML 1.2
+---
+$id: http://devicetree.org/schemas/clock/test,kunit-empty.yaml#
+$schema: http://devicetree.org/meta-schemas/core.yaml#
+
+title: KUnit empty node
+
+maintainers:
+  - David Gow <davidgow@google.com>
+  - Brendan Higgins <brendanhiggins@google.com>
+
+description: |
+  An empty node to confirm KUnit can load device tree overlays.
+
+properties:
+  compatible:
+    const: test,kunit-empty
+
+required:
+  - compatible
+
+additionalProperties: false
+
+examples:
+  - |
+    kunit-node {
+      compatible = "test,kunit-empty";
+    };
+...
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

