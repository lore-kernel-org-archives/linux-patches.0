Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039136;
	b=1FGRHBMGnuVT8wGlnZ3sTyywMlNO4eNkBo2Emca66d0Wm4HpXZKtEQ5c1eFJfXWng+8d
	 6kOVv26XtMLMbRAH40YO/gNGCVxUn3YEmqVV3KHj2tpijQEks/QORiOK8zKignnRyNLEk
	 HgOWxjBJKKvrT7hJIuNYd316jGNeoOK3mp7yu3SBQyxlZK/8h41HtHP6pEofNZ/G8QzgK
	 W5LQDmny0mshirsgMuGZSN5oMOaWUw3NDx1PbvIS+lXzKa5W3P2cAlFMEI2+rSXklu98Z
	 ht+kI71QcEme5uvrE1zTNyTVO53o16ZRvL0f6hdCyalXgkYD1jZu16LOw1BeA0xWi2w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039136;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BoCk/bFLZghUrkItl7pmV0E46/vlOJXJ8q40Af8kmV4=;
	b=4Q2npiRSQuXesvRJaBGTG2I9DWmc/jl4iOLA4zEFDs6qs9AYYDXufTIMV8pI/eI2vbp9
	 Qb7boNQoFJB5uXX1tErbg08ygl8zmGDSUtr0UPwJu6C1oE9rC6qbELNEwdAn3sqhIlrlq
	 HmFhqA9Su56UIseswF/ltLfjo72I1S9Rkzh2/YyYP3ovJGSRYQKTS7g6lbybT00e+//ZR
	 C8Ij66CG+JdvDQgPaQCBO4Emh+rwgn+1RgRfrJfZbWaBDfvFWB5EgTA0suL/up+nf9KUh
	 R5PJPbSTgDtQgvmqgjQYYZfEk6MmIXsdR3yFWns+j9jpidnU9EyueNLYwIl+V47ghAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2U91EWzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 424A7606A320;
	Wed, 18 Nov 2026 21:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2U91EWzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C99F1F000C4;
	Wed, 18 Nov 2026 21:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039136;
	bh=BoCk/bFLZghUrkItl7pmV0E46/vlOJXJ8q40Af8kmV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2U91EWzcEpaoiN9+F5h0uGHaBDv+uCmY4hGqC6Sa7uEL/oVD4rZdRhTk9863GyLkN
	 5m84Y4+E3RoksAYFFDesE79LBW535jQw+0QMTVPwai/d2Ggkboe7ob4L/3p9qFPfWj
	 nhcSOC+auiDqOtOByayynurXceauXRKYiji3yCzM=
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
Subject: [PATCH 6.6 1991/3318] dt-bindings: iio: light: ltr501: Sort compatible enum array
Date: Wed, 18 Nov 2026 15:43:33 +0100
Message-ID: <20261118150421.791621786@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



