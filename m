Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025002;
	b=LxNOl1UAKbCSiEDA2cCjMvV0z3C+6qHviHV83bNpaHIymSiglB5Td+kdK+y8vJNg7Aez
	 idRy+6TnbQVcqz5++KLl4rQQsXBBMF4sp27hBtv/BKWlk30BBuNP+yAdMkapjPXwdMIgQ
	 /rhlvRMPBNklHEikpBYZwPHsAMQKuCRrJ9VT1IqhRkPmZmfLQT42IIYfKScGD8GH2A/GX
	 8Y1sNYsmiOxUKd+MpXWvP4eSzPqLrKSJIgdY1hsCCHa/QtZyL2YuIWSAagcT4UQ9yYMyZ
	 YsU7V6EU8Tud1b8PXCNwl7R1UxsK4LeWHMyGgxEiIQWYn3YUtPk0qdiKRFtxZpbbUSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025002;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TnDOAHPqX4nDCu5DagYe4o6dBSZP1j/N5h4xrMPbFDM=;
	b=pYZIF5aGFl1mBpWduu8YlLggXJLjxln0JLOuCYwHqRgmulfvBaFdVHLL/LLaTBBIxHME
	 TGBfCq9F5MHOQzaw4fU/X1otM9X+WzRoniosECVH0KWNEdJ2p8cV60ean8rtn8DxMJiG9
	 Cahv81lhL1cAtJEdQ/BwYpL92gb6fnPlRTIJYF3pzuUDDZEsNrL2Z3opIdTvmBWe1+sxy
	 7rj01rcbpVAIhUVqrl3q6RSi0N3RVQKVdxwL2rPTf//J5QKDTTd/k8WOzj3uQ6Pp3DmgA
	 Z9FGhwBsAziDcRPXQM4cQRK+sQcs9qn+Q2Wv7wG1q8Fwh2w+kuKiTbOYCtaJz7/AGMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07a0zlmn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D78606A31C;
	Wed, 18 Nov 2026 18:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07a0zlmn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 999111F000C4;
	Wed, 18 Nov 2026 18:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025002;
	bh=TnDOAHPqX4nDCu5DagYe4o6dBSZP1j/N5h4xrMPbFDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07a0zlmnW1lQddJyvVkHyXehXOvQk+9g8P98kKXyQrCO7eFh51ihKT53eQLpnh5MS
	 jD/KNY2D2ntmgwhJeMi4kQsenWel5w+CzvbMHDP8fXK541/NIqKALmQGM6Sixpl/mk
	 J+7KftfWcSIMpBSE+XVu/+0HavthLpPvBiyTcCF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mateusz Nowicki <mateusz.nowicki@posteo.net>,
	Alexandre Torgue <alexandre.torgue@foss.st.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0926/2151] arm64: dts: st: fix sai3b unit address on stm32mp231
Date: Wed, 18 Nov 2026 15:44:21 +0100
Message-ID: <20261118150156.190933864@linuxfoundation.org>
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

From: Mateusz Nowicki <mateusz.nowicki@posteo.net>

[ Upstream commit 4b14dbc4c636e760f5db5a2e4e1b4589d484a7d2 ]

The unit address of the sai3b node, 502b0024, is the address of the
SAI_BCR1 register in the secure alias of SAI3. The reg property of the
node translates to the non-secure address 0x402b0024, which all other
SAI nodes use. Fix the unit address to match.

Fixes: e9b03ef21386 ("arm64: dts: st: introduce stm32mp23 SoCs family")
Signed-off-by: Mateusz Nowicki <mateusz.nowicki@posteo.net>
Link: https://lore.kernel.org/r/20260924193759.27881-3-mateusz.nowicki@posteo.net
Signed-off-by: Alexandre Torgue <alexandre.torgue@foss.st.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/st/stm32mp231.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/st/stm32mp231.dtsi b/arch/arm64/boot/dts/st/stm32mp231.dtsi
index 57ab9d785f347..8a109e46af391 100644
--- a/arch/arm64/boot/dts/st/stm32mp231.dtsi
+++ b/arch/arm64/boot/dts/st/stm32mp231.dtsi
@@ -557,7 +557,7 @@ sai3a: audio-controller@402b0004 {
 					status = "disabled";
 				};
 
-				sai3b: audio-controller@502b0024 {
+				sai3b: audio-controller@402b0024 {
 					compatible = "st,stm32-sai-sub-b";
 					reg = <0x24 0x20>;
 					#sound-dai-cells = <0>;
-- 
2.53.0



