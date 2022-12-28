Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E56E41863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FBAC433D2;
	Wed, 28 Dec 2022 15:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240078;
	bh=Oo5BUUtsAlGLp33s/yhgi2J2Q82PJAfUZQM+Kckc3eE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k0homfPcytiafvwL26/meSDTIRCQ8GHzFqE1mWjuxyB3Cmbl9cn/71CVH0LhnWItc
	 nnz/qRZ3wTl+V/41vSBoG9NSGHKz3GYagVRWPWE7MzmhrHfDbjgbt93nvUtSA4r9le
	 05UkoDz5k4ID8J7a1jH8rkGFhO5dVbxMdubwoP/0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0078/1146] arm64: tegra: Fix Prefetchable aperture ranges of Tegra234 PCIe controllers
Date: Wed, 28 Dec 2022 15:26:57 +0100
Message-Id: <20221228144332.267690193@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vidya Sagar <vidyas@nvidia.com>

[ Upstream commit 248400656b1cd85de37f3742d065dc1826cdf589 ]

commit edf408b946d3 ("PCI: dwc: Validate iATU outbound mappings against
hardware constraints") exposes an issue with the existing partitioning of
the aperture space where the Prefetchable apertures of controllers
C5, C7 and C9 in Tegra234 cross the 32GB boundary hardware constraint.
This patch makes sure that the Prefetchable region doesn't spill over
the 32GB boundary.

Fixes: ec142c44b026 ("arm64: tegra: Add P2U and PCIe controller nodes to Tegra234 DT")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 0170bfa8a467..9b43a0b0d775 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -1965,7 +1965,7 @@ pcie@140c0000 {
 
 		bus-range = <0x0 0xff>;
 
-		ranges = <0x43000000 0x35 0x40000000 0x35 0x40000000 0x2 0xe8000000>, /* prefetchable memory (11904 MB) */
+		ranges = <0x43000000 0x35 0x40000000 0x35 0x40000000 0x2 0xc0000000>, /* prefetchable memory (11264 MB) */
 			 <0x02000000 0x0  0x40000000 0x38 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
 			 <0x01000000 0x0  0x2c100000 0x00 0x2c100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
@@ -2336,7 +2336,7 @@ pcie@141a0000 {
 
 		bus-range = <0x0 0xff>;
 
-		ranges = <0x43000000 0x27 0x40000000 0x27 0x40000000 0x3 0xe8000000>, /* prefetchable memory (16000 MB) */
+		ranges = <0x43000000 0x28 0x00000000 0x28 0x00000000 0x3 0x28000000>, /* prefetchable memory (12928 MB) */
 			 <0x02000000 0x0  0x40000000 0x2b 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
 			 <0x01000000 0x0  0x3a100000 0x00 0x3a100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
@@ -2442,7 +2442,7 @@ pcie@141e0000 {
 
 		bus-range = <0x0 0xff>;
 
-		ranges = <0x43000000 0x2e 0x40000000 0x2e 0x40000000 0x3 0xe8000000>, /* prefetchable memory (16000 MB) */
+		ranges = <0x43000000 0x30 0x00000000 0x30 0x00000000 0x2 0x28000000>, /* prefetchable memory (8832 MB) */
 			 <0x02000000 0x0  0x40000000 0x32 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
 			 <0x01000000 0x0  0x3e100000 0x00 0x3e100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
-- 
2.35.1



