Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF2B270545;
	Thu, 30 Jul 2026 14:27:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421669; cv=none; b=AhOW31oIP+lgrIDs+G/LueuvGGlqUYrz6/3ZySI3ggZBJbpiYa8LNk451YBEwVA/pN0kSimcABf8AbUeFuPJ+flxJcB2LuZUfcWcv31ZCljPYnGG5O9psg/ufRarOk4+WCPIdQTyX4/2ZT8q64d03fz6LLvGqh/+dGKYN/kxImQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421669; c=relaxed/simple;
	bh=meuYFrlAmHXUmBuSegFrYOe/3ubiMdwVkpJn3aOfCeo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=evOtNqcI6nRa/A076PTjyxJQD+qCwuxZHm+0YlOUG+A4GkVvWzGB4yLTgfxbZOkd83FUzhqjuvso+e839OxHuNw+moJaDkl1mm4vOBvH8O8LFTGNVgRhq7grdw5AuyjAvpV3MobsAY6UjiTHoSfw2NlJVR8Q5SydYQtTYTvFkXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XfumBXxg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XfumBXxg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 358011F000E9;
	Thu, 30 Jul 2026 14:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421667;
	bh=zHCxmk+zmoZ17MspgZVymM1TZ5xoBKG1ulJgm6nwTAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XfumBXxg+9nRcuO+DkCuadBBBGRWBKR6MZ11TxL03m2dQVnTHLptUzQth/NrbLR+O
	 fM6L9VcyqRYfEEHmu0odOJI0FRI04nYMUQc1K9/iIuS0amIIQitJ+I3DMFKatCwN71
	 PHLeruqcbPKrF2CRQPatlNVVp7MK69fbqEHikDxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 182/744] platform/x86/intel/vsec: allocate res with intel_vsec_dev
Date: Thu, 30 Jul 2026 16:07:35 +0200
Message-ID: <20260730141448.153337115@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit 8ef6b01cee44803691c0a0c95b36f8ec710e2afb ]

Use a flexible array member to combine allocations. Avoids having to
free separately.

Add __counted_by for extra runtime analysis.

Move counting variable assignment to after allocations as is already
done by kzalloc_flex for GCC 15 and above.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Tested-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: David E. Box <david.e.box@linux.intel.com>
Link: https://patch.msgid.link/20260430224307.109311-1-rosenp@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 09b2ae290a24 ("platform/x86/intel/vsec: free ACPI discovery data on early errors")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c      | 14 ++++----------
 drivers/platform/x86/intel/vsec_tpmi.c | 13 ++++---------
 include/linux/intel_vsec.h             |  6 +++---
 3 files changed, 11 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 439c0c8ac896c7..3ae4557b32b478 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -112,7 +112,6 @@ static void intel_vsec_dev_release(struct device *dev)
 	ida_free(intel_vsec_dev->ida, intel_vsec_dev->auxdev.id);
 
 	kfree(intel_vsec_dev->acpi_disc);
-	kfree(intel_vsec_dev->resource);
 	kfree(intel_vsec_dev);
 }
 
