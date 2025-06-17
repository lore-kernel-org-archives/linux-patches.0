Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F601285055;
	Tue, 17 Jun 2025 16:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178030; cv=none; b=Kys8AuxSjTXr3a1qjNHqXDxPfdJ2aUHt/vcyj0t1Cb3OF0CPrIprXXAIxrhzIjBvkdB+xlSJXk12USj+XPqzSDH2eA7bSjiXZ00pRlY+zRQju92PdCqhoNTX7pMgD6YMfTPBPWP5ytmDVTqQlYbj1L2ITY2QG4+LWuZ5QdOKEuQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178030; c=relaxed/simple;
	bh=uO+fGwNm24vXdkCKobDWW5elWjgI9A7HdZczaP6rvbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=c/kUnffaDLOwW9YPrs/oYFENyLeVNE+pU8QqbNEFCoptuMI22jGoZeOkc9gaoyNf8EX3zj7kJDBT+Zyx3SBec9utmZ6wUergZDOfV+ygB56/n1Ifs+cZLrqq9cRNd2+lb73JWtMpQ68r/4uMfS4Z7OfHZuhyK/zQsd/3MUwbFh0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HoWZnUr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoWZnUr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52A9FC4CEE3;
	Tue, 17 Jun 2025 16:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178030;
	bh=uO+fGwNm24vXdkCKobDWW5elWjgI9A7HdZczaP6rvbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoWZnUr2jQheG9RDQcIu7IvY9Rk3pD6ZOvBBQB9a5gIFfz0g55R5R9ijeUTKjuMkq
	 RXqZ9hU3RCdezDOmB/R3h89QS33tOEQTVjNqgeaaPlOgRXweBt+zUJOOOCAPCEvteP
	 t+EVHJrN5c/fzHTPh/fG5gkEE13/8E99GrNLP01Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 416/512] dt-bindings: pwm: adi,axi-pwmgen: Fix clocks
Date: Tue, 17 Jun 2025 17:26:22 +0200
Message-ID: <20250617152436.435526956@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Lechner <dlechner@baylibre.com>

[ Upstream commit e683131e64f71e957ca77743cb3d313646157329 ]

Fix a shortcoming in the bindings that doesn't allow for a separate
external clock.

The AXI PWMGEN IP block has a compile option ASYNC_CLK_EN that allows
the use of an external clock for the PWM output separate from the AXI
clock that runs the peripheral.

This was missed in the original bindings and so users were writing dts
files where the one and only clock specified would be the external
clock, if there was one, incorrectly missing the separate AXI clock.

The correct bindings are that the AXI clock is always required and the
external clock is optional (must be given only when HDL compile option
ASYNC_CLK_EN=1).

Fixes: 1edf2c2a2841 ("dt-bindings: pwm: Add AXI PWM generator")
Cc: stable@vger.kernel.org
Signed-off-by: David Lechner <dlechner@baylibre.com>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250529-pwm-axi-pwmgen-add-external-clock-v3-2-5d8809a7da91@baylibre.com
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pwm/adi,axi-pwmgen.yaml     | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
index 45e112d0efb46..5575c58357d6e 100644
--- a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
+++ b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
@@ -30,11 +30,19 @@ properties:
     const: 3
 
   clocks:
-    maxItems: 1
+    minItems: 1
+    maxItems: 2
+
+  clock-names:
+    minItems: 1
+    items:
+      - const: axi
+      - const: ext
 
 required:
   - reg
   - clocks
+  - clock-names
 
 unevaluatedProperties: false
 
@@ -43,6 +51,7 @@ examples:
     pwm@44b00000 {
         compatible = "adi,axi-pwmgen-2.00.a";
         reg = <0x44b00000 0x1000>;
-        clocks = <&spi_clk>;
+        clocks = <&fpga_clk>, <&spi_clk>;
+        clock-names = "axi", "ext";
         #pwm-cells = <3>;
     };
-- 
2.39.5



