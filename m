Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212430;
	b=WDVfSTCdWCM45GrxkWMXWWEWTJek0fk9TW6NUFyHQoKsdHYoZP6AEyyfbbyUtYIsitdq
	 K9o88jZJNhq5GjKzDMK2VBbI/8oGBV2lDrD/EQye5Xr3mjR70ZNs8vteqfNsycX1gH/+5
	 hNNyOY480jZZm7fyH51ntbxo9rRq+52fP6MZl6m+uSG8Mx9VyeH2uSSp8GHYgAkVt75ir
	 BmsY0TXJatVwtwchSvebnjYch18zYEckt9MCKjD56Whvulg3ft3LfLdaTcwPieFp6xA5+
	 hOw64sSCj/h6qrnBIHt1xJNBxHP6OBJWIGrgYugp3dSSmMiRWmXBk36VAjKdfpqhFIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212430;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=D9kqQwyEDmePzU4jn3/UOX6/gPk2tJlAZrwpFtGePkE=;
	b=cgcI22SWLx6W89riKmCQzrIWIhaVuZQ6rAqeKiY8cQ/AhdntAIOinTWYebAnYEHHxo0e
	 nVrExJbPnKI2Igp0x3Tj03P0fej/jfMbceeWtVn1O7Y0gnDTt/8ONFQIHZ32Zsd7k4Wfr
	 OzleEY2LGz6Qzt6AhgTHu1rt+Q0c1jytoPTBbB+4HebJSATP+f/oUrGoEyN/n5Iy3HuxE
	 PyoHL2/swNyP4y6GnppnHBHc+0KNVFrBxtBkNCe5oXODnUC9nvABlFJGxlTTXuG+Xf97z
	 YnP9xVxUoPeVVIBVdGjO6fNjuDcrhR8jB4B1T2/aDl350BqcPUtzrjIeN/2E/R6HJ0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx8pbyEn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578BB606A326;
	Wed, 28 Oct 2026 18:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mx8pbyEn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88161F01828;
	Wed, 28 Oct 2026 18:33:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212430;
	bh=D9kqQwyEDmePzU4jn3/UOX6/gPk2tJlAZrwpFtGePkE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mx8pbyEnxLAO8sHgpIyh6fnXA73SK6JshTIxkBn6C1T8guEvcDErtOyHKiDtTOvjN
	 QUoc/fT0LbpBfoN6hcHO0Pp80A1mC4ZQxd7R3BYmta+4Q39I1TMgV980Qmcd9rnaak
	 nEfBqiZoQTe+P8UHoGVMZN7jTCMVrnvEl9qhh39g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0149/1887] PCI: Fix Resizable BAR restore order
Date: Wed, 28 Oct 2026 17:37:25 +0100
Message-ID: <20261028170502.625841500@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

[ Upstream commit 5528fd38f230c906fcebb202cc94fbb8ed8f122a ]

The commit 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback
path") changed BAR resize to layer rebar code and resource setup/restore
code cleanly. Unfortunately, it did not consider how the value of the BAR
Size field impacts the read-only bits in the Base Address Register (PCIe7
spec, sec. 7.8.6.3). That is, it very much matters in which order the BAR
Size and Base Address Register are restored.

Post-337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
during BAR resize rollback, pci_do_resource_release_and_resize() attempts
to restore the old address to the BAR that was resized, but it can fail to
setup the address correctly if the address has low bits set that collide
with the bits that are still read-only. As a result, kernel's resource and
BAR will be out-of-sync.

Fix this by restoring BAR Size before rolling back the resource changes and
restoring the BAR.

Fixes: 337b1b566db0 ("PCI: Fix restoring BARs on BAR resize rollback path")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://lore.kernel.org/linux-pci/aW_w1oFQCzUxGYtu@intel.com/
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260121131417.9582-3-ilpo.jarvinen@linux.intel.com

[6.12 dependency preparation for d58384c22739848efe14b34e9586e4f1242f33c0:
Keep the existing memory-decoding and supported-size checks in rebar.c.
Move BAR size programming and rollback into the resource release helper,
so the old size is restored before restoring BAR addresses.

Use the assigned parent window to select resources for release, retaining
the old flags-based selection when the resized BAR has no parent. Provide
file-local macro mappings for the follow-up's bridge reassignment and
resource assignment checks; no functions are added.

Retain the upstream pre-target pci_bus_sem placement to allow the target
to apply without conflicts. This preparatory dependency must be applied
together with d58384c22739848efe14b34e9586e4f1242f33c0, which takes the lock
before releasing resources and assigns released BARs on root buses.]

