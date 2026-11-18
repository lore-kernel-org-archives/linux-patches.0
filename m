Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060905;
	b=wnxdqZ9U7obh9cj4c2TiyeChozToJDh85koRiVeeP3mWFernnRmEu04TdIgopgAIwvEl
	 4nVOl7oMUDCxukr1fCNYkORSzspCtqIazGmQwgv4mlGetkodZ09UHsjDL2rUxPMA/lmux
	 ZuD9D0hrK5TQ4M3gtL1Z2lFlVdslDdPcwOI5foj9LLXSlvYpQnp8SoWX0Rf4aQO0ruxAr
	 5vteBM6vEwmhuTbkiPwHj5VDuRh0FBZncZPatCwdO8d84r10tJ3nz0rntRXnXLUOtbjIi
	 BdcJ9jkVDGkPee+BsYT/B2xQWLXGDrik7aT7tcM2wyOQpPAp3EUMzWCzyXTmmcT5f0Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=u1DUA6LtAakgks5YvZjx6rNNknP2aH/O4rRcKeSPRYQ=;
	b=y6UE7Tj/wVV/NW00msWgtC2I0T6igxDleOBP4qLjRW59Y7Ig/uviIhaFOvJuKF6ZBSD/
	 x4VwcGuZPfzuHJqcqpeilanLnSzwoZjlGlmkqJhF541pQyG/WLEtycClfY84bgJ19INhG
	 PssmA1HcUBfVUcpiwS9yjiB7r8m9q0Z9sBwGT6T0YBckZTsBOvWH42zdC986DS0rsnrSw
	 VWQsdee+UlZ9MFXRmCbOGIAWCiCyC+YTCeg7hLQxqBteCfIO2SN1wMVDUJ0dmi2dIzFbL
	 nsUTskuatZI0nna7L3dglANbGBMKOYSAD3Hb3PoYaMvP0B3G7fp2UtjNGwqCDY1XRyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1DxI6Hv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32ABA606A320;
	Thu, 19 Nov 2026 04:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1DxI6Hv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 812921F000C4;
	Thu, 19 Nov 2026 04:01:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060905;
	bh=u1DUA6LtAakgks5YvZjx6rNNknP2aH/O4rRcKeSPRYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1DxI6HvgOImqg+zImTfqFxEoMoKMSlJyUd5OmuTGB1pGOKDTLj3gMIJmMsbyCC8a
	 S1LHGtYSzit2YWssGPOddodhgoWF7zALDjnncfEzzPBAQp7JQAD9pWb9+R4pCNlFni
	 8PqcjPvhRbhOcPgmJ9gFf052zXC0rKGo+OoRKIr8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Skladowski <a39.skl@gmail.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1365/1848] dt-bindings: vendor-prefixes: Add LeEco
Date: Wed, 18 Nov 2026 15:56:43 +0100
Message-ID: <20261118150016.718545747@linuxfoundation.org>
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
index 762398cf70290..03a5843661b70 100644
--- a/Documentation/devicetree/bindings/vendor-prefixes.yaml
+++ b/Documentation/devicetree/bindings/vendor-prefixes.yaml
@@ -601,6 +601,8 @@ patternProperties:
     description: Lattice Semiconductor
   "^leadtek,.*":
     description: Shenzhen Leadtek Technology Co., Ltd.
+  "^leeco,.*":
+    description: Leshi Holding Beijing.
   "^leez,.*":
     description: Leez
   "^lego,.*":
-- 
2.53.0



