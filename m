Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060780;
	b=ueKz785FSVpR/AnxA3C2CvrluV/+DCosL3pF8ZGfkM6b8wEMZHiW33YFou1p3LPZ9GMX
	 /B8r3mRDOnBN2/bamzXEdSkxEf5AzpHqbU8jMc02h3dA9ygqjImqPb2EPwx3OrpgOM8Pg
	 KqEmxVHM2cMs4uL9xdzJosb9SCEyOoPVYS81kTqpsEVVCSW5ld1xTVvhwGpvJUOCNleXR
	 0pPrNOTSaRROpYz+bfYoAPzrl2Y/a/U7VW+9uwCbMsVY4gJsUFxLXPBnWZtUtZQgmnWsr
	 Qb7YSubQY4ZKaAy1G67SEYfUqMgq6QGHrhZIRSbhdoeA00naASqwa4OCWuikYKVTw7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060780;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BrkoJziW6mAEM8SRne/PFiRyHHh+Yhh1MkIK3QpXOWA=;
	b=fKC9jB7hU4l0n7C7QcU725OBPjnuLfcncJBok1O+YVohQSKQtX3jJCrIBjARV602FUDT
	 Qr4//muHM+4ppwTI2jaunF5cy4Lj84GnEBhD4kjjAI3jbvvUQtlKglj2mQxw7VVOoCg3T
	 IaZ9H63ToGaKZwze1S5rj1AGF7fX1omRNoi+O9Yb7FRGW8H3Y4no0eD6v0sYxyu1L2I5n
	 vE4x0A3g6o0HMdM5dls0vv7fRvRwGFQcMM1VfOgYma3v1VglBWmSY5w3GjgBNOWNsyVgC
	 TAPS4sUtDuVuzf4262vEMAC5YaydHgSubzi4Y4mWGQVrwP+wClGbjM4bvBPc3sySH7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1huywA5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6322606A325;
	Thu, 19 Nov 2026 03:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L1huywA5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB251F000C4;
	Thu, 19 Nov 2026 03:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060780;
	bh=BrkoJziW6mAEM8SRne/PFiRyHHh+Yhh1MkIK3QpXOWA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L1huywA50Adaxr76j6M5GJpHZqrnyJWVKvgXBNNa06ExARPp8oIDqsdEOyu6Omvk8
	 X1/LqQ5aFXmcZh5kTSvD0ZvORGSgwNrfuYiNzuX6JrDHqJPlWXKXAFcLXAeWfTf/xg
	 HpMx9pgPsobi/Otx4ilzlln7SKkqyxVC4MB5NOXM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Icenowy Zheng <uwu@icenowy.me>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1321/1848] dt-bindings: vendor-prefixes: add Genesys Logic
Date: Wed, 18 Nov 2026 15:55:59 +0100
Message-ID: <20261118150014.948249518@linuxfoundation.org>
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

From: Icenowy Zheng <uwu@icenowy.me>

[ Upstream commit 38cea8e31e9ef143187135d714aed4d7bd18463c ]

Genesys Logic, Inc. is a manufacturer for interface chips, especially
USB hubs.

https://www.genesyslogic.com.tw/

Signed-off-by: Icenowy Zheng <uwu@icenowy.me>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20221206055228.306074-2-uwu@icenowy.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: aa906abf611c ("dt-bindings: vendor-prefixes: add Free Mobile")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index aeb046d4b1d48..ecc4c3a300565 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -409,6 +409,8 @@ patternProperties:
     description: GE Fanuc Intelligent Platforms Embedded Systems, Inc.
   "^gemei,.*":
     description: Gemei Digital Technology Co., Ltd.
+  "^genesys,.*":
+    description: Genesys Logic, Inc.
   "^geniatech,.*":
     description: Geniatech, Inc.
   "^giantec,.*":
-- 
2.53.0



