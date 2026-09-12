Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5C730BF69;
	Sat, 12 Sep 2026 14:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223200; cv=none; b=E1zjYRHr0pOccrwOgSUNjnvl15Ve5mrnpOgLb82FIPQERA9/VN33wWE71xrFvvoHnXDqx+WIXYnre2+CmyZmTdRNXRJEW2HtfZ/XRq3Bhez6Y+y68OQzm5OnGokT+ANq3pcjSmF0mjpIZmUjklvORC/C93Zyyhg03MZFbWN6QUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223200; c=relaxed/simple;
	bh=SAIxcc3ASBA1yUfYU/Qudf9nsLhQGUQjAGQBuYf2HaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IYIhNv+G5COfUgy6D2LcwXmr3Js4mSBWBIjsQ5KR3AAzUaLC/dbKI8ny5t6uZe3mAb3mcVCcqk05RCn5+189UGFmk27KaCSzf12d69KrRvKJ/vkAIk55oWN1Qlm2/5Z43YiDYRRzmqoH0YG5/gQoVDQAfvnUOaYpMJIRLr183iw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f4umA9qU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4umA9qU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C57311F000FF;
	Sat, 12 Sep 2026 14:26:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223199;
	bh=pujY//9BAfJugr6g4tQP/pFuY5+tLP9XxM796D4sjBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f4umA9qU+TZGc3LAgnYoBKDuGC2+YnSOLDi5KPAvhYR7f/l2vHRMZ9r2A2DSzHB22
	 nYh7owkgSDr90JD5CQ5whvRDrATmMu3/spJ1zzGFzcGga9lsjPtJGsZM7/UJ1vfvk0
	 oGjSslnS7p48+LZN+PQWumUtKGxt2HUdfROdWINQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terry Bowman <terry.bowman@amd.com>,
	Robert Richter <rrichter@amd.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Dan Williams <dan.j.williams@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0741/1424] cxl/pci: Store the endpoints Component Register mappings in struct cxl_dev_state
Date: Sat, 12 Sep 2026 08:52:53 +0200
Message-ID: <20260912065623.890692276@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Richter <rrichter@amd.com>

[ Upstream commit 2dd18279202f6247904e6e23738c1ec6a86b24b1 ]

Same as for ports and dports, also store the endpoint's Component
Register mappings, use struct cxl_dev_state for that.

Keep the Component Register base address @component_reg_phys a bit to
not break functionality. It will be removed after the transition in a
later patch.

Signed-off-by: Terry Bowman <terry.bowman@amd.com>
Signed-off-by: Robert Richter <rrichter@amd.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20231018171713.1883517-7-rrichter@amd.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Stable-dep-of: 430c502c80e5 ("cxl/pci: Honor -EPROBE_DEFER from component register setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cxl/core/mbox.c | 2 ++
 drivers/cxl/cxlmem.h    | 2 ++
 drivers/cxl/pci.c       | 9 +++++----
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/core/mbox.c b/drivers/cxl/core/mbox.c
index d98cb4ddca55d..059e95e086205 100644
--- a/drivers/cxl/core/mbox.c
+++ b/drivers/cxl/core/mbox.c
@@ -1404,6 +1404,8 @@ struct cxl_memdev_state *cxl_memdev_state_create(struct device *dev)
 	mutex_init(&mds->mbox_mutex);
 	mutex_init(&mds->event.log_lock);
 	mds->cxlds.dev = dev;
+	mds->cxlds.reg_map.host = dev;
+	mds->cxlds.reg_map.resource = CXL_RESOURCE_NONE;
 	mds->cxlds.type = CXL_DEVTYPE_CLASSMEM;
 
 	return mds;
diff --git a/drivers/cxl/cxlmem.h b/drivers/cxl/cxlmem.h
index edb46123e3eb0..36c90eafc5fb1 100644
--- a/drivers/cxl/cxlmem.h
+++ b/drivers/cxl/cxlmem.h
@@ -400,6 +400,7 @@ enum cxl_devtype {
  *
  * @dev: The device associated with this CXL state
  * @cxlmd: The device representing the CXL.mem capabilities of @dev
+ * @reg_map: component and ras register mapping parameters
  * @regs: Parsed register blocks
  * @cxl_dvsec: Offset to the PCIe device DVSEC
  * @rcd: operating in RCD mode (CXL 3.0 9.11.8 CXL Devices Attached to an RCH)
@@ -414,6 +415,7 @@ enum cxl_devtype {
 struct cxl_dev_state {
 	struct device *dev;
 	struct cxl_memdev *cxlmd;
+	struct cxl_register_map reg_map;
 	struct cxl_regs regs;
 	int cxl_dvsec;
 	bool rcd;
diff --git a/drivers/cxl/pci.c b/drivers/cxl/pci.c
index aacd93f9067da..6a6ab285034b9 100644
--- a/drivers/cxl/pci.c
+++ b/drivers/cxl/pci.c
@@ -825,15 +825,16 @@ static int cxl_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	 * still be useful for management functions so don't return an error.
 	 */
 	cxlds->component_reg_phys = CXL_RESOURCE_NONE;
-	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT, &map);
+	rc = cxl_pci_setup_regs(pdev, CXL_REGLOC_RBI_COMPONENT,
+				&cxlds->reg_map);
 	if (rc)
 		dev_warn(&pdev->dev, "No component registers (%d)\n", rc);
-	else if (!map.component_map.ras.valid)
+	else if (!cxlds->reg_map.component_map.ras.valid)
 		dev_dbg(&pdev->dev, "RAS registers not found\n");
 
-	cxlds->component_reg_phys = map.resource;
+	cxlds->component_reg_phys = cxlds->reg_map.resource;
 
-	rc = cxl_map_component_regs(&map, &cxlds->regs.component,
+	rc = cxl_map_component_regs(&cxlds->reg_map, &cxlds->regs.component,
 				    BIT(CXL_CM_CAP_CAP_ID_RAS));
 	if (rc)
 		dev_dbg(&pdev->dev, "Failed to map RAS capability.\n");
-- 
2.53.0



