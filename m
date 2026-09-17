Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC7C4EF15B;
	Thu, 17 Sep 2026 17:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667382; cv=none; b=kheUcunyw9WYx0M3SKP4HxNAYgIN6v0C+5C+ECkxTGZykAbvR3yCVrTvbwY4nGmT931djNafGrem0yhRudG7+nSPAKA+4dmeV2Bv9ZW4sywjGZJqZoGLJhICaIaXnGy8WfpGIjdEy3sxlj7nO0nZJuETG/57wmc4lTGCAK7N4Uw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667382; c=relaxed/simple;
	bh=Md+fMDefiFnECOhoOKhCGo5AfsZ3pSwseBPoEeh8fEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UFAzjnrHueKZJlZCoObwl8i7RL6tGAaXe6LITeU5ivmtn2FEOXg0V1CGQZOzgo9T8WGPAUYs3NCEhVxWr5zkEpLxJW9XoWnnuL+qRbVHLId+IfpSTyeccitF2Up+utsFlMOaL3Jhcx9koeBOqf8jodDtWD01M6B7KdMTxnKtAYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROTKfL+G; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROTKfL+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B701F000FF;
	Thu, 17 Sep 2026 17:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667381;
	bh=uw1Y94vcjivTQdzTNukHWsrJ9yqZNgXXR1dO+FtqqY0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROTKfL+GsLrCk8QLO6b46ZJrL5hUw1JUBwS4X1VjMwLHoGuckTYsEBux1nbRZJzx0
	 InnDaC3kZaotG2x9sv/vfy3goiRBkkReDJwJgBSTPNHQ1HkHWEDEh0gGzGGI/ayODD
	 8swcTuUBl1GOMjDG4NEp85wAF2UNs9RT832OM4pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Reed <Ben.Reed@microchip.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0047/1102] PCI: switchtec: Add Gen6 Device IDs
Date: Thu, 17 Sep 2026 15:59:50 +0100
Message-ID: <20260917151540.629433012@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Ben Reed <Ben.Reed@microchip.com>

[ Upstream commit 5e6c21c56998e1e58d2f314e70779989ea0fee5d ]

Add device IDs for the next generation of switchtec products.

No changes to the driver were required with the new version of the
hardware.

[logang: rewrote commit message]

Signed-off-by: Ben Reed <Ben.Reed@microchip.com>
Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20260505161633.67454-1-logang@deltatee.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/switch/switchtec.c | 16 ++++++++++++++++
 include/linux/switchtec.h      |  1 +
 2 files changed, 17 insertions(+)

diff --git a/drivers/pci/switch/switchtec.c b/drivers/pci/switch/switchtec.c
index b14dfab04d846..b093bb70b9d15 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1853,6 +1853,22 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
 	SWITCHTEC_PCI_DEVICE(0x5552, SWITCHTEC_GEN5),  /* PAXA 52XG5 */
 	SWITCHTEC_PCI_DEVICE(0x5536, SWITCHTEC_GEN5),  /* PAXA 36XG5 */
 	SWITCHTEC_PCI_DEVICE(0x5528, SWITCHTEC_GEN5),  /* PAXA 28XG5 */
+	SWITCHTEC_PCI_DEVICE(0x6048, SWITCHTEC_GEN6),  /* PFXs 48XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6064, SWITCHTEC_GEN6),  /* PFXs 64XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6044, SWITCHTEC_GEN6),  /* PFXs 144XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6060, SWITCHTEC_GEN6),  /* PFXs 160XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6148, SWITCHTEC_GEN6),  /* PSXs 48XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6164, SWITCHTEC_GEN6),  /* PSXs 64XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6144, SWITCHTEC_GEN6),  /* PSXs 144XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6160, SWITCHTEC_GEN6),  /* PSXs 160XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6248, SWITCHTEC_GEN6),  /* PFX 48XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6264, SWITCHTEC_GEN6),  /* PFX 64XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6244, SWITCHTEC_GEN6),  /* PFX 144XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6260, SWITCHTEC_GEN6),  /* PFX 160XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6348, SWITCHTEC_GEN6),  /* PSX 48XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6364, SWITCHTEC_GEN6),  /* PSX 64XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6344, SWITCHTEC_GEN6),  /* PSX 144XG6 */
+	SWITCHTEC_PCI_DEVICE(0x6360, SWITCHTEC_GEN6),  /* PSX 160XG6 */
 	SWITCHTEC_PCI100X_DEVICE(0x1001, SWITCHTEC_GEN4),  /* PCI1001 16XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1002, SWITCHTEC_GEN4),  /* PCI1002 12XG4 */
 	SWITCHTEC_PCI100X_DEVICE(0x1003, SWITCHTEC_GEN4),  /* PCI1003 16XG4 */
diff --git a/include/linux/switchtec.h b/include/linux/switchtec.h
index cdb58d61c1526..724da6c08bf7d 100644
--- a/include/linux/switchtec.h
+++ b/include/linux/switchtec.h
@@ -42,6 +42,7 @@ enum switchtec_gen {
 	SWITCHTEC_GEN3,
 	SWITCHTEC_GEN4,
 	SWITCHTEC_GEN5,
+	SWITCHTEC_GEN6,
 };
 
 struct mrpc_regs {
-- 
2.53.0



