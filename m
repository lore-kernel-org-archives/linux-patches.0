Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638D3471279;
	Tue, 21 Jul 2026 18:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657227; cv=none; b=rdaKKQZzDsQstWtW4gZtoHJknev3+9zwvhOX1vKi4vPJ73Rpn57uRp3hJc8q16jK9wdpEYEcouxi+8d9EmSlTw2Ei0qlwbpPFM2DbQ70Yb0VMNmh4O/ERAMdEs7jBu2UVbQz0KLln1vssimWqhn+4on8fQzcW3bATlxC/xiq0mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657227; c=relaxed/simple;
	bh=iZXo7Y94hvEXDopPP0jmqUoJ3zKnqH4orEI6kYsE3Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P4VeK5wNogzgdyjU2IU8f6EYwKzPOOZ2CyRg2agFOSX6twUkREOG8r1VlYEwzw4S/JRPyKIvJHQ7qV38Tob50okMh7wExjZpQdKUDrp3lw+LlKsaLj17APKagnvwHRiaI9rFFnz48iSQiTo6NK7U0lDXlcbdSU9qCzNbPvrgQE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f1jRobPp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f1jRobPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9A701F000E9;
	Tue, 21 Jul 2026 18:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657226;
	bh=mPaYylXL07tj4UYTJVpXytqL4yf+c34+lJWuSVhj5VY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1jRobPpYlTY3mvjOt5iphxB+6TpD78B9mtG0lHUgWphBopJJmVQPRiruA7hiCDjm
	 MXH2WiiZ+InJw84eCC/MbC7oX/nmBc2ecz+7ZNiCAgOpbf7wgJDKV7UmxfVN3CA7Ql
	 XgFnTqT8gmIyQ8diYlv9HdSdOqPLXt+RMC3uXQZw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David E. Box" <david.e.box@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0684/1611] platform/x86/intel/vsec: Decouple add/link helpers from PCI
Date: Tue, 21 Jul 2026 17:13:20 +0200
Message-ID: <20260721152530.767987415@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: David E. Box <david.e.box@linux.intel.com>

[ Upstream commit c62fd96a04e4a7b847448f97ecfe9f3fe706e7b3 ]

This refactor prepares for adding ACPI-enumerated PMT endpoints. While
intel_vsec is bound to PCI today, some helpers are used by code that will
also register PMT endpoints from non-PCI (ACPI) paths. Clean up
PCI-specific plumbing where it isn’t strictly required and rely on generic
struct device where possible.

Signed-off-by: David E. Box <david.e.box@linux.intel.com>
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Michael J. Ruhl <michael.j.ruhl@intel.com>
Link: https://patch.msgid.link/20260313015202.3660072-4-david.e.box@linux.intel.com
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Stable-dep-of: 375bbbbd112a ("platform/x86/intel/vsec: Restore BAR fallback for header walk")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c      | 13 +++++++++----
 drivers/platform/x86/intel/vsec_tpmi.c |  2 +-
 include/linux/intel_vsec.h             |  2 +-
 3 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 96fc27d88fbf32..cf1fc63ab6df2e 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -158,18 +158,23 @@ static bool vsec_driver_present(int cap_id)
  */
 static const struct pci_device_id intel_vsec_pci_ids[];
 
-static int intel_vsec_link_devices(struct pci_dev *pdev, struct device *dev,
+static int intel_vsec_link_devices(struct device *parent, struct device *dev,
 				   int consumer_id)
 {
 	const struct vsec_feature_dependency *deps;
 	enum vsec_device_state *state;
 	struct device **suppliers;
 	struct vsec_priv *priv;
+	struct pci_dev *pdev;
 	int supplier_id;
 
 	if (!consumer_id)
 		return 0;
 
+	if (!dev_is_pci(parent))
+		return 0;
+
+	pdev = to_pci_dev(parent);
 	if (!pci_match_id(intel_vsec_pci_ids, pdev))
 		return 0;
 
@@ -204,7 +209,7 @@ static int intel_vsec_link_devices(struct pci_dev *pdev, struct device *dev,
 	return 0;
 }
 
-int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
+int intel_vsec_add_aux(struct device *parent,
 		       struct intel_vsec_device *intel_vsec_dev,
 		       const char *name)
 {
@@ -252,7 +257,7 @@ int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
 	if (ret)
 		goto cleanup_aux;
 
-	ret = intel_vsec_link_devices(pdev, &auxdev->dev, intel_vsec_dev->cap_id);
+	ret = intel_vsec_link_devices(parent, &auxdev->dev, intel_vsec_dev->cap_id);
 	if (ret)
 		goto cleanup_aux;
 
@@ -343,7 +348,7 @@ static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *he
 	 * Pass the ownership of intel_vsec_dev and resource within it to
 	 * intel_vsec_add_aux()
 	 */
-	return intel_vsec_add_aux(pdev, parent, no_free_ptr(intel_vsec_dev),
+	return intel_vsec_add_aux(parent, no_free_ptr(intel_vsec_dev),
 				  intel_vsec_name(header->id));
 }
 
diff --git a/drivers/platform/x86/intel/vsec_tpmi.c b/drivers/platform/x86/intel/vsec_tpmi.c
index a8ccdd801ddd4c..7eb0f86469cd01 100644
--- a/drivers/platform/x86/intel/vsec_tpmi.c
+++ b/drivers/platform/x86/intel/vsec_tpmi.c
@@ -655,7 +655,7 @@ static int tpmi_create_device(struct intel_tpmi_info *tpmi_info,
 	 * feature_vsec_dev and res memory are also freed as part of
 	 * device deletion.
 	 */
-	return intel_vsec_add_aux(vsec_dev->pcidev, &vsec_dev->auxdev.dev,
+	return intel_vsec_add_aux(&vsec_dev->auxdev.dev,
 				  feature_vsec_dev, feature_id_name);
 }
 
diff --git a/include/linux/intel_vsec.h b/include/linux/intel_vsec.h
index d551174b004916..49a746ec012890 100644
--- a/include/linux/intel_vsec.h
+++ b/include/linux/intel_vsec.h
@@ -184,7 +184,7 @@ struct pmt_feature_group {
 	struct telemetry_region	regions[];
 };
 
-int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
+int intel_vsec_add_aux(struct device *parent,
 		       struct intel_vsec_device *intel_vsec_dev,
 		       const char *name);
 
-- 
2.53.0



