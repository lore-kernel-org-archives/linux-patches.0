Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023932;
	b=iR7ea5uvgceqUi+LTpprFc9YurNO8/vswvqqkwo7LheRxMA5NWuOum/nII1BGVhmdoSH
	 zIXOKk1QjZ/UIaOkG9dHdqDZKhPdzke1a96duGOMX5bsBnP1or4w9piVFdDTJYVlu2nj7
	 r0vbz9Rp07hC9o37aF3s+9aTIoIR0YUBO3y9e/lD7/uTND7MQmTzaF1rgSy65/e0fZskb
	 rc86JFQkvqGndiMbq9eC8kHDxDtn8Oe9W//ZVG6+ystOVT9lyXVLwEYhdf3OgsPbdVHO7
	 HyJx+W9S2j/rbNyu/SaGdx4LArU017QN5Vq/7xp8E0UI/4eHADLCRdC2Ry+4XoTeRKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023932;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iXZPZdhPaK8nu2M2io7Ng/o5QLRDNtTULX//vYwN5JQ=;
	b=CrR+uoC3rOajAP7vI8Z4lm9pUlHHIYWitmQTUwzCmoN457BzG37Lpd1nkxuf5Kw94bFu
	 VZLEVNN5ZWHoM3YcdC/iPu3EfHPHFExdeScCVQcJjEbvK4r1kSk+Sn1ZbIHinYc3VIMXb
	 S3rJsciy1Yk6rey0Rj06javFmZ/OB7mipTRwTlKrIP7U9QK+fCWA06yT/FGu30ar0czkP
	 2mzPcGOCNiS/8jmUjvbtzMefd3tfI2xg+BVnJHL5IOOf0z8OBt6xArdtldlQMabS2TGC8
	 jIp9XJnXsvRHJ/Rfml23VxAXCkUgCcff4rDmOAdgs5M0A/lP6ksVG7JO+DK/oLe9w3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZz2z7NE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8F6F606A31C;
	Wed, 18 Nov 2026 17:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zZz2z7NE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 231E41F000C4;
	Wed, 18 Nov 2026 17:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023932;
	bh=iXZPZdhPaK8nu2M2io7Ng/o5QLRDNtTULX//vYwN5JQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zZz2z7NE5rcE5D6brrp7V12XJd9y2yMrd0SkJwlAoMadfH1SZCEW7VOKXWnchQkIO
	 23IChOngOdcXYbsTlyOdzsvwfHrmKMOuyMqu/ynbJYFgJVqEpyJiJKOAYkZGv+mFvh
	 UOiCCB9uQM25MbfEXz1HKRS7hNQliNdvDyIvbq5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0544/2151] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:37:59 +0100
Message-ID: <20261118150141.794080760@linuxfoundation.org>
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

From: Karl Asseily <karl@asseily.com>

[ Upstream commit beb56d1d3de522885b30bb97fee83825041d65c2 ]

Add the vendor prefix for ESS Technology, Inc., maker of the SABRE family
of audio DACs. The prefix follows the company's domain, esstech.com.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Asseily <karl@asseily.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260918182317.143223-2-karl@asseily.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a9cf85fd6fbec..6de8d02320b52 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -527,6 +527,8 @@ patternProperties:
     description: Seiko Epson Corp.
   "^esp,.*":
     description: Espressif Systems Co. Ltd.
+  "^esstech,.*":
+    description: ESS Technology, Inc.
   "^est,.*":
     description: ESTeem Wireless Modems
   "^eswin,.*":
-- 
2.53.0



