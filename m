Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060792;
	b=1/bpI7F52BWBmpdI6Fjh9kn0FEDvYtK0MS9M+E6itucimD6qJe7+icVkpu4K7fIqvcuB
	 MNs0Df7LNybvuezE/1QMio2yY9YCJctNuUyKfqoCLK+U3TihV3AqGVly3ue1Mc9dKAdTd
	 znXBdGtC1dYga1YpjmgaoizKByKMqqyCUsk+Jm3lyPIq3tI6ASJgFkUWFbt+KI2c+XRto
	 Y2tkz/cZ8ixnoGy42Zs1EPN9Q+GYmuMVQB1J1JpATa1xJz/1LJtH+oBiMXRXDK7hwtp/8
	 qMbsCvJC6tJJkIDKVsV4tydpZUW3PKOoUi660Gt9x+tK7VIRoo6UmbCHdb+4YsIN1Tg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060792;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9NyZI65CWSGPytX8GeNHARLD21JermIPOhxbnl+VpOc=;
	b=bbkcS+pXG607tzP2HBRh1CBZR/cXbPVf4iwSKHS0YLU+zJeizPlNhGgK6yBpEM7N0siy
	 knBPOWf0gjDW8AbT92Hm4DribhvmA1e11pCcFQsYkoxK4f1gmozBZBoQEPY1M+bItsYfB
	 66rvRJ0B6A7KTO1mEk/SHAMYMsE+2fSEuUQgeooGuk9cSTjZgdsiYRtO/GnztDxYWH27g
	 M3RN647Ol3KmS31sH2/nhY0QwQ/xuXFDhar4ezjjTwGsP+mgXgGT08oXDfSdb2+BP1YJi
	 wBUdGd0ayq/rbFB4Mly8e/rl+lXK7jtDtbf5R0UdCrT7iVGyqK0lO3CCM5lYJ9YkOaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kFF96yl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00537606A320;
	Thu, 19 Nov 2026 03:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1kFF96yl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553D51F000C4;
	Thu, 19 Nov 2026 03:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060791;
	bh=9NyZI65CWSGPytX8GeNHARLD21JermIPOhxbnl+VpOc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1kFF96yl4M8wXfNSuX9li8zmwA5/QIZiCluNOiqci6tm7oUrBckWxL8OkffjKWWvj
	 eBHGNLz61WDB2nOcfpYSB6Utzk/BSJCFJ1mJwkjiATFztV552nnqkhe7FpV4r+JxrK
	 yebvaBPycLzUQqzhW/rRm0f/vOnuSvhfN8k16oA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1324/1848] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150015.144529866@linuxfoundation.org>
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
index 487b4e9d42542..632c92ac6d0f7 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -391,6 +391,8 @@ patternProperties:
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



