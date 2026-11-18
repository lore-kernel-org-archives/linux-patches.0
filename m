Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055712;
	b=0+GHOag7b7B7Vm50VKHZ2FtY9YCp34dCRQ9OUtsl/6l9U3chHbD+oYTajaTO8+2RD6Jo
	 /D5CeOdzZKvq9uC69z8z26pBUNoEr9vU/TSKfWp28HP4f+dmG3y6Pp3TcblB8AxwDNmSU
	 TaZURfxXKRfg4QeNlWvzv00lSqwNd2dOH+mlBRGZL05am5oJPkkT6/OmkkjoWOwgTk8S7
	 4qat4nY3Tki/acSTyjH85brHofXZ7IjF1qrXov3Sd08JKyHsQlYmhbhO4C1D5pCkaorDR
	 D8KF7Vh2i1ST7reJfnvfMtpZiuL5EOYbjV4nmlM2umgrU/Oz5MT7+SXFwz7huxBryEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8ExkpaIBYDv+YWaqCxpEaD/aRbyVHzPHOMAR4i4DTSE=;
	b=gM9TRCO+raOyofR8Nkf8h25JsMzqnjF1t6idh9i8AwOfK++hLYblFSVb2HJYClCV11TF
	 ygw3kKd2nW4WIUL9JcZNKVTritm4/NGAqYM1XVHEpVutxg6nygKQhH9Pz6o6hp1S8hlOJ
	 wBYhdkIIvNU4u0Har8DtYBBS4s+ahDYBjOIvQ9Cpyxm6Lkugt2pgUAFvuv3gdo8AkDxfR
	 E8rw3nrykICse6+yJJATLhM/BQe9NO8pBBwnwSA7EwGLCYRxy9gdHvxh/aYwjS90hemZP
	 VekJtkB8xHc2tNBTsLSktAu5f+Xi6oeZNNh/encoTKJrDgOK7A6BENkJCZQosDIJFaw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vghCePhD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00BF606A325;
	Thu, 19 Nov 2026 02:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vghCePhD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32CEE1F000C4;
	Thu, 19 Nov 2026 02:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055711;
	bh=8ExkpaIBYDv+YWaqCxpEaD/aRbyVHzPHOMAR4i4DTSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vghCePhDyi2Wo9j0xfygb+l3CwUm8TtuAX7og8Tm2CxI3BrV/sNATTnolNIiPZ+6f
	 86sLI8asEGXZsAkNhcTv0RcWzc8iQNdArgsSKBsG9t6jw7FoLvb/3kXeSi8kCpjE+K
	 FOqfOfOCD5LfqPQAOBCQ8VvZ84+S7v0qpyS/jQeA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1687/2214] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:56:03 +0100
Message-ID: <20261118150119.314148073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>

[ Upstream commit 538f8ec6b9c711833c5217a8bd8207a282265303 ]

Add the "sophos" vendor prefix for Sophos Ltd., a vendor of network
security appliances.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Assisted-by: LLM
Signed-off-by: Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>
Signed-off-by: Gregory CLEMENT <gregory.clement@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 22f0da9bb3bda..e8503de28eb62 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1138,6 +1138,8 @@ patternProperties:
     description: Sony Corporation
   "^sophgo,.*":
     description: Sophgo Technology Inc.
+  "^sophos,.*":
+    description: Sophos Ltd.
   "^sourceparts,.*":
     description: Source Parts Inc.
   "^spansion,.*":
-- 
2.53.0



