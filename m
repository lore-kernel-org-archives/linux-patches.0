Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029849;
	b=jcL00YVtNAjPuCgs4guF7sk9dDmIKc/eX29XHyLK5OaXXwDWQAC1zg33xf3O3jOPODpb
	 +p1eNVK8s41TmqAekOVSMnCwJm6VWJYp82rV/fk66aeMtsh6OYhHwB/wUdyMExmMjbM6R
	 PJAKrZNJV1Pro+vbLBXNaVOUcZDBD8hdZFg3uFqNGVRMLW4NCfqpkHWftfFKe2YGXxMQh
	 vmjyvBx6UuhsG5kKUlk1JCJogNfGKrBd2uc8KQLeKKPn/AZPM5rbiqrS0YoBigbyE6prb
	 zyHTSmgZter5WP2Wyfe2YR7sx8b9NMkA/243YdefmOcps4YKwP8lbkplHwrNJBx7E3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=da9T44iBF9tvu+GdwznQvfipE6b02kIcJ5pBfdUOF0A=;
	b=lEdD4n7/1R6lfckO5IJvFbghtMo7UJms40hDdxXqaWVRsdbYFgagYGXjq2Y4CKBBr8J4
	 UJmGkYMKMsOlG7wcjOUQDlE0FfYkNiLdPSTNyyD5TKFTqj/BLj+uUNyin2Qo+Uspy60i3
	 za8bqbrgmG40RR/5l2+sicxT9ncJzxitYz6e8rsrnR5FZ5rxGyrlI3QPmHph0ftWNIEtF
	 4kpYuaL/ppKxJwF1sHVb1nwAT69E8R/eOQ2a0xmzwOG4B5hTwHQaIsHuBSVlx4qSRdjJy
	 stVD0Fdq0o9sdGTVEpDqvUl0OgJcak8fMNJozEqnqWV/2C9pN9HUxqcG9lXPsKUK5qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc4i0yux;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ECA606A320;
	Wed, 18 Nov 2026 19:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rc4i0yux
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CF1E1F000C4;
	Wed, 18 Nov 2026 19:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029849;
	bh=da9T44iBF9tvu+GdwznQvfipE6b02kIcJ5pBfdUOF0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rc4i0yuxpwtFh3LazQNnVLk3jWH3G7vEXwZU+5cl5yLucJ+FtSpctVhz4xd6qEJGU
	 Hb98+v5Dl1WYvPJDWZCpyNAyV+xzP1/Sl7MVYFS/9li7zm+NoqjUkHPJjWAs8y00Ac
	 3OjozmwiZbfesryStDmd8H2IwPXEUY3f7YNQj3Jg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Asseily <karl@asseily.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0469/1756] dt-bindings: vendor-prefixes: add ESS Technology
Date: Wed, 18 Nov 2026 15:43:16 +0100
Message-ID: <20261118150027.540114410@linuxfoundation.org>
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

From: Karl Asseily <karl@asseily.com>

[ Upstream commit beb56d1d3de522885b30bb97fee83825041d65c2 ]

Add the vendor prefix for ESS Technology, Inc., maker of the SABRE family
of audio DACs. The prefix follows the company's domain, esstech.com.

Assisted-by: Claude:claude-opus-5
Signed-off-by: Karl Asseily <karl@asseily.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260918182317.143223-2-karl@asseily.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index af9a8d43b2479..fd7fca71564c6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -480,6 +480,8 @@ patternProperties:
     description: Seiko Epson Corp.
   "^esp,.*":
     description: Espressif Systems Co. Ltd.
+  "^esstech,.*":
+    description: ESS Technology, Inc.
   "^est,.*":
     description: ESTeem Wireless Modems
   "^ettus,.*":
-- 
2.53.0



