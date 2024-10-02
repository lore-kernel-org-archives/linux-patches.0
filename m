Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8551B1D0164;
	Wed,  2 Oct 2024 13:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876577; cv=none; b=NEaUc2ECTD5KvDwmCLXWWPThfwtvmUhXwcVGfRRvrPIw5kCrkSPWT83BQ/kyV2ACpAYCeEb0/pvo5J2O9WK3MoOGQEXqhpXOxgfb4AOD7jNEVSPLY9/Cdg0KMaoxxc/RcOrXcM9IxOIC1m+Aa0Dcr9opmb/GQq8rreBm5azNvOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876577; c=relaxed/simple;
	bh=Vv4Cr7hQTabE9bPR0IX2FI2+B7aaz7w+gEWwHDVR1VQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5OwGmHscNJBCKGL2C5e1Oa4IQbLE7lgjxi6zhfgjK1eFjvbkhXLmmbyqcUklPkX36sV2bbQCt1pXFokpBMP8vZxHCChOo+ambkfLg1VMF8hI5jMuy6zxdB2GoA4H+ibvtQhKXgveGT2xUKKrW51eNgf8X5kGjKe+aRwz+BAvNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GI9te2XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GI9te2XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06A5C4CEC5;
	Wed,  2 Oct 2024 13:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876577;
	bh=Vv4Cr7hQTabE9bPR0IX2FI2+B7aaz7w+gEWwHDVR1VQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GI9te2XI/+7PgOU3n/2WFGRj0xYsYhU8gY6K6cz8LgW019ueT0pJNo46t6Evex7nY
	 CBBMKmoQc3iIWYlsDuEVBmzv0w4I5xRSs1d8srtGOJAewGuDyWSziZVLCUHR6L3onS
	 /i3LChMg9lzAzEP45pVI1PMIxq9b3aXWy//6skAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 460/695] dt-bindings: iio: asahi-kasei,ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:57:38 +0200
Message-ID: <20241002125840.817791520@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>

[ Upstream commit c7668ac67bc21aebdd8e2d7f839bfffba31b7713 ]

All compatibles in this binding without prefixes were deprecated, so
adding a new deprecated one after some time is not allowed, because it
defies the core logic of deprecating things.

Drop the AK09916 vendorless compatible.

Fixes: 76e28aa97fa0 ("iio: magnetometer: ak8975: add AK09116 support")
Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20240806053016.6401-2-krzysztof.kozlowski@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml | 1 -
 1 file changed, 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
index 9790f75fc669e..fe5145d3b73cf 100644
--- a/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
+++ b/Documentation/devicetree/bindings/iio/magnetometer/asahi-kasei,ak8975.yaml
@@ -23,7 +23,6 @@ properties:
           - ak8963
           - ak09911
           - ak09912
-          - ak09916
         deprecated: true
 
   reg:
-- 
2.43.0



