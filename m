Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016516;
	b=c+RNhnszG2S5DZsJZfUmllTkg8pTwM9es/LgLp3+JDFx5tvLkvmCGGAHKIiX5ZgvuGWQ
	 nuRa2PKVjWKHzDCvYw1JL6pr5P/Qtu7FpoJ91vEIY7esVXWs2UWKUbSFWi6ETQCegQ2D3
	 0OklCNh3Jlbp/u59yiZu5xzlC81BCySqsuslKl+kRSIt4/JKJXpQkVQRZ/YJmkRmzxcnB
	 Wgw4isYYwqng4khPXjnflsj1mk4VTGdheqyhcCnjHwc//J4MgSz+3EJiXndfjA9lVenI0
	 x/FCZD+DWikf8Y2bVPLGcVxdgM+AwO1zlV4Lqi/iwqW+slz6XRPlFtMjc8goOpPy92g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EW+vBuYQ+RnEWPeez0mSlScXD6OBZRTO9IzADPrYGVE=;
	b=xye+F4ZpZEwKL+VT3VdNDA1EoUigqKoFop7q5UeXdwpxxmBC8GYhpUfrUdU/RVxdX3ig
	 UKagcK14ZBKI+mZXM+RpJ7ek9rLBUdJUnmSkrgT6+EWwH3wOaXAJeFQvBR93A9SntDL9K
	 rZ+FUxrpljbUN2LwGlEumc91yQx0/R9FKNAdiFWl0wgNXvpdXHjnSVowWkRRekVRZtFwv
	 FIkgp8i/WfuRSA1PdXScDgKbVwpvGic+epqXKbhfyc8ombDlNGyWdiUwnesJYCYGHmfrr
	 3agC+mrULp7NF+4qbLjkbSdv8RNcCdcQj5A8KNaQaliydHww2VlCOdDKQRRU0eTkEVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2wvsdbi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494F606A31C;
	Wed, 18 Nov 2026 15:41:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F2wvsdbi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62531F000C4;
	Wed, 18 Nov 2026 15:41:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016516;
	bh=EW+vBuYQ+RnEWPeez0mSlScXD6OBZRTO9IzADPrYGVE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F2wvsdbi4KG3QODtuncYtfdFEMMmCsq74jA94IW1jTxbgiFGfyngYYsIpx/G0yj4c
	 QIMKmU0Vzo5ueZHijacL0uEhrgHS2iz+Ct0AJ+87z4L2cIx8xgyx3ZMTXBOfPnfFhl
	 me1eVjaFULj/NM2lnoUooO5Ga6cKeW/9ZRf/BmdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0554/2651] dt-bindings: interrupt-controller: chrp,open-pic: Typo s/pci/pic/
Date: Wed, 18 Nov 2026 15:29:54 +0100
Message-ID: <20261118150307.686976710@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit f0597e96a23b0cc7877581cf907407645ca71c03 ]

The device_type for an OpenPIC node is "open-pic", not "open-pci".

Fixes: a241f1a1b338b714 ("dt-bindings: interrupt-controller: Convert chrp,open-pic to DT schema")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/f2cc11922b3e5dd73997ef8c673137951d3fe715.1788426169.git.geert+renesas@glider.be
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/interrupt-controller/chrp,open-pic.yaml | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
index 642738512f3ce..5363f4c6ffbcf 100644
--- a/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
+++ b/Documentation/devicetree/bindings/interrupt-controller/chrp,open-pic.yaml
@@ -24,7 +24,7 @@ properties:
       - const: chrp,open-pic
 
   device_type:
-    const: open-pci
+    const: open-pic
     deprecated: true
 
   reg:
-- 
2.53.0



