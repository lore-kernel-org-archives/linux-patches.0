Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A7A4F207;
	Tue, 23 Jan 2024 00:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970430; cv=none; b=JlDC0eaGGB49aJtKHHsr1sSFyEb1AoPi+fhBExHiN+K1V0Z3Tv6605iOuWne3eG2rikyS8hjK1JvPqUSuLsIz2xpGYuyfM629Ff+1ZunsGQISdnpXnxCXdUmXfX00jhEd8SH9IIFyDbc+XSj1gsk6s3hCclV8mha67crBYGaiGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970430; c=relaxed/simple;
	bh=f2Jw9GpdLj7W4sTVY1ESFoVNc8bktZVOpUM4BNTO47o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsoI3UJm1wEd+tzBqfteqTt+Rts+jxv/rkRIuDOJHEg/u77ETM4AThIqX5jk2Bh6zIlTOn6uXSEcBg9g6uewTg65p8nuVvv4hjnoKZIScUW1BQmidyfqt91miTAD9EtjYVzGniLICFE4gYspFTaZssv3w7mFaZWPaVj2kiLtG7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GazC0PHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GazC0PHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81524C43390;
	Tue, 23 Jan 2024 00:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970430;
	bh=f2Jw9GpdLj7W4sTVY1ESFoVNc8bktZVOpUM4BNTO47o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GazC0PHGCaLVca/87vyq5iTTNpcmdccgo8TZcYJDUz1gr/8cv3oCFkw5un9IE22N4
	 ePQE0glXCb2qiS68E5B+H1VXRNaF37jZyUMy4wSIVVGJhz/kzlnFpUpBAGBsh3vGQT
	 5IXHPzU24oYtqVbnRzDN8uKVm/u/8qQuLz/Xyy28=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"David E. Box" <david.e.box@linux.intel.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 018/417] platform/x86/intel/vsec: Enhance and Export intel_vsec_add_aux()
Date: Mon, 22 Jan 2024 15:53:06 -0800
Message-ID: <20240122235752.163899578@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

[ Upstream commit 251a41116aebdbb7ff00fbc635b1c1a0f08119e6 ]

Remove static for intel_vsec_add_aux() and export this interface so that
it can be used by other vsec related modules.

This driver creates aux devices by parsing PCI-VSEC, which allows
individual drivers to load on those devices. Those driver may further
create more devices on aux bus by parsing the PCI MMIO region.

For example, TPMI (Topology Aware Register and PM Capsule Interface)
creates device nodes for power management features by parsing MMIO region.

When TPMI driver creates devices, it can reuse existing function
intel_vsec_add_aux() to create aux devices with TPMI device as the parent.

Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Acked-by: David E. Box <david.e.box@linux.intel.com>
Link: https://lore.kernel.org/r/20230202010738.2186174-3-srinivas.pandruvada@linux.intel.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Stable-dep-of: 8cbcc1dbf8a6 ("platform/x86/intel/vsec: Fix xa_alloc memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/vsec.c | 16 +++++++++++-----
 drivers/platform/x86/intel/vsec.h |  4 ++++
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/intel/vsec.c b/drivers/platform/x86/intel/vsec.c
index 483bb6565166..4d73ad741892 100644
--- a/drivers/platform/x86/intel/vsec.c
+++ b/drivers/platform/x86/intel/vsec.c
@@ -133,8 +133,9 @@ static void intel_vsec_dev_release(struct device *dev)
 	kfree(intel_vsec_dev);
 }
 
-static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *intel_vsec_dev,
-			      const char *name)
+int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
+		       struct intel_vsec_device *intel_vsec_dev,
+		       const char *name)
 {
 	struct auxiliary_device *auxdev = &intel_vsec_dev->auxdev;
 	int ret, id;
@@ -146,9 +147,12 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 		return ret;
 	}
 
+	if (!parent)
+		parent = &pdev->dev;
+
 	auxdev->id = ret;
 	auxdev->name = name;
-	auxdev->dev.parent = &pdev->dev;
+	auxdev->dev.parent = parent;
 	auxdev->dev.release = intel_vsec_dev_release;
 
 	ret = auxiliary_device_init(auxdev);
@@ -165,7 +169,7 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 		return ret;
 	}
 
-	ret = devm_add_action_or_reset(&pdev->dev, intel_vsec_remove_aux,
+	ret = devm_add_action_or_reset(parent, intel_vsec_remove_aux,
 				       auxdev);
 	if (ret < 0)
 		return ret;
@@ -178,6 +182,7 @@ static int intel_vsec_add_aux(struct pci_dev *pdev, struct intel_vsec_device *in
 
 	return 0;
 }
+EXPORT_SYMBOL_NS_GPL(intel_vsec_add_aux, INTEL_VSEC);
 
 static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *header,
 			      struct intel_vsec_platform_info *info)
@@ -235,7 +240,8 @@ static int intel_vsec_add_dev(struct pci_dev *pdev, struct intel_vsec_header *he
 	else
 		intel_vsec_dev->ida = &intel_vsec_ida;
 
-	return intel_vsec_add_aux(pdev, intel_vsec_dev, intel_vsec_name(header->id));
+	return intel_vsec_add_aux(pdev, NULL, intel_vsec_dev,
+				  intel_vsec_name(header->id));
 }
 
 static bool intel_vsec_walk_header(struct pci_dev *pdev,
diff --git a/drivers/platform/x86/intel/vsec.h b/drivers/platform/x86/intel/vsec.h
index 3deeb05cf394..d02c340fd458 100644
--- a/drivers/platform/x86/intel/vsec.h
+++ b/drivers/platform/x86/intel/vsec.h
@@ -40,6 +40,10 @@ struct intel_vsec_device {
 	int num_resources;
 };
 
+int intel_vsec_add_aux(struct pci_dev *pdev, struct device *parent,
+		       struct intel_vsec_device *intel_vsec_dev,
+		       const char *name);
+
 static inline struct intel_vsec_device *dev_to_ivdev(struct device *dev)
 {
 	return container_of(dev, struct intel_vsec_device, auxdev.dev);
-- 
2.43.0



