Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B91D2F2370;
	Tue, 17 Jun 2025 16:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177958; cv=none; b=nMlA2Vq3sqYTFZUWGzUjKrjPNQCk+XUW9mo9L1t5moeL/ohfX1IAvgy2AtY6/Ybl5xg8SFBBIOhwuA+tSaREA/ZxwQYrayIdheWehypeDjVDZ2NpXifoZfl3/Zz5j8qKYKYIoI+heshvT+1fkSiJLrbKDiq+4UDsped7mcK6tUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177958; c=relaxed/simple;
	bh=0cgrny0a2sB6eYytrn7F3bkDknrVsze/Z1n2AsF2LXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pd552GvewFw50zNNtXrttZH5Y6UCgwmqppmeeSFAbauDGRAGLWs2/uKTQZrHoXc6twiAqxRcVRZK7aWL2BaQZ570ZLMpiQRG2Eqbvsm2J5VGB8YZ9mofEBzVIWVSG+edalmQU6rhxSzFgoAg34cg7TGqiaV1f/1kWKjJ1Gkbwd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWiL4eBm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWiL4eBm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED30C4CEE3;
	Tue, 17 Jun 2025 16:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177957;
	bh=0cgrny0a2sB6eYytrn7F3bkDknrVsze/Z1n2AsF2LXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWiL4eBmAgAxU7VsAq1i9AFmmGSTU/5jEM8LX11AD3o6ozn13rcA6JAXxZ4C2XEBI
	 8UGcw7LUYiqf7mNBxQt30ycFgrLgWNOwaLiiBszy42ZjEs3avPuBhvMJZz6r0Sde3k
	 InnNxvkhTZc5wjsdyWABzv+AyomhN7iUEplfSAQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Nuno Sa <nuno.sa@analog.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 415/512] dt-bindings: pwm: Correct indentation and style in DTS example
Date: Tue, 17 Jun 2025 17:26:21 +0200
Message-ID: <20250617152436.397572503@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit 78dcad6daa405b8a939cd08f6ccd6c4e2cb50a9c ]

DTS example in the bindings should be indented with 2- or 4-spaces and
aligned with opening '- |', so correct any differences like 3-spaces or
mixtures 2- and 4-spaces in one binding.

No functional changes here, but saves some comments during reviews of
new patches built on existing code.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Acked-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20250107125831.225068-1-krzysztof.kozlowski@linaro.org
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Stable-dep-of: e683131e64f7 ("dt-bindings: pwm: adi,axi-pwmgen: Fix clocks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml | 8 ++++----
 .../devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml         | 8 ++++----
 Documentation/devicetree/bindings/pwm/brcm,kona-pwm.yaml  | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
index aa35209f74cfa..45e112d0efb46 100644
--- a/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
+++ b/Documentation/devicetree/bindings/pwm/adi,axi-pwmgen.yaml
@@ -41,8 +41,8 @@ unevaluatedProperties: false
 examples:
   - |
     pwm@44b00000 {
-       compatible = "adi,axi-pwmgen-2.00.a";
-       reg = <0x44b00000 0x1000>;
-       clocks = <&spi_clk>;
-       #pwm-cells = <3>;
+        compatible = "adi,axi-pwmgen-2.00.a";
+        reg = <0x44b00000 0x1000>;
+        clocks = <&spi_clk>;
+        #pwm-cells = <3>;
     };
diff --git a/Documentation/devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml b/Documentation/devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml
index 119de3d7f9dd7..44548a9da1580 100644
--- a/Documentation/devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/brcm,bcm7038-pwm.yaml
@@ -35,8 +35,8 @@ additionalProperties: false
 examples:
   - |
     pwm: pwm@f0408000 {
-       compatible = "brcm,bcm7038-pwm";
-       reg = <0xf0408000 0x28>;
-       #pwm-cells = <2>;
-       clocks = <&upg_fixed>;
+        compatible = "brcm,bcm7038-pwm";
+        reg = <0xf0408000 0x28>;
+        #pwm-cells = <2>;
+        clocks = <&upg_fixed>;
     };
diff --git a/Documentation/devicetree/bindings/pwm/brcm,kona-pwm.yaml b/Documentation/devicetree/bindings/pwm/brcm,kona-pwm.yaml
index e86c8053b366a..fd785da5d3d73 100644
--- a/Documentation/devicetree/bindings/pwm/brcm,kona-pwm.yaml
+++ b/Documentation/devicetree/bindings/pwm/brcm,kona-pwm.yaml
@@ -43,9 +43,9 @@ examples:
     #include <dt-bindings/clock/bcm281xx.h>
 
     pwm@3e01a000 {
-       compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
-       reg = <0x3e01a000 0xcc>;
-       clocks = <&slave_ccu BCM281XX_SLAVE_CCU_PWM>;
-       #pwm-cells = <3>;
+        compatible = "brcm,bcm11351-pwm", "brcm,kona-pwm";
+        reg = <0x3e01a000 0xcc>;
+        clocks = <&slave_ccu BCM281XX_SLAVE_CCU_PWM>;
+        #pwm-cells = <3>;
     };
 ...
-- 
2.39.5



