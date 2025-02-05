Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C451FECB0;
	Wed,  5 Feb 2025 14:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767011; cv=none; b=kWR4+U1RFznxyOfvE1NqcGlFtDs/zA0AydCXrI5ENQo5dDMWlFyR4s60weuBvutpVjUeYcXh0Vi8nL6AsQ7ZRjf4TSmmSZpR2Y0TF8cPmfKzG0pVAx4o0MQvlCJ8HcdFfuYHXuj4MIuO4Dk21pXdQ4vUVCFnjWf6WiuQeFeWy/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767011; c=relaxed/simple;
	bh=oZf+tnVc56SDJQSAPRX46ki8DDG4RQdZJbxmasbn7Aw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnjmROQ3NRFhefyDVMexQySf0GcNV6aJ3MbswsARHXzk8QO4d+twW6Vxc5A76/X+/wD3liMEDRkLv87qdhL4b4LztFiXuwd793/UhISGGUVQrRfnYMwSQnor0mHSvMrn/d71jCfDIGiBUnjLCcgEC0QeHG66QxyQ2zbaVBB0mXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2uolTm0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2uolTm0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6903EC4CED1;
	Wed,  5 Feb 2025 14:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767010;
	bh=oZf+tnVc56SDJQSAPRX46ki8DDG4RQdZJbxmasbn7Aw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2uolTm0jCk3GV2HY+SVV8l9rsJNhdj/f3GyaWKAhvvu5DDIdNrfVhiQUQVhyUQaWy
	 pQ7dPfSLaogOb7KXpzyMQoBMmW0SXroTyMJhX8ZviaHMacqqrSdOiAm6MESTodm/sK
	 fSAN8LEY/FLh/hHgXJI1U3Ph3en08gJKcuDxXw2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Akhil R <akhilrajeev@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/590] arm64: tegra: Fix DMA ID for SPI2
Date: Wed,  5 Feb 2025 14:42:27 +0100
Message-ID: <20250205134510.264606239@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Akhil R <akhilrajeev@nvidia.com>

[ Upstream commit 346bf459db26325c09ed841fdfd6678de1b1cb3a ]

DMA ID for SPI2 is '16'. Update the incorrect value in the devicetree.

Fixes: bb9667d8187b ("arm64: tegra: Add SPI device tree nodes for Tegra234")
Signed-off-by: Akhil R <akhilrajeev@nvidia.com>
Link: https://lore.kernel.org/r/20241206105201.53596-1-akhilrajeev@nvidia.com
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/nvidia/tegra234.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/nvidia/tegra234.dtsi b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
index 984c85eab41af..570331baa09ee 100644
--- a/arch/arm64/boot/dts/nvidia/tegra234.dtsi
+++ b/arch/arm64/boot/dts/nvidia/tegra234.dtsi
@@ -3900,7 +3900,7 @@
 			assigned-clock-parents = <&bpmp TEGRA234_CLK_PLLP_OUT0>;
 			resets = <&bpmp TEGRA234_RESET_SPI2>;
 			reset-names = "spi";
-			dmas = <&gpcdma 19>, <&gpcdma 19>;
+			dmas = <&gpcdma 16>, <&gpcdma 16>;
 			dma-names = "rx", "tx";
 			dma-coherent;
 			status = "disabled";
-- 
2.39.5



