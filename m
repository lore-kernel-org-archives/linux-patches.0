Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050194;
	b=yZn5hSj8VsqkxNQrggFa2mYkZ53e5zMNkuJRK7uhYZGecc1u/Dw6h3J0pA8Gh7+oxzye
	 FMelxjz3wV89uCZpLJoiBFl7tXSDFBoZfI1FnztwLcyWbwEZZNG+gdl71f+Ge7nJ/aJlz
	 0E0o+nhXWa1Z5m2Q595MvKup3v0LjKNVxg9Yc9Qf8aAQ2gA/j+u3u3EmUvhWDSTedVYcJ
	 S159ny+qfRy8BclcnZ0CoFZTxx3NIPKUVIT//3WVuiF5d0htAS1/6KN+14P//edjwuoza
	 AJUzd4TMZ5l15i+lJVbphO+P68koe1bVS9lb7xFawN8T6YBpUV5Si0P8BSTDEvqiRBA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m0/tgBNRg1jKzNBUZxbJbFwjl44ZaNPW+nfHgith8EM=;
	b=FsVIt1xecWV2+UUJCaV7DXPYm5cdepHnz9j8JNbbcUWbRv/e/WkEanLvOkMGZqsxBnmM
	 CeajXUFftTtS4ARroODu3JWivHkDJjTB+KI2pCdjqZs9H+sWhMYTCz8sWgQ9+KsIGlqr+
	 vy9SFtj+XzyGCCOJEDGBY8/zCeign2OMVX/LX3BN+7VFqBkCSI4Ron3amGTSMtT/a9qaL
	 pawHBqMn4mIL6SZRf2d5dCADiDd7zR/f/693nzX02UjH6MnvZKk80fjZi/6tdsd1EoIzW
	 VsR9xqYVZemIB0CKfueEnVscyaozUn0ti28fXDdD9ygXp1GXfNDRTICwU0ds2Hw+wnA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhzO0fzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EA61606A31C;
	Thu, 19 Nov 2026 01:03:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhzO0fzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C41941F000C4;
	Thu, 19 Nov 2026 01:03:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050194;
	bh=m0/tgBNRg1jKzNBUZxbJbFwjl44ZaNPW+nfHgith8EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhzO0fzcYg0+iyhlJV3b6iXYyoYJfp5nQAMsHg2N7fSRUGnpA4xp7vfraHePrDpUa
	 n1Jrb1F0y7fjVGZkv//ACdDu2GwP1dbOwM7+LQLSVsAEIoU4mp1U4gO3CWY6gh2EA+
	 2f4jl0aDFqW76bJtImXKbNJOZLC50sSHixNaQpyI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2619/2857] dt-bindings: vendor-prefixes: Add Sensylink
Date: Wed, 18 Nov 2026 16:00:53 +0100
Message-ID: <20261118150335.875409143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 750a9154dc2a8..9d76e83af9fe2 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1167,6 +1167,8 @@ patternProperties:
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



