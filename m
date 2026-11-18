Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055315;
	b=lByyYPIxklcxWp4as/XuTU4RUduhXK/YcpQ9IfuT6LQ2cL/Mwgq5Kd+SOl4iWUx9Z1NB
	 z/FeMsMrTM867VUfRTDBAluAIbjkwobMcolGVGlyjsLXFzdPiZIWdT1NzZCo9YvmnbhU7
	 xhRYvoLf5CHAscsqVMignLMyz1irDPAQtPgPNmprUY98e4iNEZ/ts7T0P/bCcx2t2IYAX
	 Xs9vsWirIHn/L/QB8YtfOc2dK8fQ5L2hcla3cx4CBX7HWy1IwEZztjr46gbwEBmvuobnL
	 FoQIyqx6JFok5JKpiAUt90yy4A02uHid6VD8ZPvHIwX8zpt0S5pDaHVgXOrXWVBZBUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IYZ6GkIMoPs3oFk8ldpdZVtUD3RVYVFfUiZgOBBC204=;
	b=s56p/q1AKZOhSRN9EJfpDC3i3AAIGT7Hi8MgBWuDjogHepWo946mJ2MW8SuYnqaxDJ3Z
	 EO42dRcaVP1UwA3JSuqAY/vm2V2cAa+rQFL5JjbtMUvnp8EK43FPSJ9BkFEzLAD2xzzk1
	 Dc3Z/aKNVMFv6iAbF46QA1NlWa9sXO/tcKs3KZPCMN6SkZ7QqfyLHNvmmO1gS6B2Ff77Z
	 cNWt9MfhAnJTFExJC2o9rlkCx/s67bGzIqv8t+laMpkJg4gYWZ5r+pX146Cq942nO1/kW
	 auMLxtf4WH2sHZSNH6se3EIUfy1lIxxzcL12AuZKva8WsE4b6fwswnwhtP97roSIKsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfqUVgjK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4BA1606A325;
	Thu, 19 Nov 2026 02:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZfqUVgjK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2E51F000C4;
	Thu, 19 Nov 2026 02:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055315;
	bh=IYZ6GkIMoPs3oFk8ldpdZVtUD3RVYVFfUiZgOBBC204=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZfqUVgjKcQYxAcfv0e3jpv5DSXpb1pCIcxDla0bTKCBhaEhgB2BKvBVbBRaol2Eva
	 mn/V3B55HSocqeBKvfWEqsarDAUNmJCDZr/ejKdltFnQ/nSPoJTJ+S4+dmu/HqN6pn
	 e8JkA8va2kz2YAnTihKjpFQ55Hnqw0xeTYxhxqjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1586/2214] dt-bindings: vendor-prefixes: add Genesys Logic
Date: Wed, 18 Nov 2026 15:54:22 +0100
Message-ID: <20261118150115.445881951@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 38cea8e31e9ef143187135d714aed4d7bd18463c ]

Genesys Logic, Inc. is a manufacturer for interface chips, especially
USB hubs.

https://www.genesyslogic.com.tw/

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221206055228.306074-2-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index fd2d25d7fa51b..f32408840be63 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -445,6 +445,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^genesys,.*":
+    description: Genesys Logic, Inc.
   "^geniatech,.*":
     description: Geniatech, Inc.
   "^giantec,.*":
-- 
2.53.0



