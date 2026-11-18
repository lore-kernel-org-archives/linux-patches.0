Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061725;
	b=Yob2smrelQzQOL31T+vz0CaW92kmsnAU2Lc91H0e7YAWRXqgREBkIw30q8FiC/Ckdjjv
	 iJSHBnrETTntuh/RbNOYkvHigoWD4s57gk+kGe/uc3DXfoXVl9cmTt8NXFBF1Aq14Fpm4
	 jRqXhDnnmbda0u+cmhH7rLH8AxZAHYUaOuD3SApgnEXI2cqvd2MZ+a5sTFYtBPoqKXtym
	 HASZYm30Foo+MksVLsq5e5aa98VugIqhvT7yJWxu/hKb3aRid/i7RoZIasKHJOUfPEwD+
	 AeGdrOgu8uv+5u2nmp3tbJwIfewwMWCarwWwNqA96+qpCqlt3bwGd+3bXgb+DewFUcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=6zQvyC9kGj9ypjlkPwcIeBdZpIX9AtoUvb6wUolUlw8=;
	b=A3EvWvgoTjjZyNYaLIfg9i9iFdbL8Sq1TdL6WNYxkA/+DKWz3wAqHjuM/jdk1RtX02/3
	 LP3bOVeKnSmb6ZRsi0SIdRBWZPQLKkr+IEThBq1GgnqAfVreOPikU7Ix984DW/XkCnTTa
	 hvorXsTJAhJMGy3YJjcL5yjASw3vsNK4hridkq5RtUT+jM3PrNa1W7XhhVLe8QmdXfdXN
	 EAnJWvV3dymW+xn7OuxFFeMX2q9g2dGztFL2NbQzCWujT1Byl2gUYQ46H4ziiDOttoUjI
	 +tSEbdt0NXqYSqK9777wqM76VxrPToFViUA3pF8/J2gDMR2q2KLYLKoQoqzfjRBUajA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTncA2X3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08340606A320;
	Thu, 19 Nov 2026 04:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qTncA2X3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5278B1F000C4;
	Thu, 19 Nov 2026 04:15:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061724;
	bh=6zQvyC9kGj9ypjlkPwcIeBdZpIX9AtoUvb6wUolUlw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qTncA2X3NV6SodChC9pvg4FLV7h7tGiZJgCw8ZfDcn4kk7aC5/WBYG3Z2B5IJi7K2
	 5JKLfo2Y/3INF3evJvZ0kw6wDf3gzZ4QRHYheatWT1c9YPJe+pkR8sp7kTqLf38JuR
	 0NGttFo/+3OW+mf0o8k1AtjFjDWpr4Spf9tQUAu4=
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
Subject: [PATCH 5.10 1656/1848] dt-bindings: vendor-prefixes: add Ambarella
Date: Wed, 18 Nov 2026 16:01:34 +0100
Message-ID: <20261118150029.040131888@linuxfoundation.org>
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
index 6a18a2333ae04..4fdfdf8f162cd 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -73,6 +73,8 @@ patternProperties:
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



