Received: from mail-dy1-f202.google.com (mail-dy1-f202.google.com [74.125.82.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C12F1FE4
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 21:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776200800; cv=none; b=sax9h1e9X1geKSmdHBbnAurTBxEEi3fY7zbq2JRweWbPkp4cJxWIwEnI038KGfZvKa+8J2ELEH54GN8t1vgQO1e2NwITvNc+9sVFyzXrrSoOEwXOMnIPvU1CLV5/hcL2NdJRtbW2F91XK3UTdMinCDvH2807VZae0DgrZXvSZXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776200800; c=relaxed/simple;
	bh=LsvN4Iwj4LpN4c4Tw/gYuHJNYBRDPuQyJDiYk349by4=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=Q9i7uX9wF8ww9Q4EwA8jBbLR0bZ/ZLkjDbEET5097Cwc+KlxznyzrjXcFVKf+h05PYDcCglEbTkrKYsnJ5hIykOtUU5sgrRic6nNn2SISpxzQub5DNEB2kNXrUtoDlnSqyXrJArfHDLZUO6yqWhID0J06KOk+0IENnrvclxUt7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wSHx2Wzj; arc=none smtp.client-ip=74.125.82.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wSHx2Wzj"
Received: by mail-dy1-f202.google.com with SMTP id 5a478bee46e88-2dd1c74508cso2813707eec.0
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 14:06:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776200798; x=1776805598; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=sIiB47+xae8QQS2k1R5QxVK+78ZtZ1GfH0fOqq7eBOY=;
        b=wSHx2Wzjcc4O7l7h4o1bTDbaha3d5tPl+bXZo3OZDN4wd+CcLZfrNE076QfFFNS5w/
         CDyGYWyYMOz5BGXDFFx2OFEp8OQJMTbFW8np13VSCrEkjfwtSOIQoTnl/f/wakRVukjY
         TYFiPe27QmPV/1SdpnK6SsxyTQJL3HldldN+50/7CHRqDeW5F9y+T67oRpgcjS4I5rd5
         PJa47iMChWI2QJhmJg1TMgjYkhoANkbUk1vHubM/LE2ghXy/jtJhiJO3Qrs/D14Z0Lp/
         Su2CWy5EALQhlrXxHtYtdxcFvTfoosBaLUqvuseH4psEP4LcNwd6oZKdtHE4rPMgN1IB
         lcuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776200798; x=1776805598;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sIiB47+xae8QQS2k1R5QxVK+78ZtZ1GfH0fOqq7eBOY=;
        b=oXQafSSmmUG9r4Bqkh62Ul5GIhkL0jMH9Zd54fAlj+kc/jtRuWUgsUKi9R+ouFmvZz
         lEv/UsYR0eXajxgpQ3JqlbhcRn6l+waWDihvwyiQJj+A1spRJz9Db91/S3+enZs7A1DH
         n/R55t2v5PYXbm2mC2RWU7CKRcQ6FqHUP4C+YXjQKxXNZdu0KIZrZ3a7vZVGct8iZu2K
         P/Svn2CPnsCLeiUHgafjTObQ33/doVd405SCqc2yadRufjKjU1Uk57cT57YGbd/e/vhD
         Pa5DkIpCeIQoKtTgHOWlTMHaYPrSc7oy3bRJj7lEc/BhnbCFVKUrkZ4o+uqMBB6ZcKIY
         VbHQ==
X-Forwarded-Encrypted: i=1; AFNElJ/ZdY1ndrB7v4EcCMpYjX7Nqu19nA3zKBWHGV/HjRpD+jni948ekpszBmQD/6SgRFPiiCpg/whd@lists.linux.dev
X-Gm-Message-State: AOJu0YxAmM/CoWgtFIcCws5kB8MQclDMsjJ3P1dCtE6z4SG2ha78SdVO
	LcWU7Pmt7S3/+/OLJgaKHvwc/icjKLPQtYwAQEAtS0t7qgvUC0N8VUesGkhzwZfrzUQE7xX38+s
	NwA==
X-Received: from dycnm7.prod.google.com ([2002:a05:7300:d187:b0:2d8:fc66:cd7b])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7301:5787:b0:2da:10f0:a8df
 with SMTP id 5a478bee46e88-2da10f0b2e4mr4603827eec.12.1776200797666; Tue, 14
 Apr 2026 14:06:37 -0700 (PDT)
Date: Tue, 14 Apr 2026 21:06:26 +0000
In-Reply-To: <20260414210626.2097722-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260414210626.2097722-1-wnliu@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260414210626.2097722-2-wnliu@google.com>
Subject: [PATCH v1 1/1] iommu/amd: Don't split flush for amd_iommu_domain_flush_all()
From: Weinan Liu <wnliu@google.com>
To: iommu@lists.linux.dev, jgg@nvidia.com
Cc: joro@8bytes.org, patches@lists.linux.dev, robin.murphy@arm.com, 
	suravee.suthikulpanit@amd.com, wei.w.wang@hotmail.com, will@kernel.org, 
	kpsingh@kernel.org, josef@toxicpanda.com, Weinan Liu <wnliu@google.com>
Content-Type: text/plain; charset="UTF-8"

We have observed multiple full invalidations occurring during device
detach when we are done using the vfio-device.

blocked_domain_attach_device()
  -> detach_device()
    -> amd_iommu_domain_flush_all()
      -> amd_iommu_domain_flush_pages(..., CMD_INV_IOMMU_ALL_PAGES_ADDRESS)

      	while (size != 0) {

          -> __domain_flush_pages( flush_size /* power of 2 flush_size */)
            -> domain_flush_pages_v1()
              -> build_inv_iommu_pages()
                -> build_inv_address()

         }

build_inv_address() will trigger a full invalidation  if the chunk
size > (1 << 51). Consequently, the guest will issue multiple full
invalidations for a single call to  amd_iommu_domain_flush_all()

Without this patch, we will see 10 time instead of 1 time full
invalidations for every amd_iommu_domain_flush_all().

Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")

Suggested-by: Josef Bacik <josef@toxicpanda.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
---
 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 760d5f4623b5..bcec8721d228 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1769,7 +1769,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size == CMD_INV_IOMMU_ALL_PAGES_ADDRESS) {
 		__domain_flush_pages(domain, address, size);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
-- 
2.54.0.rc0.605.g598a273b03-goog

