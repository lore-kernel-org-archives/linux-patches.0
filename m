Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109A2325706;
	Sun,  7 Jun 2026 10:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829862; cv=none; b=C6Wt3jMROxGw5pyxmQTshUdfUZfKtOUBxcvEODH0W4YdlowYoDILHw2uLH3wVdioZjpcXIGkTSwWpJZVMh1wJG3c1LiBa2ua5HNGwL+MflUwsRFx591RCzZIRt5kDXM3fnLiy4enzuDWGb3nSuoaLb4FX4rVbiDbU43kCjY+hNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829862; c=relaxed/simple;
	bh=PaVgC7liIF5uGnqcWT24I4//WWJggikaW5u50e/Xtu0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=a2xRK5ERzsQ2e4dWqLvjRiZqwooyy3XpdfXOhD/orLujqSHRWKzPt6LA7IwKYcaCVpOE52dVR4YnxIAU4tvp0iyh8SO2nuRIVy2ENc9+e5bkFyRxuFDdD5dO8SEZ+QXWXWq7ZdD/V3zrejj0udVVuk712PU2EFUgbHxyX5XZo6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZZw0k63W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZZw0k63W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15ED71F00893;
	Sun,  7 Jun 2026 10:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829860;
	bh=aUv6YvCi28VNPRUy68Z1Fdec3KtkKaTQCroA0M16hQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZZw0k63WMCVyE1dnPqz0rE+mg925g8eg3jRUX9INGz1el8yOE3jeCBDLbgFPEfvTk
	 hI0pw0Yuv5tYtAJR2+a3R+y3X7J3c9lh1HHH5h12lYiIH9fO34X0l+M4eTFtVit5VP
	 ZWCMJ6mpsYWh1l0UaQ4WhPMy+6xXzHgF324JnA5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 319/332] platform/x86/intel/vsec: Refactor base_addr handling
Date: Sun,  7 Jun 2026 12:01:28 +0200
Message-ID: <20260607095739.833305807@linuxfoundation.org>
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

[ Upstream commit 904b333fc51cc045941df9656302449a0fc9978e ]

The base_addr field in intel_vsec_platform_info was originally added to
support devices that emulate PCI VSEC capabilities in MMIO. Previously,
the code would check at registration time whether base_addr was set,
falling back to the PCI BAR if not.

Refactor this by making base_addr an explicit function parameter. This
clarifies ownership of the value and removes conditional logic from
intel_vsec_add_dev(). It also enables making intel_vsec_platform_info
const in a later patch, since the function no longer needs to write to
info->base_addr.

No functional change intended.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260313015202.3660072-2-david.e.box@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 348ccc754d89 ("platform/x86/intel/vsec: Fix enable_cnt imbalance on PCIe error recovery")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/vsec.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -271,14 +271,13 @@ EXPORT_SYMBOL_NS_GPL(intel_vsec_add_aux,
 
 static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *header,
 			      struct intel_vsec_platform_info *info,
-			      unsigned long cap_id)
+			      unsigned long cap_id, u64 base_addr)
 {
 	struct intel_vsec_device __free(kfree) *intel_vsec_dev = NULL;
 	struct resource __free(kfree) *res = NULL;
 	struct resource *tmp;
 	struct device *parent;
 	unsigned long quirks = info->quirks;
-	u64 base_addr;
 	int i;
 
 	if (info->parent)
@@ -310,11 +309,6 @@ static int intel_vsec_add_dev(struct pci
 	if (quirks & VSEC_QUIRK_TABLE_SHIFT)
 		header->offset >>= TABLE_OFFSET_SHIFT;
 
-	if (info->base_addr)
-		base_addr = info->base_addr;
-	else
-		base_addr = pdev->resource[header->tbir].start;
-
 	/*
 	 * The DVSEC/VSEC contains the starting offset and count for a block of
 	 * discovery tables. Create a resource array of these tables to the
@@ -412,7 +406,8 @@ static int get_cap_id(u32 header_id, uns
 
 static int intel_vsec_register_device(struct pci_dev *pdev,
 				      struct intel_vsec_header *header,
-				      struct intel_vsec_platform_info *info)
+				      struct intel_vsec_platform_info *info,
+				      u64 base_addr)
 {
 	const struct vsec_feature_dependency *consumer_deps;
 	struct vsec_priv *priv;
@@ -428,7 +423,7 @@ static int intel_vsec_register_device(st
 	 * For others using the exported APIs, add the device directly.
 	 */
 	if (!pci_match_id(intel_vsec_pci_ids, pdev))
-		return intel_vsec_add_dev(pdev, header, info, cap_id);
+		return intel_vsec_add_dev(pdev, header, info, cap_id, base_addr);
 
 	priv = pci_get_drvdata(pdev);
 	if (priv->state[cap_id] == STATE_REGISTERED ||
@@ -444,7 +439,7 @@ static int intel_vsec_register_device(st
 
 	consumer_deps = get_consumer_dependencies(priv, cap_id);
 	if (!consumer_deps || suppliers_ready(priv, consumer_deps, cap_id)) {
-		ret = intel_vsec_add_dev(pdev, header, info, cap_id);
+		ret = intel_vsec_add_dev(pdev, header, info, cap_id, base_addr);
 		if (ret)
 			priv->state[cap_id] = STATE_SKIP;
 		else
@@ -464,7 +459,7 @@ static bool intel_vsec_walk_header(struc
 	int ret;
 
 	for ( ; *header; header++) {
-		ret = intel_vsec_register_device(pdev, *header, info);
+		ret = intel_vsec_register_device(pdev, *header, info, info->base_addr);
 		if (!ret)
 			have_devices = true;
 	}
@@ -512,7 +507,8 @@ static bool intel_vsec_walk_dvsec(struct
 		pci_read_config_dword(pdev, pos + PCI_DVSEC_HEADER2, &hdr);
 		header.id = PCI_DVSEC_HEADER2_ID(hdr);
 
-		ret = intel_vsec_register_device(pdev, &header, info);
+		ret = intel_vsec_register_device(pdev, &header, info,
+						 pci_resource_start(pdev, header.tbir));
 		if (ret)
 			continue;
 
@@ -557,7 +553,8 @@ static bool intel_vsec_walk_vsec(struct
 		header.tbir = INTEL_DVSEC_TABLE_BAR(table);
 		header.offset = INTEL_DVSEC_TABLE_OFFSET(table);
 
-		ret = intel_vsec_register_device(pdev, &header, info);
+		ret = intel_vsec_register_device(pdev, &header, info,
+						 pci_resource_start(pdev, header.tbir));
 		if (ret)
 			continue;
 


