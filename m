Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF3873D45E5;
	Tue, 16 Jun 2026 18:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632819; cv=none; b=i64DwtPo9Ni7jXDsx2gs2NXbjEA/MeiAqEKuzE47Cvjf5OUopC5G44siG1UUcJDcp7Sfq5GB0mxIl7FzaotppFuW0X2Jr0YG0l/m/Q5fv/JlhnYq7VjA05lUul7Lg3EXjNc8POHjWlQaVLXRXk8R7JJ0AYV/We0Ag7SUIlSY/gA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632819; c=relaxed/simple;
	bh=eQDddtEZrh7UQEFJ/fP46Y0FQ6QPCoUrJKvIvcCbhdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TIuqK0IHZMCd4meivj1eAb/akZfAToj7qb2pJBmcni1LUg1vC7DxMuNpz69mdliiSZ04UFpEPIXEaJaE4AtsxZLkhQVhhawT6l2AZff5GT3UuZFabRmGHV/waNgRaEKnFWGgruRsWUkO74LEvXOt1ZKH3JQAC8SdA8BV3375pk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=phHe7iaY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="phHe7iaY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47FAF1F00A3A;
	Tue, 16 Jun 2026 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632817;
	bh=amu7NAi03w8UUTxilBvdCUWhIdy12dxA3M0jXYueicE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=phHe7iaY9WjVsUT9VlKVqqNWw3HzCtQrXKaRlLwIBlfod4sgE0aasYcO/GgzgwKao
	 FE6wN92CRx0av0eFXEeFn1k4PzXe7I+2ssdWC+c5PYLa1+Gact58dBmZm02MFO+t3H
	 QNZ5nSjfVlJrzT8BXM47dNK4i1bjQLVYluNRFXkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 449/522] platform/x86/intel/vsec: Make driver_data info const
Date: Tue, 16 Jun 2026 20:29:56 +0530
Message-ID: <20260616145146.926597147@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/platform/x86/intel/vsec.c |   16 ++++++++--------
 drivers/platform/x86/intel/vsec.h |    2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -74,7 +74,7 @@ static enum intel_vsec_id intel_vsec_all
 };
 
 struct vsec_priv {
-	struct intel_vsec_platform_info *info;
+	const struct intel_vsec_platform_info *info;
 };
 
 static const char *intel_vsec_name(enum intel_vsec_id id)
@@ -203,7 +203,7 @@ int intel_vsec_add_aux(struct pci_dev *p
 EXPORT_SYMBOL_NS_GPL(intel_vsec_add_aux, INTEL_VSEC);
 
 static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *header,
-			      struct intel_vsec_platform_info *info)
+			      const struct intel_vsec_platform_info *info)
 {
 	struct intel_vsec_device *intel_vsec_dev;
 	struct resource *res, *tmp;
@@ -263,7 +263,7 @@ static int intel_vsec_add_dev(struct pci
 }
 
 static bool intel_vsec_walk_header(struct pci_dev *pdev,
-				   struct intel_vsec_platform_info *info)
+				   const struct intel_vsec_platform_info *info)
 {
 	struct intel_vsec_header **header = info->capabilities;
 	bool have_devices = false;
@@ -282,7 +282,7 @@ static bool intel_vsec_walk_header(struc
 }
 
 static bool intel_vsec_walk_dvsec(struct pci_dev *pdev,
-				  struct intel_vsec_platform_info *info)
+				  const struct intel_vsec_platform_info *info)
 {
 	bool have_devices = false;
 	int pos = 0;
@@ -332,7 +332,7 @@ static bool intel_vsec_walk_dvsec(struct
 }
 
 static bool intel_vsec_walk_vsec(struct pci_dev *pdev,
-				 struct intel_vsec_platform_info *info)
+				 const struct intel_vsec_platform_info *info)
 {
 	bool have_devices = false;
 	int pos = 0;
@@ -377,7 +377,7 @@ static bool intel_vsec_walk_vsec(struct
 }
 
 static bool intel_vsec_get_features(struct pci_dev *pdev,
-				    struct intel_vsec_platform_info *info)
+				    const struct intel_vsec_platform_info *info)
 {
 	bool found = false;
 
@@ -403,7 +403,7 @@ static bool intel_vsec_get_features(stru
 
 static int intel_vsec_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 {
-	struct intel_vsec_platform_info *info;
+	const struct intel_vsec_platform_info *info;
 	struct vsec_priv *priv;
 	int ret;
 
@@ -412,7 +412,7 @@ static int intel_vsec_pci_probe(struct p
 		return ret;
 
 	pci_save_state(pdev);
-	info = (struct intel_vsec_platform_info *)id->driver_data;
+	info = (const struct intel_vsec_platform_info *)id->driver_data;
 	if (!info)
 		return -EINVAL;
 
--- a/drivers/platform/x86/intel/vsec.h
+++ b/drivers/platform/x86/intel/vsec.h
@@ -36,7 +36,7 @@ struct intel_vsec_device {
 	struct pci_dev *pcidev;
 	struct resource *resource;
 	struct ida *ida;
-	struct intel_vsec_platform_info *info;
+	const struct intel_vsec_platform_info *info;
 	int num_resources;
 	int id; /* xa */
 	void *priv_data;


