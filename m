Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E36526B098;
	Thu, 13 Feb 2025 15:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459538; cv=none; b=F+z/bPdDTPXFndVw0SIhU7KYvTZ1YqYeQG1TnOIyPSxIuDyAH+eEAn+yKomJN/A1gVi6klEKtgD5mXHLp2USgAQTn0rE6xhuzmQB006CctyEUjyB6AcuMTXabEsm2I4F9FZVvqV8pmF1nlFyRGI2+r0srAIFEivMCA944mAV4eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459538; c=relaxed/simple;
	bh=iCzg/uxWt0xIaAkmRZGGD2kJTJOjodRx3Qegq6N7Pgg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9/3QZUJTJbZmKvJ/E2gc4ASWGdn2OC0mwnwsJD4i/Cd0xw55/8rhBYxUBBTOctHT+48nAHGn/peY4frT9cwh8Xx9LFRzWXcK7WrskJfCRNN6l1eKpjFv91eCcK22v8OO/VKz8zlUDAvzL8emD/BbHyWSYeuTmfzPRnA1gpT6gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T/GTrDLa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T/GTrDLa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2810C4CED1;
	Thu, 13 Feb 2025 15:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459538;
	bh=iCzg/uxWt0xIaAkmRZGGD2kJTJOjodRx3Qegq6N7Pgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/GTrDLaYzPpP2fJGkRZFqE8R4e1sXlbDuQy+UB5HI+o4lkh+f/zFYa/XWjq2wwcb
	 BugNqgSQP3Q4D7AktPfkh9MMM+X6v+0bb0eNLnBiPGDingXNwBMH2YQhuNGgNQ25JZ
	 fF7/eFlKcV3dN6fOs/QoPb/6OqmkCngE2Z7aMaiE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Romain Naour <romain.naour@skf.com>,
	Kevin Hilman <khilman@baylibre.com>
Subject: [PATCH 6.13 294/443] ARM: dts: dra7: Add bus_dma_limit for l4 cfg bus
Date: Thu, 13 Feb 2025 15:27:39 +0100
Message-ID: <20250213142451.960165528@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Romain Naour <romain.naour@skf.com>

commit c1472ec1dc4419d0bae663c1a1e6cb98dc7881ad upstream.

A bus_dma_limit was added for l3 bus by commit cfb5d65f2595
("ARM: dts: dra7: Add bus_dma_limit for L3 bus") to fix an issue
observed only with SATA on DRA7-EVM with 4GB RAM and CONFIG_ARM_LPAE
enabled.

Since kernel 5.13, the SATA issue can be reproduced again following
the SATA node move from L3 bus to L4_cfg in commit 8af15365a368
("ARM: dts: Configure interconnect target module for dra7 sata").

Fix it by adding an empty dma-ranges property to l4_cfg and
segment@100000 nodes (parent device tree node of SATA controller) to
inherit the 2GB dma ranges limit from l3 bus node.

Note: A similar fix was applied for PCIe controller by commit
90d4d3f4ea45 ("ARM: dts: dra7: Fix bus_dma_limit for PCIe").

Fixes: 8af15365a368 ("ARM: dts: Configure interconnect target module for dra7 sata").
Link: https://lore.kernel.org/linux-omap/c583e1bb-f56b-4489-8012-ce742e85f233@smile.fr/
Cc: stable@vger.kernel.org # 5.13
Signed-off-by: Romain Naour <romain.naour@skf.com>
Link: https://lore.kernel.org/r/20241115102537.1330300-1-romain.naour@smile.fr
Signed-off-by: Kevin Hilman <khilman@baylibre.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/boot/dts/ti/omap/dra7-l4.dtsi |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
+++ b/arch/arm/boot/dts/ti/omap/dra7-l4.dtsi
@@ -12,6 +12,7 @@
 	ranges = <0x00000000 0x4a000000 0x100000>,	/* segment 0 */
 		 <0x00100000 0x4a100000 0x100000>,	/* segment 1 */
 		 <0x00200000 0x4a200000 0x100000>;	/* segment 2 */
+	dma-ranges;
 
 	segment@0 {					/* 0x4a000000 */
 		compatible = "simple-pm-bus";
@@ -557,6 +558,7 @@
 			 <0x0007e000 0x0017e000 0x001000>,	/* ap 124 */
 			 <0x00059000 0x00159000 0x001000>,	/* ap 125 */
 			 <0x0005a000 0x0015a000 0x001000>;	/* ap 126 */
+		dma-ranges;
 
 		target-module@2000 {			/* 0x4a102000, ap 27 3c.0 */
 			compatible = "ti,sysc";


