Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F781E9B0D;
	Mon, 13 Oct 2025 15:25:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369130; cv=none; b=lpxyEUVMHV2+UfIBn69RSqrjpKql9OUASHaJIHMpBHYN9shB2PkF/ff8IPP3NMmkeP3MSLqOoFGXtyHD5ApwuIxTXH0duyD/HFXLiLEMznZ0Y2UFkrRuSV/1J/1PR4ihHbhApcA26OiVQ74nDz8YQEap4HYnvLuoJwQpHwYemYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369130; c=relaxed/simple;
	bh=6gd14LNcYfFUp19crJ8MxBX2HYQVRp+rZDwpZHPlrlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MunvNwaM1iuXCATQvqoOPiWYL1zzZzPs/CIE3P2cqIm4IN+Qt2tMPR+ggfWBeR576Ak5GzMW3xyoC1mC8tIE4A2DmgTUj0k8H95C3GZLCVI+ZUWNk9V9pp6AjGaEm3tlBjuaaqnUxF82XrjXqKoQht2L6mn/KdZa1lgFRqUhQfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LR1+K3Y4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LR1+K3Y4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19A84C4CEE7;
	Mon, 13 Oct 2025 15:25:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369130;
	bh=6gd14LNcYfFUp19crJ8MxBX2HYQVRp+rZDwpZHPlrlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LR1+K3Y4etT3gSt5gPvZtlYQT4TyRVD/wHNYJS4hfkEUROVf9n4rOHdoIYKJwLCK/
	 bic1iB4QPGmZll14clVxNJt/eDTBAX5dXOq0vnPL6U8Smozr9UWPnoTuA9l3Gy5ISe
	 ak+NZhFpifHtNTqPwveDq6F/eN9yoBntJ1ed3C5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beleswar Padhi <b-padhi@ti.com>,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 139/563] Revert "arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations"
Date: Mon, 13 Oct 2025 16:40:00 +0200
Message-ID: <20251013144416.328108332@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beleswar Padhi <b-padhi@ti.com>

[ Upstream commit 79a1778c7819c8491cdbdc1f7e46d478cb84d5cf ]

This reverts commit 9f3814a7c06b7c7296cf8c1622078ad71820454b.

The C6x carveouts are reversed intentionally. This is due to the
requirement to keep the DMA memory region as non-cached, however the
minimum granular cache region for C6x is 16MB. So, C66x_0 marks the
entire C66x_1 16MB memory carveouts as non-cached, and uses the DMA
memory region of C66x_1 as its own, and vice-versa.

This was also called out in the original commit which introduced these
reversed carveouts:
	"The minimum granularity on the Cache settings on C66x DSP cores
	is 16MB, so the DMA memory regions are chosen such that they are
	in separate 16MB regions for each DSP, while reserving a total
	of 16 MB for each DSP and not changing the overall DSP
	remoteproc carveouts."

Fixes: 9f3814a7c06b ("arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations")
Signed-off-by: Beleswar Padhi <b-padhi@ti.com>
Acked-by: Andrew Davis <afd@ti.com>
Link: https://patch.msgid.link/20250908142826.1828676-22-b-padhi@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-sk.dts | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
index d1b0257048de2..488c5ebe9e272 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -120,7 +120,8 @@ main_r5fss1_core1_memory_region: memory@a5100000 {
 			no-map;
 		};
 
-		c66_0_dma_memory_region: memory@a6000000 {
+		/* Carveout locations are flipped due to caching */
+		c66_1_dma_memory_region: memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -132,7 +133,8 @@ c66_0_memory_region: memory@a6100000 {
 			no-map;
 		};
 
-		c66_1_dma_memory_region: memory@a7000000 {
+		/* Carveout locations are flipped due to caching */
+		c66_0_dma_memory_region: memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.51.0



