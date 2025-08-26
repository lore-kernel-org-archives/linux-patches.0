Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 205D534F48D;
	Tue, 26 Aug 2025 11:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756207714; cv=none; b=lbQkXrrhrSjLBOBwHiUci2ZN8N10v9/ASCU4ylTljp+YbCmYOrVHY9twGPfyQWnY9EyzJFYBpNaPfM6Inv52ijTR+8mxW9rFFCmUXHd5ysnXcii8Du8KmfjeK2zEZRJdFNAtP04GXnnvJ+LP986RtpRthoLlyzZyN9yEJGEoGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756207714; c=relaxed/simple;
	bh=5SmGE928FRcuP9HL727USO6YtGGY6nvxL2+y7NZTEHE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kCYD0sKDbvoXYgLo2zO0WWa6ENqqQrHpO5o0Pmap+KSUplSk09HMo2nDZH1qwQn8mwc1YqlHaKtOqOVq4nLkdCrtuR4nA+KORBAtRIgVH5w3TSU+wjDmlWQeKsAsdxzI4saTqnW4HeBiFPjrR9UQw2AEcxxp74kTh8dD89u3PY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aJ89FjsS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aJ89FjsS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A02ABC4CEF1;
	Tue, 26 Aug 2025 11:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756207714;
	bh=5SmGE928FRcuP9HL727USO6YtGGY6nvxL2+y7NZTEHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aJ89FjsSMQfq/XzqdGQl5rJh3LjC9XQAiP1ig+poyHnvNXxEOisTAHPe1J12yLKAQ
	 afvszdhsnLKuZz87CK7yChyw2M/fUv1ZTJDqIwGSxIsTUM+yT43YNJu5Hpwym8dFaj
	 hVwHEYT5n6rJlJD9d5oMtBdtXrk87Y1BHKsdvntc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>,
	Sven Peter <sven@svenpeter.dev>,
	Tomasz Jeznach <tjeznach@rivosinc.com>
Subject: [PATCH 6.16 290/457] iommu: Remove ops.pgsize_bitmap from drivers that dont use it
Date: Tue, 26 Aug 2025 13:09:34 +0200
Message-ID: <20250826110944.551000681@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
References: <20250826110937.289866482@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 8901812485de1356e3757958af40fe0d3a48e986 ]

These drivers all set the domain->pgsize_bitmap in their
domain_alloc_paging() functions, so the ops value is never used. Delete
it.

Reviewed-by: Sven Peter <sven@svenpeter.dev> # for Apple DART
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Tomasz Jeznach <tjeznach@rivosinc.com> # for RISC-V
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Link: https://lore.kernel.org/r/3-v2-68a2e1ba507c+1fb-iommu_rm_ops_pgsize_jgg@nvidia.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 72b6f7cd89ce ("iommu/virtio: Make instance lookup robust")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/apple-dart.c       |    1 -
 drivers/iommu/intel/iommu.c      |    1 -
 drivers/iommu/iommufd/selftest.c |    1 -
 drivers/iommu/riscv/iommu.c      |    1 -
 drivers/iommu/virtio-iommu.c     |    6 ++----
 5 files changed, 2 insertions(+), 8 deletions(-)

--- a/drivers/iommu/apple-dart.c
+++ b/drivers/iommu/apple-dart.c
@@ -991,7 +991,6 @@ static const struct iommu_ops apple_dart
 	.of_xlate = apple_dart_of_xlate,
 	.def_domain_type = apple_dart_def_domain_type,
 	.get_resv_regions = apple_dart_get_resv_regions,
-	.pgsize_bitmap = -1UL, /* Restricted during dart probe */
 	.owner = THIS_MODULE,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev	= apple_dart_attach_dev_paging,
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -4390,7 +4390,6 @@ const struct iommu_ops intel_iommu_ops =
 	.device_group		= intel_iommu_device_group,
 	.is_attach_deferred	= intel_iommu_is_attach_deferred,
 	.def_domain_type	= device_def_domain_type,
-	.pgsize_bitmap		= SZ_4K,
 	.page_response		= intel_iommu_page_response,
 	.default_domain_ops = &(const struct iommu_domain_ops) {
 		.attach_dev		= intel_iommu_attach_device,
--- a/drivers/iommu/iommufd/selftest.c
+++ b/drivers/iommu/iommufd/selftest.c
@@ -801,7 +801,6 @@ static const struct iommu_ops mock_ops =
 	.default_domain = &mock_blocking_domain,
 	.blocked_domain = &mock_blocking_domain,
 	.owner = THIS_MODULE,
-	.pgsize_bitmap = MOCK_IO_PAGE_SIZE,
 	.hw_info = mock_domain_hw_info,
 	.domain_alloc_paging_flags = mock_domain_alloc_paging_flags,
 	.domain_alloc_nested = mock_domain_alloc_nested,
--- a/drivers/iommu/riscv/iommu.c
+++ b/drivers/iommu/riscv/iommu.c
@@ -1533,7 +1533,6 @@ static void riscv_iommu_release_device(s
 }
 
 static const struct iommu_ops riscv_iommu_ops = {
-	.pgsize_bitmap = SZ_4K,
 	.of_xlate = riscv_iommu_of_xlate,
 	.identity_domain = &riscv_iommu_identity_domain,
 	.blocked_domain = &riscv_iommu_blocking_domain,
--- a/drivers/iommu/virtio-iommu.c
+++ b/drivers/iommu/virtio-iommu.c
@@ -998,7 +998,7 @@ static void viommu_get_resv_regions(stru
 	iommu_dma_get_resv_regions(dev, head);
 }
 
-static struct iommu_ops viommu_ops;
+static const struct iommu_ops viommu_ops;
 static struct virtio_driver virtio_iommu_drv;
 
 static int viommu_match_node(struct device *dev, const void *data)
@@ -1086,7 +1086,7 @@ static bool viommu_capable(struct device
 	}
 }
 
-static struct iommu_ops viommu_ops = {
+static const struct iommu_ops viommu_ops = {
 	.capable		= viommu_capable,
 	.domain_alloc_identity	= viommu_domain_alloc_identity,
 	.domain_alloc_paging	= viommu_domain_alloc_paging,
@@ -1217,8 +1217,6 @@ static int viommu_probe(struct virtio_de
 		viommu->first_domain++;
 	}
 
-	viommu_ops.pgsize_bitmap = viommu->pgsize_bitmap;
-
 	virtio_device_ready(vdev);
 
 	/* Populate the event queue with buffers */


