Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061905;
	b=QQFzHIGHLRUa2KCKhLhR935xpSj4hH6a0zz+s5907aRuf7ypB4dFycKunNAcnh3S5269
	 GZPXLgLA8skjfdDc9MqAaRK60vYOPT0mBV4EkiFU3maXBqz6r9IfI8Vs4sNPqVjB22VRX
	 Zt1oOH9KR/+6/Ihxy50kf2vZ+pgthcPdlUUlVroEeX9ofKUWB4mgzyolUPJmj1R5ZGKsC
	 v7oe1rsp1OwTLiTq3uH+jReSKvyaSiQsmhuIuyuEZIOcWQ88Ke7H/eyD0hDpqs2EwvFAi
	 1C0RIHQzIikr+w6Iug2/0t+5oMUEvJ7nTjbnxbKW0HSiD4QXYGB2W2XZLk5To5BOChA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MwSVUxcQkBOOoXNLgI5fKHN2jcdU2/3zNDK7fcjevJk=;
	b=v4yhh1oPAaCzrxrpvSYZdmEhtcWZkWtvuaAO8IdnYUROeG/2IBa23YumMoTWMoQpUx1q
	 2BjuaLw0wZI3zGWzq7aaif4KYF2Ni3mDkx8o0jhKzix62KgBSkJnwoa35kmwXK5sIyvsn
	 4msuLb3qu+LiLDgHvppDHnLRbFJ+CnORSOOir+TlWkn/Fr9eOH3cST3ZaE1zRYJgmwa5m
	 EF50dx+ehANvXhZAtFIKi1wMqSR3ESXf9+Tcr9dujl7AzswUymTEojRm6gMLNQFoGDqdl
	 u5KjhWpkiuVr884A3BLB0Iguzqw+Wo3LRu43vPaJKoMElvxCK4xuMzzd7vPVRcwNBNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MU0U/N2t";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7F4F606A320;
	Thu, 19 Nov 2026 04:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MU0U/N2t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D94A1F000C4;
	Thu, 19 Nov 2026 04:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061905;
	bh=MwSVUxcQkBOOoXNLgI5fKHN2jcdU2/3zNDK7fcjevJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MU0U/N2tamx/3p6S2zyTesnlbWdWCYto2ZNRJoNOyRL71uNoHW84kkWzrEHebkfYJ
	 m4NcH1cKPh17hTsAiUV7aYaTAfUkSaHaqak6r4hlzpiybddB4h5ePJ3PTDdTbeNexI
	 Imj2PVALrbckEmY5jiHeq7I7d01qOkKK3FsonhNs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikhail Zhilkin <csharper2005@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1719/1848] dt-bindings: Add Sercomm (Suzhou) Corporation vendor prefix
Date: Wed, 18 Nov 2026 16:02:37 +0100
Message-ID: <20261118150031.617299521@linuxfoundation.org>
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

From: Mikhail Zhilkin <csharper2005@gmail.com>

[ Upstream commit d217c4d968bb590e5aa1ff7d02f680c9ba5c1cec ]

Add "sercomm" vendor prefix for "Sercomm (Suzhou) Corporation".

Company website:
Link: https://www.sercomm.com/

Signed-off-by: Mikhail Zhilkin <csharper2005@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220516151637.885324-1-csharper2005@gmail.com
Stable-dep-of: f4ba4f8cc8e8 ("dt-bindings: vendor-prefixes: Add Sensylink")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 4fdfdf8f162cd..c75aca426c110 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -988,6 +988,8 @@ patternProperties:
     description: Sensirion AG
   "^sensortek,.*":
     description: Sensortek Technology Corporation
+  "^sercomm,.*":
+    description: Sercomm (Suzhou) Corporation
   "^sff,.*":
     description: Small Form Factor Committee
   "^sgd,.*":
-- 
2.53.0



