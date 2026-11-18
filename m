Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040502;
	b=IEz2xMdiDjk0oKp23DThKx/1nBQUvCjDSziRQn8uZt3Q9h+82zHImM57QeUNMmMKfp5q
	 iYuvrzhSGxL9pf+O9oQxMhjPFAAWR5FPw4pXPqy88ne8mBlZ/nfbMHWwkGR5U92Z4w+I+
	 MMu4FjQb/VtffWv7V1Y6cPnRwpo8KF+EtRaSmMtJQHsl5YpUuDjC3XSxaKOacYiEEZfBw
	 yjXrUkIzKD/42n6QBpKo7DLNl3cojoWlMTQecB8ST1MsiCjR47XcjV14KanuzSDPNKDsA
	 rmoJIwEV3i8CsymE1nLvEER/Kjz6XQ5xORdhJn/NoXudQU8OGqAwWzYMzTcoh9ZGEZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040502;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ZUxt861V/zox/SbDHtLN0ArMH/teJnOJOVY8xIjpTQ=;
	b=t0kv3S0kxsHMiZN0I2Rvr8Tsgp+8JUrWQC2QNKiW79/QM5RL38nHfMW5Q1BLsXnVN+Ca
	 FAqw4+mXMJBgPOY1wqpf5ZdTkTLPGoW4gDy9c4O0QNi8hmbqtGoceYqMVT+aQkH8Z4y4d
	 qY2Gc4G3Z9VdUOC7bQQdZI8ducO6Xpi84a2NgxkQDdnx9gTYJ0wc5fMo3vuRgVSz/DVXE
	 QOyOtn45R7kj0/g1HTiVe/rfy3+LSUeBwJjkOw9CWI5XwjIYownrh2n/X34PbpmzAdhIy
	 LgEBl0MOxRmqHUULK9Be/8t+IR3dqmkZCsAGYRhbcqZxiyir+g+MFyeJu6eAAUGIn3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwmYLCrZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58387606A31C;
	Wed, 18 Nov 2026 22:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FwmYLCrZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDCA1F000C4;
	Wed, 18 Nov 2026 22:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040502;
	bh=7ZUxt861V/zox/SbDHtLN0ArMH/teJnOJOVY8xIjpTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FwmYLCrZGIGptgQPV7n4nhGq4lXwPvMpzp+iFkFelE4AafQnklUV8y8s+S23hD4FN
	 ENdtWYsQz/bOjuxgD9js40E1zTkcqWL7z0qAZRGinW5GZJqwedDOmn3nHsxw95qu93
	 v0+4a4bLMsZ/oWIMmq7lQtbkm1Z/ZK29xRjoAPwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Nicolo Giuliani <nicolo.giuliani6@studio.unibo.it>,
	Gregory CLEMENT <gregory.clement@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2479/3318] dt-bindings: vendor-prefixes: Add Sophos
Date: Wed, 18 Nov 2026 15:51:41 +0100
Message-ID: <20261118150435.776674274@linuxfoundation.org>
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
index 4ae5becd175e8..41799c152403a 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1311,6 +1311,8 @@ patternProperties:
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



