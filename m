Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B9B23FD1B;
	Thu, 12 Dec 2024 16:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020112; cv=none; b=PDBkgkOQdVC6iRdwBYg4eV9Vv0fzP0pKu09lpS5aXENt2vTajJEtrzQWW0l9c7f2K5Buc4i5wlx7cdhcnGHJbKUHP044LSYKP2A+7Pc1JSZi1OmVyeF8aAkEh2DlJlzdQwb+luzCfbBURaenKOxkjxqJXtAKApdWaTqBYjcVNHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020112; c=relaxed/simple;
	bh=Cj6VjRn5DS7q1dWH65ZlKGPusE6n44sp5zV/zFQidFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T83i2Vo812TQru0Nbzp8bFF3iGC7oSidr69ZCQTglpJbyUVC56U14hxpwj+ymcnFnmdklbQtziokm+jILrcUYMhK1m7KlpbsXhS2oRhW7X1ul14X4XEPYNKBr9UBrSth+al59iQBRbdwAc3nB3LMwSocXYetIVnT3I9udlpD+9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mz75tWbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mz75tWbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90507C4CECE;
	Thu, 12 Dec 2024 16:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020112;
	bh=Cj6VjRn5DS7q1dWH65ZlKGPusE6n44sp5zV/zFQidFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mz75tWbIu85ty6+MLKBxX1N4D0gV5XYeUTFucFGABG5KRS6KJd8MlBIc6PFjUxNYW
	 3NbdUv01Rr2bMzC/EEmjf1bqqA+OZsjlj2xPh84Jf7e4lzYTpSqsD7pLvYwgCu4gJw
	 +Yy+NL0F8hUo/vwj2DOA3MY54AnqDPod8RPPMLeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.1 380/772] dt-bindings: iio: dac: ad3552r: fix maximum spi speed
Date: Thu, 12 Dec 2024 15:55:25 +0100
Message-ID: <20241212144405.603525517@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Angelo Dureghello <adureghello@baylibre.com>

commit d1d1c117f39b2057d1e978f26a8bd9631ddb193b upstream.

Fix maximum SPI clock speed, as per datasheet (Rev. B, page 6).

Fixes: b0a96c5f599e ("dt-bindings: iio: dac: Add adi,ad3552r.yaml")
Cc: stable@vger.kernel.org
Signed-off-by: Angelo Dureghello <adureghello@baylibre.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20241003-wip-bl-ad3552r-axi-v0-iio-testing-v4-4-ceb157487329@baylibre.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml
+++ b/Documentation/devicetree/bindings/iio/dac/adi,ad3552r.yaml
@@ -26,7 +26,7 @@ properties:
     maxItems: 1
 
   spi-max-frequency:
-    maximum: 30000000
+    maximum: 66000000
 
   reset-gpios:
     maxItems: 1


