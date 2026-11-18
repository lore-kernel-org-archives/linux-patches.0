Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022813;
	b=ZfITpnNKDwDaJ8EPPOvANdm4gvoDmC1rmjSTaVdZ4mW1rNq0CO6Z4qd22cMGQ0VYw+nu
	 w5ofZgwBNA73a1402bjt8jDDKky8y0xZcOW5T81YyVvh2fMjzsaBdsYIftTJ6DXyewfvM
	 uEUP22bo7igjaBQIt18RdccmHL+8YZ1aelWVBEhOUZFWZgUnujYzIu0DXO17y81dYYdBN
	 cTSHeldlhlRCKOKaIgW9JWYSqXeG0a4ElOondF7olM5YXL/Bkii8qdqCfc/ppAY756kUP
	 56By7rjH8EG6KBnAXK0vrEo1MH4IKTKaUz0Pouo+kWLrcvOqCCQ6Pj2UouPxlS7YGjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022813;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xeF3rQtr0LXwENi9DcyColZmDlu2ibQbfDxXCDi0Jlk=;
	b=SCiDAJlMD1QTYqCZzaezEiiB3QQCvP+K/xwOg/pxSe7+Xwz0XACR7UrHu6zhqHRwWu5P
	 jZKYq503XreavwVBLKfoLN9S75OmYCHEGyUkV5KWAPRB/9ADeJto7aj+jGNWJZj/i4T53
	 Mm/slIUu4/W2wXpcYG4koCJuUVLrX9AVOWRPws2WAS7fejqVGpeIou8a7zXh0IfshmJ8J
	 cFSInYEXiVy038cUld8k+Q3qDC/s2UlEWZq5+UbmPTNnY0RkVAIUfHwaRRX6gy/G2lrjf
	 kpEEIFSAJTzwmIMS2tLwrt37rkEG2/eOXzxi9DkwS9g7e3gBN+C6Bc0vnowwzowvfaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi9NdmZz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF46606A742;
	Wed, 18 Nov 2026 17:26:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pi9NdmZz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 006751F000C5;
	Wed, 18 Nov 2026 17:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022813;
	bh=xeF3rQtr0LXwENi9DcyColZmDlu2ibQbfDxXCDi0Jlk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pi9NdmZz2aFcURbtTrXawtIK2EmUyZYdobQ4/xh09mbpZem6P+EYqVVcoCnJ6UEkS
	 km1gAlgZhbCPsbIKDy/T7pBrreysp3XmYSZmaphtl1MM/g/KiYJR43OccVRRrZsCYI
	 glqoyPSKcbYKp+1bium1cJ64aZc1Pdzfc7iq1cBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
	Esben Haabendal <esben@geanix.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0148/2151] dt-bindings: iio: light: ltr501: Add missing ltr303 compatible
Date: Wed, 18 Nov 2026 15:31:23 +0100
Message-ID: <20261118150127.163721052@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Esben Haabendal <esben@geanix.com>

[ Upstream commit 198ed7962e42f1e45b7f48b9abc70aad9e3185f8 ]

When support for ltr303 was back in 2021, the bindings documentation was
not updated accordingly.

Fixes: 7d71d289e1ba ("iio: light: ltr501: Added ltr303 driver support")
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index 480523ca37500..6234e2eaec2e4 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -16,6 +16,7 @@ properties:
   compatible:
     enum:
       - liteon,ltr301
+      - liteon,ltr303
       - liteon,ltr501
       - liteon,ltr559
 
-- 
2.53.0



