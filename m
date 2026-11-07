Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060959;
	b=l9IHg8/V15q4tZBGHoapTifzAuqTbmloZKDeNKgw0IU4xQW/xTb6DVORJhpEYKufwCn3
	 CgDRrpltH5Wi3RO8h2l8VxPy1lJLUJqmWWSyfXFrG3a7lOl1skvibD7vwOeob+nuPCOot
	 zjXXt3DQapcmNnulBsG0WOc6zk/8y3U0uanpMQCT207iWgrSkFvJzY//hLuHkVWpn6A2H
	 N4U3A5eaSLrzaZwAZ4Hon2e7NaPhKt3l77zKbiZN7O2+Lm1IA9sbFIeG1fzZNmdTuVdVu
	 7WlkG0ZdavSzH2bPwz1k5A4o1WqCTub4DaE5Uy0HN7w9qXMPFRI//MPP9UZQiA0b2wQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060959;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=N0TYYmAKD3ix4Y0qq/p9iQbIUkR+jkiydSIdpHK+QEY=;
	b=R2KMvFA+fJjW8FZsTLPbRRkIKysrgnSxZIN3RLY7EjRu9m8nB2S6j9RaRnXWprUU3FyP
	 yIfALyZpVZjmfaMquU4ihkcFuRDojrMfdNoksXnE9jC+vRKljKFY5gwDRvdCkCJPn8yyw
	 huYomtk8WkGd0m2yU3fdiVV35CA6xf1smxd2p862YrdpaHj1y/Pde2pXTzekFbLBQRqeK
	 Z/utuJL6UTnUeZGDreJIGFkC2BauCV3oCCzdY41zTZToM668oZM7T6AfztJaLGDVFIXUu
	 WAN3H8ejIWrlAk8DSS5mdtOerhqUvOl24b9pBIz5aUGE+Vi2wVrtq8XuA6QoBPtADGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGKJyXAW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73B56606D80C;
	Sat,  7 Nov 2026 14:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EGKJyXAW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 247AE1F0089F;
	Sat,  7 Nov 2026 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060959;
	bh=N0TYYmAKD3ix4Y0qq/p9iQbIUkR+jkiydSIdpHK+QEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EGKJyXAWHjR1akQKw415ewrZbQZSVy09z3SeMCPH+ulV4OBPUXflw+Zfed1IHKj4T
	 r/3TC3IBuXg/9yYTXnEybc8tvcTwhGIfoOdg3ZFwkyL40pPXDFAzxXKcdinfWH/Mxs
	 Qx9IB7JuMJgilOrn6/0Io3P4VENhWP69I+rwpr8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaultier Delbarre <Gaultier.Delbarre@amd.com>,
	Wei Huang <wei.huang2@amd.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Ankit Soni <Ankit.Soni@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0316/1536] iommu/amd: Fix missing CMD_COMPLETE_PPR response for invalid PPR requests
Date: Sat,  7 Nov 2026 08:38:52 -0500
Message-ID: <20261107135006.595960181@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vasant Hegde <vasant.hegde@amd.com>

[ Upstream commit bc1f5ec826bfa510e7138e2be5aad23907850874 ]

The AMD IOMMU spec, requires the host to respond with a CMD_COMPLETE_PPR
command when an EVENT_TYPE_INV_PPR_REQ event is received with the RX bit
cleared. This response was missing in the current implementation, leaving
invalid PPR requests unacknowledged.

Introduce amd_iommu_report_ppr_err() to handle EVENT_TYPE_INV_PPR_REQ
events. The new function logs the invalid PPR request and when the RX
bit is cleared, sends CMD_COMPLETE_PPR response.

Reported-by: Gaultier Delbarre <Gaultier.Delbarre@amd.com>
Co-developed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Reviewed-by: Ankit Soni <Ankit.Soni@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/amd_iommu_types.h |  1 +
 drivers/iommu/amd/iommu.c           | 38 ++++++++++++++++++++++++-----
 2 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/amd/amd_iommu_types.h b/drivers/iommu/amd/amd_iommu_types.h
index b3af429f23143..9d877008fc2d9 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -154,6 +154,7 @@
 #define EVENT_FLAGS_SHIFT	0x10
 #define EVENT_FLAG_RW		0x020
 #define EVENT_FLAG_I		0x008
+#define EVENT_FLAG_PPR_RX	0x001
 
 /* feature control bits */
 #define CONTROL_IOMMU_EN	0
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 3f109a99a9e40..2efa059cc7e80 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -896,10 +896,40 @@ static void amd_iommu_report_page_fault(struct amd_iommu *iommu,
 		pci_dev_put(pdev);
 }
 
+static void amd_iommu_report_ppr_err(struct amd_iommu *iommu, volatile u32 *event,
+				     u16 devid, u64 address, int flags)
+{
+	struct pci_dev *pdev;
+	struct device *dev = iommu->iommu.dev;
+	u32 pasid = PPR_PASID(*((u64 *)event));
+	int tag = event[1] & 0x03FF;
+
+	dev_err(dev, "Event logged [INVALID_PPR_REQUEST device=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x tag=0x%03x]\n",
+		iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
+		pasid, address, flags, tag);
+
+	/* Skip COMPLETE_PPR_REQUEST response if RX=1 */
+	if (flags & EVENT_FLAG_PPR_RX)
+		return;
+
+	pdev = pci_get_domain_bus_and_slot(iommu->pci_seg->id, PCI_BUS_NUM(devid),
+					   devid & 0xff);
+	if (!pdev)
+		return;
+
+	if (!dev_iommu_priv_get(&pdev->dev)) {
+		pci_dev_put(pdev);
+		return;
+	}
+
+	amd_iommu_complete_ppr(&pdev->dev, pasid, IOMMU_PAGE_RESP_FAILURE, tag);
+	pci_dev_put(pdev);
+}
+
 static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 {
 	struct device *dev = iommu->iommu.dev;
-	int type, devid, flags, tag;
+	int type, devid, flags;
 	volatile u32 *event = __evt;
 	int count = 0;
 	u64 address;
@@ -971,11 +1001,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
 		amd_iommu_report_rmp_hw_error(iommu, event);
 		break;
 	case EVENT_TYPE_INV_PPR_REQ:
-		pasid = PPR_PASID(*((u64 *)__evt));
-		tag = event[1] & 0x03FF;
-		dev_err(dev, "Event logged [INVALID_PPR_REQUEST device=%04x:%02x:%02x.%x pasid=0x%05x address=0x%llx flags=0x%04x tag=0x%03x]\n",
-			iommu->pci_seg->id, PCI_BUS_NUM(devid), PCI_SLOT(devid), PCI_FUNC(devid),
-			pasid, address, flags, tag);
+		amd_iommu_report_ppr_err(iommu, event, devid, address, flags);
 		break;
 	default:
 		dev_err(dev, "Event logged [UNKNOWN event[0]=0x%08x event[1]=0x%08x event[2]=0x%08x event[3]=0x%08x\n",
-- 
2.53.0



