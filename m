Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040079;
	b=j2ffxrs58e4H9lPu/16UkVWMHlrVDgGY+wRneUs4Sjn1031+aZGbLeSxALYXvZpCf3/u
	 o749/TpS9gZv51Dkd7AHL0C93CAKjTe3p7E3niTz/SS4dJOdVK8sgDGl8LY3aBsjGG6Cx
	 n8yeQ42fL8WQt/dJuK57QycdnwF33qMFrkGFEhffWmYa9RSI9y1DKWJ5E7h3t/+4NxI/Q
	 kORAXRnorMeNkDOtdzxroX/tV4Asl1mgyHIZI01Iup/c0WLPYbAwCipiZg/5GD5TkNjLB
	 mcLsZtAlP3G8Dln96qgIrwNelyd9Fjapn6Dnyvk6iav+TUtp3iuq8D6SgOLmszl+K5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040079;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qjFAY3k3zdHBQDVgVrDnsVmjsL/Bq3zXPbXa6v9wQ3Y=;
	b=gpjrY+sPl6BbyP95mKEX1VcNEETQz18u6EksEkl9Rw7SxzaB3JeXcgLE0uyes+r43XAf
	 uTsxHXfm8+Z6lnFED78CK3DUzBBra4d+8vD5IBIg6+Mg70iTS/BnTyBd+PzAWKugt/Cq1
	 baxRwFFPyfMk/2ELVXvxjVIuv2RZhBmR/h6lxJqXhXA0QKcA7A+Uj7QjNLYl2LWLgzrQk
	 FIqo04tOeN4siEXSRL8q8H+iR6lIj0lVB/hjXbuh8yh5CnP/knPhW4Bj9wsqoDS5icQII
	 kYOi20C8bMKLKrhkS5GIUCNzqF5FeHP3ijJ8EI6X/eC+0rRWVjF/VL31h3kOy/AIXXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtYpF0LC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257FA606A320;
	Wed, 18 Nov 2026 22:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TtYpF0LC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78C651F000C4;
	Wed, 18 Nov 2026 22:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040079;
	bh=qjFAY3k3zdHBQDVgVrDnsVmjsL/Bq3zXPbXa6v9wQ3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TtYpF0LCkSsmy4VaN5GFB0r+Z/UsPfbq31bPWhB0o9PELloFQxLmQdVBDXHEJ25+2
	 XUhRwKWPewOLrJuKWaiL7GX/p/WCi9UvOR7nJhlwzntrHJNaXBCCszpjq2LeLT0Za3
	 wbJUAhZRH46/fH/K7TdGb+f/ixudTzkE3rsunYRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2330/3318] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:49:12 +0100
Message-ID: <20261118150431.552360225@linuxfoundation.org>
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

From: Vincent Jardin <vjardin@free.fr>

[ Upstream commit aa906abf611c7f37c0fe9171c1d33c40270aa5fe ]

Free Mobile is a French mobile network operator. Add its vendor
prefix, used by the Nodebox v3 CPU Module (freemobile,nbxv3).

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Vincent Jardin <vjardin@free.fr>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 56a2c99827c93..e8ea99fc7b04f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -492,6 +492,8 @@ patternProperties:
     description: Baoding Forlinx Embedded Technology Co., Ltd.
   "^freecom,.*":
     description: Freecom Gmbh
+  "^freemobile,.*":
+    description: Free Mobile
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



