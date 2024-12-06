Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FFAF1474AF;
	Fri,  6 Dec 2024 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496374; cv=none; b=eIl5k8PUGWxJz1lhG/SDdAXtimsjVFLCAINuDVcgDIoo0f0IpOtE1CIf8Ecf2hmMbOWjC2hn5H3lZ9WPZxu/iI0IgTIK127x1x4imd6kTYXsJO2jDiYz9TrgusaqwbP8+OFkRBrDLlI0+rGXoW+IlOI0PjDVh4fEjEe8svTOT0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496374; c=relaxed/simple;
	bh=814p6JNH/kGsbTk1oE6DRc42J0ZQctN1gT1i0yEVkRc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pLANim44iG5JN0BI39eT9GmsUb+eJztJ8nv2VWp4xUHPLmVlg/Zl3Xq+z0dxAmpn1pKJlaOtkOqBM2m46ubmBBpciTqCDlb6JHJQY2Z3nNVcWEDWv8CNl7S38j21886+Lej2lnnoPOkSHeWJY5SLNL3LYq/jFQmJrQ4lRhR1Mu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PjNhR0Fa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjNhR0Fa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D81AC4CED1;
	Fri,  6 Dec 2024 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496374;
	bh=814p6JNH/kGsbTk1oE6DRc42J0ZQctN1gT1i0yEVkRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjNhR0FaxUtBx9OCUcCHtSdMNdGYXg6fas17KbgfeghUbGIBugyqBWWwhSczyGGyg
	 RoR6oEYj6t6+HIoGlopINq4G+fOH3dnMksR3Db+p/FoUTsZvBs9FaLvPq7EmWQm24I
	 TpLb5oDleTWSCxVRR8PyRkp79q7He8rHlkoE9fuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Francesco Dolcini <francesco.dolcini@toradex.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>
Subject: [PATCH 6.12 116/146] dt-bindings: net: fec: add pps channel property
Date: Fri,  6 Dec 2024 15:37:27 +0100
Message-ID: <20241206143532.119610423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -183,6 +183,13 @@ properties:
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


