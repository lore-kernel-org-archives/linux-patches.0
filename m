Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8618D1AE016;
	Mon, 14 Oct 2024 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917596; cv=none; b=OtQZnlsebp77xmaHi9uACKOx0RxBonRtxAnmQyJNR41q4cbx9PAcdvNdtFh1SrC0VRu3W9VszPuwvXFNFIfUcGH3HFWGF4RCaHtoOq+kX6ZWHRPUD9/0DEuLyXi9R21vm7K+DQBBf0CmxPVbDkiNajGzbXzyj5L6Tns0hBOHqxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917596; c=relaxed/simple;
	bh=yQ4h/Qq+jQv44K3kJfUbWWMCx1Hpek68xM56WwrrT5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fj6GGuZR6koyWgMqbVODeKzEcEjSRIUhh/ySKnAJb7NhIpK+PZiGdJ5eQW+aHvkoq6PcpLR6gO0ApgNAJaAFd+xOqptNrMlktBdBMqiV2kDunkshfyZUzY0QN7EZTxw3sRwW42tRTsoaq8NpWeGvqI/a+dxsKgoaUx0qLWdv+IY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HBD7hxiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HBD7hxiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EF4C4CEC3;
	Mon, 14 Oct 2024 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917596;
	bh=yQ4h/Qq+jQv44K3kJfUbWWMCx1Hpek68xM56WwrrT5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBD7hxiqPFJ6NTFgKPSRCsEksJ56I+Gyu9l7k0StHoPOZREQjNDNY8OKNyI169qXX
	 7l1HgWTxz/dfS1XhIgCZ3o4Ovn56g2G2R6X3SI3XIapbQHOKpdCILKd89kSF3b+0Dh
	 yBfE34WrDglDaobHOTV14yVdbPyp2CZ2lPZL8/xY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 077/798] arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations
Date: Mon, 14 Oct 2024 16:10:31 +0200
Message-ID: <20241014141220.961943070@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 9f3814a7c06b7c7296cf8c1622078ad71820454b ]

The DMA carveout for the C6x core 0 is at 0xa6000000 and core 1 is at
0xa7000000. These are reversed in DT. While both C6x can access either
region, so this is not normally a problem, but if we start restricting
the memory each core can access (such as with firewalls) the cores
accessing the regions for the wrong core will not work. Fix this here.

Fixes: f46d16cf5b43 ("arm64: dts: ti: k3-j721e-sk: Add DDR carveout memory nodes")
Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240801181232.55027-1-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
index 80358cba6954c..f4a76926c4e64 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -111,7 +111,7 @@ main_r5fss1_core1_memory_region: r5f-memory@a5100000 {
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -123,7 +123,7 @@ c66_0_memory_region: c66-memory@a6100000 {
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



