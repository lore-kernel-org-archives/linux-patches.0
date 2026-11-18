Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042063;
	b=SsSvny34qlSSdnZl+wtYTOosJv6mYE45tNNwcRm6LxJaDrq4si3uPkxgRRbW+tiCqvJe
	 mtwflsWFm1n7y8IXvnW4DbL+9IFOg0Zm+oVhGO90CAa/jEA3V4WuKZTT2nD56ZYZnapLr
	 MXF3YgL9FtEAoUQ1o5gQNVcifDvJwx/IZsY8Wh55apSVQ8VfLJDdLLrvvmnu7AsFEqd4d
	 mTqUUZQtbwiQtBNcOQyrnEK4xpJLcEozUBlL4J2mpm+9OpM9tEunKTA8ZQ83dpBijMHf8
	 5GF+O0wrwX3YzD3wIcevmgXzdX/mNBLtBmbdMfwZQXaGNIAJPZfdRVbK+5AqC47vxwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042063;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KZY1OdoAd7QVXMKQe4EC1yqhwXWXafyFqYjH0x2thG0=;
	b=OX+181DxQGQ5SX7xtxzKRMRBlygXKkxQcVz1ftW8DoogBFctPoSTjgPxvTxg6cfWfbqg
	 GlV2wSWATd+yo97Z8xBErrsQ5VsIHQTH6qiZwNnpLS9e8KzbY+BA9RvCIl+8w2vFQVd1P
	 AFSjebiLMvH60dD8fqjMcn6/fiqrvZtfHhFHdy7AOHpTbvIeJIFDlxU0U71281/Wy4hoy
	 xraTd+idacdPI9DGT0M8WCj/76RopkTErDnQpyhaFxpHNhhF99d1/NaLzNZ2QcNsF9VZb
	 nlSr9swcHzaJR0FCRXIdlqtW84huCEB9yVvAIVfXqEXJKKa4L5pDslxZ4mmZkurb7TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8Mt4dB2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA25606A330;
	Wed, 18 Nov 2026 22:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=g8Mt4dB2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C37A1F000C4;
	Wed, 18 Nov 2026 22:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042063;
	bh=KZY1OdoAd7QVXMKQe4EC1yqhwXWXafyFqYjH0x2thG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=g8Mt4dB2MmIzYlUsHOW4ZPWlAUwGV0WLu9/3OVVAJrrUhGYT5Voz9cTZj2sCiSjhu
	 kQN6XOUGZciSI6PgnfJxIE6LPlFtx9TPYBk6NVWRuco8NIh/GTrU373bnxdf8iXbGL
	 S26PSU6Ka0DQsWMJxxLDOiRsd7UHMTetDOrSqXPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3038/3318] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 16:01:00 +0100
Message-ID: <20261118150451.312755115@linuxfoundation.org>
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
index 635d0249651f8..4e73971c6c735 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1225,6 +1225,8 @@ patternProperties:
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



