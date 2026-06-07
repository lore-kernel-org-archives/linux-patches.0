Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388BF12CDA5;
	Sun,  7 Jun 2026 10:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829847; cv=none; b=UhK8rLDo4MfDOyrYm5DJtmtZXouW2CjHNhMmxPdoX8i/xVPGKujg9Xv6BIaAwDJ3rPWfgtxZpGwASBgJxeVlP4BtbQwvE532Wy3dcJcq9SzJj7wd4JvnNy70YDE18P6qyVnLS7tCtg7MLzjJJJ3cjvLpGEXZpoHmgiMcWwDvYq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829847; c=relaxed/simple;
	bh=8A7x4H/+QwHyuAj5o0K3Bg5q7GOmN3X5gM9+R5AoOlw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pqBkQZXNAnIURGstJV7Be7kog/Qn+AE3WRfO7uMOOeg4ludY6QUXqUEc2a/LGwLGP71GUD+cFpA2qwwRURXsEuWBQYm1vt0xELRNten2zaUAVGIOTSY3mA3H02tS44suzBxwHVgpWSTtCX8DCjwDEkkeHiaOTxcvhmuAN6ZseGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kE2mHNOd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kE2mHNOd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DCC41F00893;
	Sun,  7 Jun 2026 10:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829845;
	bh=654ym93HLh5FIJZlSLsxaLU5X9DEl6/2GWKKiTfa9HA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kE2mHNOdhPa9ydv2krQyZtAuc34F6FrTsR3ZifsLRQKvHphSj1MpXnueOPErzXsGB
	 7dsvlttSKoA+pgCuE+Yu/mb6+hqCgXlvHCTXP1sxsEEw8nyjFEt2cZWY2TYyWqWRjK
	 KlMZ6qWg2ojlxzrfPaDkluA+fGZurfh4S7AaPRno=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 283/315] platform/x86/intel/vsec: Make driver_data info const
Date: Sun,  7 Jun 2026 12:01:10 +0200
Message-ID: <20260607095737.978054232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David E. Box" <david.e.box@linux.intel.com>

[ Upstream commit 9577c74c96f88d807d1ba005adbf5952e7127e55 ]

Treat PCI id->driver_data (intel_vsec_platform_info) as read-only by making
vsec_priv->info a const pointer and updating all function signatures to
accept const intel_vsec_platform_info *.

This improves const-correctness and clarifies that the platform info data
from the driver_data table is not meant to be modified at runtime.

No functional changes intended.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260313015202.3660072-3-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 348ccc754d89 ("platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec.c |   20 ++++++++++----------
 include/linux/intel_vsec.h        |    4 ++--
 2 files changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -42,7 +42,7 @@ enum vsec_device_state {
 };
 
 struct vsec_priv {
-	struct intel_vsec_platform_info *info;
+	const struct intel_vsec_platform_info *info;
 	struct device *suppliers[VSEC_FEATURE_COUNT];
 	struct oobmsm_plat_info plat_info;
 	enum vsec_device_state state[VSEC_FEATURE_COUNT];
@@ -270,7 +270,7 @@ cleanup_aux:
 EXPORT_SYMBOL_NS_GPL(intel_vsec_add_aux, "INTEL_VSEC");
 
 static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *header,
-			      struct intel_vsec_platform_info *info,
+			      const struct intel_vsec_platform_info *info,
 			      unsigned long cap_id, u64 base_addr)
 {
 	struct intel_vsec_device __free(kfree) *intel_vsec_dev = NULL;
@@ -406,7 +406,7 @@ static int get_cap_id(u32 header_id, uns
 
 static int intel_vsec_register_device(struct pci_dev *pdev,
 				      struct intel_vsec_header *header,
-				      struct intel_vsec_platform_info *info,
+				      const struct intel_vsec_platform_info *info,
 				      u64 base_addr)
 {
 	const struct vsec_feature_dependency *consumer_deps;
@@ -452,7 +452,7 @@ static int intel_vsec_register_device(st
 }
 
 static bool intel_vsec_walk_header(struct pci_dev *pdev,
-				   struct intel_vsec_platform_info *info)
+				   const struct intel_vsec_platform_info *info)
 {
 	struct intel_vsec_header **header = info->headers;
 	bool have_devices = false;
@@ -468,7 +468,7 @@ static bool intel_vsec_walk_header(struc
 }
 
 static bool intel_vsec_walk_dvsec(struct pci_dev *pdev,
-				  struct intel_vsec_platform_info *info)
+				  const struct intel_vsec_platform_info *info)
 {
 	bool have_devices = false;
 	int pos = 0;
@@ -519,7 +519,7 @@ static bool intel_vsec_walk_dvsec(struct
 }
 
 static bool intel_vsec_walk_vsec(struct pci_dev *pdev,
-				 struct intel_vsec_platform_info *info)
+				 const struct intel_vsec_platform_info *info)
 {
 	bool have_devices = false;
 	int pos = 0;
@@ -565,7 +565,7 @@ static bool intel_vsec_walk_vsec(struct
 }
 
 int intel_vsec_register(struct pci_dev *pdev,
-			 struct intel_vsec_platform_info *info)
+			const struct intel_vsec_platform_info *info)
 {
 	if (!pdev || !info || !info->headers)
 		return -EINVAL;
@@ -578,7 +578,7 @@ int intel_vsec_register(struct pci_dev *
 EXPORT_SYMBOL_NS_GPL(intel_vsec_register, "INTEL_VSEC");
 
 static bool intel_vsec_get_features(struct pci_dev *pdev,
-				    struct intel_vsec_platform_info *info)
+				    const struct intel_vsec_platform_info *info)
 {
 	bool found = false;
 
@@ -622,7 +622,7 @@ static void intel_vsec_skip_missing_depe
 
 static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct intel_vsec_platform_info *info;
+	const struct intel_vsec_platform_info *info;
 	struct vsec_priv *priv;
 	int num_caps, ret;
 	int run_once = 0;
@@ -633,7 +633,7 @@ static int intel_vsec_pci_probe(struct p
 		return ret;
 
 	pci_save_state(pdev);
-	info = (struct intel_vsec_platform_info *)id->driver_data;
+	info = (const struct intel_vsec_platform_info *)id->driver_data;
 	if (!info)
 		return -EINVAL;
 
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -199,13 +199,13 @@ static inline struct intel_vsec_device *
 
 #if IS_ENABLED(CONFIG_INTEL_VSEC)
 int intel_vsec_register(struct pci_dev *pdev,
-			 struct intel_vsec_platform_info *info);
+			const struct intel_vsec_platform_info *info);
 int intel_vsec_set_mapping(struct oobmsm_plat_info *plat_info,
 			   struct intel_vsec_device *vsec_dev);
 struct oobmsm_plat_info *intel_vsec_get_mapping(struct pci_dev *pdev);
 #else
 static inline int intel_vsec_register(struct pci_dev *pdev,
-				       struct intel_vsec_platform_info *info)
+				      const struct intel_vsec_platform_info *info)
 {
 	return -ENODEV;
 }


