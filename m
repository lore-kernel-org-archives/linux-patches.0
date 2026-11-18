Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015490;
	b=Ute/3Rlj8Wiol3uoE/Fcg3ICVAJnMLtnhT5z/StWyUEjBcXW8Yh1kp3ANiiSuAI/cSMq
	 osaKnocyzFLKeiXU6gkOAolJWNziVXioa9ve9NrRyrU9ZCWLlc1SiMxRN/ZM31C/pEPgV
	 g8hDDEWiy5Q8rRiGNg7Nqzo41bjhjnxgKb8kxaVYiiTml8iody3vrIgqEO0gpWSLrNnbF
	 cvZZzDZRO6046xCpSx8++STbaqGlVAvKROY60dBSs+xEOgHmSgOOasH03htyowJ2rxe4i
	 r0O4We/1a1hoelg+ObyPLbObIR+CjlGqNlbjSBQo9+nb67U6hGUJzd5T6flLJ843/FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ay2Uo90r8OpJN/wpWdfWnrBPdPa8Vo2m2pK26wF+gk4=;
	b=aXYBTKjDyBvUjBa3ijMjSxP6oJEqxo9FJxoL80UChdhB7kwpd5UMzWAMkQ6NdREvALPf
	 n0VvrDMhoz/Kp9kmTlpURxGJXz63u8NQiiXv8ABxyoOX5tDN1nJbN31YCpaMsGuVwg1CH
	 laEwdL93vXDyMmvsa/8nnZcFdKYgeUQ38rFJl/u0Fr5m7XFmb5ObPrP96bllvvTiYfrN7
	 HAiWi7bEiZn+3hUs2iUlr69rFJoKyXeXe0Kl2cEJdNhE/hRwpPMZhjguAXP0SwF/AxIzo
	 dp5uDmJL9N09ivgsYN1QJmM9hnFumd8acbKH0w8/F+J223tBKNN9mL1MWcWob7PaHdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGaB+Azq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1619606A31C;
	Wed, 18 Nov 2026 15:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hGaB+Azq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F7F41F000C4;
	Wed, 18 Nov 2026 15:24:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015490;
	bh=Ay2Uo90r8OpJN/wpWdfWnrBPdPa8Vo2m2pK26wF+gk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hGaB+AzqCgK8OcCwqp94MW/Yj18qaxdc7zd0b83PNG8Sblass0d/Zo3Y1pUnWVsFp
	 BUhhJu5swuBYjBPy75EotxsB/SBxc7HUu0ikhAuSKzPRsr04K//S7i+khze55gRQWQ
	 ra/9S9pPyqgXzBDanuI/cH/h9ojqtFw7IiaNn9m4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abel Vesa <abel.vesa@oss.qualcomm.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Alex Elder <elder@riscstar.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0191/2651] arm64: dts: qcom: qcs8550-rb5gen2: clean up PCI function nodes
Date: Wed, 18 Nov 2026 15:23:51 +0100
Message-ID: <20261118150254.739436135@linuxfoundation.org>
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

[ Upstream commit 3f7d46aaf5565471f65b2e21fbb649cedc55e6b8 ]

The Qualcomm RB5gen2 devicetree source file defines a node representing
a TC956x chip which contains a PCIe switch and an embedded endpoint that
implements two PCIe functions.

The devicetree nodes erroneously include a "pci" device_type property
for the two PCIe functions.  That property should only be used for a
PCI device "that implements a PCI bus".  Remove this property for the
two function nodes.

In addition, only PCI bridge nodes should be named "pci@" (or "pcie@").
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

Fixes: 33cae252054a6 ("arm64: dts: qcom: qcs8550: add QCS8550 RB5Gen2 board support")
Reviewed-by: Abel Vesa <abel.vesa@oss.qualcomm.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Signed-off-by: Alex Elder <elder@riscstar.com>
Link: https://lore.kernel.org/r/20260902214321.1721477-7-elder@riscstar.com
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts | 12 ++----------
 1 file changed, 2 insertions(+), 10 deletions(-)

diff --git a/arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts b/arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts
index 9df8dcd6c62b6..e6340f7d30dd8 100644
--- a/arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts
+++ b/arch/arm64/boot/dts/qcom/qcs8550-rb5gen2.dts
@@ -1126,20 +1126,12 @@ pcie@3,0 {
 			ranges;
 			bus-range = <0x5 0xff>;
 
-			pci@0,0 {
+			dev@0,0 {
 				reg = <0x50000 0x0 0x0 0x0 0x0>;
-				#address-cells = <3>;
-				#size-cells = <2>;
-				device_type = "pci";
-				ranges;
 			};
 
-			pci@0,1 {
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



