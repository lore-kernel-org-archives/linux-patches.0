Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A45B352084;
	Tue, 26 Aug 2025 14:33:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218804; cv=none; b=OzuAD/0ALus1BRrsyQkJEGZKzug08kwq/DKi987AYWtG3Kly4BhTfc0CHWBxlYowuqo2pi9JZrUTEY0zXDc4vBL4azPodhq5UmL7bIDjnoV6/bosNSM9DhsYu/fPlUz5h8JV7/+W2WK82bEV14nNRKISTSSao6XOWeeHyX3EtJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218804; c=relaxed/simple;
	bh=5qiGtdL5WAAjVSQYgINuxvWyPst+iKKoIYM09kwFnF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7hZxmyT0bjSUg5W4OSTprlB9MuPPCHNNdXxfsX1BV7aDaEjhcbLZy7IIVZC1gMFvvMmIEgLEfRVKPSeInGM/H6W8pym3F+8hSvb7MZ5bWYETypD2zgqr+e7MzAqgBfJGsEh4e6fOpeVNlFKcWDQTawWyhyEG+30/u1BPH8/5rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=otUvamJw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="otUvamJw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2502C4CEF1;
	Tue, 26 Aug 2025 14:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218804;
	bh=5qiGtdL5WAAjVSQYgINuxvWyPst+iKKoIYM09kwFnF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=otUvamJwbxoPFAaX103tsRVemo5Rf3c4a8tevkBQDd41Rq2ys4tBJDKVSg3M+bRRT
	 jv+knshzJsDREhREL3VTyCcLWcj1eckRkh4j/qR5/GKkRJrCie8mTUQqPwGKTDFe8f
	 iDZm36CA0vPKRR4h32qvYYGJyjFK+JLHdIZZJIRk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alastair DSilva <alastair@d-silva.org>,
	Andrew Donnellan <ajd@linux.ibm.com>,
	Frederic Barrat <fbarrat@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 139/403] pci/hotplug/pnv-php: Wrap warnings in macro
Date: Tue, 26 Aug 2025 13:07:45 +0200
Message-ID: <20250826110910.592936622@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Barrat <fbarrat@linux.ibm.com>

[ Upstream commit 748ac391ab9acd8d7f3c93cbf3e63c773c0b2638 ]

An opencapi slot doesn't have an associated bridge device. It's not
needed for operation, but any warning is displayed through pci_warn()
which uses the pci_dev struct of the assocated bridge device. So wrap
those warning so that a different trace mechanism can be used if it's
an opencapi slot.

Reviewed-by: Alastair D'Silva <alastair@d-silva.org>
Reviewed-by: Andrew Donnellan <ajd@linux.ibm.com>
Signed-off-by: Frederic Barrat <fbarrat@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20191121134918.7155-11-fbarrat@linux.ibm.com
Stable-dep-of: 466861909255 ("PCI: pnv_php: Clean up allocated IRQs on unplug")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c | 51 +++++++++++++++++++----------------
 1 file changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index 8223fe0b751f..3687a99383c1 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -18,6 +18,9 @@
 #define DRIVER_AUTHOR	"Gavin Shan, IBM Corporation"
 #define DRIVER_DESC	"PowerPC PowerNV PCI Hotplug Driver"
 
