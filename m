Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216199;
	b=MhvX/W/mQiQehxvbe56SZhv2DmJYEnyzkPuyprSxuGeMBwpz9flesPHmw1o4gNquOdXZ
	 jH+2oO804hmAfaQIywZ1i+iUk54nw+Fulgpsis/gh/147QnJaOLKQQdQQ4I3gCfiYbiix
	 4qgJsDLdQi2cjRzyCrjWZ2kfVr1Ul745CKHjp16ZnGGo/J5+fWVsKaQ5LU+eahvvqg6y3
	 +mTqFyetnt4AUHYkWSZplfpf3HoEO6nJJwvY5mRzB0JxhmWTW6MjgVb29gxMozYZBRCVO
	 OEeeMsNB+mzQw7tC4yUGWnKGcGmFEpN4Bk4vJ7AlRX/RNHxWEvag3vnc9bxl+mrDkow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216199;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nywHVFCWiezvzrXSafvvsktaW68auTd1HSLFOhpMvxg=;
	b=ZZ6p0tkLff4cOMwb7Np91q3nfNreD3lqEwjAPyTuPh+B+osLF+igrRyjUEUWjvvvC1yM
	 Vk53GkD56SzylWgREiWK6cybOmWc6O7/cSfLMEQ16lXiGuqaK5B5DXBoHytj2k0KMsy0Z
	 MYXRczbxTWkG662V333v0rPtsbnHR9R4qsMZxhQnIUoQA24Xp9fsLotMa/q7XuiQiyM36
	 4tM43av95rEXRxV8nIU2/Ouxg3QbEzmyo7giNhzF0fMilkONfBpHcJzuYMPpxtdXJdbUr
	 hmm3gUa6nmwplrbkn4E8quU7lm7Bt54Nh4QNbUSYpW8WyKzoj0BXYVsL6Rd980zF9oQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvUBOqHv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 450BC606A31F;
	Wed, 28 Oct 2026 19:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xvUBOqHv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9703A1F01825;
	Wed, 28 Oct 2026 19:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216199;
	bh=nywHVFCWiezvzrXSafvvsktaW68auTd1HSLFOhpMvxg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xvUBOqHvEC/R+DkplwxODPoDYVtwaSKwT6OCr2EgqJ16k0UbvctY74du8ur3NXxD/
	 jeetALzhg+9uLsyLKNMaQWZF0J5AEm9F60thlHq/Y4BWYBfQkBSmZoQGLp39QDOxOB
	 c/du7mM4NHQ/RWQDSQ/dZ5+UOATUHXGgjR2eQ3yQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bjorn Helgaas <bhelgaas@google.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Tyrel Datwyler <tyreld@linux.ibm.com>,
	linuxppc-dev@lists.ozlabs.org,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1476/1887] PCI: Introduce PCI_SLOT_PLACEHOLDER constant for slot_nr placeholder value
Date: Wed, 28 Oct 2026 17:59:32 +0100
Message-ID: <20261028170533.041972923@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Farhan Ali <alifm@linux.ibm.com>

[ Upstream commit c243e6c470c4695965cc8287767925bc1d9a7867 ]

Introduce a constant for placeholder value and update the kerneldoc for
pci_create_slot() to reference PCI_SLOT_PLACEHOLDER instead of -1
throughout. No functional change.

Suggested-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Tyrel Datwyler <tyreld@linux.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org
Link: https://patch.msgid.link/20260805165518.794-2-alifm@linux.ibm.com
Stable-dep-of: dcc5bec09e23 ("PCI: Allow per function PCI slots to fix slot reset on s390")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/hotplug/pnv_php.c     |  2 +-
 drivers/pci/hotplug/rpaphp_slot.c |  2 +-
 drivers/pci/slot.c                | 21 +++++++++++----------
 include/linux/pci.h               |  3 +++
 4 files changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/pci/hotplug/pnv_php.c b/drivers/pci/hotplug/pnv_php.c
index ec7828ad66617..2bd2b7599d1c4 100644
--- a/drivers/pci/hotplug/pnv_php.c
+++ b/drivers/pci/hotplug/pnv_php.c
@@ -799,7 +799,7 @@ static struct pnv_php_slot *pnv_php_alloc_slot(struct device_node *dn)
 	if (dn->child && PCI_DN(dn->child))
 		php_slot->slot_no = PCI_SLOT(PCI_DN(dn->child)->devfn);
 	else
-		php_slot->slot_no = -1;   /* Placeholder slot */
+		php_slot->slot_no = PCI_SLOT_PLACEHOLDER;   /* Placeholder slot */
 
 	kref_init(&php_slot->kref);
 	php_slot->state	                = PNV_PHP_STATE_INITIALIZED;
