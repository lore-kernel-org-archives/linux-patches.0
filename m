Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048647;
	b=Iw00wLCB7EFvZECU+8iK7ZysApjVP0vpLw7/XUh4JlMSBeH6b0yf2EbXPmO3X+M5xUoW
	 O8TjAY269vCPy6eSFDiUR33v+PnRaUTtqQIUwpAgLRRFbACs4boK+NnRDM/EU8hp4z6zn
	 1ed6sUpfBQQi5rVXbJyU5cdZgQMzcspZ+HPd0UX9mpevYObqp2O39+7FuL0P2UeCJ8kNY
	 dPELFBh1UaN5kqLyDp6+7QgG9ZtVVrzwSOGABmntR91DF3PU50YbpVjxNgmWghMcll/CA
	 jMstWdDTZFuk29h6VdB31Q5ILx25Vs1Dl5lI7cbtBExwxKrvU7kaLqxEXXMmnrOXrJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048647;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=awj856xwA3VJVlZhsjGYMNH4Q345Dn+1RE4PwoKICZE=;
	b=EYGkyZZWCt3w+4nYxnPFxBCF6phXQ5D0GycePerkuT614IUR+UTZI6hjYbVZr3PLEKkK
	 kfeQGx6iV0n25J2fH4WJXjivGbTSOzY1imFW2hBG1gyNgxxXIM6dzbbvvs0zc2zIEymwd
	 jbhQLedTDQEdu35HkVNkPn2OMDF6HYrYDu+3H1JaBrCFyoCtX6C/sRaSIgmVf1Ey0dnpE
	 gLprRm3iDo4iY6Nc37gyf4dxziosmb0AawYrRAZUOd5nP1/vN7YX+hvZAeVJ5TmTz6gET
	 uQ7UBQ+Fe2f8bCTzjLksNdhVDRLjqjB3JY4goavFhOfg+BiG8twwcu3ptEbDhjjixbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwrPOidV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF20A606A32A;
	Thu, 19 Nov 2026 00:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nwrPOidV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BB7A1F000C5;
	Thu, 19 Nov 2026 00:37:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048646;
	bh=awj856xwA3VJVlZhsjGYMNH4Q345Dn+1RE4PwoKICZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nwrPOidVVxFLQzlzvgC65H4pO6fhj3qi8gz50QVaaRKxmKbGfWFwpu4zjpjsgC16N
	 FzVswyqhVL8fbK68VTxPPrOlTEmQ2jPI+8s0xmxtL0E2PMxFxy085ZbjnocMdmdoHG
	 g8IF3AVjgWNQV/kwy2oFQzJK+7Y0QpvZZPS7aGhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Jagan Teki <jagan@edgeble.ai>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2068/2857] dt-bindings: vendor-prefixes: Document Chongzhou
Date: Wed, 18 Nov 2026 15:51:42 +0100
Message-ID: <20261118150315.877785195@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jagan Teki <jagan@edgeble.ai>

[ Upstream commit 90f86d0c617d9461cb00f4d8e861eda28011d46e ]

Chongzhou is a professional is a manufacturer of LCD panels
from Shenzhen.

Add vendor prefix for it.

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Jagan Teki <jagan@edgeble.ai>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108173120.618312-1-jagan@edgeble.ai
Stable-dep-of: 058ee00216a1 ("dt-bindings: vendor-prefixes: Add Chip Wealth Technology")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index fbb480af8568d..2daf0cf31023c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -250,6 +250,8 @@ patternProperties:
     description: ChipOne
   "^chipspark,.*":
     description: ChipSPARK
+  "^chongzhou,.*":
+    description: Shenzhen Chongzhou Electronic Technology Co., Ltd
   "^chrontel,.*":
     description: Chrontel, Inc.
   "^chrp,.*":
-- 
2.53.0