+#define SLOT_WARN(sl, x...) \
+	((sl)->pdev ? pci_warn((sl)->pdev, x) : dev_warn(&(sl)->bus->dev, x))
+
 struct pnv_php_event {
 	bool			added;
 	struct pnv_php_slot	*php_slot;
@@ -270,7 +273,7 @@ static int pnv_php_add_devtree(struct pnv_php_slot *php_slot)
 
 	ret = pnv_pci_get_device_tree(php_slot->dn->phandle, fdt1, 0x10000);
 	if (ret) {
-		pci_warn(php_slot->pdev, "Error %d getting FDT blob\n", ret);
+		SLOT_WARN(php_slot, "Error %d getting FDT blob\n", ret);
 		goto free_fdt1;
 	}
 
@@ -284,7 +287,7 @@ static int pnv_php_add_devtree(struct pnv_php_slot *php_slot)
 	dt = of_fdt_unflatten_tree(fdt, php_slot->dn, NULL);
 	if (!dt) {
 		ret = -EINVAL;
-		pci_warn(php_slot->pdev, "Cannot unflatten FDT\n");
+		SLOT_WARN(php_slot, "Cannot unflatten FDT\n");
 		goto free_fdt;
 	}
 
@@ -294,15 +297,15 @@ static int pnv_php_add_devtree(struct pnv_php_slot *php_slot)
 	ret = pnv_php_populate_changeset(&php_slot->ocs, php_slot->dn);
 	if (ret) {
 		pnv_php_reverse_nodes(php_slot->dn);
-		pci_warn(php_slot->pdev, "Error %d populating changeset\n",
-			 ret);
+		SLOT_WARN(php_slot, "Error %d populating changeset\n",
+			  ret);
 		goto free_dt;
 	}
 
 	php_slot->dn->child = NULL;
 	ret = of_changeset_apply(&php_slot->ocs);
 	if (ret) {
-		pci_warn(php_slot->pdev, "Error %d applying changeset\n", ret);
+		SLOT_WARN(php_slot, "Error %d applying changeset\n", ret);
 		goto destroy_changeset;
 	}
 
@@ -342,10 +345,10 @@ int pnv_php_set_slot_power_state(struct hotplug_slot *slot,
 	if (ret > 0) {
 		if (be64_to_cpu(msg.params[1]) != php_slot->dn->phandle	||
 		    be64_to_cpu(msg.params[2]) != state) {
-			pci_warn(php_slot->pdev, "Wrong msg (%lld, %lld, %lld)\n",
-				 be64_to_cpu(msg.params[1]),
-				 be64_to_cpu(msg.params[2]),
-				 be64_to_cpu(msg.params[3]));
+			SLOT_WARN(php_slot, "Wrong msg (%lld, %lld, %lld)\n",
+				  be64_to_cpu(msg.params[1]),
+				  be64_to_cpu(msg.params[2]),
+				  be64_to_cpu(msg.params[3]));
 			return -ENOMSG;
 		}
 		if (be64_to_cpu(msg.params[3]) != OPAL_SUCCESS) {
@@ -364,8 +367,8 @@ int pnv_php_set_slot_power_state(struct hotplug_slot *slot,
 	return ret;
 
 error:
-	pci_warn(php_slot->pdev, "Error %d powering %s\n",
-		 ret, (state == OPAL_PCI_SLOT_POWER_ON) ? "on" : "off");
+	SLOT_WARN(php_slot, "Error %d powering %s\n",
+		  ret, (state == OPAL_PCI_SLOT_POWER_ON) ? "on" : "off");
 	return ret;
 }
 EXPORT_SYMBOL_GPL(pnv_php_set_slot_power_state);
@@ -383,8 +386,8 @@ static int pnv_php_get_power_state(struct hotplug_slot *slot, u8 *state)
 	 */
 	ret = pnv_pci_get_power_state(php_slot->id, &power_state);
 	if (ret) {
-		pci_warn(php_slot->pdev, "Error %d getting power status\n",
-			 ret);
+		SLOT_WARN(php_slot, "Error %d getting power status\n",
+			  ret);
 	} else {
 		*state = power_state;
 	}
@@ -407,7 +410,7 @@ static int pnv_php_get_adapter_state(struct hotplug_slot *slot, u8 *state)
 		*state = presence;
 		ret = 0;
 	} else {
-		pci_warn(php_slot->pdev, "Error %d getting presence\n", ret);
+		SLOT_WARN(php_slot, "Error %d getting presence\n", ret);
 	}
 
 	return ret;
@@ -680,7 +683,7 @@ static int pnv_php_register_slot(struct pnv_php_slot *php_slot)
 	ret = pci_hp_register(&php_slot->slot, php_slot->bus,
 			      php_slot->slot_no, php_slot->name);
 	if (ret) {
-		pci_warn(php_slot->pdev, "Error %d registering slot\n", ret);
+		SLOT_WARN(php_slot, "Error %d registering slot\n", ret);
 		return ret;
 	}
 
@@ -733,7 +736,7 @@ static int pnv_php_enable_msix(struct pnv_php_slot *php_slot)
 	/* Enable MSIx */
 	ret = pci_enable_msix_exact(pdev, &entry, 1);
 	if (ret) {
-		pci_warn(pdev, "Error %d enabling MSIx\n", ret);
+		SLOT_WARN(php_slot, "Error %d enabling MSIx\n", ret);
 		return ret;
 	}
 
@@ -783,8 +786,9 @@ static irqreturn_t pnv_php_interrupt(int irq, void *data)
 		   (sts & PCI_EXP_SLTSTA_PDC)) {
 		ret = pnv_pci_get_presence_state(php_slot->id, &presence);
 		if (ret) {
-			pci_warn(pdev, "PCI slot [%s] error %d getting presence (0x%04x), to retry the operation.\n",
-				 php_slot->name, ret, sts);
+			SLOT_WARN(php_slot,
+				  "PCI slot [%s] error %d getting presence (0x%04x), to retry the operation.\n",
+				  php_slot->name, ret, sts);
 			return IRQ_HANDLED;
 		}
 
@@ -814,8 +818,9 @@ static irqreturn_t pnv_php_interrupt(int irq, void *data)
 	 */
 	event = kzalloc(sizeof(*event), GFP_ATOMIC);
 	if (!event) {
-		pci_warn(pdev, "PCI slot [%s] missed hotplug event 0x%04x\n",
-			 php_slot->name, sts);
+		SLOT_WARN(php_slot,
+			  "PCI slot [%s] missed hotplug event 0x%04x\n",
+			  php_slot->name, sts);
 		return IRQ_HANDLED;
 	}
 
@@ -839,7 +844,7 @@ static void pnv_php_init_irq(struct pnv_php_slot *php_slot, int irq)
 	/* Allocate workqueue */
 	php_slot->wq = alloc_workqueue("pciehp-%s", 0, 0, php_slot->name);
 	if (!php_slot->wq) {
-		pci_warn(pdev, "Cannot alloc workqueue\n");
+		SLOT_WARN(php_slot, "Cannot alloc workqueue\n");
 		pnv_php_disable_irq(php_slot, true);
 		return;
 	}
@@ -863,7 +868,7 @@ static void pnv_php_init_irq(struct pnv_php_slot *php_slot, int irq)
 			  php_slot->name, php_slot);
 	if (ret) {
 		pnv_php_disable_irq(php_slot, true);
-		pci_warn(pdev, "Error %d enabling IRQ %d\n", ret, irq);
+		SLOT_WARN(php_slot, "Error %d enabling IRQ %d\n", ret, irq);
 		return;
 	}
 
@@ -899,7 +904,7 @@ static void pnv_php_enable_irq(struct pnv_php_slot *php_slot)
 
 	ret = pci_enable_device(pdev);
 	if (ret) {
-		pci_warn(pdev, "Error %d enabling device\n", ret);
+		SLOT_WARN(php_slot, "Error %d enabling device\n", ret);
 		return;
 	}
 
-- 
2.39.5



