Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024614;
	b=mVY9iO3Q/iQOrkmdNPoyLSyUXQyv3g7bXUee/Pqly3f/4qWWJefRx49hcgOXa9tN+Mzy
	 Xzx6O3c0L0Hy2XCF0uzf1OaeFUhqqf8iUc6a+1dVcDqURb1c04K7sjHs20sDUMB19P0CY
	 UDU4HrkxU5pN1sZhnxB5GtZcKg89rkErbhSEgRyLlTk3qem4s84ekMfY+3H2z9RUJzS5Q
	 tviTUab22CEfAQGYoRduW+5VqR9RbzHfIJsicOrgRr8CbeYQoCbgWpuzWwMHTd+kQvOzo
	 DhNfEwNCLEFSpasJer3O0+QklqknzcqMA9TfXtnvBehdaCQ1UTyb0+vEZ/syOs2lwNQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024614;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=47WtohhC0vvoljPkJaKL+ca6cLWxGSwh9uZTZvCYI74=;
	b=cpiLMMnrqA7cdOssYOJ2IVskJTlBDFlbS3iKewastqJXSj3uHRuZRrnteqyNB2aou35w
	 IMYKDZkW4R8B0Ka1DTrLcinu2+6WfWz5MnaTjQTrFUgTFKbR5STHiV9qUUGeeeG6KSl7g
	 Be4ZSg+fh4ChYxr5p0Dzg0kdIdE110uiGtuq/w6S1XiBKC9EDKUcfohqVY7pNhz7/UQPp
	 o1ai9kTtQZy8r7ynlOsOannTqesqZCo0hHCDO6CJ9gaZvutR/0018C2ySs4bZ+hOxuf7U
	 8Xj1ATPoCyzmuysKooqkJ/3OTm4BSxg6fcDfKw9TxghzC/89RnmjCcdsld5PHmjIuJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+XPBnB+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACDA606A31C;
	Wed, 18 Nov 2026 17:56:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b+XPBnB+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266721F000C4;
	Wed, 18 Nov 2026 17:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024614;
	bh=47WtohhC0vvoljPkJaKL+ca6cLWxGSwh9uZTZvCYI74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b+XPBnB+wjs7DCzc855I+zqnxOnrhSGSkKzOx8pPU2z86JKLKy1S6j0IKlKMIvMHO
	 +haM+AsyUaEWfciMUsKtwAY0iOi7rpIYeMUCJ3cIfJcNdK7mLwEh/wOh9pmegaiKHG
	 4OzOwhD5fnJMPwd4H+AJ4AYD5Xl+mIyTrUWijf1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0789/2151] iommu/vt-d: Handle DID reservation errors when copying context tables
Date: Wed, 18 Nov 2026 15:42:04 +0100
Message-ID: <20261118150150.844290816@linuxfoundation.org>
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
index b13fe38edf490..df3d28abcaeda 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1923,12 +1923,39 @@ static void intel_iommu_init_qi(struct intel_iommu *iommu)
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
@@ -1991,9 +2018,13 @@ static int copy_context_table(struct intel_iommu *iommu,
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



