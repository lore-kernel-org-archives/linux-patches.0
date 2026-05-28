Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DCA930F535
	for <patches@lists.linux.dev>; Thu, 28 May 2026 22:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780007520; cv=none; b=QuZtwgtk1iS09UbafzVu+GWgQkjR8ewfY1ilUnzkSJFEzYXhom3tViHXKoR5OHUgpaH0ByFUW5XNqQBeOcR0R+dY3UW4VJUy6UT9Zp1LKueojDIqhqHpxnZtj8wx67Oq3E/fq2Qxut6ZsgB6tXV/SKCj0yhPZr93EdqXuLMt8Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780007520; c=relaxed/simple;
	bh=0yNCf/FZmVdH7OxyVcTRK0azQYedr/GytLYxP6I0HHc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=nctOrS8Zd5ypCqBivWhKVNIKRP+zAB6GbxVNb9VwOZhg1Bm80VTZ5sKGWo+OmwnA5NHoLvDjm72m+CpSxDF+MygVt6Hyy5XXU2umwEDN6sqp28Ep/UbArhDaWyXKEwzhIh6D03JMlh70XFHNgZMb4hFQ0qBHMLIZlmiQLbAVmqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TLO5hqXZ; arc=none smtp.client-ip=74.125.82.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--wnliu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TLO5hqXZ"
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-1353ac304f3so18955420c88.0
        for <patches@lists.linux.dev>; Thu, 28 May 2026 15:31:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780007518; x=1780612318; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qnJY90lzCZa7sp51vCdlrsdl5wBeEKPOKUYIM3PKwp4=;
        b=TLO5hqXZMOhX8IkoX46JJr+4LICoKKixCKjAb0bRCFkyjeQBJCuJydOuMFJpWdFF6f
         RBBOaVFQycO//lAd7Hr8El89AqKn2/h5zfqnV62JBFHVvRtbDtj0m+zMw7L7cpfnQR6y
         ZtGuSgbekoz6gEfC1JxXOuI6ySKgP1V+ZtR5l7DEnzb0iT9/vUbY2se3MI94R1+rc7nt
         KKA7XjfLjXwL6Ot5YBS8OBgoZ8MaoVeaL7T1BZtOTdOkJjkgQL8nelixPcfVnp//Gv4z
         fIdbLGYcQFaACTBxL2kAJKtPAoK7CQptNlNINxtPJ6GViVEMYrPDuumRUKUe//OAwb88
         OpuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780007518; x=1780612318;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qnJY90lzCZa7sp51vCdlrsdl5wBeEKPOKUYIM3PKwp4=;
        b=Rldg7z42x4sG0ahMLJu9mcm6KNrJcKJEuKfTQbH0a3cz9+1170neECeVQvfC2TZaRe
         idYpXujivPtNdgV97NRHIE/HBXjx9uHPjA7/X9hIO2Ljpa/nFTs15FtieFfYP5DAx99X
         yLnyTJDPG7FUqtgm+ndxo/f9yPuCMAkZMpXszg7y+7RkUf2L/pLa/vQQ1wYIl33PL3cw
         KskHSGkvBHqFH2pKeZxwuMTxYgBp3pzbFZAmV5lIXV6GN30RiDykS9zwrgzh+ZTMIko9
         LLtk106aKlHSPhAuchd3sBNVmcdeZOWC3Ha8AEbWvTbo1GbIUf4tZvvHGvJg+W0Bz32Y
         Lvaw==
X-Forwarded-Encrypted: i=1; AFNElJ9jl4+fyRHdTAplZOssE5ck7Qte/1G7S/+8sxUVEtYQePwS47Da1CnQ18+zssUrUh/QqTFhNIEi@lists.linux.dev
X-Gm-Message-State: AOJu0YzHRkwRfOaDqGGzQwr2xbm0o50J6a5BdZTNhCLLdMeejVef7Q5+
	MO82XU/dexy2I75l5ncPjqKkVLa5m5sTsjVJgO7SMeaGkBIGLRYUu+uY9XE+yL26l5UY4q+Mc6e
	V/g==
X-Received: from dlbrl13.prod.google.com ([2002:a05:7022:f50d:b0:136:f9e9:6d7a])
 (user=wnliu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:ebc5:b0:12c:856:ddcc
 with SMTP id a92af1059eb24-137aeff8d97mr118590c88.27.1780007518036; Thu, 28
 May 2026 15:31:58 -0700 (PDT)
Date: Thu, 28 May 2026 22:31:47 +0000
In-Reply-To: <20260528223147.750229-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <20260528223147.750229-1-wnliu@google.com>
X-Mailer: git-send-email 2.54.0.823.g6e5bcc1fc9-goog
Message-ID: <20260528223147.750229-2-wnliu@google.com>
Subject: [PATCH v2 1/1] iommu/amd: Don't split flush for amd_iommu_domain_flush_all()
From: Weinan Liu <wnliu@google.com>
To: iommu@lists.linux.dev, jgg@nvidia.com, joro@8bytes.org, 
	suravee.suthikulpanit@amd.com
Cc: will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	robin.murphy@arm.com, vasant.hegde@amd.com, santosh.shukla@amd.com, 
	chrisl@kernel.org, josef@toxicpanda.com, Weinan Liu <wnliu@google.com>, 
	Wei Wang <wei.w.wang@hotmail.com>, Samiullah Khawaja <skhawaja@google.com>
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

Cc: stable@vger.kernel.org
Fixes: a270be1b3fdf ("iommu/amd: Use only natural aligned flushes in a VM")
Suggested-by: Josef Bacik <josef@toxicpanda.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Weinan Liu <wnliu@google.com>
Reviewed-by: Wei Wang <wei.w.wang@hotmail.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>
---
 drivers/iommu/amd/iommu.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 57dc8fabc7d9..15ffc4742183 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -1774,7 +1774,8 @@ void amd_iommu_domain_flush_pages(struct protection_domain *domain,
 {
 	lockdep_assert_held(&domain->lock);
 
-	if (likely(!amd_iommu_np_cache)) {
+	if (likely(!amd_iommu_np_cache) ||
+		size >= (1ULL<<52)) {
 		__domain_flush_pages(domain, address, size);
 
 		/* Wait until IOMMU TLB and all device IOTLB flushes are complete */
-- 
2.54.0.823.g6e5bcc1fc9-goog

