Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015473;
	b=MNKaF/f+56F+qWAnRvmNL5Op1aQ5W3HBpcvzYvpXGrV1GNId1PHagihF/xARfTXDHGYQ
	 uWJBuQP/KMbEfe0eR5BaZgycilLxxLlJsel6wUNjl4EI35R1cm5kT1bLhjFJ8QB+BsEes
	 KUNjfItuZCOEPpyT+XWMF/isO2lisGSvIZWoIUTdO5B3zV7K8XYrdu1VcGeGEDgs0H8W8
	 Qe7oKp+Kes5bnvhObXy1IT3JJbe6qr7bbJDcDZ6auzHCrOMO64MRqM+EDKbnQJ3SxnxDN
	 hVsZ316lOiwZmaBodHX62RqFP9afHM6tlV0vM5J8ExwPha7FxcnxPnYXuMQpBLnNMyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015473;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GcyM5P0QXdKlAt+OHj3OOel9JJbhrlKQq0IJ0YNVfqE=;
	b=c1PrjtaUDmeMXTFV4hS4OIrF8aitcbg9wHJeidpoePC36Nd7Dpa5Fu6smN0QIdp0+bME
	 iCrl1Gg6hQqohOftnx1bo0Gf95Gp7HZWqUMkQ1Ex2Y6nlMTioIfjsa0Kxsbyu1uDhtgtn
	 MYdHgWTti7QM9EsfW16LhUYtrCFOHyYih8ZmlWebfC+liU3E9OgLTtvFQZhYviUUZ0UVf
	 /2y1t/Kf52N/07cSs364JiaeGh+trXBWaTZS+0zzUs0BQ85FMBSZ14EHC34XgnVQWPUfK
	 7f5JCQ9iR9/E+ML+nPd6NhDqKIEGnWsOkAT2peKGcX1olFY4q+IcOOwJqeEXtZj2hBw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="IUpA/VSB";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9BF7606A31C;
	Wed, 18 Nov 2026 15:24:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IUpA/VSB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A361F000C4;
	Wed, 18 Nov 2026 15:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015473;
	bh=GcyM5P0QXdKlAt+OHj3OOel9JJbhrlKQq0IJ0YNVfqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IUpA/VSBwzEnCSDR7ZqQ1GEfPtlZAqrGCCk/LGhfsDRWLN2klwyxvbHNekEFpOD3J
	 xMS9j5VeXkRKKgfk6JlrQ5N7VD1UspFwUF5HKDVFWsaU5QWvv5tCc9Y8FvB2AL3bUI
	 Akhfx7pMzFvPyYiHFEw5pm3QDDPgUIaIWXZoUjQ0=
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
Subject: [PATCH 7.3 0186/2651] arm64: dts: qcom: qcs6490-rb3gen2: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:46 +0100
Message-ID: <20261118150254.564451355@linuxfoundation.org>
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

[ Upstream commit df4107fc729e3bffce27fe0ed06fc6a64dd675cd ]

The TC9564 SoC contains a PCIe switch with three downstream ports.
The third downstream port connects to an embedded PCI endpoint,
and that endpoint implements two PCI functions.

The devicetree node describing those functions incorrectly includes
this property:

    device_type = "pci";

That property should only be used for a PCI device "that implements
a PCI bus", but not a PCIe function.  So remove the device_type
property from the nodes representing the two embedded PCI functions.

Additionally, only PCI bridge nodes should be named "pcie@" (or "pci@").
PCI endpoint nodes are typically named based on the functionality they
implement (e.g., "ethernet@").  In this case, the role of these PCI
functions is not (yet) specified, and furthermore they will be used
with PCI endpoint buses.  Rename these to use "dev@", following the
convention used in of_pci_make_dev_node() for dynamically-created
devicetree nodes.

Finally, those properties contain #address-cells, #size-cells,
and ranges properties.  And although these properties *will* be
appropriate for these functions on an RB3gen2, they are not normally
used for PCI functions.  So remove these properties as well; we'll
include them in the commit that actually adds a pci-ep-bus sub-node
to these PCI function nodes.

Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Fixes: aa7b4bbcb3a1d ("arm64: dts: qcom: qcs6490-rb3gen2: Add TC9563 PCIe switch node")
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-2-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
index a13315bf0fb07..3bb5fca8e2b13 100644
--- a/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs6490-rb3gen2.dts
@@ -954,20 +954,12 @@ pcie@3,0 {
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



