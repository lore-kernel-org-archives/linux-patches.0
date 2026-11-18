Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017549;
	b=OZnYitFlY6N9tCCWrXfmKhRo7OC2C9fucV+xy1i+6lc82aN+Ec0gbTncMuBrzo6JDYqh
	 kN7Ti3ZU3bErAs9YNiNwfldA/Uz1XDIqmzM1fEuUoMby6AUOEaVfMBVnufcfFU9QWqw2Y
	 NwWgibQ/Mizmla+OmE5EKU72+rYiWCIEwmgXm7p/6Gl1pvClrmuvmOheVs9d515L08bsr
	 T88bL76+1YQWdW8b9NINQmtU3Q6iQH6jAZwhKEUFS3K/yIZNjW21yUZGwaoBh658i7VhW
	 CXfXuQ80sarIAxvp9FO6XGO0vMlYr7chbMvUqC4EAxckfFt6I3z/8rIUhy629zTq5AQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017549;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=143mpbJkI8kjBmSRMGU22aqMfj8u3cRz7/PWZ0sGR1Y=;
	b=CyWabajDgx0841OkMNOprNmemOiZ3UvuLE4kzhAh+2DQtCrT0rdlbPJ+Po5xqKECTIh2
	 0ZZlPRN3uxCbsdEzntm4dTDkUOD5SflwV+EzE1cqcfFF0CxRuDuC10hONzobtMRkWQXlY
	 IyZi11XRILNKFDz7KoZNUBuseRkOFSrzAblP3h4GGGUJyjo1D93hRPPHsKrVfPVHINDGm
	 kOBaEqT6nj6Fsap61Uhox+FXS5rWWg+IVfoWBoTkWljHi0glMD9KvNLxBvP2jVYZvwdOh
	 rtPuDU0fPID5+t8rExFiHWQXjJTjt4Y/xsx5L0k/V6TT7EBey4nOSsoRlXgLTMkCofQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeGIfh7w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE95606A31C;
	Wed, 18 Nov 2026 15:59:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zeGIfh7w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 050481F000C6;
	Wed, 18 Nov 2026 15:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017549;
	bh=143mpbJkI8kjBmSRMGU22aqMfj8u3cRz7/PWZ0sGR1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zeGIfh7wRV7UM/lTN1If/Tv+fa9a8CXxf8ESvG9Dc9Z0oTCa78MDhusJ9w7gSsJ0e
	 hkgGvwrS+BHVmswGMEGp5Vg+KlTHVUujJkrrTykeMDIrBWVfvA5jg1a4eSzMvKX/cM
	 +Xv3nxZZUQuskasKo1pGrpQBvTyuerBF5cXTTlyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0925/2651] iommu/vt-d: Handle DID reservation errors when copying context tables
Date: Wed, 18 Nov 2026 15:36:05 +0100
Message-ID: <20261118150321.188521548@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 12a2ea2d91bea9b1f8f0a6608433210d0abd1291 ]

When kdump reuses old translation tables, all old domain IDs (DIDs) must
be reserved in the new kernel before new domains are created. Today
copy_context_table() ignores ida_alloc_range() return values, so a real
-ENOMEM can be missed and an ID may stay unreserved.

That can allow DID reuse while stale hardware cache entries still exist,
risking domain aliasing.

Fix this by moving DID reservation into a helper that:

- treats duplicate reservations (-ENOSPC) as expected success,
- skips out-of-range IDs as success,
- propagates real allocation failures (like -ENOMEM), and
- normalize successful return values.

On failure, unwind as in existing copy-allocation failure paths.

Fixes: f93b4ac5929a ("iommu/vt-d: Use ida to manage domain id")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 39 +++++++++++++++++++++++++++++++++----
 1 file changed, 35 insertions(+), 4 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index bf8b3e3edf3b6..85400d0ab3340 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1452,12 +1452,39 @@ static void intel_iommu_init_qi(struct intel_iommu *iommu)
 	}
 }
 
+/*
+ * Reserve a domain ID inherited from the previous kernel so that it is not
+ * handed out again while the copied translation structures are still live.
+ *
+ * Returns 0 when the ID is reserved, was already reserved, or cannot be
+ * re-assigned, and a negative errno for a genuine allocation failure.
+ */
+static int reserve_domain_id(struct intel_iommu *iommu, int did)
+{
+	int ret;
+
+	if (did < 0 || did >= iommu->max_domain_id)
+		return 0;
+
+	ret = ida_alloc_range(&iommu->domain_ida, did, did, GFP_KERNEL);
+	/*
+	 * Devices sharing a domain share its ID, so the same ID is seen in
+	 * more than one context entry; -ENOSPC merely reports that it is
+	 * already reserved.  On success the allocated ID is returned, which
+	 * is not an error either.
+	 */
+	if (ret == -ENOSPC || ret >= 0)
+		return 0;
+
+	return ret;
+}
+
 static int copy_context_table(struct intel_iommu *iommu,
 			      struct root_entry *old_re,
 			      struct context_entry **tbl,
 			      int bus, bool ext)
 {
-	int tbl_idx, tbl_slot = 0, idx, devfn, ret = 0, did;
+	int tbl_idx, tbl_slot = 0, idx, devfn, ret = 0;
 	struct context_entry *new_ce = NULL, ce;
 	struct context_entry *old_ce = NULL;
 	struct root_entry re;
@@ -1520,9 +1547,13 @@ static int copy_context_table(struct intel_iommu *iommu,
 		if (!context_present(&ce))
 			continue;
 
-		did = context_domain_id(&ce);
-		if (did >= 0 && did < iommu->max_domain_id)
-			ida_alloc_range(&iommu->domain_ida, did, did, GFP_KERNEL);
+		ret = reserve_domain_id(iommu, context_domain_id(&ce));
+		if (ret) {
+			/* Not yet published through @tbl, so free it here. */
+			iommu_free_pages(new_ce);
+			new_ce = NULL;
+			goto out_unmap;
+		}
 
 		set_context_copied(iommu, bus, devfn);
 		new_ce[idx] = ce;
-- 
2.53.0



