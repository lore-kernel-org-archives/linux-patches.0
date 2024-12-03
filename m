Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2311E1F473A;
	Tue,  3 Dec 2024 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239600; cv=none; b=AjdOAsxYb8LgyDrIhJ/Zn4of9yCpM9K6F1eSdVtdUJdsJzrZci3QPQjWspDSFrLSf0hUL8cmSZZy9pzhL/bR9HUU4aojq2y4QvpSNPjEpe3nbFJ1YgIxbz3ebVwtqRefsRXPzAswex9OWms11a4vEDnTCY7UXyPE24JHfRMSxPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239600; c=relaxed/simple;
	bh=MoVFtI5+rQGFearqxmTUgIGx9fZEL9T7uzUsnNi94VU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTCoiG3c5fC7z5d23g0SE4yooRSPyOHMOBhQmgNRI0r1gdQ6fYjFpnp/bye3rqY7ehL541EcR+r2V/KjPpUHW49WpwkVrCu/iKn1MnFl0cHAjxluVBEBk1fRT+49JhrrPFCMrJcEGpDDWnTa0y4pZKf9HopBFtXOICWnmtwUYww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h+ghDEF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h+ghDEF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D438C4CECF;
	Tue,  3 Dec 2024 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239600;
	bh=MoVFtI5+rQGFearqxmTUgIGx9fZEL9T7uzUsnNi94VU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h+ghDEF3kRQiBxlK+n5nnv22ylEHkPDiH8iAcnjdUYXzH00k1UkE5oRylwAk4h5uu
	 aTPDPWAiIbkl+WtUAPmF7HCPNXkqX6g7l1aMVHT8Fwf04sa7RYCJX1OmQTQr9kZfWJ
	 LGxccMf0t/3Ik8vhGUi091BRVGjQwok7vOQ9pzxM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.11 669/817] dt-bindings: pinctrl: samsung: Fix interrupt constraint for variants with fallbacks
Date: Tue,  3 Dec 2024 15:44:01 +0100
Message-ID: <20241203144022.071161922@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ffb30875172eabff727e2896f097ccd4bb68723f upstream.

Commit 904140fa4553 ("dt-bindings: pinctrl: samsung: use Exynos7
fallbacks for newer wake-up controllers") added
samsung,exynos7-wakeup-eint fallback to some compatibles, so the
intention in the if:then: conditions was to handle the cases:

1. Single Exynos7 compatible or Exynos5433+Exynos7 or
   Exynos7885+Exynos7: only one interrupt

2. Exynos850+Exynos7: no interrupts

This was not implemented properly however and if:then: block matches
only single Exynos5433 or Exynos7885 compatibles, which do not exist in
DTS anymore, so basically is a no-op and no enforcement on number of
interrupts is made by the binding.

Fix the if:then: condition so interrupts in the Exynos5433 and
Exynos7885 wake-up pin controller will be properly constrained.

Fixes: 904140fa4553 ("dt-bindings: pinctrl: samsung: use Exynos7 fallbacks for newer wake-up controllers")
Cc: stable@vger.kernel.org
Acked-by: Rob Herring (Arm) <robh@kernel.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20241015065848.29429-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/pinctrl/samsung,pinctrl-wakeup-interrupt.yaml |   19 +++++-----
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/Documentation/devicetree/bindings/pinctrl/samsung,pinctrl-wakeup-interrupt.yaml
+++ b/Documentation/devicetree/bindings/pinctrl/samsung,pinctrl-wakeup-interrupt.yaml
@@ -91,14 +91,17 @@ allOf:
   - if:
       properties:
         compatible:
-          # Match without "contains", to skip newer variants which are still
-          # compatible with samsung,exynos7-wakeup-eint
-          enum:
-            - samsung,s5pv210-wakeup-eint
-            - samsung,exynos4210-wakeup-eint
-            - samsung,exynos5433-wakeup-eint
-            - samsung,exynos7-wakeup-eint
-            - samsung,exynos7885-wakeup-eint
+          oneOf:
+            # Match without "contains", to skip newer variants which are still
+            # compatible with samsung,exynos7-wakeup-eint
+            - enum:
+                - samsung,exynos4210-wakeup-eint
+                - samsung,exynos7-wakeup-eint
+                - samsung,s5pv210-wakeup-eint
+            - contains:
+                enum:
+                  - samsung,exynos5433-wakeup-eint
+                  - samsung,exynos7885-wakeup-eint
     then:
       properties:
         interrupts:


