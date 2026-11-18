Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048663;
	b=S/7/Cgw0iNVOGfHxFkIh3T5mqy/OGnTLRuZmZJGW9Oh9jlNwOv8duklp6L3z/Rz/zybL
	 A85LAHM7UI0AyqY/SHS8XE51cCdRnj7kGNv+zUdxq5rwQO0McMITB8y87C7IKRmrRiYay
	 uzvgLDmQ8m3NwmjlhAkRc/r8Qs7gScvWhHtTi2gjx8nC2GVNZZCpTDIw68rX5i1MtTnKK
	 NTcYXHfUK0UM61ikCHed4oLPAzcfpnEX/iV3DIA4mP5cIHdSHPVftm8AlTFjiLGPvaahz
	 7Ga23kgoy/r5Jcla6JJ2HOAArcbrbctVD6heV8kY14JaE/TWUwaoB1+AaDxPpAvTQfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048663;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x80E+k1dH+N2hWsVlRzrWF8+kBiJVLlMSyReFPcsjXE=;
	b=RVEPKpLK0Cch14d29pF0EP4cp4JsL+GSp6T1sHZbEGKENd42yghjSIkMpeaUn4p+cpaS
	 XVUbilo/YhG4SSCQWBcAFdvBPZapA1hKZIWx14iS4tVDn26i6uWAuKhQ10r6UsY7ZxxB7
	 Ow4BEo3+rexpob7vAhuuRqsVV9eW8V3pAON/QMX9s5wPx8ZucZ8LGDMG1a9WFxwjgLUAy
	 60fxptKFjKENOKToDthUDsZPimFz7xCMipDuuQwe4wFBlhDoijeYKqpOkZejaTXt9rGOx
	 TPdIJm7rDor2Pof+bpANSOXxaprQwzFmnqcjnORD0ul88LMhFhJKIXWihtbKfrVTNIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuShrIQe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50FB7606A32A;
	Thu, 19 Nov 2026 00:37:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GuShrIQe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1D3D1F000C4;
	Thu, 19 Nov 2026 00:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048663;
	bh=x80E+k1dH+N2hWsVlRzrWF8+kBiJVLlMSyReFPcsjXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GuShrIQeOlrY/reRmJlHXifRhP5U+rMkC/8EgQYCmBTTSelT9wqwXTJ6uC3qbeYvf
	 7gbGeP3lcV3p4cCPokuf0uQFbNUf3NXlTxspryssel1eFzyj8NHfybxknPqVygyuLS
	 9ctwiv2vHHBLOcphLuWn56to+3criaj+8fjB4wKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Aaron Kling <webgeek1234@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2073/2857] dt-bindings: vendor-prefixes: Add Retroid Pocket
Date: Wed, 18 Nov 2026 15:51:47 +0100
Message-ID: <20261118150316.056485762@linuxfoundation.org>
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
index 68d89638e6f65..b07d3671865d6 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -1103,6 +1103,8 @@ patternProperties:
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



