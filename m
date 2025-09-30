Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B174306B1C;
	Tue, 30 Sep 2025 15:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244999; cv=none; b=ePrB8/KiSWFQD7MdcJj6C1hEyiXIU1oklx6qdaSX4svyptC/dcRHlLhts8Vuy5ElL3HscRQqxPxdXDAt90ZrSOBFXfcIsTu7jZ5S6rV5DfQq+lrRMtXJ94TSK+iKlctaQNzQmkdfvByNN9nzmlAmDeTtXIYcCfgvknxcG+mjjfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244999; c=relaxed/simple;
	bh=DFtG/55r9+aB0j+FwfSkvABmEhStiCQ52K6TlX0ZsYE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRtvkWDCqxHe1N2DICb5tv6MZWpyeU4uOJLsYegyeMp6cXcV64VUUpj2jC//J/1Zlv+vE9YBIzynO488kO+k22gcp/7GOGGhmRfPo66hYQEoNATWOBaLJ9jJG7uygq5yB+pFafUsH0w9b++tNA0wNumbjCR/EokLB7asw+XYEvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k8QvqMUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k8QvqMUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D5DAC113D0;
	Tue, 30 Sep 2025 15:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244999;
	bh=DFtG/55r9+aB0j+FwfSkvABmEhStiCQ52K6TlX0ZsYE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k8QvqMUV9zmTs6DIJQPUfGHtlAZ/WAiJ91FmxBUsMqadg/lUdq6J5m84S7GrY4Uij
	 b9KOmATTjOSf3a7uwHIDYY3+CV1VVBTCdj2JsqrSp4iqYltxMe4+fLkUGWO0Y5meWP
	 Vbz74KOqVtiYlOUwfO6Y5KkJBrdpPNfs0myWNeJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 5.15 035/151] dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks
Date: Tue, 30 Sep 2025 16:46:05 +0200
Message-ID: <20250930143829.013713565@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143827.587035735@linuxfoundation.org>
References: <20250930143827.587035735@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

commit ee047e1d85d73496541c54bd4f432c9464e13e65 upstream.

Lists should have fixed constraints, because binding must be specific in
respect to hardware, thus add missing constraints to number of clocks.

Cc: stable <stable@kernel.org>
Fixes: 88a499cd70d4 ("dt-bindings: Add support for the Broadcom UART driver")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20250812121630.67072-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
+++ b/Documentation/devicetree/bindings/serial/brcm,bcm7271-uart.yaml
@@ -41,7 +41,7 @@ properties:
           - const: dma_intr2
 
   clocks:
-    minItems: 1
+    maxItems: 1
 
   clock-names:
     const: sw_baud


