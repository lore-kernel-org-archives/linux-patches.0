Received: from mail-dl1-f51.google.com (mail-dl1-f51.google.com [74.125.82.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18A304CA276
	for <patches@lists.linux.dev>; Wed, 13 May 2026 16:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778691403; cv=none; b=JVv/w4wGoGHDVyi02rIoQuiGYwumQ8TPjZ1OPbhLPQcqYCeN7CdtM+XrWL1UsnRxskfPXfyzKspLpA5lvtyJaVUV0aQMDN5K6fX0OkIsuhF9ilIumAMTtKQHdUmB2LbLALBc9ItxYAYhZEO2zWNnEpOL5UmyxhgC7O97kdzSy9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778691403; c=relaxed/simple;
	bh=Ut5l11CKVrSjVJL/SXBTdKTB+m65fhYWOTIJs46hZ4Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pQ9dXs3U8CVMo3aE3e5OP9oU9Zm9dtdInO1+Ecdvi/E9ingx1a/juGSIVf3VriYPV1Rxa4XWWAV3JZoRnnxDYdn8ZstNMy6FoH4We0U8OyCTEO1C9MOfhLQPytXYLldLYOu6ls5+YI+ZXhe/IWENF7v6yqgiD5I4P+VMnMlgFE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MSrErUg2; arc=none smtp.client-ip=74.125.82.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MSrErUg2"
Received: by mail-dl1-f51.google.com with SMTP id a92af1059eb24-133362c30cfso1486c88.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 09:56:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778691399; x=1779296199; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=X3lVfNFiffp+uU+9DlG1DEynuXNArzY2ybDWxR4v/kU=;
        b=MSrErUg2lm0x5R6LbBmZxeIk2ObTUA1rFQ1KrkXyaDPbxMyJ0vplGmwSPmgxfXORUp
         /Y5YtN1OVe4i1XqtGouL7+LrTed6lBxKsch+bTETjHrHzJQd9fzyImw8cOz2dOZT5GCt
         lGCTQn1qc6mtHlcHDlItIUng+3iK4peyjFbVXa2SgYuGIeOxLLzxAe0aaQn6rjcnKItx
         680I7NzEUsguOjfh41R9ZoOxBiCiKTl31qkUu2vifXVZiVc/enC9RdunPZa9QHWExLwz
         LASzCshSsmx/DP2rfYGyzRiBmTL2bx8zOrDFOCcz9E4ursL2iJgL/AyRkvYKGVwqKVvV
         ZvjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778691399; x=1779296199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X3lVfNFiffp+uU+9DlG1DEynuXNArzY2ybDWxR4v/kU=;
        b=SmnYGicZL6M4Iyg3KqeVuCxUxK/JYJLvOD0/JwrLJwW++vBND7/qDR778GaOsIfIJ2
         HksPEuA9+mBS+CsH5hPUOZe+c7uFyxwMfBh0MHnLWfQ2Y2Ai6MzetGAW4HgZBTiHau+c
         wHX5HYZQqSTiASfxabJJE7Gv7xhyfHuAYpLFKRkQZe9qF2dZzFrm+GntVmse67aNRdNy
         AVfi+QOPuvheosDmmfFj39QQNMynlvdyh38p26yxKZfJL4qHkFQwvRn02QP5OMo/P125
         5k3py9VVTkdbBY0UmLmNesjcv+n7smC9tfrj/clIQ2aomwP69hs3OVuYxjRF1ZiqiUGy
         6ywQ==
X-Forwarded-Encrypted: i=1; AFNElJ9vBxMBkn3JiejfvfiCaTgqzMikQjeYJO7s7uBvubNaCsyiy6lK2QwfgiK1/UY/GsDyauEaiY4n@lists.linux.dev
X-Gm-Message-State: AOJu0Yx8Deu4DcO/UHP0GBR67th6RrDaFl3Q5TFhYsIWFTo8tpWJSoA8
	jBg4jONPwyFEK8y7XbMlloPtBEYdi72Jr6OIdJKeVVeUa/bSzd8kDYwX2XisiJOmtQ==
X-Gm-Gg: Acq92OEmTsEjpAkYpxVSaIg9Y/lwNz2kzJYPi7l/h47jV6uc3tUtpN2o3sTb2qyeYDX
	a/1iRlv0QJ1lY72Ua9ufZmBBsqSnGblZzoPev1HweYloyvalzQ6LJsTjyidxn2VzO26FRCtLlNW
	9mkUWt1OXUvcR/QcKD9uLeHIyysazDhfJiTg6kErqKKep35IQRSrdQOXZFp/az16/uusqkFOYd3
	lNhFWgtKK4rXGgH061PHuVjK52y+Zwo7X05rrNfa9oalEva9TrMlnMbwsXw9O5Eao3awXVEiFR3
	VQojoizTld7du/gqgfqI3C87EovoNEVZXakD6B2EC04sjA4VH1x7AEIZCQT2jMC1PU2ygcveoG2
	7J/siobo9EoLgGhkvh0Gz+tHcNE8GDMa5LOM6fONpaRDwEKqq9T9m2R/f42fYTCOCWYwE0t4Fx1
	B8XZmtiINJmr6SbIVrWAlR1wiAP+/poo8hqDOwQDZ8hAmfiat6xHU9u3+4Z4+ZK1MUcGBrEw==
X-Received: by 2002:a05:7022:ef05:b0:12c:7ec:b96 with SMTP id a92af1059eb24-1347dbc6465mr209272c88.1.1778691397968;
        Wed, 13 May 2026 09:56:37 -0700 (PDT)
Received: from google.com (153.46.83.34.bc.googleusercontent.com. [34.83.46.153])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2f888c3b301sm29447066eec.23.2026.05.13.09.56.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 May 2026 09:56:37 -0700 (PDT)
Date: Wed, 13 May 2026 16:56:33 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Josua Mayer <josua@solid-run.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>, 
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 3/5] iommu: Handle unmap error when iommu_debug is
 enabled
Message-ID: <agSswSq8bTYiI6Uv@google.com>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
 <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:15PM -0300, Jason Gunthorpe wrote:
>Sashiko noticed a latent bug where the map error flow called iommu_unmap()
>which calls iommu_debug_unmap_begin()/iommu_debug_unmap_end() however
>since this is an error path the map flow never actually established the
>original iommu_debug_map() it will malfunction.
>
>Lift the unmap error handling into iommu_map_nosync() and reorder it so
>the trace_map()/iommu_debug_map() records the partial mapping and then
>immediately unmaps it. This avoid creating the unbalanced tracking and
>provides saner tracing instead of a unmap unmatched to any map.
>
>Fixes: ccc21213f013 ("iommu: Add calls for IOMMU_DEBUG_PAGEALLOC")
>Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>---
> drivers/iommu/iommu.c | 49 +++++++++++++++++--------------------------
> 1 file changed, 19 insertions(+), 30 deletions(-)
>
>diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
>index e334588a2476b4..e5fa9875900228 100644
>--- a/drivers/iommu/iommu.c
>+++ b/drivers/iommu/iommu.c
>@@ -2575,12 +2575,11 @@ static size_t iommu_pgsize(struct iommu_domain *domain, unsigned long iova,
>
> static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
> 				    unsigned long iova, phys_addr_t paddr,
>-				    size_t size, int prot, gfp_t gfp)
>+				    size_t size, int prot, gfp_t gfp,
>+				    size_t *mapped)
> {
> 	const struct iommu_domain_ops *ops = domain->ops;
>-	unsigned long orig_iova = iova;
> 	unsigned int min_pagesz;
>-	size_t orig_size = size;
> 	int ret = 0;
>
> 	if (WARN_ON(!ops->map_pages))
>@@ -2603,31 +2602,25 @@ static int __iommu_map_domain_pgtbl(struct iommu_domain *domain,
> 	pr_debug("map: iova 0x%lx pa %pa size 0x%zx\n", iova, &paddr, size);
>
> 	while (size) {
>-		size_t pgsize, count, mapped = 0;
>+		size_t pgsize, count, op_mapped = 0;
>
> 		pgsize = iommu_pgsize(domain, iova, paddr, size, &count);
>
> 		pr_debug("mapping: iova 0x%lx pa %pa pgsize 0x%zx count %zu\n",
> 			 iova, &paddr, pgsize, count);
> 		ret = ops->map_pages(domain, iova, paddr, pgsize, count, prot,
>-				     gfp, &mapped);
>+				     gfp, &op_mapped);
> 		/*
> 		 * Some pages may have been mapped, even if an error occurred,
> 		 * so we should account for those so they can be unmapped.
> 		 */
>-		size -= mapped;
>-
>+		*mapped += op_mapped;
> 		if (ret)
>-			break;
>+			return ret;
>
>-		iova += mapped;
>-		paddr += mapped;
>-	}
>-
>-	/* unroll mapping in case something went wrong */
>-	if (ret) {
>-		iommu_unmap(domain, orig_iova, orig_size - size);
>-		return ret;
>+		size -= op_mapped;
>+		iova += op_mapped;
>+		paddr += op_mapped;
> 	}
> 	return 0;
> }
>@@ -2645,6 +2638,7 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> 		phys_addr_t paddr, size_t size, int prot, gfp_t gfp)
> {
> 	struct pt_iommu *pt = iommupt_from_domain(domain);
>+	size_t mapped = 0;
> 	int ret;
>
> 	might_sleep_if(gfpflags_allow_blocking(gfp));
>@@ -2656,24 +2650,19 @@ int iommu_map_nosync(struct iommu_domain *domain, unsigned long iova,
> 				 __GFP_HIGHMEM))))
> 		return -EINVAL;
>
>-	if (pt) {
>-		size_t mapped = 0;
>-
>+	if (pt)
> 		ret = pt->ops->map_range(pt, iova, paddr, size, prot, gfp,
> 					 &mapped);
>-		if (ret) {
>-			iommu_unmap(domain, iova, mapped);
>-			return ret;
>-		}
>-	} else {
>+	else
> 		ret = __iommu_map_domain_pgtbl(domain, iova, paddr, size, prot,
>-					       gfp);
>-		if (ret)
>-			return ret;
>-	}
>+					       gfp, &mapped);
>
>-	trace_map(iova, paddr, size);
>-	iommu_debug_map(domain, paddr, size);
>+	trace_map(iova, paddr, mapped);
>+	iommu_debug_map(domain, paddr, mapped);
>+	if (ret) {
>+		iommu_unmap(domain, iova, mapped);
>+		return ret;
>+	}
> 	return 0;
> }
>
>-- 
>2.43.0
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
