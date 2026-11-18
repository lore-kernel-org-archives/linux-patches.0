Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030476;
	b=udWYmHz+XfhAtsD7D34i6NdNuomW0m2/BWzjmPXZOXfD47hmpVFlPVQg35HB5xDXd8hw
	 mcClEbV2OrJacOkxmPzDP+oIua5x0FVdINy/fthx1zgqVnRb8E/lolv6djOPmu4pWjw7L
	 ROWRbwM4TiZsqYClJODC4BJdXG+bSJNUlbMcvh507+wHYKw+1AefKjK24HoR3O9yrso4i
	 ZHdIF/yZJeEanhrxvb8ZnJuxTHF0CEBJi6jn2jWEBYlDncSVbugnslOeN+UrUvql4EBt2
	 2oCnXLsR51m0OaogkH4+BD7NofQvSXDq3P6/n7oKuiVPm4NWcotvQJ24H2qg/w3geSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8dlh6WEpfrOspd9qHMSG/uQ3lnGEJeVmWX5o/35I0Mc=;
	b=mtC5Fth2qcoHbpB6+eMg/0bTl6JC3253s5+tJueK0f4D7CyhWQ6sGLvVwP024akteaf4
	 MGyMBe9Aga0Llm+YDXVaPARfYgOqSbmhecPjjXsxtGr6c9QUYARKyZjqRiTDP+NO81/nA
	 WkIqz5lT4Uy/J3RJEfvyUvB2n/YEfPe/GnopcDD2XemBLz5AMeNwYpvgVdcE8+V2UAfjs
	 CJdJeoM3fYqCK+OgfE3a6T95IcqqEbk0GgsrdBgIFyOxnNkniDl/pdiT5U2T6vZ5YHJON
	 citunGpoe434mvU0e6DqW6tpXrbgunscI+/Xq+Tp+zY6vxf2EdWSrb1OjQP9qrj2Ijw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBEj1RZv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37366606BB4C;
	Wed, 18 Nov 2026 19:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZBEj1RZv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88A991F000C7;
	Wed, 18 Nov 2026 19:34:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030476;
	bh=8dlh6WEpfrOspd9qHMSG/uQ3lnGEJeVmWX5o/35I0Mc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZBEj1RZv5r+uyyd3FTW2XaTDOVT4XtXdArwaX6OhpmWtXmYoeP+TAplsnz6vsVvNM
	 hd7ny5AX2yDJddzruDZlJ5o+tF2jaSYlwoRzGcDt/X6hepT9awVt80JEUkQwjaX7yl
	 X0f4v/Ya0l43PgXGskKInKpGFcdr4rR5jihBNISI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0718/1756] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:47:25 +0100
Message-ID: <20261118150038.196154969@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 633d540e504b3..fb89e413e3d24 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1406,6 +1406,8 @@ patternProperties:
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



