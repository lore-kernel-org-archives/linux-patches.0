Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029802;
	b=U8o+Jyx+J7pKW+Mgk2mKE7DdmQMQYSbPv17zjfHgem9crs9oKw6L2lu93EagVYZh/2uR
	 zwWB8JUK6vj//BkyU9HAS0ks6UBcZw6HmQeocaaEtcFnuLX0Rj6H/z/fY43Ud9FshxtrN
	 bUcVqbeO/PdZoZAfeTjiDCoI/dXtJApQ0PviUtqyuCZ00frrD4/7mhoSm1leCFJzBKxUB
	 xvpufgy/AdMDYRduMpfJtp/cw9rZpF0VuK5ngCN9aXNjkr8yOcIojdiD5P90urP9MWC4Z
	 oMEfMQbhWlYvJ5uGf5s5Fn3cfufr1YiMm8N7kxoj6ZW/MUqFrXxmS2f8UXPC5VRjV+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VKNix1vPaev2iJYWtwF2J/4B5aKLN4pL7T5Ayh3X8wk=;
	b=J5OmbhFNCZ6L/A0ASyX/870qLoD+Izdws5j9S+2xqzuveXqmsWWAVACv4N68WwrAfNIy
	 6gMqZ33rEL+Ohu7gdaOcberSKM4O4qc4kqJ3rhMP4udNm2rQ7ehIYQdQP4pNiqFqRstOd
	 HCkjpkw4eRXNfSuEUF3QtIDAjCp3ObWW8Ej7lT4aN3zPEhUOfOg3uW/hVxaslutlEsu2w
	 gf4Inlj2jQJtymryN6aawZXJWVvGFnRzgIOv0sLsAObQNCkGyHgEsLyMq+xhloEvjzbA5
	 4tie+bixpUjvGbMDVsuk22brFrFJ0EllTorNhwg/stTGeTTDhgPEK03hsaTlQLVDrhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFgjcd5R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F34E2606A31C;
	Wed, 18 Nov 2026 19:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFgjcd5R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C4ED1F000C4;
	Wed, 18 Nov 2026 19:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029801;
	bh=VKNix1vPaev2iJYWtwF2J/4B5aKLN4pL7T5Ayh3X8wk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFgjcd5RgMRIcd3SV9IEnHHLfRG+DzSmyp1RrAZZgE5Q6gp7hQ5P/XDJFFemDio+U
	 WjLnY+hwHayhcZkiFhjp7FmkRnnH6cf+KYHJC+lPDw+h50bueCnh51Cmd7U+fn9zY7
	 dFAwmNwjDJwloh8ZZR6LaQ9H06uuu5gsCitXc4dI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0480/1756] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:43:27 +0100
Message-ID: <20261118150028.005636821@linuxfoundation.org>
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
index fd7fca71564c6..1866ea628ee6c 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1041,6 +1041,8 @@ patternProperties:
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



