Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A76015FA85;
	Mon, 27 May 2024 18:59:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836370; cv=none; b=q9GwAp6XeT0oj+Ek5LaysDxM6lWbXZOrWQQWmKxf/wf3HvioAtKQc/IvSxWIlEebyHDE2PHIDG0fuTlnNG4QVFTWEex+qJ9xP2Ugi8DHNBj7ukSaPo7FxCMCRopca5/w4gVa4GhtVP+9P+Ivw6x6Jd3E1OiCnKDW8igx9uKbG54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836370; c=relaxed/simple;
	bh=NXbNzWKrkKMUhGFh2h789WVm5DMDHVN+o90BjPhdpMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qMixz9wnHJdIVLeyXpvSsfs6odBJd4UiQ8jl528toTsRjF0RJu/dV15LWJ7RGOx+tKsobG6/hEmU7+yXB6JmlexybLbpoetRnYZ6hbdQv0LQWrkv1BLLJG/x6OQPkQGJgfPZyTsnBsGuO39YfgbTFC4Eq3cfuMh/dk8w8CV3HIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td2C5rr2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td2C5rr2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023E6C2BBFC;
	Mon, 27 May 2024 18:59:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836370;
	bh=NXbNzWKrkKMUhGFh2h789WVm5DMDHVN+o90BjPhdpMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Td2C5rr2ctMXo3NjljxLsMad3GGGTDaSFuBjY+J7bNRdHqxx3uno0MdXjTYLpEcCM
	 KD5cIfderd0yPN0Z+dF4rEH2qitN9mt771BIoukv0C1z7xDV8WwC6vNcqxYbyzarOT
	 vj4ErUU1UJBHQD/P817RcmbVX639phZY7a/EJhY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Nuno Sa <nuno.sa@analog.com>,
	Stable@ver.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.9 027/427] dt-bindings: adc: axi-adc: add clocks property
Date: Mon, 27 May 2024 20:51:14 +0200
Message-ID: <20240527185604.199679590@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

commit 19fb11d7220b8abc016aa254dc7e6d9f2d49b178 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/adi,axi-adc.yaml |    5 +++++
 1 file changed, 5 insertions(+)

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


