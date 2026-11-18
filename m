Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024617;
	b=k+3qAfI6R++j/FmldbMNeZDz7s0a3ExAUCpvjgp74B+N9MLqK7scbETygGMHd7D5qg+B
	 YX4ySeaNyH+hWpOtnMbE4TWuYJAR/Xib7WOiGtGEgc2sSX7mIqulfRMyRgrM7Ad8ruGhw
	 CddwTN0TkW8jyvvTIx+GJcezujY8+tgRi8NN1mTJ65WGQiQPRBB68+FEheY3snrt0lG0e
	 iUrpnDpHOpAGlCyLoR7EzebzHdBPVMSCa7aonSV903A+NlcaCn3/BrBec+xoHvat6JFtC
	 Ezi2QDDSbhapkIUaLSDgE1eaJ1ircoyTNwEaGNaaT/0oTvBDwMIGZsxgiV2KInXES3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024617;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rw1dRwjA33bGkainWVB8hi8fCy4xiWmS6sLDX0/zGS4=;
	b=xDsRv23lvZezLARqjEIy6LTFId1CZ5Klqxbc6hOgTemAu1CXT9CpSVh8TMbx9tXpxejb
	 7DFsIzBo1QjFWt/jA0NIzyhZyHNEtKQpNJSlf97HVfJFQAnIz/euSyFWieSyhF6dxKbId
	 hPf8viTiDn00bBZsPGmgMGgpFdNwQjk5MQgsDC5tnY4UoVnSu9QXYOMGKLV5Pj9ur9TC7
	 TgsvR3zC0sTRrncKTRGU3NGNA9gz9BbA9eJbpduF2owdaEFYLGYScosQCFX7p+iiKQmwy
	 Hg1bKg4JLUPHMCl3MD/yTaNCG0coBZ8jwOBRvrOc8F1DjnOe91vcTjV1SChZF2YS21A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ab9Xdptm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B441606A325;
	Wed, 18 Nov 2026 17:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ab9Xdptm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBEB91F000C4;
	Wed, 18 Nov 2026 17:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024617;
	bh=rw1dRwjA33bGkainWVB8hi8fCy4xiWmS6sLDX0/zGS4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ab9XdptmW2L0Gz83Uwebg9o7S1V8ySTrNba29XVrAFrhThdcHuJxds1peYn1bOAyO
	 Md5dHdeFNnxw7SKS3hq0KhGtPj9jcYzrGkEfLeAN3lRlSO7k/mU6exoYiHh/msKnx7
	 1no3h9S3E07weW7jgis7og/W3pr1O0qFgqwj4o+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0790/2151] iommu/vt-d: Reserve scalable-mode DIDs from PASID entries during copy
Date: Wed, 18 Nov 2026 15:42:05 +0100
Message-ID: <20261118150150.880022704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 07a64cbe15c4b0bf1d55208f3e945ba8a53075a0 ]

copy_context_table() reserves old domain IDs (DIDs) from context entries.
That works for legacy mode, but not for scalable mode: scalable context
entries do not carry DID, so this path ends up reserving the wrong value
(often DID 0) repeatedly.

In scalable mode, real DIDs are stored in PASID table entries. If they
are not reserved during kdump table copy, new domains may reuse old DIDs
while stale PASID/IOTLB cache state still exists, causing translation
conflicts and DMA faults.

Fix this by walking PASID tables in scalable mode, and reserving DIDs
from present PASID entries. If PASID structures cannot be remapped, return
error so caller can fall back safely instead of continuing with an unsafe
DID space.

Fixes: 0c5f6c0d8201 ("iommu/vt-d: Fix kdump kernels boot failure with scalable mode")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 74 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 72 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index df3d28abcaeda..19ea73dad7f35 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1950,6 +1950,70 @@ static int reserve_domain_id(struct intel_iommu *iommu, int did)
 	return ret;
 }
 
+/*
+ * Reserve the domain IDs used by a scalable mode context entry copied from
+ * the previous kernel.
+ */
+static int copy_pasid_table_dids(struct intel_iommu *iommu, struct context_entry *ce)
+{
+	struct pasid_dir_entry *dir;
+	unsigned long dir_size;
+	phys_addr_t dir_phys;
+	int ret = 0;
+	int i, j;
+
+	dir_phys = ce->lo & VTD_PAGE_MASK;
+	if (!dir_phys)
+		return 0;
+
+	dir_size = get_pasid_dir_size(ce);
+	dir = memremap(dir_phys, dir_size * sizeof(*dir), MEMREMAP_WB);
+	if (!dir)
+		return -ENOMEM;
+
+	for (i = 0; i < dir_size; i++) {
+		struct pasid_entry *table;
+		phys_addr_t table_phys;
+
+		if (!pasid_pde_is_present(&dir[i]))
+			continue;
+
+		/*
+		 * Do not use get_pasid_table_from_pde(); that returns a
+		 * phys_to_virt() pointer, which is not valid for memory
+		 * owned by the previous kernel.
+		 */
+		table_phys = READ_ONCE(dir[i].val) & PDE_PFN_MASK;
+		if (!table_phys)
+			continue;
+
+		/* A PASID table is one page: PASID_TBL_ENTRIES * 64 bytes. */
+		table = memremap(table_phys, PAGE_SIZE, MEMREMAP_WB);
+		if (!table) {
+			ret = -ENOMEM;
+			goto out;
+		}
+
+		for (j = 0; j < PASID_TBL_ENTRIES; j++) {
+			if (!pasid_pte_is_present(&table[j]))
+				continue;
+
+			ret = reserve_domain_id(iommu, pasid_get_domain_id(&table[j]));
+			if (ret) {
+				memunmap(table);
+				goto out;
+			}
+		}
+
+		memunmap(table);
+	}
+
+out:
+	memunmap(dir);
+
+	return ret;
+}
+
 static int copy_context_table(struct intel_iommu *iommu,
 			      struct root_entry *old_re,
 			      struct context_entry **tbl,
@@ -2017,8 +2081,14 @@ static int copy_context_table(struct intel_iommu *iommu,
 
 		if (!context_present(&ce))
 			continue;
-
-		ret = reserve_domain_id(iommu, context_domain_id(&ce));
+		/*
+		 * The context entry only holds a domain ID in legacy mode.
+		 * In scalable mode the IDs are in the PASID table entries.
+		 */
+		if (ext)
+			ret = copy_pasid_table_dids(iommu, &ce);
+		else
+			ret = reserve_domain_id(iommu, context_domain_id(&ce));
 		if (ret) {
 			/* Not yet published through @tbl, so free it here. */
 			iommu_free_pages(new_ce);
-- 
2.53.0



