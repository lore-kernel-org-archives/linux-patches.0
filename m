Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024536;
	b=laPIFlowUCl52fODrl2jyR7khYb96h9ciLeKBZrvPv26XvtiM2eyUMGgiRxgGQEa2XzH
	 GpFq0LJVz5jjNSF6S8Z3HacdxmrIztEQWeqpf0X/62DUaaYy+moWNAytJFT+aPv71N6zI
	 nFgsD2oeodz6gFvxn3soi7PDM4XM3gIe9RTK/s0YuqJ9/lOkU4hfI0icOvPuaF2rdwwBk
	 phpc4iif8dtNRZQrUX2iUcQQPwYyXcvJhakTh6JJnYoQ22GaiagStZMDpCPJ2W/pvPzoA
	 A0+pMMROYLioyJ451A88IFzWL0eOFSVWyYiNb+JMiGjJnWhEN2Qv2Wk/Wv3t0dkQdjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024536;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NAACWgQDQv8eYitTRyeXH7Lsia6ouctoFiejWQAphTk=;
	b=3HV5kH2Rr0GYeeuDVr8tOpHhutMhwAZeu0tq3GusPb+SBqjnN4Psrqo2QgEUh3xTcilr
	 S9+N77Q4ggrMaegt4BUd5dCAzwQG2PIIR/OotKpe/KCv+s1ZFMa59wgoi2ni+z+G4gn+x
	 H2Pg8oYLO7Zcq/hc9Q0U6BVnhK87aAXiH0E/iQFmwWf6EPgVj24l2o4NRfzchpC8k8u4c
	 aChAINiWwryamTIP2JVJ8uw3Xqw/zyKFLar3fNT1llg5x9+8QJHBgH4Uuof2dHEu4Gmsk
	 7m48Q3LUzr9uf7TFcViAvHf+tk2eXvZQHCVYKpmJW2gGMb6FQ8dPhTAhIiT8xPcG8qw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmGpcqLm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79AD7606A32F;
	Wed, 18 Nov 2026 17:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CmGpcqLm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF58D1F000C4;
	Wed, 18 Nov 2026 17:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024536;
	bh=NAACWgQDQv8eYitTRyeXH7Lsia6ouctoFiejWQAphTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CmGpcqLmrdzaOS5flFPv4IofCNIxsF2WiJo1cCn1FzTpsbPxTKFzLtoq/E675OHCw
	 htjlXkoC9sT/ddaEIrJ5yrRipFezmdVZG7gwPkpOfortYGHF4ouyufTdRMzAf7C1Y5
	 3ZkxnKrU/BDYM8kHrOXDyl92tt76wEXobohSHTvo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0760/2151] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:41:35 +0100
Message-ID: <20261118150149.720050629@linuxfoundation.org>
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

From: Aaron Kling <webgeek1234@gmail.com>

[ Upstream commit ea55bba4c68a49fcb527da6c71dd48879b705fd1 ]

Add an entry for Retroid Pocket (https://www.goretroid.com/)

Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Signed-off-by: Aaron Kling <webgeek1234@gmail.com>
Link: https://patch.msgid.link/20260829-rp-qcs8550-v3-1-198d5b2fc475@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index a2a3fce5ba004..80cbd78cc21df 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1349,6 +1349,8 @@ patternProperties:
     description: Renesas Electronics Corporation
   "^rervision,.*":
     description: Shenzhen Rervision Technology Co., Ltd.
+  "^retroidpocket,.*":
+    description: Retroid Pocket
   "^retronix,.*":
     description: Retronix Technology Inc.
   "^revotics,.*":
-- 
2.53.0