diff --git a/drivers/pci/hotplug/rpaphp_slot.c b/drivers/pci/hotplug/rpaphp_slot.c
index 779eab12e9810..ac8c512190df4 100644
--- a/drivers/pci/hotplug/rpaphp_slot.c
+++ b/drivers/pci/hotplug/rpaphp_slot.c
@@ -85,7 +85,7 @@ int rpaphp_register_slot(struct slot *slot)
 	struct device_node *child;
 	u32 my_index;
 	int retval;
-	int slotno = -1;
+	int slotno = PCI_SLOT_PLACEHOLDER;
 
 	dbg("%s registering slot:path[%pOF] index[%x], name[%s] pdomain[%x] type[%d]\n",
 		__func__, slot->dn, slot->index, slot->name,
diff --git a/drivers/pci/slot.c b/drivers/pci/slot.c
index 7f4bcf359b917..a3551f12780e7 100644
--- a/drivers/pci/slot.c
+++ b/drivers/pci/slot.c
@@ -38,7 +38,7 @@ static const struct sysfs_ops pci_slot_sysfs_ops = {
 
 static ssize_t address_read_file(struct pci_slot *slot, char *buf)
 {
-	if (slot->number == 0xff)
+	if (slot->number == PCI_SLOT_PLACEHOLDER)
 		return sysfs_emit(buf, "%04x:%02x\n",
 				  pci_domain_nr(slot->bus),
 				  slot->bus->number);
@@ -189,7 +189,7 @@ static struct pci_slot *get_slot(struct pci_bus *parent, int slot_nr)
 /**
  * pci_create_slot - create or increment refcount for physical PCI slot
  * @parent: struct pci_bus of parent bridge
- * @slot_nr: PCI_SLOT(pci_dev->devfn) or -1 for placeholder
+ * @slot_nr: PCI_SLOT(pci_dev->devfn) or PCI_SLOT_PLACEHOLDER for placeholder
  * @name: user visible string presented in /sys/bus/pci/slots/<name>
  * @hotplug: set if caller is hotplug driver, NULL otherwise
  *
@@ -214,15 +214,16 @@ static struct pci_slot *get_slot(struct pci_bus *parent, int slot_nr)
  * In most cases, @pci_bus, @slot_nr will be sufficient to uniquely identify
  * a slot. There is one notable exception - pSeries (rpaphp), where the
  * @slot_nr cannot be determined until a device is actually inserted into
- * the slot. In this scenario, the caller may pass -1 for @slot_nr.
+ * the slot. In this scenario, the caller may pass PCI_SLOT_PLACEHOLDER for @slot_nr.
  *
  * The following semantics are imposed when the caller passes @slot_nr ==
- * -1. First, we no longer check for an existing %struct pci_slot, as there
- * may be many slots with @slot_nr of -1.  The other change in semantics is
- * user-visible, which is the 'address' parameter presented in sysfs will
- * consist solely of a dddd:bb tuple, where dddd is the PCI domain of the
- * %struct pci_bus and bb is the bus number. In other words, the devfn of
- * the 'placeholder' slot will not be displayed.
+ * PCI_SLOT_PLACEHOLDER. First, we no longer check for an existing %struct
+ * pci_slot, as there may be many slots with @slot_nr of
+ * PCI_SLOT_PLACEHOLDER. The other change in semantics is user-visible,
+ * which is the 'address' parameter presented in sysfs will consist solely
+ * of a dddd:bb tuple, where dddd is the PCI domain of the %struct pci_bus
+ * and bb is the bus number. In other words, the devfn of the 'placeholder'
+ * slot will not be displayed.
  */
 struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 				 const char *name,
@@ -235,7 +236,7 @@ struct pci_slot *pci_create_slot(struct pci_bus *parent, int slot_nr,
 
 	mutex_lock(&pci_slot_mutex);
 
-	if (slot_nr == -1)
+	if (slot_nr == PCI_SLOT_PLACEHOLDER)
 		goto placeholder;
 
 	/*
diff --git a/include/linux/pci.h b/include/linux/pci.h
index 282e86b9a35fe..440e0ef0a134c 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -71,6 +71,9 @@
 /* return bus from PCI devid = ((u16)bus_number) << 8) | devfn */
 #define PCI_BUS_NUM(x) (((x) >> 8) & 0xff)
 
+/* Used to identify a slot as a placeholder */
+#define PCI_SLOT_PLACEHOLDER	0xff
+
 /* pci_slot represents a physical slot */
 struct pci_slot {
 	struct pci_bus		*bus;		/* Bus this slot is on */
-- 
2.53.0



