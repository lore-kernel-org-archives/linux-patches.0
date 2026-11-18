Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015488;
	b=VvQ44LecipAyZsmwpK+FXuiAjceJ/Yms9gsqSM4F1g8BCqCk2crjnrlbO9RkqMMWbb0V
	 egksTquaTUizczupkaGQmJTwfwmljQ1KrYuvQP97RHsOos9WMeugFVDs+wE5OU1n8XDRE
	 8hUwPuU+syIXFd/LxDyeu51wQreo5fF8NWPiUQUDb9TgI/7Sm8u/CULFjgSwJtgA/lg5g
	 nOVkKpiUA6IdJOaC2vtuWURVDNWmycAs3z7UnOC5qcImD0wFWTauLp9sthCucgUsgQba7
	 ibbnVptKVLyrrMooi60d79RzMola+yO26hc1CONsGhXg1RVM5/TSSHAgJCdEGUsBQ4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015488;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hXJZL/wmjen/jAXQVAGnUMOU7VPlNIth/PPZTm+rEH4=;
	b=tAemz1z0QLT9luIPLbrb6df3IkFA1toEIXe9WVdM+ySnYO0o/JTTCWzYilUXeMoLk4tx
	 LF8eo6Zb6w15vwQGfrxZGMqHKPQpwuUNx/TqRp3CVOvH4o22ylHHEyXwe0kO7oQHJQr91
	 7TyluG0eprNU2wgWTA8Q8dN3Umri3Vxdf6k8RjSllFjVCVY6VI/A2qbanr0SMybb1CCc4
	 13lc7lGMlZqnzreFpJdi2QNjvN9AWfINARLWwg4V4fhe0o3K7OR/cJ2a7AqMsf0/ir4d+
	 8xktsioK2KEtyCyNjwAeBQifiOJh/XqSAQFDi/S7KBpA6WNoleRvP22LTVmMc00UiEQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJnlEt7u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EE60606A31C;
	Wed, 18 Nov 2026 15:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eJnlEt7u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3646B1F000C4;
	Wed, 18 Nov 2026 15:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015487;
	bh=hXJZL/wmjen/jAXQVAGnUMOU7VPlNIth/PPZTm+rEH4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eJnlEt7uGZVD+vVcSJaVbh9doaXcZpCb+mxkLDxGD0eysxbZ5yqZVSk3lCXl41TlJ
	 XHEoSgQxS1HwacVwGZLF8VbcoTUNH9zvB5iMGxrQcMCDhgpYguvzdNWH0g7JfwkHWO
	 dT/m5XcrfCZrhVOW/OMcfeZK0tCUdBy3nyUfbqCE=
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
Subject: [PATCH 7.3 0190/2651] arm64: dts: qcom: qcs6490-thundercomm-minipc-g1iot: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:50 +0100
Message-ID: <20261118150254.705006035@linuxfoundation.org>
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

[ Upstream commit 55580d234cec123e9b2964cab30fbfad10774b26 ]

The Thundercomm AI Mini PC G1 IoT devicetree source file defines a node
representing a TC956x chip which contains a PCIe switch and an embedded
endpoint that implements two PCIe functions.

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
Fixes: 1cde54c54b83b ("arm64: dts: qcom: qcs6490: Add Thundercomm AI Mini PC G1 IoT")
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-6-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts    | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
index 31bafa2cf51db..51b59a75c1e03 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-thundercomm-minipc-g1iot.dts
@@ -790,20 +790,12 @@ pcie@3,0 {
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



