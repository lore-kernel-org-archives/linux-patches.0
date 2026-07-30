Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EE5343E08C;
	Thu, 30 Jul 2026 14:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421237; cv=none; b=IlWW1t8mP0+/DSJwV8jUVj6hvvFwbmfb18Npp4K1rFfncltefK9yR8G46R9dHnXM2MoK7SDAKJPC1HVMSViF5jVe4oI3ATrbgOG4VkkB1cYO9JYeKcXaZgINiuE5b3/iTeZbrwm1gKZnSMAFtR/FvUxfnfLlGFDv+2I64wG57z4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421237; c=relaxed/simple;
	bh=XA5tJPrNxqUejVz/i3zSpgSkQpX07EgAxutPGOxotiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nxz5Mh2TaGMq3xZ2PaIXIrHrhSxnEYEbLYRgdApRTn8NHxxRE1nuWmQemYAldRzbh/+0kuQHZJFihxOFy99oMzaPLdiJgsREROLFKeICPG7LDXkrtdBvDZi0t7e5NuoCf9bnkefntglGjBFB4SZJ/5dqjvn23LI7lJD+SJ56Ifo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nR9PVRAG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nR9PVRAG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696D81F000E9;
	Thu, 30 Jul 2026 14:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421236;
	bh=P6FtDQqEkDksrB4sRPhNT0eSJnvFkZ6SYA0uzTeL/3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nR9PVRAGhnXdoskXgWoQjMo9Q1gGuOxlIxDYp3hoDN28XWDoewETKyjD009ZY/HYA
	 3NfdcWybUAInjItIwLbaiuIZ79ZSZscfam9JGMFzlEbqacIjvbvbwIfjF2yp00jzBW
	 yST6NAcUWBv1Q7tK+SaFuiMQvW3n600pUdmikXow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Jon Hunter <jonathanh@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 012/744] arm64: tegra: Remove fallback compatible for GPCDMA
Date: Thu, 30 Jul 2026 16:04:45 +0200
Message-ID: <20260730141444.544872961@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit ee7863e43228a3143398dc5bbb943c9a735a8fca ]

Remove the fallback compatible string "nvidia,tegra186-gpcdma" for GPCDMA
in Tegra264. Tegra186 compatible cannot work on Tegra264 because of the
register offset changes and absence of the reset property.

Fixes: 65ef237e4810 ("arm64: tegra: Add Tegra264 support")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Reviewed-by: Jon Hunter <jonathanh@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra264.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra264.dtsi b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
index 2d8e7e37830ff2..3dfdd7bb28a911 100644
--- a/arch/arm64/boot/dts/nvidia/tegra264.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra264.dtsi
@@ -3208,7 +3208,7 @@ agic_page5: interrupt-controller@99b0000 {
 		};
 
 		gpcdma: dma-controller@8400000 {
-			compatible = "nvidia,tegra264-gpcdma", "nvidia,tegra186-gpcdma";
+			compatible = "nvidia,tegra264-gpcdma";
 			reg = <0x0 0x08400000 0x0 0x210000>;
 			interrupts = <GIC_SPI 584 IRQ_TYPE_LEVEL_HIGH>,
 				     <GIC_SPI 585 IRQ_TYPE_LEVEL_HIGH>,
-- 
2.53.0



