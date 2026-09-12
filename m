Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D01C427F91;
	Sat, 12 Sep 2026 16:26:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230383; cv=none; b=rkUfXy1+ebUZSANSPQUIwa3jMGYbVjd8QZzAqpGb1RJk48n7LJhuLjfVba6LGK+0LzhASQS9BgCVb5HpgMeceGeB7/DVA/7+4wBZRPQhcHRzNwpTkcHi5wRgE73PE/n+5l2JxpWwGgRRs4/7qKdTF42jF6+dtkFdpArzajWmqvU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230383; c=relaxed/simple;
	bh=J91lnxftg/7OhubuqxpOAX3tlBIc6Mcz8R9FpClogBc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0VKvEr2DQjamd9Jhos9feBVPPGrqYrMQ3BY+Ug7SEaHhWu0kFvA1WqAJolMinXLN+GwLYwDvu3uVw3Scv9qmcOwjIqs9MC2SGN8kg/PRBRZmX8hkZY4pR29aUZ8DMdMWEv3PCI4vsJrKUvlWfkng2gX3+X7W1T2PL1DeL9QK5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onVEx1eK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onVEx1eK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F060B1F000FF;
	Sat, 12 Sep 2026 16:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230381;
	bh=hPEV/zbzt8fr1zzmSIBGWClhYNAq4yh5vw2kuodtzDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=onVEx1eK3Znht/tnHd/0kN1cjOraC/0cvNB3Lmn4nYyLqyk+Gdagqmrovhwp3317T
	 Iz8cWhPrgMkvGDP4E50IiMMlcR/681eFcZpOnZNkxowIYn5UkOJwwpMtg35i5wn4zX
	 14Y/rWeFcKEm4ZOAR4vriMy2tjK8cX3pTCKF/GQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0780/1191] arm64: dts: qcom: sm8550: Use GIC-ITS for PCIe0 and PCIe1
Date: Sat, 12 Sep 2026 08:58:28 +0200
Message-ID: <20260912065605.796120066@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neil Armstrong <neil.armstrong@linaro.org>

[ Upstream commit 114990ce3edfd059648889f978cbdc83447b305b ]

Both PCIe0 and PCIe1 controllers are capable of signalling the MSIs
received from endpoint devices to the CPU using GIC-ITS MSI controller.
Add support for it.

The GIC-ITS MSI implementation provides an advantage over internal MSI
implementation using Locality-specific Peripheral Interrupts (LPI) that
would allow MSIs to be targeted for each CPU core.

Like SM8450, the IDs are swapped, but works fine on PCIe0 and PCIe1.

WiFi PCIe Device on SM8550-QRD using GIC-ITS:
218:          0          4          0          0          0          0          0          0   ITS-MSI 524288 Edge      bhi
219:          0          0          5          0          0          0          0          0   ITS-MSI 524289 Edge      mhi
220:          0          0          0         33          0          0          0          0   ITS-MSI 524290 Edge      mhi
221:          0          0          0          0          3          0          0          0   ITS-MSI 524291 Edge      ce0
222:          0          0          0          0          0          1          0          0   ITS-MSI 524292 Edge      ce1
223:          0          0          0          0          0          0         38          0   ITS-MSI 524293 Edge      ce2
224:          0          0          0          0          0          0          0         31   ITS-MSI 524294 Edge      ce3
225:          0          0          0          0          0          0          0          0   ITS-MSI 524295 Edge      ce5
226:          0          0          0          0          0          0          0          0   ITS-MSI 524296 Edge      DP_EXT_IRQ
227:          0          0          0          0          0          0          0          0   ITS-MSI 524297 Edge      DP_EXT_IRQ
228:          0          0          0          0          0          0          0          0   ITS-MSI 524298 Edge      DP_EXT_IRQ
229:          0          0          0          0          0          0          0          0   ITS-MSI 524299 Edge      DP_EXT_IRQ
230:          0          0          0          0          0          0          0          0   ITS-MSI 524300 Edge      DP_EXT_IRQ
231:          0          0          0          0          0          0          0          0   ITS-MSI 524301 Edge      DP_EXT_IRQ
232:          0          0          0          0          0          0          0          0   ITS-MSI 524302 Edge      DP_EXT_IRQ

NVMe in SM8550-HDK M.2 Slot using GIC-ITS:
212:          0          0         22          0          0          0          0          0   ITS-MSI 134742016 Edge      nvme0q0
213:     133098          0          0          0          0          0          0          0   ITS-MSI 134742017 Edge      nvme0q1
214:          0     139450          0          0          0          0          0          0   ITS-MSI 134742018 Edge      nvme0q2
215:          0          0     139476          0          0          0          0          0   ITS-MSI 134742019 Edge      nvme0q3
216:          0          0          0      69767          0          0          0          0   ITS-MSI 134742020 Edge      nvme0q4
217:          0          0          0          0      80368          0          0          0   ITS-MSI 134742021 Edge      nvme0q5
218:          0          0          0          0          0      77315          0          0   ITS-MSI 134742022 Edge      nvme0q6
219:          0          0          0          0          0          0      73022          0   ITS-MSI 134742023 Edge      nvme0q7
220:          0          0          0          0          0          0          0     329993   ITS-MSI 134742024 Edge      nvme0q8

Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://lore.kernel.org/r/20240122-topic-sm8550-upstream-pcie-its-v2-1-b3398d86d1f1@linaro.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Stable-dep-of: 16d98ee918d6 ("arm64: dts: qcom: sm8550: Fix the PCIe iommu-map entries")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/qcom/sm8550.dtsi | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/boot/dts/qcom/sm8550.dtsi b/arch/arm64/boot/dts/qcom/sm8550.dtsi
index 0734db09fbae6..ea03538d7f996 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1416,6 +1416,9 @@ pcie0: pci@1c00000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_0 0 &mc_virt SLAVE_EBI1 0>;
 
+			/* Entries are reversed due to the unusual ITS DeviceID encoding */
+			msi-map = <0x0 &gic_its 0x1401 0x1>,
+				  <0x100 &gic_its 0x1400 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
 				    <0x100 &apps_smmu 0x1401 0x1>;
 
@@ -1519,6 +1522,9 @@ pcie1: pci@1c08000 {
 			interconnect-names = "pcie-mem";
 			interconnects = <&pcie_noc MASTER_PCIE_1 0 &mc_virt SLAVE_EBI1 0>;
 
+			/* Entries are reversed due to the unusual ITS DeviceID encoding */
+			msi-map = <0x0 &gic_its 0x1481 0x1>,
+				  <0x100 &gic_its 0x1480 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
 				    <0x100 &apps_smmu 0x1481 0x1>;
 
-- 
2.53.0



