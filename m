Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015485;
	b=4Qh4uWK4UirSAuGllfIOzX4q/x0cs1uiLDRpKHax0fQiJ4zb3bkxMznsBg2kfqw58/oH
	 3LEed9tAwbTgq47C7yY6gnGcu7mw7pRlcTszoRvmfCIetkwl1m6N9y6YKqFFHJNzhif20
	 ruxg2v8d4eobJE749ynP0LRXWlsrr0uH56sa3W112rxdF0KKRb5u8jW/IFVBS2QNNHM0O
	 bnr1RKW2N232vGoS/qZl6JIqB/XLEISmAayKiz+lD7+DNg3dLdvoG8KnL5i2OPUNbgPiy
	 ++FcFW2vklfU66tUyv8bd/AzVbh4I4D7pRkBk5Y8UCOLBCn588xCTNY9z9YgDQle2uw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xo72IEgBRPVDaafNN0cr3cwGfAZm4pSXlTvCJCpPKmU=;
	b=k8bxnnJDv+LAkcekSENifUwtfO464J7YKavYaiwwxS6jRxATZUMctKeKzFfKb0S82GuK
	 CPp370n1mwDkM5xgjNagGuGQLmaZZwh19I7UHt5PYHQrmDPIBx06idkjdmKimsIRAnP+/
	 ixDrBBQYpE3oK5qfo1IaSB2zLKNAsOiXMVsave5kGOrxD6CTiDWZvqklMCq1Suf963mQ2
	 9Puut5VV2LbMQFCYMd0abnW/1RhYxYrwjDrmYz2Gy/talwoCZAZ47aBgB8+mLXhLFqvCf
	 Tbx8aSs/Xoab7a7wPGVx0rSvZidogfFFT2miP8iSSHMIA0A3mXa0IMQnIwLTKlR664A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmg5jwjE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB738606A31C;
	Wed, 18 Nov 2026 15:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wmg5jwjE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1451F000C8;
	Wed, 18 Nov 2026 15:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015484;
	bh=xo72IEgBRPVDaafNN0cr3cwGfAZm4pSXlTvCJCpPKmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wmg5jwjERcso5K79NduOzjix0g9RnDSr9vzhR6CyID3GmdAjVSdFGVwy6p9XEbcTm
	 XKmKyhpQftc4OabN9Xfegl7eQ9MJTGC524lwVBZ/TrZklDrM8oBEi5gnqUHyDGBNP4
	 appddmaRlLjFqJLPhR7oteAAQRmjBdKPwF+BWbCw=
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
Subject: [PATCH 7.3 0189/2651] arm64: dts: qcom: monaco-evk-ifp-mezzanine: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:49 +0100
Message-ID: <20261118150254.671884646@linuxfoundation.org>
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

[ Upstream commit 0f8cbe572057b0ef98c651fbd6da1877983c7165 ]

The monaco-evk-ifp-mezzanine overlay defines a node representing a
TC956x chip which contains a PCIe switch and an embedded endpoint
that implements two PCIe functions.

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
Fixes: 5a67924d2fc57 ("arm64: dts: qcom: monaco-evk: Add IFP Mezzanine")
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-5-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso      | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso b/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
index ca5bf0fe5ec6e..4f727ff6ecb61 100644
--- a/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/monaco-evk-ifp-mezzanine.dtso
@@ -117,20 +117,12 @@ pcie@3,0 {
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



