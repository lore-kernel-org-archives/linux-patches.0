Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026804;
	b=ODnfyN+t5tMCsOwf6eUkq+jXfz6jw7xOda6X/qlC66YewaaaIvhXEB1vC5ZNOpM+UhFU
	 ufG8V5IL2Murp3J/QCR5pPx91tRYZ/mZB1Pgi7qZJXadi8ZvQmkHkBzlOM4xA2eAh11O9
	 p9hOiPWEDglA9BQuFbbNKTHOgNaWhYKQoT8+zgMrXaEjYCk9TpIUNvCFuLTufytlHZ+4k
	 SqG0ve03+lZB90wFlOaLcE+rvP3UrH3gO0y2r+v4W1dcENHl+PGluqXcWgffS0ypasQ89
	 GKPTL2aLvGqLYj/tMLAb88pdAx3DXBgHRq5z5whkV2Dpmp8bA46+yuO29K0tMxwVIXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026804;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MWwulVh89TFb5hS+6o4Pj1KoUIjoDdUVIumWoE9Ddjc=;
	b=hqe9EdJAcl3SnBjVJDzclwPCN96IEdKUUZYwM2jRK4Chm97BxDoSzGf/Fdk8emJng14h
	 muKyiRX/Y+cxUNW69nmk3vtGGeshr8NP2b9KSG9FFvzqORU9mF+vftj0X7CAAogGhArRv
	 gd4TaJ/CPItFmbPW5P9fNO4Q4z3YxI3tcBKb9sB378BOW1ih5Ububp4eYfmuq9a9A3/pP
	 g789vP27dq99H6qsmfGMbzGCQJgFpjTKFMAeUBx+C+id2hEH8W0aBeSEM9pZrr0T7f4I1
	 cozGxnP/pDVDrGHV5aVDSHponlrraeJ6cc0GN3HPkqZiwAe4Uisbbl5bi7Fl1JPS+vA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUcykYzf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9565F606A31C;
	Wed, 18 Nov 2026 18:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UUcykYzf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E81101F000C4;
	Wed, 18 Nov 2026 18:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026804;
	bh=MWwulVh89TFb5hS+6o4Pj1KoUIjoDdUVIumWoE9Ddjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UUcykYzfG6i4wjlKipcV2k+F7x6Rw/xj/W5aU7ij0dGD22Ee2uNimkKS9D6iCZk/i
	 3nMb/UaisfnaMDQxHGI5/bt6jggL7h8lqClVOWmDmAtETVKTjDngCibIPIlwwxfMcP
	 IV3lsiqQcNI553TggSRT53wgLp9RjHRV3Fc5aJUE=
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
Subject: [PATCH 6.18 1566/2151] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 15:55:01 +0100
Message-ID: <20261118150218.930690329@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 52aa5da45d616..d7e41406f7202 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -108,6 +108,8 @@ patternProperties:
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



