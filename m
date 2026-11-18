Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015479;
	b=kj4cV2/Rx6I9ZlpcXe1MY6HEXKlI+Wym0KCDmqdSypLKJXtpobw2gBkcVp6uktH+lFo1
	 keFDQDZPHN2HAF8aPqzgbwMQXlkCke5YNtpHG1SJUZ4p8jg3lJzJFSo8d2j8+/c9xrKlK
	 6aDbL1mYki7N06sVWT22kDXoOSlxt6JR32/0Z6HhPfQIdWSVJ60hn31Jjsa4XJvwl0ZyQ
	 RzlgrX520xxfkfi2fcKcU9CLEnJfnljz3mgq3D+FFml1nTzc2cBBq/ER2Jjcmn8pe7Hsc
	 T8KcCzAb6s8KGNVBjvDLF3Ug66prq8w7PaoxvTqrqsNiC2sgaHXTGO940G8RzCcG8VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015479;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qam66mzj76sxUOIn7Pfhz+0lvezMo/M1aJ1+wk5rnd4=;
	b=4r/OjUVVFXZXUsuUEmDKPQ9PJ2WkS9bJiXnLe0nNBhK5olZRP0JJ9PwBo7OxGHFxWYKb
	 aw15ooKYqG8KXef0Rt4sJAubYrZv3t5IMy8XQ6uxrqVV1Dr1ulIzXUOluRfQ7LFcHFIeX
	 dd3DgjHKsrpXj2DgBaFzsY6/tXC190VZOEcdv+b84J1r0wfgWkDF7sbTuRpaQ8/RRdo6h
	 laKBAO5lX+KrRExZ7fDdfeju2dgM7vRxglkRRx2wf4u47Dyy1pEmBOvz+C8HAxMw1a6dQ
	 h6n3dORCGg1Y9hN1QSoL2XMVB3VV1op/S3GBrNGWZ8NHZWhMP0FZ8sxxjo8gpOV9J7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C05wSZEk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5913A606A320;
	Wed, 18 Nov 2026 15:24:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C05wSZEk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B103B1F000C4;
	Wed, 18 Nov 2026 15:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015479;
	bh=Qam66mzj76sxUOIn7Pfhz+0lvezMo/M1aJ1+wk5rnd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C05wSZEkGmicHxViwoCkdc+ENHBbnXnUATHFHVYeS2ugtxBUZSGk6tVKoBzwKPjAr
	 kOmB3cF9BT83uORcXB+7xJRgxbMDVxj58hilv7XV0ofeIsHEZLjNXIOkNePoMLnJGg
	 VN1DYZFxnTzWf1C2TO8JrPGDtn6VM0pf9dgI+xRU=
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
Subject: [PATCH 7.3 0188/2651] arm64: dts: qcom: lemans-evk-ifp-mezzanine: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:48 +0100
Message-ID: <20261118150254.635984723@linuxfoundation.org>
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

[ Upstream commit ca3027cfe8c7ef612910d2f04e58d75ec8a9b427 ]

The lemans-evk-ifp-mezzanine overlay defines a node representing a
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
Fixes: b64abb26a2916 ("arm64: dts: qcom: lemans-evk: Add IFP Mezzanine")
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-4-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso      | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
index 6cfa0bc1440e9..e42314c648579 100644
--- a/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
+++ b/arch/arm64/boot/dts/qcom/lemans-evk-ifp-mezzanine.dtso
@@ -271,20 +271,12 @@ pcie@3,0 {
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



