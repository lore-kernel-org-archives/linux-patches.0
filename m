Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDC1991D0;
	Thu,  6 Jun 2024 14:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683670; cv=none; b=j3WUvNsQO4aZfpkK70jQmPXhYIZLumUQpsYVB4lqzYC/3W62z93spkRPEXbxg6meR4m2Tj/AzrXSmd+qSiyNM4lpc2Y2xxxGM1G318n8Vho63t80+nURIrgOcwCvWCeju4ygyaDgqYnGwLpy/Z15bER5kP62Uws+bnp6/Dye1gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683670; c=relaxed/simple;
	bh=YYcXYmfz1PtXxiTYrv84rcZ6NRR0b2TZUDeG7v2i7GY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sebYChcGCs/F1XFX4b2sS/aIKOfw1rVpOvZFwxU+7Y96r3ML5vkJD/j6Zy8Xy6ZCtgvxFk4llFxV8Y3TwQqzrBEyQYS93EPg1vqlZ2BawDiuWdpTkZA8Mllp5vq/E/bdlXoEC8/ETMP+UXxSuvTBj1MjuxzQEbfId40CYmmCk2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XOp9mLaY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XOp9mLaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE4EC2BD10;
	Thu,  6 Jun 2024 14:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683670;
	bh=YYcXYmfz1PtXxiTYrv84rcZ6NRR0b2TZUDeG7v2i7GY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XOp9mLaYQnUwqUyKqu1tcfMdE9ePJ59EpohC3qlYyd0SVoaNXvGxjBWfXCyYY5frB
	 GQ0//e8k3y3EJFggP1wg86bS6XX/PRSiGvF8bzKxuIf/i9DjEPt0VluSGpdN/YYzdh
	 /HjxKZ8wfgimNyFCEjUVbxaYDBu50hhmBbJSPrTo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@ver.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 558/744] dt-bindings: adc: axi-adc: add clocks property
Date: Thu,  6 Jun 2024 16:03:50 +0200
Message-ID: <20240606131750.356074577@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit 19fb11d7220b8abc016aa254dc7e6d9f2d49b178 ]

Add a required clock property as we can't access the device registers if
the AXI bus clock is not properly enabled.

Note this clock is a very fundamental one that is typically enabled
pretty early during boot. Independently of that, we should really rely on
it to be enabled.

Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Fixes: 96553a44e96d ("dt-bindings: iio: adc: add bindings doc for AXI ADC driver")
Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240426-ad9467-new-features-v2-3-6361fc3ba1cc@analog.com
Cc: <Stable@ver.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml b/Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml
index 3d49d21ad33df..e1f450b80db27 100644
--- a/Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml
@@ -28,6 +28,9 @@ properties:
   reg:
     maxItems: 1
 
+  clocks:
+    maxItems: 1
+
   dmas:
     maxItems: 1
 
@@ -48,6 +51,7 @@ required:
   - compatible
   - dmas
   - reg
+  - clocks
 
 additionalProperties: false
 
@@ -58,6 +62,7 @@ examples:
         reg = <0x44a00000 0x10000>;
         dmas = <&rx_dma 0>;
         dma-names = "rx";
+        clocks = <&axi_clk>;
         #io-backend-cells = <0>;
     };
 ...
-- 
2.43.0



