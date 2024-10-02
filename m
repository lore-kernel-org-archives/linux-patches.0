Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0AA16F84F;
	Wed,  2 Oct 2024 13:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875576; cv=none; b=VfnOL2u4Tf45oc6m3hCjmX3xqo4mUWoaj6rZWN1h5DVXGnkyz/I/Tc3o1vNd2HMmfFRVRK6fvt0DQ7nXpcMumK5iKOLR7GPzhv7sKylAYYYfhLGgejGbPhNS2Nz+pm2R5A4sChK5EtSavg22RZ93G6CvBHfpkbLXVbH9W0Oq9e4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875576; c=relaxed/simple;
	bh=Dig//kOnpeCTXvDP3PS6jQqoJw0Q0irWuy1rjkcGDY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r7IjGtvZdyH3hit4u2i+lOy6w5kb1dUqOdUm1D/I0pXu/EGZHEXR+EoSiekvtiU+6EKJT0OjPIMvUTJXt+gHtV1npYNOVTE9oniqIdihDGHYRSotc4OHaSe1PyjWW5nhqPdbYSodmT8o8bHpM+9wW40jgSU1Gv1lmiqDkBLwR5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P/bndJdj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P/bndJdj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00BD5C4CEC5;
	Wed,  2 Oct 2024 13:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875576;
	bh=Dig//kOnpeCTXvDP3PS6jQqoJw0Q0irWuy1rjkcGDY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P/bndJdjUuDR187897qdIaqEeH1Lp3DFO73URaAeTs3ZXJZXI29goALgSFjUGLe1P
	 9/5oEWJMT73vV7Xd8vMf0BQzRexNoyAqGMWWjYE5odM8Hegyo+p25G5nfHzPY4FssX
	 F75eVgt7tPLOMxtwbGU8xjRRGVuFEIiHM4lqbklY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 147/695] arm64: dts: ti: k3-j721e-sk: Fix reversed C6x carveout locations
Date: Wed,  2 Oct 2024 14:52:25 +0200
Message-ID: <20241002125828.351556671@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 89fbfb21e5d3b..e709edeb95cf7 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-sk.dts
@@ -120,7 +120,7 @@
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -132,7 +132,7 @@
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



