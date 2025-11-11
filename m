Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2113446CB;
	Tue, 11 Nov 2025 01:13:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823615; cv=none; b=D+zvhDibvzhpYQt8FQaBSQBM93QsfxjEaDmX221+ukaecfDFmeM5x8BQZ/dpR0lGtmWwkmotGTJpcPxc28In7g8a//Z8yWPj4iEdnnJ866UXcRxpMU29usj9nu6FkNvZmlMjBM7oEAGEzuYC5Bj3hiVTyTQd5U6F07cP3cIlql0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823615; c=relaxed/simple;
	bh=ex2me4M4HEgNC3tHDlZGVM883dvh/FJxHlFmG2UB518=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ir2A3+8tj+dPDTtGJfrd7UCNDmq9KVOHKQ8HhWM//A3kppGA2LyRAcqcJgOdy9AezbtY1EDApRM4aPvpWo87rUYFQQh7XzxT5oG6/xVJ2WnacKBVyPAvGiCHjLDzpApjwNAdIwP5KxnIKhowj6t6KPHyoey4rd3PjVQBMuFZxtI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VMWZ0n90; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VMWZ0n90"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D1B9C19422;
	Tue, 11 Nov 2025 01:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823615;
	bh=ex2me4M4HEgNC3tHDlZGVM883dvh/FJxHlFmG2UB518=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VMWZ0n90pz5SmzP3yDCiUj7EqPSaifMIE/+99RPsheIcWuEHwqT9EL3lVKcTNW7Ql
	 dNDxVd7bZ07ueFlAgUZdnF4RjFZvMttNgMAPdRyDaJVVR+og6Es5ONclW6cjDsfCDA
	 Hq9d+HQpHhONGaWshacYosFdwYsVE8jT/p+QXBZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 336/849] dmaengine: idxd: Add a new IAA device ID for Wildcat Lake family platforms
Date: Tue, 11 Nov 2025 09:38:26 +0900
Message-ID: <20251111004544.542442223@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>

[ Upstream commit c937969a503ebf45e0bebafee4122db22b0091bd ]

A new IAA device ID, 0xfd2d, is introduced across all Wildcat Lake
family platforms. Add the device ID to the IDXD driver.

Signed-off-by: Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Link: https://lore.kernel.org/r/20250801215936.188555-1-vinicius.gomes@intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/idxd/init.c      | 2 ++
 drivers/dma/idxd/registers.h | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/dma/idxd/init.c b/drivers/dma/idxd/init.c
index 8c4725ad1f648..2acc34b3daff8 100644
--- a/drivers/dma/idxd/init.c
+++ b/drivers/dma/idxd/init.c
@@ -80,6 +80,8 @@ static struct pci_device_id idxd_pci_tbl[] = {
 	{ PCI_DEVICE_DATA(INTEL, IAA_DMR, &idxd_driver_data[IDXD_TYPE_IAX]) },
 	/* IAA PTL platforms */
 	{ PCI_DEVICE_DATA(INTEL, IAA_PTL, &idxd_driver_data[IDXD_TYPE_IAX]) },
+	/* IAA WCL platforms */
+	{ PCI_DEVICE_DATA(INTEL, IAA_WCL, &idxd_driver_data[IDXD_TYPE_IAX]) },
 	{ 0, }
 };
 MODULE_DEVICE_TABLE(pci, idxd_pci_tbl);
diff --git a/drivers/dma/idxd/registers.h b/drivers/dma/idxd/registers.h
index 9c1c546fe443e..0d84bd7a680b7 100644
--- a/drivers/dma/idxd/registers.h
+++ b/drivers/dma/idxd/registers.h
@@ -10,6 +10,7 @@
 #define PCI_DEVICE_ID_INTEL_DSA_DMR	0x1212
 #define PCI_DEVICE_ID_INTEL_IAA_DMR	0x1216
 #define PCI_DEVICE_ID_INTEL_IAA_PTL	0xb02d
+#define PCI_DEVICE_ID_INTEL_IAA_WCL	0xfd2d
 
 #define DEVICE_VERSION_1		0x100
 #define DEVICE_VERSION_2		0x200
-- 
2.51.0



