Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030279;
	b=4jZKGsjHmifgJUhcEV57rCD5wa1iiQtR+0Bq2JdND9WRPOk6840z5rlA+gbIX2HsJTL2
	 NiKI3c3QVKiejVrmPChpqJOj/SKPOgQY5DFU0kmenlsdvm4ZoDU3r8yIfZvOrxbXbIpIl
	 fR5e4ObfIVOKiZH+VceXYQcOVCLNCfuUEAn2zlgDzPp1X9DcE48HNg+luPULIF+G9V8U7
	 i+fC6NeBH42Q5xBeusWMNUUrxdNPaOQ45GUEvVwbpuVswpQCBuYHLlhh8T6YPJf1coLQN
	 kFZEBrmCbxNCKzrDLzejf4kFmGqQnhsGODPdeDzsQcYvzCu8HiSlqId+kel1Id7DRaw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030279;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=n0nM4QU97QiOQ0SG/Lg151JlO/aKk9Gu1ZEcBTE7KT0=;
	b=cwj5URpR5SoWqNfcfMLXpLOryJBnLO63LVBcn+WQAMukt/xGihTx8FVLKpvmd5JonEB9
	 jVaPeMpNsu9ogqgzjdCOSI00e73IHXMRRi1xkvQHPe23QEnfXrqDnn9PzC5nvTSpXxX6R
	 HfFZbSCw10dVZwmK2BYY/+1UDthBaQqfS33GZJK5qPeCcjqshAu/MkXLTwW5V4LVKhnUk
	 njhLwcx0bGkepsJwhRmRa9SO3dvySMZ25W9cmmUNWnBaf3BmPMEHqkO/U4r+kqvEl3DKm
	 8VglVtGF8I0DvFibdWgPvViqrAmEcKU5EuFdqcPIYl4uahVZqMlEkzZHR88hrPfj5dA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWgONK5x;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07AD4606A7CF;
	Wed, 18 Nov 2026 19:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWgONK5x
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F35F1F000C4;
	Wed, 18 Nov 2026 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030278;
	bh=n0nM4QU97QiOQ0SG/Lg151JlO/aKk9Gu1ZEcBTE7KT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWgONK5xjL6UpYZxRYvkwKHkhHOiSU/fLJUb/MbnlXmBgGiI4OuSkHB2TGxwLwo7Y
	 3vUB7GQFTS8yAOUnib2NqzoexFUT+vSSHf/9/Frm0JJFLQ6fJIg4Yfji89izAWAacR
	 dMPCJAmCHFhDKRnfKL0wPsMNhfHEqRPWd5Qe2R4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0607/1756] dt-bindings: vendor-prefixes: Add Retronix Technology Inc.
Date: Wed, 18 Nov 2026 15:45:34 +0100
Message-ID: <20261118150033.125451525@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit da076d5562d2fc99138ff8ab04ff82eee7a4a3d8 ]

Add vendor prefix for Retronix Technology Inc.
https://www.retronix.com.tw/en/about.html

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Link: https://lore.kernel.org/20250420173829.200553-2-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Stable-dep-of: ea55bba4c68a ("dt-bindings: vendor-prefixes: Add Retroid Pocket")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 10038744243b2..a5202c82e7f21 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1248,6 +1248,8 @@ patternProperties:
     description: Renesas Electronics Corporation
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retronix,.*":
+    description: Retronix Technology Inc.
   "^revotics,.*":
     description: Revolution Robotics, Inc. (Revotics)
   "^rex,.*":
-- 
2.53.0



