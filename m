Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0584E3226;
	Thu, 17 Sep 2026 16:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661058; cv=none; b=mvs0zBBEbAePX6eabH2RN1lLbJPbAstbQdKfH5WeMbrDpZEIIBluQyIjMxHqUf6JBlPmAtX/cPWOhd8cVGWdOQZtYJhlNeS1htlZ8jT4EleTjWw4NEgE8tGtXN3E9gBrmqVTj1UDr6gUuYyRyWQAJ/AK9I6ZE++Vt38Zue6EDbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661058; c=relaxed/simple;
	bh=A+RTu9G1jiw7yNvCXhtRbULR08O41Ew1AAMgpZD1Jow=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qZJAfou3UmKnd2jzW1LfNdbx9gVLm5aw8Fq4orUBmxtk+oPW48gXdWzEThxUh5gTbjHC4x8ukp9lESXYqxptNyaZDpWsKxRV3mMzE8V6T0DSqEN9KbOkjFIo1OWcLJGiA4uf9tCoBbbF9ySR1EQXbHVRhTc573J4qwSn3t4exWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaF6VQmm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaF6VQmm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DCB1F000FF;
	Thu, 17 Sep 2026 16:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661057;
	bh=NnhM+KS0nauisCYpyNdCsEOouIwaRc7fr75Q9YdJJkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DaF6VQmmHpjwsyp7JduszwaPv//9TO8kW3dcFiOqtmLIBuKEztGBTa04Nlm8iv93a
	 osxu/ZYS+LjEqr/KXgmY7YXKVMKVHV5u1ZaJaLydEt4kiUotRlxXuiZFB9tXwWcTIq
	 rgIZcpzc+B27yXhWa6zqFxsI9MBDPPromHUQk0ww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ben Reed <Ben.Reed@microchip.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0067/1250] PCI: switchtec: Add Gen6 Device IDs
Date: Thu, 17 Sep 2026 15:57:42 +0100
Message-ID: <20260917151553.758573013@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5ff84fb8fb0f4..f32ddfa79da99 100644
--- a/drivers/pci/switch/switchtec.c
+++ b/drivers/pci/switch/switchtec.c
@@ -1852,6 +1852,22 @@ static const struct pci_device_id switchtec_pci_tbl[] = {
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



