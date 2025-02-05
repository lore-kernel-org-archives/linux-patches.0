Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 431E61519BE;
	Wed,  5 Feb 2025 14:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764983; cv=none; b=jinbvY3eFu66s3cMIRRQaW5wCCDV6Lt8mJC4qUz3/iv0pbjX1rxsT0oYmfW4YuQtPiUdHp4xC5qnv3cyLHHRG5mTGO4uKrUqcLanCpEU+9SwQEOTCR0dTTnqL7ICiduXwtolCIa7VWtW/eetXidnWUdgBj9yvegYtUXgF2BDaDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764983; c=relaxed/simple;
	bh=hba3cf2Fg3hkp7otQv73gNMKCounjCJtlNSI9Lg25E4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ado1TdYAMu2T5dwW5iVwq/kmp+11rmPqBT+u+vgTkQ67N7xgjd/Zrm9Cvuy/EAVVo/DFWnKTIU2YXt4EoC5LWLWhH/41jzHTXf71dpiF0QKNeM5eDw0yNqwdfc6hYMZHUU647dkFF9o4esXR4vz8myDsfEwt3yskPN+hG1GlciU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gN+hmirm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gN+hmirm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EF2C4CED1;
	Wed,  5 Feb 2025 14:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764983;
	bh=hba3cf2Fg3hkp7otQv73gNMKCounjCJtlNSI9Lg25E4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gN+hmirmGlvJe2BrqAM/6obVE1/99b9+Fjrdp6Xm9WGqwwyjl+xPFYvKp2va1cyqF
	 8SuPcWdjPvPkdpg6siqPLiovyFETB+WIBdN1KwQbyXdexgDm4PqG2DKkzU599ZksRE
	 xquJBcFAe5YxaE/Dfi/Czn5aM+Qu5gToVQYqY/gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"=?UTF-8?q?N=C3=ADcolas=20F . =20R . =20A . =20Prado?=" <nfraprado@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 221/393] arm64: dts: mediatek: mt8195: Remove suspend-breaking reset from pcie1
Date: Wed,  5 Feb 2025 14:42:20 +0100
Message-ID: <20250205134428.763756919@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5a087404ccc2d..1cb22257adb36 100644
--- a/arch/arm64/boot/dts/mediatek/mt8195.dtsi
+++ b/arch/arm64/boot/dts/mediatek/mt8195.dtsi
@@ -1572,9 +1572,6 @@
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



