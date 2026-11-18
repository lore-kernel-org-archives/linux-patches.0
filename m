Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056341;
	b=HQUIy6exX7zIXBeTy6SdaH5ddmFIO+NGQzu+T71T74rLyIyt0cD9v9JflY7mTczgYOrU
	 tnz8Kf+lN8wqJfE+x4S+pHAC7/4HlmDnmO075DxFfDClSTeWl8X/+qwAPmO3PaVlwvGoN
	 FmT/9hYwW6+0JTVt6ZTH7Aaq9I7o2E7VoAAm6Jbpy9eGUDPRR+UuheY0bfG+WtdNByz15
	 DF9Pau7g7W5DfZsbMkiHHYo9QEtbFVgmbs/Nql2y/AR21R2aQQlAvLilo8ljPxb2ZMz3o
	 lcwl3RlO36zHsOoKnlgOtlLPgY1oaL1IA3KsY2vvJj0xV88CFgNStKBNdXq0apjkrUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056341;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DHDpWygyTmbpOcrm8l0zwLw8bElQcsDWJkPyIytc16E=;
	b=vEJK/3yrPN76rYgokfFP9HGx6L2wgGWytmdcq9CEh8jjPD4iCdTB39oiHSqqRKB5RRDg
	 rFYhG16fkqaGOqPPwf1AoRdpOZLSSOM6Fe5mVRCGNx4ZTPMzcyA4egGXcVs+6DPEm0S9k
	 hqCAX3P3fsomiGCJLxz1JHp7bMgNE0GmxHT2GuOcWk7bZSEuPbvdI3h+6VHSkNnVXcyL1
	 eyt93e0RP6DqWu7ZdnGl31y9FDeUYr2kmH9YcxWy5YUONFY1Xk3MH/qNUyLp5jWp1FR7O
	 wGstSTkr4tb7zsND+mteVJHwTcXKW9OtSifBqVzaq0AL351xa9Bczw+3WNi8lOZ+hRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjaA7Na+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02319606A335;
	Thu, 19 Nov 2026 02:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjaA7Na+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 545C71F000CB;
	Thu, 19 Nov 2026 02:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056340;
	bh=DHDpWygyTmbpOcrm8l0zwLw8bElQcsDWJkPyIytc16E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjaA7Na+tYmI3ULOHkdw7epHezJMKL6/39MTGshPz+Mtc/czaIQ/yvScBe4EpsivW
	 Udht6Cw6/zfjxe7G3hz+u+9Y88L0nMkPqsg4oYTbhzPCg0wLoi8Ws87NSMBdG+1ZYP
	 Mi/DTOxJ3s9LeUAxyWTsOA6imvd2l9DwA5iXErwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Long Zhao <longzhao@ambarella.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Linus Walleij <linusw@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1946/2214] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 16:00:22 +0100
Message-ID: <20261118150128.846824610@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Long Zhao <longzhao@ambarella.com>

[ Upstream commit 5ef299ffb56531b3a4f2b311000da76beed403ee ]

Document the Ambarella, Inc. vendor prefix so Ambarella DT bindings
can be applied without waiting for the SoC series.

Signed-off-by: Long Zhao <longzhao@ambarella.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://patch.msgid.link/20261014-cv75-prefix-v1-1-fe95ed567880@ambarella.com
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index e8503de28eb62..5f4114bcb2e64 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -83,6 +83,8 @@ patternProperties:
     description: Amarula Solutions
   "^amazon,.*":
     description: Amazon.com, Inc.
+  "^ambarella,.*":
+    description: Ambarella, Inc.
   "^amcc,.*":
     description: Applied Micro Circuits Corporation (APM, formally AMCC)
   "^amd,.*":
-- 
2.53.0



