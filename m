Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024280;
	b=20e/oGqt+lbgdLZuL08QGWm9fUbHXJ7hrx87BijYg+pwEOH+MCxHRGRNCl+LoTPWbWSx
	 0/LN9WQeBFLx5DEOqEYhufYgiPMU2yTS3vN3J2wAmmYO1U2Dh1+GTwVjCc/Iz2jsMrlor
	 z2E8Drkxm5tZ1uFCK0oQw3oWTL6AVRHnfC900S3AQ6qzP4689PDcsTzaDlu4ivUSDQ9Yg
	 MMnQFgPlPqitlDGobcC2QJp8+xjiez/xSDbenaMHfACAxKMBPZZ8QuIFK1YaWYmlEcOPu
	 aE81tAM+uAebrn+F0MWaAgpYe3b6acLOpq5vVSzg8GA2WvZviNVOFr/1QnAz3awhiOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024280;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WbRWVz1WpM4yAubmo2N2EF7HqM1ZNrTSwE32OaycNEc=;
	b=xQEWvC/r+rxd2IDVb7o054hjheK5vQvT/WAuiVStz87+byeMOgEOPkb2eOT3xkQf9ej7
	 kgFdlERBQqS4/wN1PP5iS4smFWlUKDF9WUqq3oxIaJqOphd4SFCGUoJ3FKOo/QCzNFqNP
	 GOskAwEfVfFdqBoTgg8cWA6py33XEMEcXud7GczAACYVl+cbx2g2qPPmdxXtIhUkJzazr
	 /jP3CLxq96HP1If3gbi4UvlATjovgLqSh617tyTTmHYYmmJH2EnOItSY5odw9SrBlJ9QK
	 qLUtiams1cKu+NYpm6oVRJ7ZqfJLH34mIxzgf5urI5NetS9JdWgzoEAQJgSnaIZ7Y/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0AXZr0C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E38E606A32C;
	Wed, 18 Nov 2026 17:51:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y0AXZr0C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 432271F000C4;
	Wed, 18 Nov 2026 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024279;
	bh=WbRWVz1WpM4yAubmo2N2EF7HqM1ZNrTSwE32OaycNEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y0AXZr0ClGA1R2256z7I5AHzydtKJhyuTsjVUzLwQOptO2wgI8fNI30BHpYntVjCz
	 V1L6kdp4oUhUiPI0f9axfo3gJ+nS++dqnuGCDPk/DV7OeBYnw5VquKyIozfmSXnt16
	 Sy0IT5ZSBylgHmTkGPX1DXYZEQK0D9VGHIGECMao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Vincent Jardin <vjardin@free.fr>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0669/2151] dt-bindings: vendor-prefixes: add Free Mobile
Date: Wed, 18 Nov 2026 15:40:04 +0100
Message-ID: <20261118150146.194044421@linuxfoundation.org>
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
index 9066860061f66..e6fa43a510329 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -588,6 +588,8 @@ patternProperties:
     description: Freebox SAS
   "^freecom,.*":
     description: Freecom Gmbh
+  "^freemobile,.*":
+    description: Free Mobile
   "^frida,.*":
     description: Shenzhen Frida LCD Co., Ltd.
   "^friendlyarm,.*":
-- 
2.53.0



