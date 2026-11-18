Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027364;
	b=VYyRKwYlsQyVRVlQ5Osr9is8BFEzgvJ2t/4V7M2/w/wrv0jRjJlRCytL0wzIeU2UUnN2
	 DdbgJsXFQEnsODXM+JkZaxQ6Jz5MVsGwYmTU8HXGlPqRXLPYU1YDSGTigX2h+41Pm/jF/
	 /6w0wy6evUmPy8tKc70OFnhFmLY+FXf3hRrkN/R1q3gaz1rDEODvW704dlWrPPvfuJkI1
	 rhYQ6njwcl5k5us6zBj4qTpLvqIcnH5ndGPpN39nyqVbyCqLuUXJR0t/A12wjWZHiU+vR
	 0bmG40hP3RA6TJPbHntx1HQeRoVk5YWjnyhxvQqFsIK4EpzuCcJegvKetnIh7G+pOVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bQhnP2suCZ+odnW63TmVqHxPdST13bGpHolqDXxDDUY=;
	b=NY9ZVeAxO92lBSzzgWIqNLkbsiUqB6cxlEBaXvajMs7azbXt+du/ES91kwUrp7zzaqJ2
	 FxYwqE4S5dN8XXwgK9VlO37DwMFQs6kdqBhlHOrqfTmxa/3h+HnVfVxzaFB2R3wCpGB1n
	 7DJ47tSSOUsoH8spt219Uivco7BpxRoHDszahyP1UsMADj2vQFEjKw9HFfoM8uC6gYsca
	 id/pA4blCt9zCvjxA10i5WtUn5/ysyX0F8Ni9UPtpZB/l3NEhUYNfhIKlzxdHHYl7SWjY
	 XFGykrxiENc1kNd8Vhf1K0RMyjOAxyBJ8hBh/JTCa2edum2jhFQ/ZDfImzABWfhXihw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhFgzFaH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5282A606A33A;
	Wed, 18 Nov 2026 18:42:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fhFgzFaH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5878B1F000CB;
	Wed, 18 Nov 2026 18:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027363;
	bh=bQhnP2suCZ+odnW63TmVqHxPdST13bGpHolqDXxDDUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fhFgzFaHtun4qsrhvuSOS1ePM0bqLtzvk89erGIngCSOzAPHp2g5BfU6YAjg7LXyu
	 EdcJF8jYu94IEhdstAjZ78lK58VvoaTrg42Baw+3njRl3E9NCRZn1Ix1R74yuMdB6A
	 DsuZCQp+7gUGoHtuLZ0o2pSdL554Pm+EIGUgfmaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1762/2151] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 15:58:17 +0100
Message-ID: <20261118150226.026536979@linuxfoundation.org>
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
index d7e41406f7202..bf594638b0e62 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1425,6 +1425,8 @@ patternProperties:
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



