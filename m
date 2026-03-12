Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3C48296BCF;
	Thu, 12 Mar 2026 20:19:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346740; cv=none; b=BF8r8NU7Q4VSuzLRm6Qqhxo4r6RIgHnJg1MNiZORd2DQEmqJatmBaf5KpPr25I4Wr4t+E0StuZIGxu0SQU55f7qyge5gZShZ6worHji6koafasCN/DXGw8F+juDPYPa+5B1hL6LPYCU94ITmu2dRbXybKIjBqb+qspcOAdhBHbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346740; c=relaxed/simple;
	bh=r9VFQjYbQ9vQfcmJQ3bxpU/F1detlCUyrz8NkiqOtJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YVnntQxuTTZMhyxKlhRpuOFe3W7MbkrIjDUVfuQ32HVIo6k4pqlYF9GiXzj2QU+3v/uXl/2MV+66zjeIAL4YkXIkVMHzHwFsXSZ+FRPBcC0Yc+ZcuYYs+ZdlPFTJ3+JeGFV1XP4mWdE1L+l9vgJM5FtIlhZ3BelKQwS6B9bssTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2TFRR8WD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2TFRR8WD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E902AC4CEF7;
	Thu, 12 Mar 2026 20:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346740;
	bh=r9VFQjYbQ9vQfcmJQ3bxpU/F1detlCUyrz8NkiqOtJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2TFRR8WD9seOkib6z0l0eXyvR9mcKKa67NAEAZP7hUTqAI40GihO8tyrvYCzL+8sx
	 B+tFP3DX6c8XwOl1kmOteOsMIibHnhHmABCX/CzhoFxiTrTQ2jNKKKEtno4//AJdZr
	 i7oAczZk5EuvnSZqUrRGAZ38oQiNVqlmPAXGdtgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Powers-Holmes <aholmes@omnom.net>,
	Shawn Lin <shawn.lin@rock-chips.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 085/265] arm64: dts: rockchip: Fix rk356x PCIe range mappings
Date: Thu, 12 Mar 2026 21:07:52 +0100
Message-ID: <20260312201021.289522602@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shawn Lin <shawn.lin@rock-chips.com>

[ Upstream commit f63ea193a404481f080ca2958f73e9f364682db9 ]

The pcie bus address should be mapped 1:1 to the cpu side MMIO address, so
that there is no same address allocated from normal system memory. Otherwise
it's broken if the same address assigned to the EP for DMA purpose.Fix it to
sync with the vendor BSP.

Fixes: 568a67e742df ("arm64: dts: rockchip: Fix rk356x PCIe register and range mappings")
Fixes: 66b51ea7d70f ("arm64: dts: rockchip: Add rk3568 PCIe2x1 controller")
Cc: stable@vger.kernel.org
Cc: Andrew Powers-Holmes <aholmes@omnom.net>
Signed-off-by: Shawn Lin <shawn.lin@rock-chips.com>
Link: https://patch.msgid.link/1767600929-195341-1-git-send-email-shawn.lin@rock-chips.com
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/rockchip/rk3568.dtsi | 4 ++--
 arch/arm64/boot/dts/rockchip/rk356x.dtsi | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/rockchip/rk3568.dtsi b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
index 6fd67ae271174..0d16f74949b6a 100644
--- a/arch/arm64/boot/dts/rockchip/rk3568.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk3568.dtsi
@@ -97,7 +97,7 @@ pcie3x1: pcie@fe270000 {
 		      <0x0 0xf2000000 0x0 0x00100000>;
 		ranges = <0x01000000 0x0 0xf2100000 0x0 0xf2100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf2200000 0x0 0xf2200000 0x0 0x01e00000>,
-			 <0x03000000 0x0 0x40000000 0x3 0x40000000 0x0 0x40000000>;
+			 <0x03000000 0x3 0x40000000 0x3 0x40000000 0x0 0x40000000>;
 		reg-names = "dbi", "apb", "config";
 		resets = <&cru SRST_PCIE30X1_POWERUP>;
 		reset-names = "pipe";
@@ -150,7 +150,7 @@ pcie3x2: pcie@fe280000 {
 		      <0x0 0xf0000000 0x0 0x00100000>;
 		ranges = <0x01000000 0x0 0xf0100000 0x0 0xf0100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf0200000 0x0 0xf0200000 0x0 0x01e00000>,
-			 <0x03000000 0x0 0x40000000 0x3 0x80000000 0x0 0x40000000>;
+			 <0x03000000 0x3 0x80000000 0x3 0x80000000 0x0 0x40000000>;
 		reg-names = "dbi", "apb", "config";
 		resets = <&cru SRST_PCIE30X2_POWERUP>;
 		reset-names = "pipe";
diff --git a/arch/arm64/boot/dts/rockchip/rk356x.dtsi b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
index bc0f57a26c2ff..32ccc57555545 100644
--- a/arch/arm64/boot/dts/rockchip/rk356x.dtsi
+++ b/arch/arm64/boot/dts/rockchip/rk356x.dtsi
@@ -1045,7 +1045,7 @@ pcie2x1: pcie@fe260000 {
 		power-domains = <&power RK3568_PD_PIPE>;
 		ranges = <0x01000000 0x0 0xf4100000 0x0 0xf4100000 0x0 0x00100000>,
 			 <0x02000000 0x0 0xf4200000 0x0 0xf4200000 0x0 0x01e00000>,
-			 <0x03000000 0x0 0x40000000 0x3 0x00000000 0x0 0x40000000>;
+			 <0x03000000 0x3 0x00000000 0x3 0x00000000 0x0 0x40000000>;
 		resets = <&cru SRST_PCIE20_POWERUP>;
 		reset-names = "pipe";
 		#address-cells = <3>;
-- 
2.51.0