Stable-dep-of: d58384c22739 ("PCI: Fix BAR resize for devices on a root bus")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/rebar.c     | 19 +------------------
 drivers/pci/setup-bus.c | 39 ++++++++++++++++++++++++++++++++-------
 2 files changed, 33 insertions(+), 25 deletions(-)

diff --git a/drivers/pci/rebar.c b/drivers/pci/rebar.c
index 920ef3ab4bda3..d5e432d084e51 100644
--- a/drivers/pci/rebar.c
+++ b/drivers/pci/rebar.c
@@ -177,7 +177,6 @@ int pci_resize_resource(struct pci_dev *dev, int resno, int size,
 			int exclude_bars)
 {
 	struct pci_host_bridge *host;
-	int old, ret;
 	u32 sizes;
 	u16 cmd;
 
@@ -197,22 +196,6 @@ int pci_resize_resource(struct pci_dev *dev, int resno, int size,
 	if (!(sizes & BIT(size)))
 		return -EINVAL;
 
-	old = pci_rebar_get_current_size(dev, resno);
-	if (old < 0)
-		return old;
-
-	ret = pci_rebar_set_size(dev, resno, size);
-	if (ret)
-		return ret;
-
-	ret = pci_do_resource_release_and_resize(dev, resno, size, exclude_bars);
-	if (ret)
-		goto error_resize;
-
-	return 0;
-
-error_resize:
-	pci_rebar_set_size(dev, resno, old);
-	return ret;
+	return pci_do_resource_release_and_resize(dev, resno, size, exclude_bars);
 }
 EXPORT_SYMBOL(pci_resize_resource);
diff --git a/drivers/pci/setup-bus.c b/drivers/pci/setup-bus.c
index df345ebbb991f..73427c09f983a 100644
--- a/drivers/pci/setup-bus.c
+++ b/drivers/pci/setup-bus.c
@@ -2294,6 +2294,11 @@ static int pci_reassign_bridge_resources(struct pci_dev *bridge, unsigned long t
 	return 0;
 }
 
+/* Keep the resize follow-up compatible with the 6.12 resource helpers. */
+#define pbus_reassign_bridge_resources(bus, res, saved) \
+	pci_reassign_bridge_resources((bus)->self, (res)->flags, (saved))
+#define resource_assigned(res) ((res)->parent != NULL)
+
 int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size,
 				       int exclude_bars)
 {
@@ -2301,12 +2306,20 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 	unsigned long flags = res->flags;
 	struct pci_dev_resource *dev_res;
 	struct pci_bus *bus = pdev->bus;
-	struct resource *r;
+	struct resource *b_win, *r;
 	LIST_HEAD(saved);
 	unsigned int i;
-	int ret = 0;
+	int old, ret;
 
-	down_read(&pci_bus_sem);
+	b_win = res->parent;
+
+	old = pci_rebar_get_current_size(pdev, resno);
+	if (old < 0)
+		return old;
+
+	ret = pci_rebar_set_size(pdev, resno, size);
+	if (ret)
+		return ret;
 
 	pci_dev_for_each_resource(pdev, r, i) {
 		if (i >= PCI_BRIDGE_RESOURCES)
@@ -2315,7 +2328,10 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 		if (exclude_bars & BIT(i))
 			continue;
 
-		if (!pci_resource_len(pdev, i) || r->flags != flags)
+		if (!pci_resource_len(pdev, i))
+			continue;
+
+		if (b_win ? r->parent != b_win : r->flags != flags)
 			continue;
 
 		ret = add_to_list(&saved, pdev, r, 0, 0);
@@ -2329,7 +2345,8 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 	if (!bus->self)
 		goto out;
 
-	ret = pci_reassign_bridge_resources(bus->self, res->flags, &saved);
+	down_read(&pci_bus_sem);
+	ret = pbus_reassign_bridge_resources(bus, res, &saved);
 	if (ret)
 		goto restore;
 
@@ -2339,14 +2356,22 @@ int pci_do_resource_release_and_resize(struct pci_dev *pdev, int resno, int size
 	return ret;
 
 restore:
-	/* Revert to the old configuration */
+	/*
+	 * Revert to the old configuration.
+	 *
+	 * BAR Size must be restored first because it affects the read-only
+	 * bits in BAR (the old address might not be restorable otherwise
+	 * due to low address bits).
+	 */
+	pci_rebar_set_size(pdev, resno, old);
+
 	list_for_each_entry(dev_res, &saved, list) {
 		struct resource *res = dev_res->res;
 		struct pci_dev *dev = dev_res->dev;
 
 		i = res - dev->resource;
 
-		if (res->parent) {
+		if (resource_assigned(res)) {
 			release_child_resources(res);
 			pci_release_resource(dev, i);
 		}
-- 
2.53.0



