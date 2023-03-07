Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E83DBA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E12F8C433D2;
	Tue,  7 Mar 2023 17:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678209151;
	bh=v3PEFF0tjST3jgawp8BYT5n3NeHK+QSKciRdRjAH8xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nQDVQl2do0S+GJldX0QDGZbHZJFk6rgSGy8X3ALU6Jky+WM1Gjn0g6vFFJ9WCvk1x
	 HZJby3O9So8Ccu8kQtE8/NtQR5VSG/XU3aS+HCsRNJag42YWTUDp3MzKQ+lLRxdWQh
	 MzRTqFS4DVAhGlc96yqyVmKPKxtD63Ep9dGOikP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0087/1001] arm64: tegra: Mark host1x as dma-coherent on Tegra194/234
Date: Tue,  7 Mar 2023 17:47:39 +0100
Message-Id: <20230307170025.924315414@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 361238cdc52523fd7b1f3aa447c0579f42448b00 ]

Ensure appropriate configuration is done to make the host1x device
and context devices DMA coherent by adding the dma-coherent flag.

Fixes: b35f5b53a87b ("arm64: tegra: Add context isolation domains on Tegra234")
Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra194.dtsi | 1 +
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 1 +
 2 files changed, 2 insertions(+)

diff --git a/arch/arm64/boot/dts/nvidia/tegra194.dtsi b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
index 45a204d753b1b..76c672d2196be 100644
--- a/arch/arm64/boot/dts/nvidia/tegra194.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra194.dtsi
@@ -1922,6 +1922,7 @@ host1x@13e00000 {
 			interconnects = <&mc TEGRA194_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu TEGRA194_SID_HOST1X>;
+			dma-coherent;
 
 			/* Context isolation domains */
 			iommu-map = <0 &smmu TEGRA194_SID_HOST1X_CTX0 1>,
diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 7a3112c82cdc7..cee86dcb68712 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -1967,6 +1967,7 @@ host1x@13e00000 {
 			interconnects = <&mc TEGRA234_MEMORY_CLIENT_HOST1XDMAR &emc>;
 			interconnect-names = "dma-mem";
 			iommus = <&smmu_niso1 TEGRA234_SID_HOST1X>;
+			dma-coherent;
 
 			/* Context isolation domains */
 			iommu-map = <0 &smmu_niso0 TEGRA234_SID_HOST1X_CTX0 1>,
-- 
2.39.2



