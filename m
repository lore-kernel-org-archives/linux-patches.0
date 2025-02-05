Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FC9C156C5E;
	Wed,  5 Feb 2025 14:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767144; cv=none; b=CPbmR2LcYGEy6PZoLXnwYT827T0R0TTAD4L+pU3LtgoVQQI3UATxOnhT9cNfEupS9Uj19/VGv+YEu88kbiaFWdBl5sGZxvlMo7gfuq2NTwO5yJLk0/nNWerv3YextvXyBafXO6YYW1tr527Q0IiPo6Vz3xCLxwwgEInBTjUANFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767144; c=relaxed/simple;
	bh=8BLc7QBJuO5JvxN1FlvLEhQEjbomY+X0/ZslvqqIoqQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Q/FGqZf5mYnLvUjWZy1iYx6G6bbxZ9yKRs0gH80crbyxGCGOBEYtiZNHPho1MYMf0+wEap14NuirUM93bWSYdHb9NIuG+D6tmK/disqyNqAhkspl9VxPJJgxNTwAv8A+5vh5s5dekySI5I9Nk+YwmWQ7vDqI7yD5qI8oL6/BeIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G1bq14e7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G1bq14e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A31AC4CED1;
	Wed,  5 Feb 2025 14:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767144;
	bh=8BLc7QBJuO5JvxN1FlvLEhQEjbomY+X0/ZslvqqIoqQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G1bq14e7GwBtCPFyo7WqjCc93ZQk/YqfC/K3uss9B/knxkfZWvyPURXMXTVDBJ+tT
	 Ks62EeuUoFLmYGGCKXsTZdgt2WM4Iy4ZFg0967k4yYzMKcFwPQmeatB898wBW3KyTh
	 GZsNJmup/ljyFYQWqzD/kxtdMQuDJBbjY4WtKa+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 362/623] arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie1
Date: Wed,  5 Feb 2025 14:41:44 +0100
Message-ID: <20250205134510.071401975@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nícolas F. R. A. Prado <nfraprado@collabora.com>

[ Upstream commit 3d7fdd8e38aafd4858935df2392762c1ab8fb40f ]

The MAC reset for PCIe port 1 on MT8195 when asserted during suspend
causes the system to hang during resume with the following error (with
no_console_suspend enabled):

  mtk-pcie-gen3 112f8000.pcie: PCIe link down, current LTSSM state: detect.quiet (0x0)
  mtk-pcie-gen3 112f8000.pcie: PM: dpm_run_callback(): genpd_resume_noirq+0x0/0x24 returns -110
  mtk-pcie-gen3 112f8000.pcie: PM: failed to resume noirq: error -110

This issue is specific to MT8195. On MT8192 with the PCIe reset,
MT8192_INFRA_RST4_PCIE_TOP_SWRST, added to the DT node, the issue is not
observed.

Since without the reset, the PCIe controller and WiFi card connected to
it, work just as well, remove the reset to allow the system to suspend
and resume properly.

Fixes: ecc0af6a3fe6 ("arm64: dts: mt8195: Add pcie and pcie phy nodes")
Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
Link: https://lore.kernel.org/r/20241218-mt8195-pcie1-reset-suspend-fix-v1-1-1c021dda42a6@collabora.com
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/mediatek/mt8195.dtsi | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/arm64/boot/dts/mediatek/mt8195.dtsi b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
index ade685ed2190b..04e41b557d448 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1611,9 +1611,6 @@
 			phy-names = "pcie-phy";
 			power-domains = <&spm MT8195_POWER_DOMAIN_PCIE_MAC_P1>;
 
-			resets = <&infracfg_ao MT8195_INFRA_RST2_PCIE_P1_SWRST>;
-			reset-names = "mac";
-
 			#interrupt-cells = <1>;
 			interrupt-map-mask = <0 0 0 7>;
 			interrupt-map = <0 0 0 1 &pcie_intc1 0>,
-- 
2.39.5



