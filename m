Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055194;
	b=hCP1aEMYzkWxOWLcEwASCeDiGdueGvP6TkzPaCVM8TlUx9OEp4yKG/k/Q4yfd9gXUjjv
	 0WOZN0NV4x0O/qU4ELSSShyT633XijxuzTg/phOGZm2mPwWFsGwh97GIypU2ueA1HO2t8
	 2aeFCMXxpl+rWSLU6KCgbP14/ehE3bl99gEcHD0nKGhl0Srzr4sLxSQFFjUnQKAzxTq4b
	 +r2gNzjz1dglYslSPH6LPk3p/ux4WNVQRWMO9HsiUYnhE1V30OEWE1ohJ4yeyobnPgQ3D
	 wBj45tFWWY9od6jWMVCoFFbk0bjsZM7WucJoQZzFGbaknl/m4tbWOsfF5bLdrPX2Mag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zHAj16kY74KugsgajIL2/yegySUezbeoxZPzJ0nBFS4=;
	b=tWXdnvQs0Zv48Pd0TCVh7VXe9ohSWADU9enwZ35hLEcLUhorCtp1lyl3ukbY5kwcho1A
	 Vm6VjsixijSz0Q75plNebvK/9NYjhrCjymvYYXUTQ6lhSuUDTvf+nxIdfJPFwXWWf7iqf
	 OSVmfBt4VhW+BoZleI42nlKz3OLBqYVFRkWC9h1HQ7S/suGF3ckYij/rK4XLF5nE0+Gji
	 b50d3BXhPAILwb0qz2SaVTSrKHRwro5N4Ueey55iQg91qE18ZDg8RhKXqmXpgvzTblKLT
	 DY56lCuRLjgj70CBYveUi+onGSNKst+EnDp95fUYY5xrJoGPYef/bSmpNdYnyVuDWJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTBek7kF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59D08606A31C;
	Thu, 19 Nov 2026 02:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xTBek7kF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CB981F000C6;
	Thu, 19 Nov 2026 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055193;
	bh=zHAj16kY74KugsgajIL2/yegySUezbeoxZPzJ0nBFS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xTBek7kFz/JKh7JFNodmbOsW0860DRDT8qI+g7JocuyXO4G8GQBF+o0/bHjpSkX3U
	 Wf8SKUORnOX0YSOCCXrDvjV1xmhs0IJ+xAtBqlEB0c6mdlZQm8y6Li8sDDPO5pWCpI
	 8ODtXVT5Q+qyT9pgQKJjVpJ0hFfQluCl6E/C2LQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1543/2214] dt-bindings: vendor-prefixes: add vendor prefix for Nexperia B.V.
Date: Wed, 18 Nov 2026 15:53:39 +0100
Message-ID: <20261118150113.867647629@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 819a3e62d37a2fe73c1e7f241f2ac086042e7757 ]

Document the vendor prefix for the semiconductor company Nexperia B.V.

The company website is https://www.nexperia.com/

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patch.msgid.link/20260921-topic-sm8x50-nex10000ub-v2-1-eeeaf9b0c913@linaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/Documentation/devicetree/bindings/vendor-prefixes.yaml b/Documentation/devicetree/bindings/vendor-prefixes.yaml
index 2ca68ee8602cf..fd2d25d7fa51b 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -802,6 +802,8 @@ patternProperties:
     description: Guangdong Neweast Optoelectronics CO., LTD
   "^nexbox,.*":
     description: Nexbox
+  "^nexperia,.*":
+    description: Nexperia B.V.
   "^nextthing,.*":
     description: Next Thing Co.
   "^newhaven,.*":
-- 
2.53.0



