Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F5B3630A5;
	Sat, 12 Sep 2026 08:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201270; cv=none; b=RbSwCyC6gNJfggvkwNBmVoIA9cl53mWg5YRhSRLnFGsqPWdh8455NZZq5bZqLHApW8DbDsfE0/SSw2mZLVX8vfSi4hgTOroU+gaS3w16ZdS1XOCEFSc6CCCI2UNRfRQ4Rr3dbGn0dTa06EYSQUCUCeN0Sx/kUdaV3AaDdmq4TgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201270; c=relaxed/simple;
	bh=f+ePstvjMWy9rxLT2+ny/59/3VQ0LD17T+W/LhXfKkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D3AXwY8qlJkpvan3aWXv71brB6kfLOPhmZsYbXPVXM3wWNNLLouF5T9SUY8KkeDPTDxW/OFsz7/aqMeUX47FYp34PmjS73HnfZTvLbsRWpxkqTIKbN8NGbeUcYZAPjlApJJVNFUkvL+zDELPhvguEb4rzxZChCbCCgcp+mBX+x4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FDmKkAR8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FDmKkAR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF291F000FF;
	Sat, 12 Sep 2026 08:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201269;
	bh=uWk3mnZZzVspZB9WVRb4bqalUJgrxCmdVwSWXY/urzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FDmKkAR8mc9qu3nkxbGCGPZGzsWDNJNzGu1FKzE9868GffWvSN11BrVgbm+MVaKFB
	 h17cTpPNBmV3lNcCw4i+8ETa73CR9Ff2Z8WMNYFPRtjskJAEco9bZqTPaEyAZmZAat
	 a7homsIir4Jl1bthNgC0qLvEXLKAx69C11B/OKlc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Ashish Mhetre <amhetre@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0919/1815] arm64: tegra: Fix CMDQV interrupt type on Tegra264
Date: Sat, 12 Sep 2026 08:44:29 +0200
Message-ID: <20260912065710.504201823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ashish Mhetre <amhetre@nvidia.com>

[ Upstream commit 5af7a8a522f61ae2a3e5038c889e231e56d63526 ]

The CMDQV interrupts on Tegra264 are described as level-triggered, but
per the hardware interrupt documentation these interrupts are actually
edge-triggered.

Correct the interrupt type for all CMDQV nodes from IRQ_TYPE_LEVEL_HIGH
to IRQ_TYPE_EDGE_RISING.

Fixes: fe57d0ac4835 ("arm64: tegra: Add nodes for CMDQV")
Reported-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Ashish Mhetre <amhetre@nvidia.com>
Acked-by: Jon Hunter <jonathanh@nvidia.com>
Acked-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra264.dtsi | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra264.dtsi b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
index 2d2cb1a3d95cb..bcbf0a558d8db 100644
--- a/arch/arm64/boot/dts/nvidia/tegra264.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
@@ -3393,7 +3393,7 @@ smmu1: iommu@5000000 {
 		cmdqv1: cmdqv@5200000 {
 			compatible = "nvidia,tegra264-cmdqv";
 			reg = <0x00 0x5200000 0x0 0x830000>;
-			interrupts = <GIC_SPI 19 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 19 IRQ_TYPE_EDGE_RISING>;
 			status = "disabled";
 		};
 
@@ -3413,7 +3413,7 @@ smmu2: iommu@6000000 {
 		cmdqv2: cmdqv@6200000 {
 			compatible = "nvidia,tegra264-cmdqv";
 			reg = <0x00 0x6200000 0x0 0x830000>;
-			interrupts = <GIC_SPI 8 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 8 IRQ_TYPE_EDGE_RISING>;
 			status = "disabled";
 		};
 
@@ -3486,7 +3486,7 @@ smmu0: iommu@a000000 {
 		cmdqv0: cmdqv@a200000 {
 			compatible = "nvidia,tegra264-cmdqv";
 			reg = <0x00 0xa200000 0x0 0x830000>;
-			interrupts = <GIC_SPI 28 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 28 IRQ_TYPE_EDGE_RISING>;
 			status = "disabled";
 		};
 
@@ -3506,7 +3506,7 @@ smmu4: iommu@b000000 {
 		cmdqv4: cmdqv@b200000 {
 			compatible = "nvidia,tegra264-cmdqv";
 			reg = <0x00 0xb200000 0x0 0x830000>;
-			interrupts = <GIC_SPI 37 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 37 IRQ_TYPE_EDGE_RISING>;
 			status = "disabled";
 		};
 
@@ -3831,7 +3831,7 @@ smmu3: iommu@6000000 {
 		cmdqv3: cmdqv@6200000 {
 			compatible = "nvidia,tegra264-cmdqv";
 			reg = <0x00 0x6200000 0x0 0x830000>;
-			interrupts = <GIC_SPI 232 IRQ_TYPE_LEVEL_HIGH>;
+			interrupts = <GIC_SPI 232 IRQ_TYPE_EDGE_RISING>;
 			status = "disabled";
 		};
 
-- 
2.53.0



