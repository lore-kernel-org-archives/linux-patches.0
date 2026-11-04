Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793830913;
	b=XisyvpXBo/yu9UaxgkveVwbAAZ0EN7RANgeRReDnYaS64F9IK62uhVhuBxCVbrID917x
	 Y/RGlT4FAfZ928uAe1lopZ8b1irhW6qnk6bqr4MebEBl4aNFo1zWa7RHUOdWaXothWwmF
	 wMyD6iFmm5iYlRpEnb1Du1SAn1vyhlq7bIJ0ze4sx2LVe7w9henrE4j2K+LaV+PmZK1rU
	 B3ZsICHi7BdmvI3kUJVgAdHnuSheo5qqI0JEmRLHl2JUmb4OcqpO4peQvLOr3I8LMCQd0
	 ZXDIsimspzza9vhad4Fro9ChmaSZhh6+Ol82A8AmM95jvqzW9ckkeKKjvhQalgOItFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793830913;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YPDgguWo0+KrFhs9r4BTbhTaMGdgTVG2ClIpYDP8dSw=;
	b=Eo1ZguJ4My05zT5Ql5y3Gz07hSA9hPL5VYqDp1w8MKwlVxxkSG2YuaIHjSBlwAEk0Tej
	 keXAZDwhzrFxkkYv65CxLuE7GOwcfoNFnR3g2HwNopWG1NlhxIs0kw1d4Ehm3InEzdFIq
	 mLE66hLl63y676Jqj3hm6JFE+9ZwO9dX+29h8MN1+C/b7raDV+BLMb1n5RlHNzDBJoC3s
	 ICNBDEtUKl3UVwCLf8wnH8XaJh6HM5eIylahvBBibbwkxzN7al9o3+sbXWot+tceGhP37
	 ThAt5ze71s8E/WeweFBESMIb0Kk2/XJBFkjJyNfNK3ZAGlZNv9BJ+Qodd/nISOnuKdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzAQcX1Y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FD41606A841;
	Wed,  4 Nov 2026 22:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VzAQcX1Y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DB611F00A16;
	Wed,  4 Nov 2026 22:21:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793830913;
	bh=YPDgguWo0+KrFhs9r4BTbhTaMGdgTVG2ClIpYDP8dSw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VzAQcX1YtRdu0X3LJknV9MY/Ph1bs2UZrK1VtabFPZyWiI9dMgV6xp2yAOnNIBs7I
	 wrmrzQAwpUJs9W/s5Y6dbaHXmlLiY9FFIaZrETUVJt2he+qH8pRjZqf2yxx95WgOcd
	 maH5PFOkxyhYk7BUmTBTmBUXC6tVNfQLySazDXTs=
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
Subject: [PATCH 6.18 0381/1005] iommu/amd: Fix missing CMD_COMPLETE_PPR response for invalid PPR requests
Date: Wed,  4 Nov 2026 16:01:54 -0500
Message-ID: <20261104211054.770124263@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dee077bd149b7..5f43a0fcdd1e3 100644
--- a/drivers/iommu/amd/amd_iommu_types.h
+++ b/drivers/iommu/amd/amd_iommu_types.h
@@ -158,6 +158,7 @@
 #define EVENT_FLAGS_SHIFT	0x10
 #define EVENT_FLAG_RW		0x020
 #define EVENT_FLAG_I		0x008
+#define EVENT_FLAG_PPR_RX	0x001
 
 /* feature control bits */
 #define CONTROL_IOMMU_EN	0
diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index e64e6da08a5f7..49587eafc0a8f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -883,10 +883,40 @@ static void amd_iommu_report_page_fault(struct amd_iommu *iommu,
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
 	u64 address, ctrl;
@@ -960,11 +990,7 @@ static void iommu_print_event(struct amd_iommu *iommu, void *__evt)
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



