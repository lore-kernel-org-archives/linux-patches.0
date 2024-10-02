Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FEE51D0B8C;
	Wed,  2 Oct 2024 14:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878458; cv=none; b=FUNKr5pbf/OjoC7nzioXd0qeCfiSd+BRND3kzgnWH3OtpQU8t75MCZ0medIc05Pb0i1fxj5DRZuSxJOtfspNMKPMv4/D0hAG5pKLn/1UFrWaJNfAWKqTsDzomj1Y90FzIwpCrFpW2kwVcNW41oY5/uJHTS8cve/sm0MQDzLYEfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878458; c=relaxed/simple;
	bh=9VvvdwvQj389CGCvRfIPzsrapYio8ANtEFcIe8ZwdmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L+ws6DjsrjtdkwWIOKnI4YE8aQPwwcGDjVS9Pi/jdU25Ri+jEl2caeiwtSWgpFPz3NEupt5X9ubLM03nI7cks77hPcyz+iAXz4SI+RPb1WqRVZefcDT+CZ3etC4mUESlioBZEFO0CzwR33i450ZUz4JyPVu08YQIDy8aefLv2sk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pfbuy2ug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pfbuy2ug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25DEC4CEC2;
	Wed,  2 Oct 2024 14:14:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878458;
	bh=9VvvdwvQj389CGCvRfIPzsrapYio8ANtEFcIe8ZwdmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfbuy2ugRhODU9LxgNvfrMlmDxZD8JLR9YBrVXhEgG5dOyJQJ7kofjnYjoRrJe4GL
	 r5NtiMGwQKYJRu1HRIsJt1zISljUxDf+xEzoAHZ9TV8nkt6xBAEccSEDUMk0QBFM/w
	 5QDe/SP++xvEnTqnj4e2Dgh35HdnGYHZ6g+FnOBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Conor Dooley <conor.dooley@microchip.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 421/634] dt-bindings: iio: asahi-kasei,ak8975: drop incorrect AK09116 compatible
Date: Wed,  2 Oct 2024 14:58:41 +0200
Message-ID: <20241002125827.721333587@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



