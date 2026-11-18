Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024533;
	b=c1gT7eqjRCnnwSTQQJDB6/pKoS3VLgbv65FnIM8jnlphzQvyoO90wZ5K8AS05Swdka73
	 yKrBspaH6pbCa55n/hYMJnfa+GjKJ1n4qqGOzys04uZw6tg2C6r1Q4DXJp7V10KDPoGcq
	 I2fu2/4IuVhuehQUFR5hmGx73hOmcgZI0r8P1eUbSRHxkoe3jEsb80QKdPnP7Gw+4dLLB
	 YBHiRzM5CswLUJvbUOrjg2DOPBb77tfI+lMZ+ASYFGSTiDxLTjsaWPnNYTQWYneXZ/GCr
	 DKgp3lC9j8E3DmQhMDT3YO3vAFOECMFbJ6DN96EjSooMenJHQyo98Ao+AMH5RHELq7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ac2cZwVTw/n5WigJ518bLbnQHzokIaJ5XCzQMsK8uIY=;
	b=BL5Ibua9umUy2f5HBXxP9f+Ipyx55YuSlmOGRbVevosdt+/r1Ukzvu8FrXO0leoXcNK6
	 o1FctHV+Jq6qJM9HjhYd93lKhph6Az3gDdIrV0yhu3tqUMvT11kNuulpZBAHP2Gg7VPTd
	 j9+opBWcQr/vWDB0s3fBi/oKEUOTdvIms98j1LmJZ7K8AWratUyueMxOjTzhkWjk8cB2N
	 F4ItYpsR+eDG13Miyaoh8v9aE0nfBjzHY/4F4LNturUdham4E8wxcja68dWP0PrjuzDq6
	 eWt9t293nMQwgPLLvx2oIvYIjt8Fd6AysRFWhMhss5g1OeaSNKs4SKTBJYfzOz154BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZLkY8U4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6DB606A320;
	Wed, 18 Nov 2026 17:55:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RZLkY8U4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B6F1F000C5;
	Wed, 18 Nov 2026 17:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024533;
	bh=ac2cZwVTw/n5WigJ518bLbnQHzokIaJ5XCzQMsK8uIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZLkY8U4tXQg49EG8xrWlO3MfBCab/Xip8dr2pEW7Pa6TCSIN0AzlSEXNW97+BGiK
	 HchK/oLRb+rxpTK7uMpm3TEKNeM//oziPHLou81Lbv6wcpkVtKIBOK9b3e6GhjvwH3
	 tV6p17Hbx85wOzx2kJwWv15VY2rsQ9D5VI8tafEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0759/2151] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:41:34 +0100
Message-ID: <20261118150149.687460889@linuxfoundation.org>
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

From: Adam Skladowski <a39.skl@gmail.com>

[ Upstream commit 1658af4d25bd3133d1b3403ccdda6214d40c0ebb ]

Add vendor prefix for now dead ecosystem company LeEco

Signed-off-by: Adam Skladowski <a39.skl@gmail.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Link: https://patch.msgid.link/20260821-next-patches-v5-1-ec81cee63e09@gmail.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 5e80440a22395..a2a3fce5ba004 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -895,6 +895,8 @@ patternProperties:
     description: Shenzen LC Technology Co., Ltd.
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



