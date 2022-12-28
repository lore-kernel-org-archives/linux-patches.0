Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C141863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:20:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 155D3C433D2;
	Wed, 28 Dec 2022 15:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240828;
	bh=lV8BVZtD0eHnwAEuUs7Ehw9QERV+KVmNiw3i/+e3R00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EhzFY9g4BA9Y0wEeymsmFeo3Uu0nIR3zr6CoNUl/QQ539UpwjEDLSz6ivyRd7/nlE
	 J5YGjqU8PFacS86VLSONBaccWBvN34QL4v+KSNKKn22/8Ow6mSaOZNafWRicN1vrhP
	 UE9MomeaYnxZvEeR7fKsb/jFFtfpp/0bSDxbMr+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <Sergey.Semin@baikalelectronics.ru>,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Rob Herring <robh@kernel.org>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 402/731] dt-bindings: visconti-pcie: Fix interrupts array max constraints
Date: Wed, 28 Dec 2022 15:38:29 +0100
Message-Id: <20221228144308.219933867@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit 4cf4b9b70ab2785461190c08a3542d2d74c28b46 ]

In accordance with the way the device DT-node is actually defined in
arch/arm64/boot/dts/toshiba/tmpv7708.dtsi and the way the device is probed
by the DW PCIe driver there are two IRQs it actually has. It's MSI IRQ the
DT-bindings lack. Let's extend the interrupts property constraints then
and fix the schema example so one would be acceptable by the actual device
DT-bindings.

Link: https://lore.kernel.org/r/20221113191301.5526-3-Sergey.Semin@baikalelectronics.ru
Fixes: 17c1b16340f0 ("dt-bindings: pci: Add DT binding for Toshiba Visconti PCIe controller")
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Acked-by: Rob Herring <robh@kernel.org>
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../devicetree/bindings/pci/toshiba,visconti-pcie.yaml     | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml b/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
index 30b6396d83c8..aea0e2bcdd77 100644
--- a/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
+++ b/Documentation/devicetree/bindings/pci/toshiba,visconti-pcie.yaml
@@ -36,7 +36,7 @@ properties:
       - const: mpu
 
   interrupts:
-    maxItems: 1
+    maxItems: 2
 
   clocks:
     items:
@@ -94,8 +94,9 @@ examples:
             #interrupt-cells = <1>;
             ranges = <0x81000000 0 0x40000000 0 0x40000000 0 0x00010000>,
                      <0x82000000 0 0x50000000 0 0x50000000 0 0x20000000>;
-            interrupts = <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
-            interrupt-names = "intr";
+            interrupts = <GIC_SPI 211 IRQ_TYPE_LEVEL_HIGH>,
+                         <GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH>;
+            interrupt-names = "msi", "intr";
             interrupt-map-mask = <0 0 0 7>;
             interrupt-map =
                 <0 0 0 1 &gic GIC_SPI 215 IRQ_TYPE_LEVEL_HIGH
-- 
2.35.1



