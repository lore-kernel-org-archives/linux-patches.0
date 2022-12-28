Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6691C08
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC3CC433D2;
	Wed, 28 Dec 2022 16:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672245534;
	bh=JH5j5OjiQg6T6PQWlLUOw6ZJsnTatWQk95JArwO1l20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IihFicR1avLOTZ5wOLEhVAvpYSEqsDG0hDM0yH6kf7RZreS6b4RDGkKES4CEsLYbi
	 gal7W5NWyMy0jrF2Jfkmk7VLJ8qpZrg9KKt4tuLons/Dw3XCTnWBClPiZqDDLeBgAz
	 dFAMPTAQ+PA6nmpNza/Fi2AEnUgkcysMw91U8iFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0877/1146] dt-bindings: mfd: qcom,spmi-pmic: Drop PWM reg dependency
Date: Wed, 28 Dec 2022 15:40:16 +0100
Message-Id: <20221228144353.984110875@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bryan O'Donoghue <bryan.odonoghue@linaro.org>

[ Upstream commit 763ab98687404d924b6612f7c9c8430333d31229 ]

The PWM node is not a separate device and is expected to be part of parent
SPMI PMIC node, thus it obtains the address space from the parent. One IO
address in "reg" is also not correct description because LPG block maps to
several regions.

Fixes: 3f5117be9584 ("dt-bindings: mfd: convert to yaml Qualcomm SPMI PMIC")
Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20220928000517.228382-2-bryan.odonoghue@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
index 6a3e3ede1ede..777f2da52f1e 100644
--- a/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
+++ b/Documentation/devicetree/bindings/mfd/qcom,spmi-pmic.yaml
@@ -98,6 +98,10 @@ properties:
     type: object
     $ref: /schemas/regulator/qcom,spmi-regulator.yaml#
 
+  pwm:
+    type: object
+    $ref: /schemas/leds/leds-qcom-lpg.yaml#
+
 patternProperties:
   "^adc@[0-9a-f]+$":
     type: object
@@ -123,10 +127,6 @@ patternProperties:
     type: object
     $ref: /schemas/power/reset/qcom,pon.yaml#
 
-  "pwm@[0-9a-f]+$":
-    type: object
-    $ref: /schemas/leds/leds-qcom-lpg.yaml#
-
   "^rtc@[0-9a-f]+$":
     type: object
     $ref: /schemas/rtc/qcom-pm8xxx-rtc.yaml#
-- 
2.35.1



