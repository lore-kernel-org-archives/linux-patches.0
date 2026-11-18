Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021100;
	b=F8WC1Kx8e9AsbkWytBYOpzXUrEwMcKrsL8isQq2IiZVLevDpXtxAxO8i2uTE8beKFa9a
	 EuPSci4ptirRoYSST8qmOUV/86maQEnQmOrzjEV8vFXkqhfOb+YV/SZeI1xQJBzzr1pFU
	 d07mNfQgx5yuRTRqsb9v9nQ1O3z35ui+0B5WgZolpgXMAoW62yTp/0ceO4KX+UULhFk3D
	 P03Xtkuh8kDFu7WhUnR9U2j+sVXgN4dwHgNO1BmaZcIh20vLTjvGaIUKaB0fCCmEoBe2p
	 qUkRh3nB/d9BemuGfTwUf6oHQydJZOruL0yrzlT3dl36sEDfe0Qkbh7FljyBe9ei4Rg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021100;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cyZQfVZOjv7sV5nz7tCKxH47mJrkCTlsbVqItix80+s=;
	b=fCsMeWXWInXxCviWEWTrc7pa+Cd/h8o58Qlm5iuzd7LaeINLXtYd2PddEbHGyksEhDtb
	 8f3fwq8K4qNCxyCvzS0CREu1TMRPbX+VV8q7KrAEQd9rVpVyUyb+P+WTiojONq0VTZlCN
	 NJmBqliZANrsIiU0Iqtz12P41N08SqLOrGSjHHksQLRqMoGD/zEEl0WFeLVhTd5cs5dnj
	 E8SVAybEHHFANcLwoYZGrVGV3fIsrryD9pko+QAXEGsfZ1rnnxIsuXrbyCtQ6dlLeeezt
	 5QwXsGkos5JWd5PfOnVbusjDn1+0lLgvwwQHl2dSUHidgzIIr+jwhYKgR4Wh2lp0aCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgvX1+3Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0213606A31C;
	Wed, 18 Nov 2026 16:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZgvX1+3Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 517E11F000C4;
	Wed, 18 Nov 2026 16:58:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021099;
	bh=cyZQfVZOjv7sV5nz7tCKxH47mJrkCTlsbVqItix80+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZgvX1+3QkIFXt4Qjcplsryqx0YQF9z2qut6FBHiWQFSyXvsSaMXTKSUgSRt6SQ/+r
	 zoAxj4DUQgpA/TB0OSHguY/Yo6nSRT52YpuwzlPKHinIMrvhjx5CsE4adVI2dcBaui
	 LHQ0GUPn+C2I5ZQk8sgFTwRCsdZPsMNHC1ejnhLI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2146/2651] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 15:56:26 +0100
Message-ID: <20261118150403.101762783@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Troy Mitchell <troy.mitchell@linux.dev>

[ Upstream commit f4ba4f8cc8e8df45e57c1754955b3a6b9b089a97 ]

Add the vendor prefix for Sensylink Microelectronics.

Link: https://en.sensylink.com/
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Troy Mitchell <troy.mitchell@linux.dev>
Link: https://patch.msgid.link/20260914-ctl2301-v5-1-b44b81cd2c3c@linux.dev
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index fdc459eaa1211..5471a06f93f10 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1511,6 +1511,8 @@ patternProperties:
     description: Sensirion AG
   "^sensortek,.*":
     description: Sensortek Technology Corporation
+  "^sensylink,.*":
+    description: Sensylink Microelectronics Technology Co., Ltd.
   "^sercomm,.*":
     description: Sercomm (Suzhou) Corporation
   "^sff,.*":
-- 
2.53.0



