Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAB0E1863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:08:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1338BC433D2;
	Wed, 28 Dec 2022 15:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672240089;
	bh=FaigX0HZ09zXLHGtzIBqIElmfxYBY6s1G2aHDcufQ90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WKwutfP4cLpaKl8BKYdUKZb6g/hYfHYtQLCSCGpo/wzLU55Eo8KO3FFoV+GZ3rIfB
	 hJbZLkYiBJsjCq9aAqoy/R2muXhuvUVQErWw5VM1pw7lEI3cAD4vsE7SSSuafomN4B
	 Lra1tDWI+gTCjmb/Mc3/KJa3Tt9rFRuryZey3tyA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vidya Sagar <vidyas@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0079/1146] arm64: tegra: Fix non-prefetchable aperture of PCIe C3 controller
Date: Wed, 28 Dec 2022 15:26:58 +0100
Message-Id: <20221228144332.293355064@linuxfoundation.org>
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

[ Upstream commit 47a2f35d9ea76d92aa2385671f527b75aa9dfe45 ]

Fix the starting address of the non-prefetchable aperture of PCIe C3
controller.

Fixes: ec142c44b026 ("arm64: tegra: Add P2U and PCIe controller nodes to Tegra234 DT")
Signed-off-by: Vidya Sagar <vidyas@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 9b43a0b0d775..dfe2cf2f4b21 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -2178,7 +2178,7 @@ pcie@14140000 {
 		bus-range = <0x0 0xff>;
 
 		ranges = <0x43000000 0x21 0x00000000 0x21 0x00000000 0x0 0x28000000>, /* prefetchable memory (640 MB) */
-			 <0x02000000 0x0  0x40000000 0x21 0xe8000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
+			 <0x02000000 0x0  0x40000000 0x21 0x28000000 0x0 0x08000000>, /* non-prefetchable memory (128 MB) */
 			 <0x01000000 0x0  0x34100000 0x00 0x34100000 0x0 0x00100000>; /* downstream I/O (1 MB) */
 
 		interconnects = <&mc TEGRA234_MEMORY_CLIENT_PCIE3R &emc>,
-- 
2.35.1



