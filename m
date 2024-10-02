Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3901D1518;
	Wed,  2 Oct 2024 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877724; cv=none; b=fzXH8asuFoozIuMYn3Xb/293CDJwwSXKZKICu6h79D6tmAi439ciO57tR0G+k2TAX65wQQ5JMtWSb5Bno9ZcvKPDgg2BOuf2frOOOp4dDRoGjn2Cv0aASbHFZhNTVvj5hr9ONI5Q4al/I/RHon1t0+XhYzf6HwoSC30ev8fWWvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877724; c=relaxed/simple;
	bh=OZCO6dnXpEAGkyflTwr80v3W1BSNjSN8xS5vOqJU0do=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FEdFOdQW25m/bBUeA70UrVl2+NDiL+cp6orE95/4mcVdvEIzrtxAMLVtpsbro40In9Re6Igyjvx7+zL3LXIWWtFmMu1bZk9Q04CWxSdH3px/lxEwKKfK2NbyTNp1x2rr6422ljJJFZroBtsg2b7EGhvhDKUxepbY2shqaWD0mqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xMNdctyK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xMNdctyK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 088A0C4CEC2;
	Wed,  2 Oct 2024 14:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877724;
	bh=OZCO6dnXpEAGkyflTwr80v3W1BSNjSN8xS5vOqJU0do=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xMNdctyKik4WjduzhpoeP+HUVmzk0gxsooTWGl+4ALzu/S4RBW29CU0ad1cxIBaOr
	 LLIv1Sbkq9OzaN0CT7OMg6sKbq6LThn6EyT+oQKVi5LbYgExhd4X61LFu2SLdCXrBq
	 +M1JJ9Dk65RmEFy19X0UHOqsMnV+vETG9BgsJV60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 131/634] arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations
Date: Wed,  2 Oct 2024 14:53:51 +0200
Message-ID: <20241002125816.281220713@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 0c4575ad8d7cb..53156b71e4796 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -119,7 +119,7 @@
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -131,7 +131,7 @@
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



