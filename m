Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2383F8F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B98CC433C7;
	Sun, 16 Jul 2023 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537241;
	bh=ICxOysXMmltZ/S/DUyfb5SH8ZwZzMSqRHDVO8Nd5UNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxPnKQvudS4vSEHYIbIeCIIuKE12sv6Q+wSPqRicoNMbl+B63c67bmnXZJBAfd/UZ
	 U1I3jdUhcnf8HxiCf2pVFoiyTvvyh+DxVTjXAhFcZR4DrrvosqwZdTe247ML1f32H5
	 U5b/sK1hcjjMdaePnIBzSvOlej+gsesPNO5ZdXmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrizio Lamarque <fl.scratchpad@gmail.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.4 006/800] dt-bindings: iio: ad7192: Add mandatory reference voltage source
Date: Sun, 16 Jul 2023 21:37:39 +0200
Message-ID: <20230716194949.255312839@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Fabrizio Lamarque <fl.scratchpad@gmail.com>

commit c6dab7245604862d86f0b6d764919f470584d24f upstream.

Add required reference voltage (VRef) supply regulator.

AD7192 requires three independent voltage sources: DVdd, AVdd and VRef
(on REFINx pin pairs).

Fixes: b581f748cce0 ("staging: iio: adc: ad7192: move out of staging")
Signed-off-by: Fabrizio Lamarque <fl.scratchpad@gmail.com>
Acked-by: Conor Dooley <conor.dooley@microchip.com>
Cc: <Stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20230530075311.400686-5-fl.scratchpad@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml |    5 +++++
 1 file changed, 5 insertions(+)

--- a/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
+++ b/Documentation/devicetree/bindings/iio/adc/adi,ad7192.yaml
@@ -47,6 +47,9 @@ properties:
   avdd-supply:
     description: AVdd voltage supply
 
+  vref-supply:
+    description: VRef voltage supply
+
   adi,rejection-60-Hz-enable:
     description: |
       This bit enables a notch at 60 Hz when the first notch of the sinc
@@ -89,6 +92,7 @@ required:
   - interrupts
   - dvdd-supply
   - avdd-supply
+  - vref-supply
   - spi-cpol
   - spi-cpha
 
@@ -115,6 +119,7 @@ examples:
             interrupt-parent = <&gpio>;
             dvdd-supply = <&dvdd>;
             avdd-supply = <&avdd>;
+            vref-supply = <&vref>;
 
             adi,refin2-pins-enable;
             adi,rejection-60-Hz-enable;


