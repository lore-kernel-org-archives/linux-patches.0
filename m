Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860B578C6D;
	Tue,  7 May 2024 21:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715116092; cv=none; b=QeZcd1pLsvYmW5beETJN1nVR/ZL+8HbOelsnwHEULf6xIeGgFZNvHO7ddfHBuCVEQOdRBxqlqoQTVlQmwZpRLK3evWnL2/whq1T2NcaglHNWw0NZxHxhpHk9ngwrrYg6P5NvhsW4dBkfgCog8hRdywIv4vCLflBjYkV0Uy0iZXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715116092; c=relaxed/simple;
	bh=vTdduva3vrK34NCEK9Tt5brJHXAQ1aJfLa13W+BOfIs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JypQn5YmLoCECf8ZM+MWSzTMNtwT0hW0Cc0CqqTNZ+itwBcBneZh4D+dXHv25XCAE4o7Tzz9cwGiO3B/JSUaNSzpsiy5qi8jYQZTxPPOqiHnKqQ0XjbDBlYdTktAwGb5KdceQJE7QTc3OUJ1zKYlJCf0ka4Zb5jH3dS0VoHQ73M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=POgFa+Yd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="POgFa+Yd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C55DDC4AF67;
	Tue,  7 May 2024 21:08:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715116092;
	bh=vTdduva3vrK34NCEK9Tt5brJHXAQ1aJfLa13W+BOfIs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=POgFa+YdhtsVHrGZDBEFTcWO5xnKAL1zmQ7/xfLkLVjH06XcRvcdIm75uBiyUwVtI
	 j7EO97YscuOA14A50YyB06Mr46CvB/hzJuOcMiu8BPtpQIxKinQ69b95lzXE4jMrN+
	 1MbtLmak3b3bmCfLRdDpKOYvIOD7+YAHvQ9Ln3Ydzap3gv+b+s4n3k7mo7kjoPt8f9
	 7S8u5g4VeGwOzz1kRUEQB+GIHSjgPsEo3LODFT4qhXKT09AFw1c/p9VGoe7nZ1lODK
	 i1FN4iRp/VoHAMVEkTwW8rwVTtj4Ivj9eWc9Gh/2SyRObIDY7R52CceUoVGWvjXd+i
	 Vy2QPjCCgErNw==
From: Stephen Boyd <sboyd@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Johan Hovold <johan+linaro@kernel.org>,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 02/12] dt-bindings: spmi: hisilicon,hisi-spmi-controller: fix binding references
Date: Tue,  7 May 2024 14:07:39 -0700
Message-ID: <20240507210809.3479953-3-sboyd@kernel.org>
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

Fix up the free text binding references which were not updated when
moving the bindings out of staging and which had a leading current
directory component, respectively.

Fixes: 9bd9e0de1cf5 ("mfd: hi6421-spmi-pmic: move driver from staging")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Link: https://lore.kernel.org/r/20231130173757.13011-2-johan+linaro@kernel.org
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 .../bindings/spmi/hisilicon,hisi-spmi-controller.yaml         | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
index f882903769f9..eee7c8d4cf4a 100644
--- a/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
+++ b/Documentation/devicetree/bindings/spmi/hisilicon,hisi-spmi-controller.yaml
@@ -14,7 +14,7 @@ description: |
   It is a MIPI System Power Management (SPMI) controller.
 
   The PMIC part is provided by
-  ./Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml.
+  Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml.
 
 allOf:
   - $ref: spmi.yaml#
@@ -48,7 +48,7 @@ patternProperties:
       PMIC properties, which are specific to the used SPMI PMIC device(s).
       When used in combination with HiSilicon 6421v600, the properties
       are documented at
-      drivers/staging/hikey9xx/hisilicon,hi6421-spmi-pmic.yaml.
+      Documentation/devicetree/bindings/mfd/hisilicon,hi6421-spmi-pmic.yaml
 
 unevaluatedProperties: false
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