@@ -225,7 +224,6 @@ int intel_vsec_add_aux(struct device *parent,
 	ret = xa_alloc(&auxdev_array, &intel_vsec_dev->id, intel_vsec_dev,
 		       PMT_XA_LIMIT, GFP_KERNEL);
 	if (ret < 0) {
-		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return ret;
 	}
@@ -233,7 +231,6 @@ int intel_vsec_add_aux(struct device *parent,
 	id = ida_alloc(intel_vsec_dev->ida, GFP_KERNEL);
 	if (id < 0) {
 		xa_erase(&auxdev_array, intel_vsec_dev->id);
-		kfree(intel_vsec_dev->resource);
 		kfree(intel_vsec_dev);
 		return id;
 	}
@@ -282,7 +279,7 @@ static int intel_vsec_add_dev(struct device *dev, struct intel_vsec_header *head
 			      unsigned long cap_id, u64 base_addr)
 {
 	struct intel_vsec_device __free(kfree) *intel_vsec_dev = NULL;
-	struct resource __free(kfree) *res = NULL;
+	struct resource *res;
 	struct resource *tmp;
 	struct device *parent;
 	unsigned long quirks = info->quirks;
@@ -306,13 +303,12 @@ static int intel_vsec_add_dev(struct device *dev, struct intel_vsec_header *head
 		return -EINVAL;
 	}
 
-	intel_vsec_dev = kzalloc_obj(*intel_vsec_dev);
+	intel_vsec_dev = kzalloc_flex(*intel_vsec_dev, resource, header->num_entries);
 	if (!intel_vsec_dev)
 		return -ENOMEM;
 
-	res = kzalloc_objs(*res, header->num_entries);
-	if (!res)
-		return -ENOMEM;
+	intel_vsec_dev->num_resources = header->num_entries;
+	res = intel_vsec_dev->resource;
 
 	if (quirks & VSEC_QUIRK_TABLE_SHIFT)
 		header->offset >>= TABLE_OFFSET_SHIFT;
@@ -342,8 +338,6 @@ static int intel_vsec_add_dev(struct device *dev, struct intel_vsec_header *head
 	}
 
 	intel_vsec_dev->dev = dev;
-	intel_vsec_dev->resource = no_free_ptr(res);
-	intel_vsec_dev->num_resources = header->num_entries;
 	intel_vsec_dev->quirks = info->quirks;
 	intel_vsec_dev->base_addr = info->base_addr;
 	intel_vsec_dev->priv_data = info->priv_data;
diff --git a/drivers/platform/x86/intel/vsec_tpmi.c b/drivers/platform/x86/intel/vsec_tpmi.c
index 88f14d0ad4102f..3b76cccb975f6b 100644
--- a/drivers/platform/x86/intel/vsec_tpmi.c
+++ b/drivers/platform/x86/intel/vsec_tpmi.c
@@ -634,15 +634,12 @@ static int tpmi_create_device(struct intel_tpmi_info *tpmi_info,
 	if (!name)
 		return -EOPNOTSUPP;
 
-	res = kzalloc_objs(*res, pfs->pfs_header.num_entries);
-	if (!res)
+	feature_vsec_dev = kzalloc_flex(*feature_vsec_dev, resource, pfs->pfs_header.num_entries);
+	if (!feature_vsec_dev)
 		return -ENOMEM;
 
-	feature_vsec_dev = kzalloc_obj(*feature_vsec_dev);
-	if (!feature_vsec_dev) {
-		kfree(res);
-		return -ENOMEM;
-	}
+	feature_vsec_dev->num_resources = pfs->pfs_header.num_entries;
+	res = feature_vsec_dev->resource;
 
 	snprintf(feature_id_name, sizeof(feature_id_name), "tpmi-%s", name);
 
@@ -655,8 +652,6 @@ static int tpmi_create_device(struct intel_tpmi_info *tpmi_info,
 	}
 
 	feature_vsec_dev->dev = vsec_dev->dev;
-	feature_vsec_dev->resource = res;
-	feature_vsec_dev->num_resources = pfs->pfs_header.num_entries;
 	feature_vsec_dev->priv_data = &tpmi_info->plat_info;
 	feature_vsec_dev->priv_data_size = sizeof(tpmi_info->plat_info);
 	feature_vsec_dev->ida = &intel_vsec_tpmi_ida;
diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index 1fe5665a9d02a8..07ea563f524ee2 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -135,8 +135,6 @@ struct intel_vsec_platform_info {
  * struct intel_vsec_device - Auxbus specific device information
  * @auxdev:        auxbus device struct for auxbus access
  * @dev:           struct device associated with the device
- * @resource:      PCI discovery resources (BAR windows), one per discovery
- *                 instance. Valid only when @src == INTEL_VSEC_DISC_PCI
  * @acpi_disc:     ACPI discovery tables, each entry is two QWORDs
  *                 in little-endian format as defined by the PMT ACPI spec.
  *                 Valid only when @src == INTEL_VSEC_DISC_ACPI.
@@ -149,11 +147,12 @@ struct intel_vsec_platform_info {
  * @quirks:        specified quirks
  * @base_addr:     base address of entries (if specified)
  * @cap_id:        the enumerated id of the vsec feature
+ * @resource:      PCI discovery resources (BAR windows), one per discovery
+ *                 instance. Valid only when @src == INTEL_VSEC_DISC_PCI
  */
 struct intel_vsec_device {
 	struct auxiliary_device auxdev;
 	struct device *dev;
-	struct resource *resource;
 	u32 (*acpi_disc)[4];
 	enum intel_vsec_disc_source src;
 	struct ida *ida;
@@ -164,6 +163,7 @@ struct intel_vsec_device {
 	unsigned long quirks;
 	u64 base_addr;
 	unsigned long cap_id;
+	struct resource resource[] __counted_by(num_resources);
 };
 
 /**
-- 
2.53.0



