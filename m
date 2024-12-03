Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099FB1E3DED;
	Tue,  3 Dec 2024 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239603; cv=none; b=OGW1n/ufcpfijgMkA3kkaNVwUgaRyOPBzDghlD/sPKY0fBvyDet/nOP9eWolTEgbj/4t3+L9mFoNNLfJBC26mz7rSyExPtHofMZJdwoQQ0/fxGDCa5ZbsiEqOc9J6vf2ESlK1dyA8NvsfbYw5DT9l0tx0TxmotAn1Cq4Jhy+Lzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239603; c=relaxed/simple;
	bh=KwEN/lTHwoPfnTckeL93nBUiRV7Rtzs1+hR/3l58WRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ezAyavb6f9TIIE9BJx/ERANZi8SZIh5d7B89KdwXZL66yBomZgDxCTzy6L/dYELci2s2I0TlYPxbY6iL8qxSefa0iShWWqPXPDV2O+Xd3IvmstJSgeS0JLFYgabiLaXcBbNDbttAar1cLtsL5xbLVUBpprKpUq5hVzf3IwlP7Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UhzD13RQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UhzD13RQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 855EFC4CECF;
	Tue,  3 Dec 2024 15:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239602;
	bh=KwEN/lTHwoPfnTckeL93nBUiRV7Rtzs1+hR/3l58WRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UhzD13RQ4fDEohMreFUz7CLUqmUaI+JU5wVZUldjQTw7FfTFmowdqeXSQh5f71fuY
	 an7Gf2YFWw01Fam7KdiZ/Q6I6Vh/q1ObV/5JwxeVTyaxwafEHbf2hw5Eq+QkgG8g93
	 n0vuwo+S/YyHPnd39e4KhpkDW0Kqnu4UIFDTKC8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Angelo Dureghello <adureghello@baylibre.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.11 670/817] dt-bindings: iio: dac: ad3552r: fix maximum spi speed
Date: Tue,  3 Dec 2024 15:44:02 +0100
Message-ID: <20241203144022.109351416@linuxfoundation.org>
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
@@ -30,7 +30,7 @@ properties:
     maxItems: 1
 
   spi-max-frequency:
-    maximum: 30000000
+    maximum: 66000000
 
   reset-gpios:
     maxItems: 1


