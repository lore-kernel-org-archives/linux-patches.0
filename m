Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B60047988E;
	Fri,  7 Aug 2026 15:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117750; cv=none; b=j5ljxomFXcDDHkhd9yZKhWRtw/2HgkU72V1QI1FCFTS13MOjsdYPHotBOLNa14ECozMvaZJF67IIQQ8BxHsg8G9UuxVEtNGH+fBpUGo2rkmDuj+RgERYzJRpLpjOcs8sWaXj701FWARfASPnZYPAKod9NYwwjKD73K2lltkqOdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117750; c=relaxed/simple;
	bh=H4XDCvgUOXw+RGcxNTTcoF6uEzC+TSU6XeCpBylthok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4OKVZ8HXwVTJj4+/sCKbvzLRY69nQ4+fkkHO7fAP8fg753nH2xL0I98u+raHXx5EkF2/LjzNR4Sr1Vof7k6Rp4z0hBfygqbBK7U3P1D32L3sy2U+YHtrXsp1hhs/ShqWvE5JxJWi02WIvwSsCh2UxlEVPCgHzKdphKIXAWcsxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SzwFgXtF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SzwFgXtF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6743A1F000E9;
	Fri,  7 Aug 2026 15:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117748;
	bh=VsBw9Dw05JkQ6suNB5gv8vOoYccBLY/Bxr7kqFKCDzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SzwFgXtFIwpLypQ08pcA9iA+alvw/BSdO/uBRIJ/twEhzYA9eeIKza0IoywirMWWN
	 SFZNN0tbIVTo5j+ZNfB7yrGvVsaa6oijUVaI3dRz7qaUi+e6S02S9az1Os+5rlmPXs
	 lfupSLvOKNTHtlOUq8a3uWybx6rwV8D3JFaM3/uY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Wajdeczko <michal.wajdeczko@intel.com>,
	Raag Jadav <raag.jadav@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 428/438] drm/xe: Drop unused param from xe_device_create()
Date: Fri,  7 Aug 2026 16:40:24 +0200
Message-ID: <20260807143437.089563666@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Wajdeczko <michal.wajdeczko@intel.com>

[ Upstream commit 8a09097b11ca4d436691f64c3cc0958006f36e33 ]

We never used or need anything from the struct pci_device_id there.
And while around, add simple kernel-doc for this function.

Signed-off-by: Michal Wajdeczko <michal.wajdeczko@intel.com>
Reviewed-by: Raag Jadav <raag.jadav@intel.com>
Reviewed-by: Gustavo Sousa <gustavo.sousa@intel.com>
Link: https://patch.msgid.link/20260526195452.20545-3-michal.wajdeczko@intel.com
Stable-dep-of: ba7fd1634228 ("drm/xe: Set TTM device beneficial_order to 9 (2M)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_device.c |   11 +++++++++--
 drivers/gpu/drm/xe/xe_device.h |    3 +--
 drivers/gpu/drm/xe/xe_pci.c    |    2 +-
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/xe/xe_device.c
+++ b/drivers/gpu/drm/xe/xe_device.c
@@ -435,8 +435,15 @@ static void xe_device_destroy(struct drm
 	ttm_device_fini(&xe->ttm);
 }
 
-struct xe_device *xe_device_create(struct pci_dev *pdev,
-				   const struct pci_device_id *ent)
+/**
+ * xe_device_create() - Create a new &xe_device instance
+ * @pdev: the parent &pci_dev
+ *
+ * Allocate and initialize a device managed Xe device structure.
+ *
+ * Return: pointer to new &xe_device on success, or ERR_PTR on failure.
+ */
+struct xe_device *xe_device_create(struct pci_dev *pdev)
 {
 	struct xe_device *xe;
 	int err;
--- a/drivers/gpu/drm/xe/xe_device.h
+++ b/drivers/gpu/drm/xe/xe_device.h
@@ -43,8 +43,7 @@ static inline struct xe_device *ttm_to_x
 	return container_of(ttm, struct xe_device, ttm);
 }
 
-struct xe_device *xe_device_create(struct pci_dev *pdev,
-				   const struct pci_device_id *ent);
+struct xe_device *xe_device_create(struct pci_dev *pdev);
 int xe_device_probe_early(struct xe_device *xe);
 int xe_device_probe(struct xe_device *xe);
 void xe_device_remove(struct xe_device *xe);
--- a/drivers/gpu/drm/xe/xe_pci.c
+++ b/drivers/gpu/drm/xe/xe_pci.c
@@ -1091,7 +1091,7 @@ static int xe_pci_probe(struct pci_dev *
 	if (err)
 		return err;
 
-	xe = xe_device_create(pdev, ent);
+	xe = xe_device_create(pdev);
 	if (IS_ERR(xe))
 		return PTR_ERR(xe);
 


