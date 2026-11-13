Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585849;
	b=fWHptcMnQ2yrq+9Tc/ewRjdBdAnIrJFMSkYmZ1E2r21783ndProxzNJalZOHqg09vyY6
	 ToB5GXpKTCZLZpTxD/5qa7kAAoHZzieZHhiCw6oTj5M/5UPlpXAunDJ1xk35JAPPiyV86
	 YsPTZf7xBHWH3W+c7Y0fYMrBRl9QoWixzOo0YzcgF9ZAHvBXtjvt0phO+0J5N1OPVZnbH
	 OZAY7dUsKKgNEsOQPuJlt4rofQ5eAVzrhMQPl/eR+lrsZm+qTMQ80B/6IZPTKqViMQ9Fw
	 7PkQsWeZj2tKyOIzETLrMzeproKhU/1TjW7Yyj5GHGT6g7rCMFFz99UHTNZTvjsMCxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585849;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=07mvGztm1UZC2SkxZ58PFgMrYscMBanXQjzsfb/QKx0=;
	b=idH3hIhEGJr7keOoYs7CGxmL4z0gSLqZbR3+yOHhN8F3535OwxX+9C3AKH7CoCuHxDex
	 zruxA26E6TwQlBI88T+ymmTPzuNJIdhhKbm6oQuDFq2oR6wSCOsNrlvEofmLsOq9rvjo9
	 YP6cgMndnoyEqeiKVXBv70Z8yGNt2zoJgNVgfd7mbieULsV5lVktqudfFPtIFVzQWX8od
	 0p28qQuIVhCPXf0LLL1TmUXzrzI6RIg/+yf7d+XpiTlHpQXSvHzfX3UXUHdydLisAcCqG
	 RkAEMG7CS2c8vaWuzBKfAkrReogpMawEGyF6hVbkp19ab+LpUfl68LqCy1P9hE6evEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SsUwX7Y/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC80606BAB5;
	Fri, 13 Nov 2026 16:04:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SsUwX7Y/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94DE21F000C4;
	Fri, 13 Nov 2026 16:04:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585848;
	bh=07mvGztm1UZC2SkxZ58PFgMrYscMBanXQjzsfb/QKx0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SsUwX7Y/xHNuadM/MB3CBTBJBfGh/nc3bvt2xpCiAF/RLQtnMR/Y5ZTYZaUZ0BLv4
	 SwdLWY6sRmPwl48YK/8TDQxVDuva8np9J6wrO+Jw631sjBoMYUQZRcwkymS54LYT9s
	 G2xwANt5uQqCnTDg5qEc7Fgvhp3+fJgj2unODeho=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Mitchell <kevmitch@arista.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 426/507] iommu/amd: remove obsolete domain pointer warning on release
Date: Fri, 13 Nov 2026 10:52:10 -0500
Message-ID: <20261113153811.191515606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kevin Mitchell <kevmitch@arista.com>

[ Upstream commit fa77b023eb80cdb297ff32f6b13786e483a81ca8 ]

A warning is triggered in amd_iommu_release_device() on removal of a
device with an IOMMU_RESV_DIRECT region. The warning is based on the
false assumption that correct attachment to the release_domain will
always result in a NULL dev_data->domain pointer. For devices with
IOMMU_RESV_DIRECT (and consequently dev->iommu->require_direct), the
release domain is the permanent identity_domain which sets
itself to dev_data->domain on attach.

This behaviour was added in commit e94160488e65 ("iommu: Generic support
for RMRs during device release"). Commit c21b34762e2f ("iommu/amd: Set
release_domain to blocked_domain") caused it to take effect for AMD
IOMMU.

Remove the warning as it is no longer strictly an error to have a non-NULL
domain pointer. As this leaves amd_iommu_release_device() empty, remove it.

The warning was observed for a device with direct mapped region:

/sys/bus/pci/devices/0000:04:00.0/iommu_group/reserved_regions:

  0x00000000fee00000 0x00000000feefffff msi
  0x000000fd00000000 0x000000ffffffffff reserved
  0x0000fffd00000000 0x0000ffffffffffff direct

Upon hotunplug:

[   28.715475] pcieport 0000:00:03.1: pciehp: Slot(0-3): Link Down
[   28.715482] pcieport 0000:00:03.1: pciehp: Slot(0-3): Card not present
[   28.715601] ------------[ cut here ]------------
[   28.715603] WARNING: drivers/iommu/amd/iommu.c:2521 at amd_iommu_release_device+0x5d/0x70, CPU#4: irq/29-pciehp/99
[   28.715657] RIP: 0010:amd_iommu_release_device+0x5d/0x70
[   28.715687] Call Trace:
[   28.715689]  <TASK>
[   28.715694]  iommu_deinit_device+0x84/0x110
[   28.715699]  __iommu_group_remove_device+0xa8/0xd0
[   28.715703]  iommu_bus_notifier+0x48/0x70
[   28.715707]  notifier_call_chain+0x48/0xe0
[   28.715712]  blocking_notifier_call_chain+0x45/0x60
[   28.715716]  bus_notify+0x3b/0x60
[   28.715720]  device_del+0x259/0x3b0
[   28.715730]  pci_remove_bus_device+0x85/0x100
[   28.715735]  pciehp_unconfigure_device+0x9d/0x180
[   28.715743]  __pciehp_disable_slot+0x47/0xe0
[   28.715747]  pciehp_handle_presence_or_link_change+0x80/0x5e0
[   28.715753]  pciehp_ist+0x162/0x290

Fixes: c21b34762e2f ("iommu/amd: Set release_domain to blocked_domain")
Cc: stable@vger.kernel.org
Signed-off-by: Kevin Mitchell <kevmitch@arista.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Vasant Hegde <vasant.hegde@amd.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 893cd2be11a26..b19496f8c1b0f 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -489,6 +489,10 @@ static void setup_aliases(struct amd_iommu *iommu, struct device *dev)
 	clone_aliases(iommu, dev);
 }
 
+/*
+ * We keep dev_data around for unplugged devices and reuse it when the
+ * device is re-plugged - not doing so would introduce a ton of races.
+ */
 static struct iommu_dev_data *find_dev_data(struct amd_iommu *iommu, u16 devid)
 {
 	struct iommu_dev_data *dev_data;
@@ -2548,18 +2552,6 @@ static struct iommu_device *amd_iommu_probe_device(struct device *dev)
 	return iommu_dev;
 }
 
-static void amd_iommu_release_device(struct device *dev)
-{
-	struct iommu_dev_data *dev_data = dev_iommu_priv_get(dev);
-
-	WARN_ON(dev_data->domain);
-
-	/*
-	 * We keep dev_data around for unplugged devices and reuse it when the
-	 * device is re-plugged - not doing so would introduce a ton of races.
-	 */
-}
-
 static struct iommu_group *amd_iommu_device_group(struct device *dev)
 {
 	if (dev_is_pci(dev))
@@ -3205,7 +3197,6 @@ const struct iommu_ops amd_iommu_ops = {
 	.domain_alloc_paging_flags = amd_iommu_domain_alloc_paging_flags,
 	.domain_alloc_sva = amd_iommu_domain_alloc_sva,
 	.probe_device = amd_iommu_probe_device,
-	.release_device = amd_iommu_release_device,
 	.device_group = amd_iommu_device_group,
 	.get_resv_regions = amd_iommu_get_resv_regions,
 	.is_attach_deferred = amd_iommu_is_attach_deferred,
-- 
2.53.0



