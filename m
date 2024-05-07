Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1A014B94D;
	Tue,  7 May 2024 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116093; cv=none; b=fPFpoXkuzFSWIir6j4QyYM8PT1WFtBT9/wzVE9oeY4ui6O+SnjpGmm4avoSru752TfEL3ZrIx5EY1ZL4ipGqmul15skt0IBhoovqVt6GWimmBE5/cxTQyraQyJWGhx8F3loenborfY0LI/kVOyG6fmH1tD4yNPoX4MgQZBWc780=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116093; c=relaxed/simple;
	bh=P7YFeCpV4+T0sF0FudJ3/Z9lL7NXj9iDmHlNdiQ0EBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lJ8Ep2U3R6EhGfi1iJcMQB1quhPQ2mjd1OcE/MTT8BaGJ5j3QOx5TNgiMvaHbCBOohJ2S8oFd5owtzEfYrFlzCjwnoQtS/6HhHm1ctWkZCsypZk/Yy8JJoZkMU7+5K3LaGX8KKowGwjzOU/zVUso+BaLgAalCYzp+kyg+WCsiTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H+Udq9h7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H+Udq9h7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB22C3277B;
	Tue,  7 May 2024 21:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116092;
	bh=P7YFeCpV4+T0sF0FudJ3/Z9lL7NXj9iDmHlNdiQ0EBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H+Udq9h7uzXtLqy6Dc067Og3SvYswJPHR9dgxzq7fTKbqxJyih2m6TApVt5e5mGej
	 kzFDH7UDIk3evXXq1bT5XKw8oNDwPApN6JYcTgQrFI9C+7vZps8+cyEmubEfOdjaFg
	 R6cxbtT7ZZCAl+ZP/UEXkotHz27vFbP8POBjMR9tjymrFEOhXDnPirJpAotJpcwRBE
	 L8tw6n3vTE9g6oK3RkfXkNaafOpDcnPSdBhKZW98fSix8gXsqBfYiHoAZbMc5oRMtM
	 qkC2JqzBbZhe/xPhJVkXYyccABLR2AhRxuDwmGu8fCxGRqlFCWH1JEm7GW0UyjZTP2
	 gdLiwmJgpFKSA==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 03/12] dt-bindings: spmi: hisilicon,hisi-spmi-controller: clean up example
Date: Tue,  7 May 2024 14:07:40 -0700
Message-ID: <20240507210809.3479953-4-sboyd@kernel.org>
X-Mailer: git-send-email 2.45.0.rc1.225.g2a3ae87e7f-goog
In-Reply-To: <20240507210809.3479953-1-sboyd@kernel.org>
References: <20240507210809.3479953-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

Clean up the binding example by dropping the unnecessary parent bus
node, using a define for the second register value of the PMIC child and
increasing indentation to four spaces.

Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231130173757.13011-3-johan+linaro@kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../spmi/hisilicon,hisi-spmi-controller.yaml        | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
index eee7c8d4cf4a..3ccf35de3719 100644
--- a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
+++ b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
@@ -54,20 +54,17 @@ unevaluatedProperties: false
 
 examples:
   - |
-    bus {
-      #address-cells = <2>;
-      #size-cells = <2>;
+    #include <dt-bindings/spmi/spmi.h>
 
-      spmi: spmi@fff24000 {
+    spmi@fff24000 {
         compatible = "hisilicon,kirin970-spmi-controller";
+        reg = <0xfff24000 0x1000>;
         #address-cells = <2>;
         #size-cells = <0>;
-        reg = <0x0 0xfff24000 0x0 0x1000>;
         hisilicon,spmi-channel = <2>;
 
         pmic@0 {
-          reg = <0 0>;
-          /* pmic properties */
+            reg = <0 SPMI_USID>;
+            /* pmic properties */
         };
-      };
     };
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

