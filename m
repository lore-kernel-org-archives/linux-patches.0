Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32D1C1B3925;
	Wed, 17 Sep 2025 12:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758113831; cv=none; b=WtxOqNt5CvWBE/23dcZpWqHteIznuFLNUA6+QFoWfjNC6vc6tchlIsCYanMMZW5Hm0qTOG9NlVOtQ5VczZ3xZ7+LY/aRcoCnYnymVCd4owf9OA1dddKs7kItBbM+hVesjPcpmGhWmkU498PazhMMiS28Uiokqofjk/YT5VgZnmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758113831; c=relaxed/simple;
	bh=6rMBVZFJ0CCcEl+vY4LEQlO/itRgcHW5X7EP7yd7xTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JC8Kjg6PI8qhaWRO9PHhotiiHqWet8Dwmm4/vSeduJ2xrD3JrUmi1o5R+2xYrti7nhIbW13DqLYdEBTD9zGhdW680dEK6PCKMDvp+A4qnMYGanUUGeVLAIHZEle9AToT8GbLzPRT1GEeWP9neYfYeNkbsgtFVjSfPaWtT5T/yFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=buhGS2jZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="buhGS2jZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A434EC4CEF0;
	Wed, 17 Sep 2025 12:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758113831;
	bh=6rMBVZFJ0CCcEl+vY4LEQlO/itRgcHW5X7EP7yd7xTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=buhGS2jZbGNINT1cpuKaR1+A+cdv1FX3xZuAl7ug4p6LMbqb4HfbwihoujHeke9Q0
	 iDwVFdMx222Z99WkfKfRZMKD17pPUdluOMkBOlWQuesXnRABGUz5+cPJLTQztt9JH0
	 cdAdWd8A3fZ+sOADawwiV0+GlaRUu2yQap5to7e0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH 6.6 064/101] dt-bindings: serial: brcm,bcm7271-uart: Constrain clocks
Date: Wed, 17 Sep 2025 14:34:47 +0200
Message-ID: <20250917123338.390050451@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
References: <20250917123336.863698492@linuxfoundation.org>
User-Agent: quilt/0.68
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


