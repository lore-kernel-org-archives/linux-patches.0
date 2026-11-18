Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048594;
	b=oZQiRgQOvTvIEFGpWUf4ftCmxzv9GwsbLxnCPBe6L6Clay+BLW4aN5hv+3/3IoG0PDTp
	 aoDB1+tsD1QNAzeP67f4YGQXTifvycSbqnDvRmeShazPzcyZFmcNk8qBV6hJ05QJn7ito
	 GSno2s5qZw3EyhAcPZqTGCaXB1a2jUzkpXXVmET+yiKXFgsFgA13JAe4NBCzztL8ZjZlf
	 MOtjmbq+5lqPH3m8c01NBGskVTIoYt7ErqgQ2LzNvuFWrAKtHRqE+B0g+xcM0JeBgL/qG
	 8eVljWtpbHSBDNJItF+TZ+Mypsrz+Z0InK2fH3Pca1Ta6aDejroZ1QAo861st+YySxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048594;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+yF9vf4jbp6UOTirfrBrMSl3roW1CGDTuQKKLVdvEoA=;
	b=k662T2XBJIen1pxvXC4RMXn7ndkFUlZ3dyMVF+haSUfsGCZ13U0xlUWi3iNd+MWYFAvW
	 EPy3pM1Y/oQ11l8edufg68SCbRef5wKtGIovdnM90h5YdpXX5bieoQJDU6U/D4T1S4S/q
	 mtBiPg6r5clicnk0EF346Uwj91AmhFGsKF7UqmFkG30wsXUR7edFrRtWCGuaCNXoG2vXZ
	 Z0MEB8eUHRwQLCOGdfkPU9RaTjueeQypd/uzc71cl0K0kMPlU6+QQUqO/XOn+46mzhdJc
	 B3SJ/OTu7WiSkK7MRI7GhnM+ZxqeCOjAQEfxe97a/vFu2KL6LrJUgsabURTiS6QGkuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnXdK60p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 844EF606A31C;
	Thu, 19 Nov 2026 00:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OnXdK60p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97521F000C4;
	Thu, 19 Nov 2026 00:36:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048594;
	bh=+yF9vf4jbp6UOTirfrBrMSl3roW1CGDTuQKKLVdvEoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OnXdK60p+7AIb+PUwd8ZCJfVaNw3DkiqN4XtObvwmqiVe5D8V1eUA6OWVDDIg3iMf
	 uu+PLEZHtaR1h9EL7r+TpTY3+XQrCxYUgLAcO7s5zcWkqXV4Zljm8nliupyBQGvtd7
	 lia/d6gx5v74eqHFGZ7ApbNTOZMsqEBWE27IFQvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Lin, Meng-Bo" <linmengbo0689@protonmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2033/2857] dt-bindings: vendor-prefixes: Add GPLUS
Date: Wed, 18 Nov 2026 15:51:07 +0100
Message-ID: <20261118150314.607979823@linuxfoundation.org>
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
index a806202b80a78..61ced5bf9a74b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -508,6 +508,8 @@ patternProperties:
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



