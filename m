Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017546;
	b=o0C9qlPJIT3JtxVnC3reM3i81AuV9RRMKQCW2zzMqMPdWnoBw4QpOZAc8EAY3yorIQtl
	 fBjLqEn0M+kPS2rOQUKOpz62lLSERn1TBOoSBLUyU96witLQPYv/fKSzX4+BcH6YjNkZc
	 Sh2/UXvFLHXiSDwgPysX+hOMGaG490tx/UFw0MtcGwVLvaknQtiUofDq9aSahmDlTsH2Y
	 7YCTQ4ZOdUbDWLv8y/GNJU8jzsvVYR+DoLZpXEU01Bi5tcGOXpRpRZakHBxIbRcv/oBpx
	 KZ7De2IA4fiYZDhoxeAPFXgehM/txzdz6rqzRjHWK4hxk7TOnevrQR7Zx+zs26/LcLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017546;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GslCUcr5PXZNz0iawDtGfM0/D3VyS9mV2I3PHodeNSg=;
	b=hMlFZj7F1dk4EU3TIgb3ZYv92nJIOgB3eqFN/6N+SgqMN4EDT+xphPaIipBdhappR6Sz
	 BNdRMCWHb0LCmbQuu7WC7wjbKfwLS+InmalBhKI7ENpHyB3tU/cyP7TUgfAHDc4KbFQih
	 +aAhgYEv0xLMT1RPRmHFfwLdZvqrsK7F5fbQnBDur10fk15qsWwQSjx+86EA1Kxq2EVwf
	 /dQcc6JCMtYKLo7b4/Xx1Rnw2FvCXCDOp7L0EYpq2sAX+dQgyEAQXRza4XjVQcSXQSrR/
	 Uo6CrZ1B9IDT1bN4S3aKfV4/4VO8tJW9xB8eTqxQ/0FsFidSUnrlItIM2N0uNZftKNA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiqRRgXF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2A7C606A31C;
	Wed, 18 Nov 2026 15:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KiqRRgXF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DD141F000C6;
	Wed, 18 Nov 2026 15:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017546;
	bh=GslCUcr5PXZNz0iawDtGfM0/D3VyS9mV2I3PHodeNSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KiqRRgXFwCe2bhUu5Kxs0vZ99qRYoBMgspQZM3UIA1m9Dvj2ScZYDcMH0fZBxX3SU
	 ecpZGwqqRB0GC8v4bZRH/h7Oh0VO0x71I3uUdMcTrnI+Kxsxqbnkwhhc1oaXBSRyCj
	 R7BoAn/LQGIw/w+xuHE6zv+loRwh5B1w96tPrvZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0924/2651] iommu/vt-d: Do not ignore context table copy failures
Date: Wed, 18 Nov 2026 15:36:04 +0100
Message-ID: <20261118150321.153707576@linuxfoundation.org>
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

[ Upstream commit 53e15f28829ff304f94883e8f3f1f5074aa2a0a2 ]

copy_translation_tables() currently logs copy_context_table() failures
but still returns success, so partial copy failures are silently ignored.

That means Intel IOMMU may run with only part of the old tables copied.
Then some old domain IDs may not be reserved, and later may be reused by
new domains. With stale hardware cache entries still around, this can
cause bad DMA translations, DMA faults, or domain aliasing.

Fix by aborting on the first context-table copy failure, freeing temporary
context-table pages, and returning an error so caller falls back to a
clean root table path.

Fixes: f93b4ac5929a ("iommu/vt-d: Use ida to manage domain id")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 05f351833d0b5..bf8b3e3edf3b6 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -1591,7 +1591,7 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 		if (ret) {
 			pr_err("%s: Failed to copy context table for bus %d\n",
 				iommu->name, bus);
-			continue;
+			goto err_free_ctxt_tbls;
 		}
 	}
 
@@ -1623,11 +1623,27 @@ static int copy_translation_tables(struct intel_iommu *iommu)
 	memunmap(old_rt);
 	return 0;
 
+err_free_ctxt_tbls:
+	/*
+	 * None of these tables have been linked into iommu->root_entry yet,
+	 * so they are unreachable and must be freed here.
+	 */
+	for (bus = 0; bus < ctxt_table_entries; bus++)
+		iommu_free_pages(ctxt_tbls[bus]);
+	kfree(ctxt_tbls);
 out_unmap:
 	memunmap(old_rt);
 err_free_bitmap:
 	bitmap_free(iommu->copied_tables);
 	iommu->copied_tables = NULL;
+
+	/*
+	 * Only reservations taken from the old context entries can be in the
+	 * ida at this point; no domain has been allocated on this IOMMU yet.
+	 * ida_destroy() empties it and leaves it ready for reuse.
+	 */
+	ida_destroy(&iommu->domain_ida);
+
 	return ret;
 }
 
-- 
2.53.0



