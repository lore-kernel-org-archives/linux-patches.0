Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4855221C9;
	Mon, 31 Aug 2026 13:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183851; cv=none; b=inhxO6VBJvasYCnbySvO9HG39eqHGm4nf/qi+U6ZJ0ybWIjdWzlDYlBCky2Kjm8VivIeQ4BIc02ccOFsSKitjPdQn/fmwL1X9VzsB2IyrTzkTUF7WK80qInhNrnHesQO1yyM29gPBh6xLCy3aPioVyNtZ72K2en/OdhGdNDEJU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183851; c=relaxed/simple;
	bh=F3ru9bMztZIqXY0REiurYx26QOeb/CEh/lrLHJg+CUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mpjc93WfoyqLsjIZrvKrpkOJeLvNN5k7AjfvTxNK743cwZ0xvjuiLYcjK0/X/tfze9gysS3FfkrJtM1ZrCmlY1O8jmZwKx60Yjo4hPMEfDQyptXA71P94qtkukUBYDiLuscCVMmEOXe7CD6UVnOKSyWj0vDuKLPcZ5tY4g61xfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q/WC+K47; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q/WC+K47"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6A4A1F00A3D;
	Mon, 31 Aug 2026 13:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183849;
	bh=42PZeB3SO7oRjnzW5UFefbIM4iCarF2btVqJidzfVPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q/WC+K47SVNq7USBO89u9AlwVS7rfz+v9eWM4WyPUVhwPWq49K/6LHTWrGH4A9O7j
	 UunJvVQ60g9FfcNo1ubuE84HsNKhXYwtv1uv2Sl5fP0ATmJKm1cJNDGwP5ceZE8wR1
	 wurb/29+OmAt43RUoA107vcOtWtC5brR+KPh2zfVLzbdH+olJzAuzj+NL/fkBGKRK8
	 cZJjOgARUa5chpzn5kPDVBiH6+hmk5KAtGQrUQhD94fDAzS5aahiTa7f5hWVwVq6iW
	 pjHmZsF3efJE3pGgvvRdduN8kNWd6FiPMlxbWfn4J6pHzYSjXTl/XDloW5p6PtNM/6
	 L+vOOylBeOC/A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Ben Reed <Ben.Reed@microchip.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>,
	kurt.schwemmer@microsemi.com,
	linux-pci@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18-6.1] PCI: switchtec: Add Gen6 Device IDs
Date: Mon, 31 Aug 2026 09:26:09 -0400
Message-ID: <20260831133314.4125787-341-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

The background history search finished. In this 6.18.43 checkout, `git
log -S 'SWITCHTEC_GEN5'` and `git log --grep='switchtec: Add'` didn’t
turn up individual Switchtec ID commits — only the bulk merge
`5d324e5159d9e` and unrelated history. That matches what we already saw:
Gen3/4/5 support is present, but this tree doesn’t have granular
Switchtec commit history.

That doesn’t change the backport assessment: this is a standard PCI
device ID addition for an existing driver, it fits the stable “just add
a device ID” rule, and it should apply cleanly to 6.18.43.

**YES**

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

