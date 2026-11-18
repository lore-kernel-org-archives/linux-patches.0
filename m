Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060728;
	b=tFHGkq+RAzbANEjhqPakZR3CNX3jmAnZnWHKLNRkDg+OY4HfcU42jA8Tt9+cz8i5tfQe
	 KXCa1BNh8vzhmkl6vv+tBgTMqJhzuhsghea4RMzDyoKfHBeIwh2e5Tb8cF8eQBsh1ILkt
	 qo6pG9b/NifxvC+/F72iWniEkKoQF6AIq1o4qBEOjo8W97bikZQHUA5pv9LYKgXxw+rUK
	 EwAaCzIryJOrlHIRztkG5uMspYkFE1HvMxzW2KKSYUzkOiu3pAR695b+IBYrUdWxafpEw
	 iQAGqJunilkfW8+KgLkFmtDkMjuRDX/GcujvIhqcGfOOHh/mEpayoDaysVPJPNvYgcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060728;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rJrc0qFMhDA3qGjD+OIKOJV0czyRmxTfFv7q0DBcy68=;
	b=ypkE5V67NcPl/xZISqjQmgxp322HeikAssHU/HAGOR/Ec90gL7uJMrl0SOdctdt+56jl
	 gdzN2n6H6WqHNiHaoTlnqU8Udd/txa60QXYJqYiJNia5gXCacqAhd4CaXeQUTUh1uMPFs
	 lOWPOEQbDzw9v/eCAwJ8LaUPJ1tDAPCJrQkdbk6iD4PI0BSeTpQyfZ9eWkWhBF8bExHTg
	 QgKz82YCKMWzOneyB2WAmxYmrgTebiVI3/8WKxHUmCTgWsQVZF377nuW4vTnEg4i+HPAV
	 J8fjy98q5i6lCyeaR695DYPEbVAB03xJVMVC6BBPNIkL+uZhi/+nhL0WA9UkA9mXUcQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QZqDRtMg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65957606A326;
	Thu, 19 Nov 2026 03:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QZqDRtMg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB3441F000C4;
	Thu, 19 Nov 2026 03:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060728;
	bh=rJrc0qFMhDA3qGjD+OIKOJV0czyRmxTfFv7q0DBcy68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QZqDRtMgXwNLHxprxZzVLH6tQKk5Zoif9dtwXnxB+EnfMYy1viRtOMt3eWu3ceXEI
	 172frT49N1Yf9JWWp+3u75nHEXKX5E80ImHYUEjX9Ag4Mu1nRLvxzTbj9i+CmhVquH
	 1GoRvulYrx0OY7ilaCVUABLBSoPRWgzpJ0mxW5KY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1286/1848] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:55:24 +0100
Message-ID: <20261118150013.422893539@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 819a3e62d37a2fe73c1e7f241f2ac086042e7757 ]

Document the vendor prefix for the semiconductor company Nexperia B.V.

The company website is https://www.nexperia.com/

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260921-topic-sm8x50-nex10000ub-v2-1-eeeaf9b0c913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 194f6480a8503..207a697009af6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -736,6 +736,8 @@ patternProperties:
     description: Guangdong Neweast Optoelectronics CO., LTD
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^newhaven,.*":
-- 
2.53.0



