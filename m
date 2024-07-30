Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 492331A6192;
	Tue, 30 Jul 2024 17:04:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359081; cv=none; b=po7n9SB2XLe6nvWpBwZpWxu2ukSpZJjtmyIyqBYPdTuGlrqRmfIXVraVbESPcGgE54yw3Eb0YSrhsxSh13/I871ip790sOneJfDDdova+LLsRss1K+GtxCwvTNUe6zri8f7+fY63pLLq5ms97IzPKAGSinUkaHjkrcki1PlKScI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359081; c=relaxed/simple;
	bh=uijEdVMHgPhZ0XepNkwmKdKxdRtTxjw7c2FK/IUshI0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rXRX49CTrw1rj3a1QK38k9vn06efLmhM1PaxaOBTbUF5woaavQ2YH+FlZTe3O704PwnaW6AXSWfvVSGEIulFyuCyIpnP8MUFFVWgnEySivsWVwUADQcJYq15ZxTUuaydJMzDqTq/xmYLLfed8BKn9MSWXQ00RNfv+7urhTOevBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdFnS5rF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdFnS5rF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3484C32782;
	Tue, 30 Jul 2024 17:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359081;
	bh=uijEdVMHgPhZ0XepNkwmKdKxdRtTxjw7c2FK/IUshI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IdFnS5rF/o0salx6WNKxQF58RIeu7pom/1Oj9v3GdDcMwQ8VAyzgchbppp4+FWOQi
	 LVR0MGHAcqA9xQGzBqi0dUVmHmx37lnLJhCjRv+MhPKmJHSHwk+HkFsCduXMkYERpq
	 uc8am3r8ZM1bsEZ8TkPUFyDVCGi5v+av9e5inlc4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Joao Martins <joao.m.martins@oracle.com>,
	Matt Ochs <mochs@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 431/809] iommufd/selftest: Fix tests to use MOCK_PAGE_SIZE based buffer sizes
Date: Tue, 30 Jul 2024 17:45:07 +0200
Message-ID: <20240730151741.723122561@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Martins <joao.m.martins@oracle.com>

[ Upstream commit ffa3c799ce157493615f9f3c2b3c9ba602d320b9 ]

commit a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
added tests covering edge cases in the boundaries of iova bitmap. Although
it used buffer sizes thinking in PAGE_SIZE (4K) as opposed to the
MOCK_PAGE_SIZE (2K) that is used in iommufd mock selftests. This meant that
isn't correctly exercising everything specifically the u32 and 4K bitmap
test cases. Fix selftests buffer sizes to be based on mock page size.

Link: https://lore.kernel.org/r/20240627110105.62325-5-joao.m.martins@oracle.com
Reported-by: Kevin Tian <kevin.tian@intel.com>
Closes: https://lore.kernel.org/linux-iommu/96efb6cf-a41c-420f-9673-2f0b682cac8c@oracle.com/
Fixes: a9af47e382a4 ("iommufd/selftest: Test IOMMU_HWPT_GET_DIRTY_BITMAP")
Signed-off-by: Joao Martins <joao.m.martins@oracle.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Tested-by: Matt Ochs <mochs@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/iommu/iommufd.c | 36 ++++++++++++-------------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/tools/testing/selftests/iommu/iommufd.c b/tools/testing/selftests/iommu/iommufd.c
index 61189215e1ab7..5f7d5a5ba89b0 100644
--- a/tools/testing/selftests/iommu/iommufd.c
+++ b/tools/testing/selftests/iommu/iommufd.c
@@ -1797,47 +1797,47 @@ FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty16k)
 	.buffer_size = 16UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128k)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty64k)
 {
 	/* one u32 index bitmap */
-	.buffer_size = 128UL * 1024UL,
+	.buffer_size = 64UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty256k)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128k)
 {
 	/* one u64 index bitmap */
-	.buffer_size = 256UL * 1024UL,
+	.buffer_size = 128UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty640k)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty320k)
 {
 	/* two u64 index and trailing end bitmap */
-	.buffer_size = 640UL * 1024UL,
+	.buffer_size = 320UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128M)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty64M)
 {
-	/* 4K bitmap (128M IOVA range) */
-	.buffer_size = 128UL * 1024UL * 1024UL,
+	/* 4K bitmap (64M IOVA range) */
+	.buffer_size = 64UL * 1024UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128M_huge)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty64M_huge)
 {
-	/* 4K bitmap (128M IOVA range) */
-	.buffer_size = 128UL * 1024UL * 1024UL,
+	/* 4K bitmap (64M IOVA range) */
+	.buffer_size = 64UL * 1024UL * 1024UL,
 	.hugepages = true,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty256M)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128M)
 {
-	/* 8K bitmap (256M IOVA range) */
-	.buffer_size = 256UL * 1024UL * 1024UL,
+	/* 8K bitmap (128M IOVA range) */
+	.buffer_size = 128UL * 1024UL * 1024UL,
 };
 
-FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty256M_huge)
+FIXTURE_VARIANT_ADD(iommufd_dirty_tracking, domain_dirty128M_huge)
 {
-	/* 8K bitmap (256M IOVA range) */
-	.buffer_size = 256UL * 1024UL * 1024UL,
+	/* 8K bitmap (128M IOVA range) */
+	.buffer_size = 128UL * 1024UL * 1024UL,
 	.hugepages = true,
 };
 
-- 
2.43.0



