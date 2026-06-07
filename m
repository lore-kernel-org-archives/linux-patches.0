Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B43212CDA5;
	Sun,  7 Jun 2026 10:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829875; cv=none; b=UmKE8iKcO4RY5ayh6vl+B80O+t/DdaFyreLA3YQdTvxC2Y05O8k3Q4DAnj+Mdqjp5XG8HtDgxWsEXX56SKKCFHuhiXVyuAjbtxtCaAdmn8iHDy+L0tb/oaVtT7Xe7/t6uE1qrI0vCAjaAE0Cb1EG9KIRI50RAr9IuUhl5mP/IMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829875; c=relaxed/simple;
	bh=JFf0fKO3QP8jgo3mtWS0vZS0kXgbOwAyESmTTTbxWQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C437sg/WfDqAlFj7y8zKyopucHMgGOD5TKB09Hz5g2RD8eWOeOq9+YKzw/klI+8MJy/Z6SDa1VNT7/rNi+kdO72jditFE9g2Va6O+b7IAlEVG9/NJ6l8UiofZUW6qduqyprlT4SG163qqx36u81JKAfFoOFrxmRJNRvzjw5J8uo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q1nff0E0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q1nff0E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E03841F00893;
	Sun,  7 Jun 2026 10:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829874;
	bh=lSVmZYJ2qu8fg3AlbKo6eu1/ULyiYq3aDpi9dOBaHSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q1nff0E0FeaciHVNq736mBFVMsTUohARqLbcn4xgefL6zJqvBnHJT6hr4UmflMQp9
	 Yar36LCMOmFON/qYOFTJDepE34r0J13aWDcMDRXqd30milh7mva+EGzjtNSnq5QazO
	 fjeBA5CuXNedTmP+efw0HGoQ8FvZox17MFyll36U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 320/332] platform/x86/intel/vsec: Make driver_data info const
Date: Sun,  7 Jun 2026 12:01:29 +0200
Message-ID: <20260607095739.871419380@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -200,13 +200,13 @@ static inline struct intel_vsec_device *
 
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


