Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB258F5B
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:25:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DCBAC433C7;
	Sun, 16 Jul 2023 20:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539156;
	bh=efs/B3IZVrWOen70zee6qdnPzCC5J6IivO86y5E28qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bQw8KZfs52p2DJgNg7GAL1OLjQEZ8zvdqtSO4lNsIsvv/6uXBsfqyGQTknxondX0T
	 +v2ZtXmgLZClCr4W9Wp1tiDddwGQi7dSHtVMAYHvrnTVbuww3XT7ClO0FbF6LGaYQ4
	 IDetlZ1fznt03WNqD9+w3eUKx0pBHlQEc3P5E8uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 690/800] powerpc: dts: turris1x.dts: Fix PCIe MEM size for pci2 node
Date: Sun, 16 Jul 2023 21:49:03 +0200
Message-ID: <20230716195005.151198794@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Pali Rohár <pali@kernel.org>

[ Upstream commit abaa02fc944f2f9f2c2e1925ddaceaf35c48528c ]

Freescale PCIe controllers on their PCIe Root Ports do not have any
mappable PCI BAR allocate from PCIe MEM.

Information about 1MB window on BAR0 of PCIe Root Port was misleading
because Freescale PCIe controllers have at BAR0 position different register
PEXCSRBAR, and kernel correctly skipts BAR0 for these Freescale PCIe Root
Ports.

So update comment about P2020 PCIe Root Port and decrease PCIe MEM size
required for PCIe controller (pci2 node) on which is on-board xHCI
controller.

lspci confirms that on P2020 PCIe Root Port is no PCI BAR and /proc/iomem
sees that only c0000000-c000ffff and c0010000-c0011fff ranges are used.

Fixes: 54c15ec3b738 ("powerpc: dts: Add DTS file for CZ.NIC Turris 1.x routers")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230505172818.18416-1-pali@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/turris1x.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/boot/dts/turris1x.dts b/arch/powerpc/boot/dts/turris1x.dts
index 6612160c19d59..dff1ea074d9d9 100644
--- a/arch/powerpc/boot/dts/turris1x.dts
+++ b/arch/powerpc/boot/dts/turris1x.dts
@@ -476,12 +476,12 @@ pci2: pcie@ffe08000 {
 		 * channel 1 (but only USB 2.0 subset) to USB 2.0 pins on mPCIe
 		 * slot 1 (CN5), channels 2 and 3 to connector P600.
 		 *
-		 * P2020 PCIe Root Port uses 1MB of PCIe MEM and xHCI controller
+		 * P2020 PCIe Root Port does not use PCIe MEM and xHCI controller
 		 * uses 64kB + 8kB of PCIe MEM. No PCIe IO is used or required.
-		 * So allocate 2MB of PCIe MEM for this PCIe bus.
+		 * So allocate 128kB of PCIe MEM for this PCIe bus.
 		 */
 		reg = <0 0xffe08000 0 0x1000>;
-		ranges = <0x02000000 0x0 0xc0000000 0 0xc0000000 0x0 0x00200000>, /* MEM */
+		ranges = <0x02000000 0x0 0xc0000000 0 0xc0000000 0x0 0x00020000>, /* MEM */
 			 <0x01000000 0x0 0x00000000 0 0xffc20000 0x0 0x00010000>; /* IO */
 
 		pcie@0 {
-- 
2.39.2



