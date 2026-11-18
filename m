Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041677;
	b=NB1TeTTybA/WVovcQXcPoPwH+ciDM16N+gvf47MkMMl1++2ZY/tGP5qtj708sc/M7YfR
	 5nPwZROa+5j0xJFisOpwO9/INmI8HULKumSFn31s0LRwKsb5mpOSVkSGpTluef8H4BTy7
	 1YBi478oj4SR9Joy4VZdrZ9rVS9VCXA2SZO6vEXQL8H/7Jbfp28zU1D/Tej4oUqAqqMh9
	 RHnaiugHG6T1f/J67s3TxnVJHE53SiVb3cRbm0of5MGv83ix6FfkO3oa1qMzSL1antzLz
	 GQatlHbFD3Oo+rgeX81+P9k8OshRb1mB0kO7rh2rCX1u75rRvwTMNgod+Tex4UrwT9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041677;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V2Dox9Y8LGl8TXk0Nt3M89TyskAo72CHjTYZx08iiQk=;
	b=r976Dzhlb5Hc0S77kmG3zn5fuipHCtmF7WMjoAWYWExExyjtNwlEB32ThpLBrtNtWpiZ
	 0XnMNDYaunP2y3wZ8BJMh6bIi8G1FSBDs5ud0q5leumhRwxlrpNY2Nml2b6RB6VE4Kz8N
	 c5aDqua55VLEdcAna1Fw+aiJ0xwc6EXlVQyAVjRISKyLfv2Jjds1l6vPi8Ui91z9Ztft9
	 eO0QKnfLcwo8mF8CAbFnJvkc597LhFIgZ5SQpUi/yanlBCL2zA/9uiQKqkoe3os5WgWGS
	 h9XQKjUXLy1vkmjUVvEHKC05VXECk/NGB/G5g2Ae/llsp1ns1d0luHLG1m3/ssNkoKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04ECvPMo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CAA2606A320;
	Wed, 18 Nov 2026 22:41:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=04ECvPMo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 878861F000C4;
	Wed, 18 Nov 2026 22:41:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041677;
	bh=V2Dox9Y8LGl8TXk0Nt3M89TyskAo72CHjTYZx08iiQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=04ECvPMo9VUO4Rn22CpSCBKLFseUyA/y8TnxpiWSaU5WlnAyxXKxfoM/qYmSdVn0e
	 s/acoklFtH4LlS4VyBoUiYveStmfYnixIu5iI+Sa15VVflT7lzHEIb2V7vgLLIP2++
	 zQK6hEbY8i0UNW1ObIrBB4O/DWtBWdJPX6UreD8E=
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
Subject: [PATCH 6.6 2900/3318] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 15:58:42 +0100
Message-ID: <20261118150447.483182893@linuxfoundation.org>
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
index 41799c152403a..635d0249651f8 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -95,6 +95,8 @@ patternProperties:
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



