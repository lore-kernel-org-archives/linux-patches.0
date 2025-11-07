Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93D8026ED59;
	Fri,  7 Nov 2025 10:13:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762510396; cv=none; b=rl8wkyiqUknkrs5Y3nNjd7eDZYBL+Ub/UN/iU0lyIbR/6AJKMOhrx2IlPRtURURcxThhIOgRWqt8J6WnkovmmDGzNOwbX2CUB+qtJxoArFyEUATZkrkftp3lgwoRHt3DQbRQb/lo0NuReT0aTDLKahezADjBoP75ry7LTmrCWhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762510396; c=relaxed/simple;
	bh=vLz/CdZhy4yPzvcG3fbR2UjsnU7P4O7qwXunThdZQJ8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MCtijj3eapv7AYFv1KM1RMAGPIT5kQ4tTsdQoVd+vmFxGAeywErvhvp6zhKS0lJC0ZZGWibo2MCc37J2vgH6zQCOE5hK9RtA+wZvX3E8XZDSfWAIW9vtZ1E9aGsErjzAVZtkml+SstdtTIkrM4cP0cz1ELlaHw/3lztvUOuBJBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=Fin9RFL2; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="Fin9RFL2"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 3AC505AB91;
	Fri,  7 Nov 2025 11:13:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1762510391;
	bh=vLz/CdZhy4yPzvcG3fbR2UjsnU7P4O7qwXunThdZQJ8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fin9RFL20Z9paI9GOD7nUNYhJnlVwA/S9m6W5zUdd5PfM7RfAdK4ATSNBeB+wTCXG
	 gyCBqlElO7dHOgLDQ6VT/yLNXWmXrOh/AWi4YAnJxJNwNPTOlnhID91kJBhAYvPRHj
	 a4vsbUlclffCMhWVGY9cMdIh16Xjmjkbns1/ji4po0NnHmzYMXbNkZuKN00S1AVaXn
	 Ck0ThSdvyPM7n+8g09hBj6+dGtaJEtNfKomH7YIYE3xT3e2THCObCHlkZdDDZxbsN4
	 h+aWjlqiiLxfn0nhQLyuqlcigIaQfcv0Du9k3KlVWCPQSSWfyekbfh2bULpE5u5a4Z
	 mLqxcfBEHayuQ==
Date: Fri, 7 Nov 2025 11:13:10 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev, 
	linux-doc@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Kevin Tian <kevin.tian@intel.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	patches@lists.linux.dev, Randy Dunlap <rdunlap@infradead.org>, 
	Samiullah Khawaja <skhawaja@google.com>, Vasant Hegde <vasant.hegde@amd.com>
Subject: Re: [PATCH] iommupt: Documentation fixes
Message-ID: <ydduatsgexjutnhm4wexmwbnl2x72p6346edy3dc5c4ctpl5am@r3d3kbbff7ji>
References: <0-v1-e93135a62eee+1e4d-iommupt_docs_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-e93135a62eee+1e4d-iommupt_docs_jgg@nvidia.com>

On Thu, Nov 06, 2025 at 03:02:14PM -0400, Jason Gunthorpe wrote:
> Some adjustments pointed out by Randy:
> 
>  "decodes an full 64-bit" -> "decodes the full 64 bit"
> 
>  Correct the function parameter name for iova_to_phys()
> 
>  Use the recommended section heading style.
> 
> Suggested-by: Randy Dunlap <rdunlap@infradead.org>
> Fixes: 2c8b644f3901 ("genpt: Add Documentation/ files")
> Fixes: ac7ffd8e805c ("iommupt: Add the AMD IOMMU v1 page table format")
> Fixes: e530a2c3a098 ("iommupt: Add iova_to_phys op")

Grm, had to fix up these commit-ids. Please be more careful next time.

> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  Documentation/driver-api/generic_pt.rst | 11 +++--------
>  drivers/iommu/generic_pt/Kconfig        |  2 +-
>  drivers/iommu/generic_pt/iommu_pt.h     |  2 +-
>  3 files changed, 5 insertions(+), 10 deletions(-)

Nevertheless applied, thanks.
