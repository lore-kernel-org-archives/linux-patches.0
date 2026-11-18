Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024612;
	b=MelUYwtjhxFMt5MrFPij9hd6e4vta/p+anzIOPhV9cFp6hYoJVIrfgwvfxXU4Z62bCIT
	 Tdahq3M6i590lOAQ2NU7YH2U/zlKYLX/czF2kJt8JL+Wjtq9jy2auTgZjIOsyuQFOzmMl
	 rJk2racKMAXqwv1dwLPzyh8p1hOj/PgpAwhlZS20JfbA6tad9p49IAJlBWA9/25FYbYQF
	 F4VV65p1S+oepWdFhvwi0fDY+iVXTG81dYxPzY3b2zwAQjdYecKEebW2qvBLR+Z/qV070
	 qXqFfd8JlYDk2n+vn32BOfdiJIHl5aHAgC3jJnMOdbYEZAfRhcI8Tws7MdcH0NGr9qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024612;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iBpGK/JO/aKwvdLKfG4kXKMgyaDvg9/m1BqMohN3dSY=;
	b=aD4g7Abpryq71Uso18vfJEcCNC2VI8hFZsQvYDrx+QuO7Q0LrRmjqn0XZbFcnE6AQBK2
	 NyAcSaqy03QQJsom8casBB9CUQN3R1nG8pkoMcRF+EHMqFDpu9oM7wNNlbmAbUzrHZXsg
	 GzJrH0astaLXLllBxk7sX3SCTdxcmQuEtwyjEC8Rhv6ufNBYft3WoFc37+C2UvKBDJ5rt
	 6vMNtViEeDmKDZgo+wvkUTa2V+ACtczVTzEAPbZ/Bz/eEcqCy0QuoJKAbAywRqdY8CLJF
	 NHxCBSngN/3VmiW2rDTr6jJrwWCN5r96TvEBJD75VVzDlRIlt+qcj9BIykB6XfArKjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJ6Cl98Q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2B6606A331;
	Wed, 18 Nov 2026 17:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pJ6Cl98Q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 601331F000C4;
	Wed, 18 Nov 2026 17:56:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024611;
	bh=iBpGK/JO/aKwvdLKfG4kXKMgyaDvg9/m1BqMohN3dSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pJ6Cl98QTYY4eQVBcDlZQqjzYwHFfnIGhZO08fd7VLTbHEvHbsWsklMqhVFoxxoC+
	 dm1tYz307KCKLKL/l0oADOvXPsC6WzzALf+haxWmN9zex+Njw/oN1eEgPuDCe6pZI8
	 yz7J4PYG025ZjLbsSf2sQBys8kI7o1G8Kruf4DK0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0788/2151] iommu/vt-d: Cache max domain ID to avoid redundant calculation
Date: Wed, 18 Nov 2026 15:42:03 +0100
Message-ID: <20261118150150.808488836@linuxfoundation.org>
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

[ Upstream commit 5b3ba0a002672d189fd55eaafdd4f55e5c6c522b ]

The cap_ndoms() helper calculates the maximum available domain ID from
the value of capability register, which can be inefficient if called
repeatedly. Cache the maximum supported domain ID in max_domain_id field
during initialization to avoid redundant calls to cap_ndoms() throughout
the IOMMU driver.

No functionality change.

Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Xu Yilun <yilun.xu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Stable-dep-of: 12a2ea2d91be ("iommu/vt-d: Handle DID reservation errors when copying context tables")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/dmar.c  |  1 +
 drivers/iommu/intel/iommu.c | 10 +++++-----
 drivers/iommu/intel/iommu.h |  1 +
 3 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/iommu/intel/dmar.c b/drivers/iommu/intel/dmar.c
index f4bdc5ffa9d9b..2a99df386560e 100644
--- a/drivers/iommu/intel/dmar.c
+++ b/drivers/iommu/intel/dmar.c
@@ -1110,6 +1110,7 @@ static int alloc_iommu(struct dmar_drhd_unit *drhd)
 	spin_lock_init(&iommu->lock);
 	ida_init(&iommu->domain_ida);
 	mutex_init(&iommu->did_lock);
+	iommu->max_domain_id = cap_ndoms(iommu->cap);
 
 	ver = readl(iommu->reg + DMAR_VER_REG);
 	pr_info("%s: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 135a268e2f2ca..b13fe38edf490 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1359,7 +1359,7 @@ int domain_attach_iommu(struct dmar_domain *domain, struct intel_iommu *iommu)
 	}
 
 	num = ida_alloc_range(&iommu->domain_ida, IDA_START_DID,
-			      cap_ndoms(iommu->cap) - 1, GFP_KERNEL);
+			      iommu->max_domain_id - 1, GFP_KERNEL);
 	if (num < 0) {
 		pr_err("%s: No free domain ids\n", iommu->name);
 		goto err_unlock;
@@ -1424,7 +1424,7 @@ static void copied_context_tear_down(struct intel_iommu *iommu,
 	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 
-	if (did_old < cap_ndoms(iommu->cap)) {
+	if (did_old < iommu->max_domain_id) {
 		iommu->flush.flush_context(iommu, did_old,
 					   PCI_DEVID(bus, devfn),
 					   DMA_CCMD_MASK_NOBIT,
@@ -1992,7 +1992,7 @@ static int copy_context_table(struct intel_iommu *iommu,
 			continue;
 
 		did = context_domain_id(&ce);
-		if (did >= 0 && did < cap_ndoms(iommu->cap))
+		if (did >= 0 && did < iommu->max_domain_id)
 			ida_alloc_range(&iommu->domain_ida, did, did, GFP_KERNEL);
 
 		set_context_copied(iommu, bus, devfn);
@@ -2935,7 +2935,7 @@ static ssize_t domains_supported_show(struct device *dev,
 				      struct device_attribute *attr, char *buf)
 {
 	struct intel_iommu *iommu = dev_to_intel_iommu(dev);
-	return sysfs_emit(buf, "%ld\n", cap_ndoms(iommu->cap));
+	return sysfs_emit(buf, "%ld\n", iommu->max_domain_id);
 }
 static DEVICE_ATTR_RO(domains_supported);
 
@@ -2946,7 +2946,7 @@ static ssize_t domains_used_show(struct device *dev,
 	unsigned int count = 0;
 	int id;
 
-	for (id = 0; id < cap_ndoms(iommu->cap); id++)
+	for (id = 0; id < iommu->max_domain_id; id++)
 		if (ida_exists(&iommu->domain_ida, id))
 			count++;
 
diff --git a/drivers/iommu/intel/iommu.h b/drivers/iommu/intel/iommu.h
index 33c9e06df63f9..9551ea19f7778 100644
--- a/drivers/iommu/intel/iommu.h
+++ b/drivers/iommu/intel/iommu.h
@@ -724,6 +724,7 @@ struct intel_iommu {
 	/* mutex to protect domain_ida */
 	struct mutex	did_lock;
 	struct ida	domain_ida; /* domain id allocator */
+	unsigned long	max_domain_id;
 	unsigned long	*copied_tables; /* bitmap of copied tables */
 	spinlock_t	lock; /* protect context, domain ids */
 	struct root_entry *root_entry; /* virtual address */
-- 
2.53.0



