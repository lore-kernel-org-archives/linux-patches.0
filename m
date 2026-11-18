Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022810;
	b=bBaMmLneW4JJrJyWf8uoMZqgx0RqCeleh+jt/d2D05FpBqXYMyYfZfr4tpIBQZ0y13Y6
	 qval+qmHmWy+a7i9VuM1ce+9i1lXRDHg4xavioXhY8xk7BNs6w8ydJrhsRqz15D7Pbbl8
	 /2mObLghP0QClnpllY7zuFyRJGaZNaIq5dka+1Bsh03kZV1SL4yfEB2k/u2RpA1iolcyi
	 IMBu5yXh0OxuqafYAZY5+/oas+Wywc04YP8khJ4n9qrQJrihxUbXBdSDTH+PNc5PbssEo
	 2/lDS9xhQ5krf2RfNW8d8E09uYbeW8l0jM1YWcIzNAM00mkOxKafioO3SJSwW4Gvblg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022810;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E/17hXvyLTQ2JEpfN+PCgIpCof9lubXzls89zjIKglw=;
	b=zguC52u2/Kb6t7nUwKrFiEBZyqGTVD0JDXt9ydI0Mjbb+juuhNOEOXBJwOS54PcD/Rxm
	 pn1VKxWovErwM3BIL5AvUSzV4781VS022LTJCZxq7pkxmhhhABxMW6c+QzGS+gdPZZD6d
	 4PV0UPXqC4NerkCO/MyUo/tJs4LwbXh5kCIok+Sa5lipQta5VdAKjscWFHiQaGqTbfSwL
	 P6pUBleyLtQnJMYV6Y7BZnIL8PPhixTFJqyVmyfKhpck7WShoTLoYOdhOzic+YEIorF62
	 yUNyVMMXUF4B3E2sRyFgs3rZpSd5I0ejDnGgZP74D/fTmlLnmAxwxQHD5ARRwPL8/4g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeGnvvtd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C06BD606A74C;
	Wed, 18 Nov 2026 17:26:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YeGnvvtd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 237F81F000C7;
	Wed, 18 Nov 2026 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022810;
	bh=E/17hXvyLTQ2JEpfN+PCgIpCof9lubXzls89zjIKglw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YeGnvvtdAgvgWo05M1mibwQ/bbcbnSX/g/aVLPPC2KAq9yBm+mwWuLb0dlQIAEB5L
	 mmpuJxP4azyayqzm2wBf2cYS8dB27rMMWxF00xcXyTwkQXLzOo77n/XRy5xVDIGx6s
	 BiZQdV+aqr+uVHzD8yHFLXOOayu34PUaR8JOnxiY=
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
Subject: [PATCH 6.18 0147/2151] dt-bindings: iio: light: ltr501: Sort compatible enum array
Date: Wed, 18 Nov 2026 15:31:22 +0100
Message-ID: <20261118150127.125587456@linuxfoundation.org>
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

[ Upstream commit 6c430006fbcb63dc8baee3c3bf356b264ba7f61e ]

Restore alphabetical sorting of the properties.compatible.enum array.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Acked-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>
Signed-off-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: 198ed7962e42 ("dt-bindings: iio: light: ltr501: Add missing ltr303 compatible")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
index c8074f180a793..480523ca37500 100644
--- a/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
+++ b/Documentation/devicetree/bindings/iio/light/liteon,ltr501.yaml
@@ -15,9 +15,9 @@ allOf:
 properties:
   compatible:
     enum:
+      - liteon,ltr301
       - liteon,ltr501
       - liteon,ltr559
-      - liteon,ltr301
 
   reg:
     maxItems: 1
-- 
2.53.0



