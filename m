Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2DD942040A7;
	Thu, 12 Jun 2025 07:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749712736; cv=none; b=Zx2OLTb6xD+PnfY9dmv5udH0yiPmvw4KyLpl/aRZAEPAT77J0YxYJLn+vSsGmqMtWZKaqO7uuxDFAVlTVLo8HHPQ8/Z2soBpv4O4+7Us2JtR+Fo46x/FBj7A/Z9HStiSlG9BERMLasYRUncC3TVDHWs1zuYNbwmsH6IrE9QCj2Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749712736; c=relaxed/simple;
	bh=4qmZkNTOIJv0nI5aWiP+W1evef8vZNmuy8w6U8kXd+k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N2UobpV55B3zZxM7hvptNlOyQkqYIJ+rVNDoKl24Hf7nQUp9fSdPfSoUB1sVED4tpWSCRDcHYvjVHSgaZ7eIf0T/t1HpOMTAoAuN5yvwri8HBx50dL4LQzjFBZeOA6/IXXfHIriedZHSu4V7r4650M03YMh9+q8xBZX4BBw7dF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=ylprocBo; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="ylprocBo"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 297384D5B8;
	Thu, 12 Jun 2025 09:18:47 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1749712727;
	bh=4qmZkNTOIJv0nI5aWiP+W1evef8vZNmuy8w6U8kXd+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ylprocBot2TylMOuQkQ93WdxuWl0q9GES7/fL9w28zyTq1KLUI+JKWl0d4ht9kWMl
	 G0y5Ab5oe+ZtB/Yq/RnI3UKNy1jJ2AL1G6niPBZbua3wJs04RcPOd1LmBDkwDsLZRP
	 NTpb4935rnjG0BO0AAlVRSFChd16TNGyY8OjRPR2RSDcLIwzaadTh8YiEzdDuanyd+
	 3rQYC/YKUwGiQJMuJ0bVkV+EUf2EnLRS3UmeCAfwXLma02/85aXhjpbAHkzTxXevki
	 D58ILc80axa+osfNRogsPNIw6vVB6CoZQrHpKIsu3moyb9pbL+Jm8HPda7h4huDFfx
	 opssgkMkxKm7w==
Date: Thu, 12 Jun 2025 09:18:46 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Lu Baolu <baolu.lu@linux.intel.com>, 
	David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, patches@lists.linux.dev, Wei Wang <wei.w.wang@intel.com>
Subject: Re: [PATCH 0/7] Reorganize Intel VT-D to be ready for iommupt
Message-ID: <ohwlzwslfmcvqthbzv2hpbu2fk32ybfp4yt5czwl3lfocbmh4s@lxi52z3giikm>
References: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-20c73f153f4c+1895-vtd_prep_jgg@nvidia.com>

Hi Jason,

On Mon, Jun 09, 2025 at 04:58:19PM -0300, Jason Gunthorpe wrote:
> Jason Gunthorpe (7):
>   iommu/vtd: Lift the __pa to
>     domain_setup_first_level/intel_svm_set_dev_pasid()
>   iommu/vtd: Fold domain_exit() into intel_iommu_domain_free()
>   iommu/vtd: Do not wipe out the page table NID when devices detach
>   iommu/vtd: Split intel_iommu_domain_alloc_paging_flags()
>   iommu/vtd: Create unique domain ops for each stage
>   iommu/vtd: Split intel_iommu_enforce_cache_coherency()
>   iommu/vtd: Split paging_domain_compatible()

Nit: The correct prefix for VT-d patches is "iommu/vt-d".

Regards,

	Joerg
