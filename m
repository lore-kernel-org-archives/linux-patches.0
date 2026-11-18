Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060783;
	b=AMqET0DF4BiglkoJAxSWmrLNv3rGYDX/im7MnyDRJSkgxeuJyztOObzY3qyhEsxiZicB
	 pDCYGvDq1zf8nvEVQ2N7Dqj3p4qEeuF8JdFosm1trOuwCkwqCn6N3KUGCeC1OnRvr0jbW
	 WdcZDjpYuPyxf5KbduN7GLSj5X8i1ZSLfhissxkYHgJZxAR4jXsuduMpZeGrNBrVwFrYs
	 +hsXffJtWoY4DRPnujDqntZvVUUhIRh+1gpcti1QaWWCROZdaAxKD6zi4X4cyUS4ewyuB
	 CvQa2P56Mx+2JVLQo71wsnF9xdFG6V+I7BOijMN1nC8qGxW5TvzuiQyajyKDqUvZRIw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060783;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=f4rMXxQHZwTFT/KXGaNE8qkxMU5K9udoOTNg0XQ3dqs=;
	b=TNBjOwExWFrcPZyqUw1o+Aa9X3qzCxAxG5KWxhHBP3lEk7D5++jsQ051edlrFgrETycn
	 3RTf0PmTWUwO9ver5hDc6XWRSS0W6QAjYBAYBuBD1U9Z+MRs10vOspxAhOwkvYMiUTCzs
	 S9PDkDdmZzGznf4MLtz2rHPy807tOe3mqCgdADhLqrK+UO1/XCvm8/Dge0gykoNLMvHGD
	 DwYzUUQzISoRTe52mjLaFhgSfp34MCskCFPAfdH5WWoHjcf/FDZC412g0RKZCdRoEpZ5B
	 S5cCOG2rrdk0RciT+rw6R8QpJxQNW9XWphjnswsWWLadTswBSTRmi7CxGLj44CBC9JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4xdN3uh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA9DF606A325;
	Thu, 19 Nov 2026 03:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=E4xdN3uh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 138A11F000C4;
	Thu, 19 Nov 2026 03:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060783;
	bh=f4rMXxQHZwTFT/KXGaNE8qkxMU5K9udoOTNg0XQ3dqs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=E4xdN3uhO+bQ4ozqRzdTh06Y3HQ3ljHmQm255C+SuC4kKpfFg30iu4ItP9nhZwLCz
	 WE/IO3Q8Va0SpUGaV3js/cboJ8xyfk6ZqroAwq93Mf7w36QnMfMR+RG4zxWhqvplO1
	 sC+0N4p4FLAyPIV5pqwZcNX6zsFj1Aeq6ccjxBOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin, Meng-Bo" <linmengbo0689@protonmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1322/1848] dt-bindings: vendor-prefixes: Add GPLUS
Date: Wed, 18 Nov 2026 15:56:00 +0100
Message-ID: <20261118150015.019641302@linuxfoundation.org>
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

From: Lin, Meng-Bo <linmengbo0689@protonmail.com>

[ Upstream commit d7a2d86837b9de8d378f040cfc9184905d82bd78 ]

Add vendor prefix for GPLUS.
https://www.gplus.com.tw

Signed-off-by: Lin, Meng-Bo <linmengbo0689@protonmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Link: https://lore.kernel.org/r/20230107133145.139731-1-linmengbo0689@protonmail.com
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index ecc4c3a300565..9d872844d0f26 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -427,6 +427,8 @@ patternProperties:
     description: Shenzhen Huiding Technology Co., Ltd.
   "^google,.*":
     description: Google, Inc.
+  "^gplus,.*":
+    description: GPLUS
   "^grinn,.*":
     description: Grinn
   "^grmn,.*":
-- 
2.53.0



