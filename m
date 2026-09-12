Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A93387364;
	Sat, 12 Sep 2026 14:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789224320; cv=none; b=DUCgkKylDss/C8aTa5EkXn5T+wolmFUkAw1YfuFqrLzZnyGrOmfTq+knfhNpeu674FhhzhNLW70vp2gwAMS6y5mUDEMNhfumcaxHonztcmG96fzHwNpS8M70U2bWk34rFsYyK2yiYxHrGUR/bSqiA2uc0/antK8WstOorJOKZfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789224320; c=relaxed/simple;
	bh=LtdBLJdtPgg2AJQ8jd5Ssxqjdcx0f/uJOUHNl0EqEO4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=drXSVpC4s0Uf8jK33nfn3ImE+Q/c4dyZH9viYD6ugwkOe0JljBFc1z53fO5yTQ8KQKk5UkZUZ+v9E7xoIEwU3coj07Y/nFrfmh+zEpb0MOZF+k1B/SGmg1Jz1UHy0TJYidVdBrNseCOZDbjD0u7y1200XrrzljGnSYY8/yurqhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GszT1yx6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GszT1yx6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE69B1F000FF;
	Sat, 12 Sep 2026 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789224319;
	bh=LgaLqD8GdrkX3kC1Y9PVs/GuqG1PJlt12RaSo7ziSDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GszT1yx6A6pmCawPbY3i/nAGQNU1ILQGZgs9lMj5SBMxM9fsddnLE/m37opS/8Dyb
	 H9rGZo5qZh3erUVNaE+qMIKcGlypv/2D8o4FKQr8ZyBVKft3IjZVzhQFWXXj6BOKVE
	 tbIzj9v2w/FhUhRPJmPf/IBYQgTB/kjIyrPbfFwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0952/1424] arm64: dts: qcom: sm8550: Use GIC-ITS for PCIe0 and PCIe1
Date: Sat, 12 Sep 2026 08:56:24 +0200
Message-ID: <20260912065628.636927385@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a79adbe8da12..565752afe43b5 100644
--- a/arch/arm64/boot/dts/qcom/sm8550.dtsi
+++ b/arch/arm64/boot/dts/qcom/sm8550.dtsi
@@ -1734,6 +1734,9 @@ pcie0: pci@1c00000 {
 					<&gem_noc MASTER_APPSS_PROC 0 &cnoc_main SLAVE_PCIE_0 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
+			/* Entries are reversed due to the unusual ITS DeviceID encoding */
+			msi-map = <0x0 &gic_its 0x1401 0x1>,
+				  <0x100 &gic_its 0x1400 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1400 0x1>,
 				    <0x100 &apps_smmu 0x1401 0x1>;
 
@@ -1830,6 +1833,9 @@ pcie1: pci@1c08000 {
 					<&gem_noc MASTER_APPSS_PROC 0 &cnoc_main SLAVE_PCIE_1 0>;
 			interconnect-names = "pcie-mem", "cpu-pcie";
 
+			/* Entries are reversed due to the unusual ITS DeviceID encoding */
+			msi-map = <0x0 &gic_its 0x1481 0x1>,
+				  <0x100 &gic_its 0x1480 0x1>;
 			iommu-map = <0x0   &apps_smmu 0x1480 0x1>,
 				    <0x100 &apps_smmu 0x1481 0x1>;
 
-- 
2.53.0



