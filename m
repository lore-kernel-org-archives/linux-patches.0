Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024603;
	b=4cNYbUFRPW03qUaxHawuaIB5H79HbE+2bcS8zpU6Jb3WcrsNTNEjMpYS3niJyNPRBn9Q
	 0YdwMBsFQR/AA+5Kt71IqHZfl8+K7kAG0B+g4va521qEMVCyIpcfzzdQk7KehYNCl3GHU
	 mRITpO6OylMdIssOcX6SEFrKXo7vWrsR6EZoaYdmqcEuhvJfSu4oPz/E9TnCfEKg/gVw4
	 KivYyab6Y6d8yGicLbJq8eG5EGDLLbRelCmSWcdFSTnDOkY+/5rPpt2QpV4Hmhv4grHB6
	 GQ1Mu0Sb5OtiBnSbyhWYFIDAyAEFwWRunU/OSdgsBxnrmR1vNgRkyhprAPMNAVZH6kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024603;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GwOI9lfIJ/y31Jpgs+BPri2lioxkyy6J/FnmUHp9aVA=;
	b=yIJe6XwBIiAL08XwQtmOexu/xA8CK8CXPaaGnsRk9q5qjUz9vJXesQoy4YynqYlaSbrE
	 5wKGTXt5vemfA0jJK90eW1KMU+xbetahc5lkCT5JDgQUAVE6J2iTdFuZRKxwGTf4mimlL
	 Jj7U6/GXnYAh7jRfwWofgIeTirb2n1XiyTTdiVNxiAmapOU9qSuQObnsf8caBnJSzaYJ6
	 cpPw4htWQI7iXPlBNqC7r31xl/ZIRw5cPOyUK5KceZjn3wFYX3waFAkSLNLgoOgkUs1qa
	 kNxuUmkWIUOZezGUa4x42JWep44iPQ8t48lAxG4Y0tIYyYfuDiBSEjDfssSIN3nyaYQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vodEUAie;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90B5606A325;
	Wed, 18 Nov 2026 17:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vodEUAie
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E2BE1F000C5;
	Wed, 18 Nov 2026 17:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024603;
	bh=GwOI9lfIJ/y31Jpgs+BPri2lioxkyy6J/FnmUHp9aVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vodEUAieSw2DzUT1mCJX/eRLBq5PxpEweZsjgzw0CrpjadQSV0suGiHFUEPeWY44h
	 dln1v+tzTh2fVl4NLbCCBJmh3AqB+relPJd6eDgGXouE4XMSeLCRBl1YOIvqvxAUEB
	 I7hkm5vfUk7doTwNTofObPiukBrfeOf9MXZq/MaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Muzaffer Kadir <muzafferkadir@mainlining.org>,
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0733/2151] dt-bindings: vendor-prefixes: Add General Mobile
Date: Wed, 18 Nov 2026 15:41:08 +0100
Message-ID: <20261118150148.718336519@linuxfoundation.org>
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

From: Muzaffer Kadir <muzafferkadir@mainlining.org>

[ Upstream commit 7034bec693b752bcd7ebb4fa00dc3b429b4dc4f7 ]

Add vendor prefix for General Mobile.
Link: https://www.generalmobile.com

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Muzaffer Kadir <muzafferkadir@mainlining.org>
Link: https://patch.msgid.link/20260921-msm8952-initial-support-v3-6-b96fd3fe298b@mainlining.org
Signed-off-by: Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e6fa43a510329..8bc95dd4b2592 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -626,6 +626,8 @@ patternProperties:
     description: Gemei Digital Technology Co., Ltd.
   "^gemtek,.*":
     description: Gemtek Technology Co., Ltd.
+  "^generalmobile,.*":
+    description: General Mobile Fzc.
   "^genesys,.*":
     description: Genesys Logic, Inc.
   "^genexis,.*":
-- 
2.53.0



