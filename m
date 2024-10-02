Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F441D223C;
	Wed,  2 Oct 2024 14:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727879477; cv=none; b=O8BRbozyEjp/+FNV6IMImzt0URp6q7XQmi1EQO2IAbVxkP5y7c9ziP+sYQR7b8a21nQfKxu+7mn5yJxofD0/V/axEtdbUJfrSphRxGYpydxqYPQEa6ly0viVmCbVvBI5I9ygxzrPiqgfHzelg3zEHDo7PDlkmHpGTsndzXE8PQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727879477; c=relaxed/simple;
	bh=c8vm5i/zZ13iM98a5JGfRoDowCHodDWT5cgIvajAg4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=buqWwW5E2VGZmsft7RCC9rghchfkN7dpEl6sUuhtDBKdqsM3tDAxLnsHufMn2nSCNrMyyOBcp24r7heVd1M3lZiAUHo8z2mt1c7wk482iom8qV11Gk+oYzZiUBizzuA9ILwLtfIBjm5cTERS7lbi9xo8cNIQ1zSvm90yRS6z2qA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkf9IjaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkf9IjaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C84D1C4CEC2;
	Wed,  2 Oct 2024 14:31:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727879477;
	bh=c8vm5i/zZ13iM98a5JGfRoDowCHodDWT5cgIvajAg4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hkf9IjaDNO6ir+lsddanXv5hBSUJd5KyqOwZHS4zIbupy6HHFcO8B4O/CIsQ5pZ58
	 0O56Iaa1L4L+kPrA5buKpNKNTBnYNVLg5JFrVJRpjxPIWDBHPwyP6+3X/7ZSbsqQcd
	 GYL/jDKJjsBrY5BU8//fxZrNRVWY4Mo6LNKfLS8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/538] arm64: dts: ti: k3-j721e-beagleboneai64: Fix reversed C6x carveout locations
Date: Wed,  2 Oct 2024 14:55:40 +0200
Message-ID: <20241002125756.218784422@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit 1a314099b7559690fe23cdf3300dfff6e830ecb1 ]

The DMA carveout for the C6x core 0 is at 0xa6000000 and core 1 is at
0xa7000000. These are reversed in DT. While both C6x can access either
region, so this is not normally a problem, but if we start restricting
the memory each core can access (such as with firewalls) the cores
accessing the regions for the wrong core will not work. Fix this here.

Fixes: fae14a1cb8dd ("arm64: dts: ti: Add k3-j721e-beagleboneai64")
Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20240801181232.55027-2-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
index 2f954729f3533..7897323376a5b 100644
--- a/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
+++ b/arch/arm64/boot/dts/ti/k3-j721e-beagleboneai64.dts
@@ -123,7 +123,7 @@ main_r5fss1_core1_memory_region: r5f-memory@a5100000 {
 			no-map;
 		};
 
-		c66_1_dma_memory_region: c66-dma-memory@a6000000 {
+		c66_0_dma_memory_region: c66-dma-memory@a6000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa6000000 0x00 0x100000>;
 			no-map;
@@ -135,7 +135,7 @@ c66_0_memory_region: c66-memory@a6100000 {
 			no-map;
 		};
 
-		c66_0_dma_memory_region: c66-dma-memory@a7000000 {
+		c66_1_dma_memory_region: c66-dma-memory@a7000000 {
 			compatible = "shared-dma-pool";
 			reg = <0x00 0xa7000000 0x00 0x100000>;
 			no-map;
-- 
2.43.0



