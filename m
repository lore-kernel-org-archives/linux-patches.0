Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055326;
	b=WohiPaxzYfNY7Jvxv6eSj0T9O0FL8RFniA56uTGUEFEr7lja3Wt9o55cSs+ZfMFovNZe
	 boLB1j4ktOHPGqXjLF5kypnOEy7+j16ZZofXi5g3QivHfCN6rHrX89ilV60E8VmxaDMYs
	 2BfzL3VRY4zOvJPgNNISJlLzpIxZ30x98teRls2u6P2JqzhKGJQ9W2hqbK53C0i1Xdloo
	 jUi3GDNpw+6pDEQrzBTi0quvqmK7W80wHucKiFW6q/ZHxtn1JUwySYj2MlIqANnjFQAy3
	 xADDBLkWzaxdaWrHj27/hOK+y0HFyV0UW8AwTBsRWt6k3JJnDvTThHdCppbhkrkQskA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EqzKdkFmJUO7ZyNFvMiBK/k19IwHD3hj7WwovDZ9WTQ=;
	b=YbJJ2470mVVAhF6kGvtTSq+C8D1+2YkRj4YRfsvaSvGEaQABMvBr8xtecv8RTygwsjj7
	 vYMxbg4n/rkj/8zC2z+SvtbKAtT2ca/j/SdOLeJUZSMpC6o81ZYALf5vHgbzaRxoytnEv
	 t+83NK7PDV+iqnAsgl/rMWGboWnx4t47ezx+HAkCIRsEQpat29l2oxrVZjUV++5nPS7l+
	 6acO9kXh+8Fxjazp0gW6OQKvXG5OsOW8m5Jeq0NovNwCAvPnhhevzvbmRyzd2r/apH/Nm
	 C1Tmywig5hXjS9BNCCjwg50EJbSQuM0mLS0PWg06AYGrVPKfiJpUdp63O67GzIt3rpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFqTFTp+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C1A606A320;
	Thu, 19 Nov 2026 02:28:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kFqTFTp+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 207671F000C4;
	Thu, 19 Nov 2026 02:28:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055326;
	bh=EqzKdkFmJUO7ZyNFvMiBK/k19IwHD3hj7WwovDZ9WTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kFqTFTp+8HOabQnz7s5faKClSKD3cXvjvImmBAQGZmOOPvvo6QLwnP9zYWqcJEiVS
	 VECEXVVaEmvtvAa7bPWD0sICbbK6ot7LZSL5TiBZ2IqpwYHwRt5CC5l7tvSgRgNEN+
	 njrZPi5VVmknCN+oghlgiyy9Les1ehkMgLZQ84pQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1589/2214] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:54:25 +0100
Message-ID: <20261118150115.557125762@linuxfoundation.org>
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
index d68bfde3b28d0..9de9c419f043f 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -427,6 +427,8 @@ patternProperties:
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



