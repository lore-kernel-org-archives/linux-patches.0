Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015476;
	b=n83gxsnfI0uknWrYIJT68qc346ldxU1jIaFk7woHXdaDuReuK9viOp4gyuwEJb22tNQW
	 1Dt0lY12AJBeGz1O3i2AZq4MBIf5zWXbTlhR0lw1MQzhh7bMGIu0UQ6mltbfVcnYqT+Fk
	 SJXmK4TBW1PRLdR2Xaf+jj/yRWzrGuXnXCtq+V6HcmNzbb87TwQEpdPrCM75VgNOpDiQJ
	 wKNUMaLLUhnm8Cicx9FyM7UQo0f0krlnROQAtzPxmpNbMk0/VU+GMgSPkaVab6hA0WoGG
	 0txkNIHHde5UXRJb1ZG69s9MNN6aqnuZSXcKBiE619vL1MKt4Q/hORnTTpnWLSxMYIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015476;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yquMqBH1t5IbRkRdl7+eoxjmr/E25fbZcGf/oWprQTs=;
	b=exMOU/3B6bxrJldYVafzhsk9pDd/eNoA6I4xZrfC4JIGf2ur5z49ottEKlEj0Wqiyaw3
	 udzuu2Z0u5VpKFAGaSQrixTZZCwYVAHmnhoIvvHFLvz70UZm1NDOUEuXKBbFmxJGPyCQF
	 /mp+GEjbZA672DUNibYgKH3AUz/kLVN/qqHDiO4dMI2vWiSvD9LTt50Zcdl9UhXO18x0R
	 MLq3CTjyPiXR+s3FkDwO35FP+GohgBgwVEVp7XEtkIjDNby2/wpkyqyu3XbU0I/7lOLIP
	 NkAi1mLKv0CbleTiKQ5MXOmTqT0QSUwPFxtsrMjGF7ASMKFzAskasMcf+KdBIEOBruw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQCShF5c;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87E56606A31C;
	Wed, 18 Nov 2026 15:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQCShF5c
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42221F000C4;
	Wed, 18 Nov 2026 15:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015476;
	bh=yquMqBH1t5IbRkRdl7+eoxjmr/E25fbZcGf/oWprQTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQCShF5c8OGr4mh0oLNA6loWklLNRH0W+3djLrDsLpi+dzk3or7aR/S4BV0aneIc9
	 XAzUHhnF9cmrMPLhuEMCFSccN9h+Y4Hzj+L8xBTEWAsmoH2Fngvm59z/TBq3GUIe9s
	 FarMRJZxnZ7z03jEvgokMdOsxrjDXdc26HE1hMQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Alex Elder <elder@riscstar.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0187/2651] arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:47 +0100
Message-ID: <20261118150254.602439717@linuxfoundation.org>
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

From: Alex Elder <elder@riscstar.com>

[ Upstream commit aaedd4ea312d6fd70dfc5cf430edf5106c5b3382 ]

The qcs6490-rb3gen2-industrial-mezzanine overlay defines two nodes
representing TC956x chips, each of which contains a PCIe switch and
an embedded endpoint that implements two PCIe functions.

The devicetree nodes erroneously include a "pci" device_type property
for the two PCIe functions.  That property should only be used for a
PCI device "that implements a PCI bus".  Remove this property for the
two function nodes.

In addition, only PCI bridge nodes should be named "pcie@" (or "pci@").
PCI endpoint nodes are typically named based on the functionality they
implement (e.g., "ethernet@").  In this case, the role of these PCI
functions is not (yet) specified, and furthermore they will be used
with PCI endpoint buses.  Rename these to use "dev@", following the
convention used in of_pci_make_dev_node() for dynamically-created
devicetree nodes.

Finally, these nodes define #address-cells, #size-cells, and ranges
properties, which are not normally defined for PCIe endpoints.  Remove
these properties as well; they can be added back once they are actually
needed/used.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Fixes: 4559b435f741b ("arm64: dts: qcom: qcs6490-rb3gen2-industrial-mezzanine: Add TC9563 PCIe switch node for PCIe0")
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-3-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../qcs6490-rb3gen2-industrial-mezzanine.dtso | 24 ++++---------------
 1 file changed, 4 insertions(+), 20 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
index 46bb52c667a4d..5259f4f4f8574 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2-industrial-mezzanine.dtso
@@ -130,20 +130,12 @@ pcie@3,0 {
 			ranges;
 			bus-range = <0x5 0xff>;
 
-			pcie@0,0 {
+			dev@0,0 {
 				reg = <0x50000 0x0 0x0 0x0 0x0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				device_type = "pci";
-				ranges;
 			};
 
-			pcie@0,1 {
+			dev@0,1 {
 				reg = <0x50100 0x0 0x0 0x0 0x0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				device_type = "pci";
-				ranges;
 			};
 		};
 
@@ -225,20 +217,12 @@ pcie@3,0 {
 			ranges;
 			bus-range = <0x5 0xff>;
 
-			pcie@0,0 {
+			dev@0,0 {
 				reg = <0x50000 0x0 0x0 0x0 0x0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				device_type = "pci";
-				ranges;
 			};
 
-			pcie@0,1 {
+			dev@0,1 {
 				reg = <0x50100 0x0 0x0 0x0 0x0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				device_type = "pci";
-				ranges;
 			};
 		};
 	};
-- 
2.53.0



