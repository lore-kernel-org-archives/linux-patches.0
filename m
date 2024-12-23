Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6706A8827;
	Mon, 23 Dec 2024 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970830; cv=none; b=UJPYsNmd8aVMDPj6Faro7/8GXg50Wo0vFTHgERdb9R5lrh8cB3Lw6ut25nROrgbk8dqf1Txh4pvtQ5qkhA1SdwRQRY80AvT6dh95Usk6w2gRFEwsisWII/my2LsM51iCL3B6Kx4C8kcKYx7IRCPvXTVVtU8YJylV7O6f7cMEd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970830; c=relaxed/simple;
	bh=jFZB2NKHrIVR2p1IP21MxJ86iexnkYzOx54Ki4Dwx0M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wsl/EwMCh5lYZEse72QLBooq7UZ8VVbyC8yKcmdoYb2WoiQJBHAtYLbHMZ9Lmwd7BwL3suLMMAI95S0c/Bm3v1H8tGDqDadY59e3K4khge8WKDYz/lKTFIVrHpJnEHPvIEKbqD4SL7BSKl7wn/QDdMEYbVTuSUYsITwVWF57KTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OKxzbWBG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OKxzbWBG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA923C4CED4;
	Mon, 23 Dec 2024 16:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970830;
	bh=jFZB2NKHrIVR2p1IP21MxJ86iexnkYzOx54Ki4Dwx0M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OKxzbWBG3qDHxWWcR3x72GUKLQ4jP/PaqRBlHEOKyW7zttqt2Xw8jWKZaCawZ1pwC
	 46GQ2IlMUeAPaB+rY+JQBF/Ks+/nYqM3etMfrMAqimjuRsWwc60WJ6VtkAOVPUKQnv
	 y2OVjX0tiMk9dCl9cq5X5Y3Q/wrtEIcVkEtRYLeQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH 6.1 82/83] dt-bindings: net: fec: add pps channel property
Date: Mon, 23 Dec 2024 17:00:01 +0100
Message-ID: <20241223155356.821894168@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
References: <20241223155353.641267612@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francesco Dolcini <francesco.dolcini@toradex.com>

commit 1aa772be0444a2bd06957f6d31865e80e6ae4244 upstream.

Add fsl,pps-channel property to select where to connect the PPS signal.
This depends on the internal SoC routing and on the board, for example
on the i.MX8 SoC it can be connected to an external pin (using channel 1)
or to internal eDMA as DMA request (channel 0).

Signed-off-by: Francesco Dolcini <francesco.dolcini@toradex.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/net/fsl,fec.yaml |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/Documentation/devicetree/bindings/net/fsl,fec.yaml
+++ b/Documentation/devicetree/bindings/net/fsl,fec.yaml
@@ -176,6 +176,13 @@ properties:
     description:
       Register bits of stop mode control, the format is <&gpr req_gpr req_bit>.
 
+  fsl,pps-channel:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 0
+    description:
+      Specifies to which timer instance the PPS signal is routed.
+    enum: [0, 1, 2, 3]
+
   mdio:
     $ref: mdio.yaml#
     unevaluatedProperties: false


