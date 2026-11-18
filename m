Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040051;
	b=Ir1fJZF25WrFmeQld3i4eK8yh888yMTCx8tGDIX2afeMYv0sa3asRaHHKCsF/71mT2JQ
	 aJCCY7u3Z/nvnf/uy07yrk8SBU8STj7YvJXN1b3j8LlvVNY2fTvWyVv6YLrELnglTU01l
	 eq/W7iPb+GRW0cTIBme6aIUZvF03hZlJSlXC9gtOsjHdzTU0E/o2HDj2xWEHKu+nSI8fp
	 lCOhaI8wx2h8lN52ZxCD11Bim0DoJUoqwqSWdp572AjR06xGhmhPPKHOJd8hst2Wv66aY
	 EU62vBxwPlO22MHvTwTOe94BDZJPuSilbSuHSjLDbzI9gH/yD4rXSMjWpLOSG6vMe1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZJiuWMG3AZkrWSjBzqLnmMM6GeabJniBkM89dAbG4RE=;
	b=DwqKyBghDAvp1sijHQpLFS37NvyiW+IrJa2cDUO0sgeuSNyo0SR3B9ZKZzWGGagw9cOS
	 n1dDPzOvyw39UU5cYJ4oIxyQTRS6cCcLP3ew0CN3i/qyZiJrCl3QaPPoz6J6dwQzfLEan
	 ohwqzb30Xbf2KLDDJaiCuBjLdDLHSzhPnuQuzHAPAK1VI4CpgHp2osbStpwchb0CyTSa1
	 kvyWJiSr7ISREvJAOgDfO6attWreSQ3lpaf3TI/qiOc0R/pbiuT6jl1705dTY9uzU/Y0H
	 fITOWxWDGI43eOCuYss6aJRl5L3wmvnotjYFFLeM+5pKLpIWyAVBzB/SimjLxI0GmAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtIkqy9R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DBBF606A31C;
	Wed, 18 Nov 2026 22:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtIkqy9R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA0E01F000C4;
	Wed, 18 Nov 2026 22:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040051;
	bh=ZJiuWMG3AZkrWSjBzqLnmMM6GeabJniBkM89dAbG4RE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtIkqy9Ro4ZSezCXQafWbsJQ7XwbDyYjKfGavKqJtPvnsSi04A3GtrubKGul3WsLI
	 cFWQKiIuWmNpMsYCDoVWfZukWr9Vk6JV3Owm0LwYW6bGTF6mMJ0ReXyNYx1zqOzM9p
	 KktuRL8apQVSHjzUmPgTUejQq/+dh0r50rFBUCaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2279/3318] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:48:21 +0100
Message-ID: <20261118150430.145370469@linuxfoundation.org>
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
index 6d938b8d61d31..10194fcc20dec 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -951,6 +951,8 @@ patternProperties:
     description: New Vision Display (Shenzhen) Co., Ltd.
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^ni,.*":
-- 
2.53.0



