Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5669E336888;
	Fri, 15 May 2026 05:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778822999; cv=none; b=krRB+92kE7eN9kiqsFt5/K5bexzmMvlfp4CKTNhCogBeSYcGMkC3mTNTPmJld08H8SDespkYLyPq7/DvF1rqZboMUITAqw2Ze6LH/r5QG2sCkA0x5yJq0OD63erM6GhD/O2fjPWnidkrXXvLcMsVRKRl+JCcjLNLi/q3/2IKavk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778822999; c=relaxed/simple;
	bh=5QBKM7gsl9HnnVZ9ndHvviXb+hikBiR6z0o719FuAiM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qI7X6pC/jlBXc7+PjIdXjobMo4LFHCma6KVS5RPcGcZY8+OVaq4gTLrQBCwLyktj8s649BfXVNa3TUibCYrUSlWi596F8kWUgPRbHhlNRCrkr15w76h4OWtYps3hZhhy4m6Hvav3uYgX4cWManhpeZbWisHSQmPFp/1L8jNKyi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=5znACS2i; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="5znACS2i"
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 5EA371C3CD6;
	Fri, 15 May 2026 07:29:48 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1778822988;
	bh=5QBKM7gsl9HnnVZ9ndHvviXb+hikBiR6z0o719FuAiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=5znACS2iT2zYHYtRWAsoErcu4zenVdtJPmZyw4cQX0wFbLuZVMgCIL1yfZyOT+5RO
	 H8prQxV3Nl0rKFfoNQONUL2/LmX4grU/RXUW+TvpEU3uAGxRmA5nfA5sWqhGKBGS+e
	 Rv9ojbM46GPfwvpKHv1y+vDKUuoCg52EYjyrynWQI8qoC8b4aGVpkrXP2CUETP6GO0
	 klrUsVHRheSCU/2+eHkeYEsGbEp09sL5ZyTfPqSXkhxNHyxoxz3qA8Afp9o1vcb19l
	 2GdbYKwjMBGNBXalSk0lzy8472Rpn2DF4xbkJjW/Ll5pyHTWinV8Aqzee/ZdNNC9IG
	 rwK7V1ILsANpw==
Date: Fri, 15 May 2026 07:29:47 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Lu Baolu <baolu.lu@linux.intel.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Josua Mayer <josua@solid-run.com>, Kevin Tian <kevin.tian@intel.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, Pranjal Shrivastava <praan@google.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH rc 0/5] Fix some iommupt mistakes from Sashiko
Message-ID: <as2elpzwtlir6zqvgs2f3ahd4fmg4owdquldeiy4fufrxvp36q@yji7xglqxcjm>
References: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-44b2fef88b25+d3-iommupt_map_rc_jgg@nvidia.com>

On Tue, May 12, 2026 at 01:46:12PM -0300, Jason Gunthorpe wrote:
> Josua found there was an errant !ret, so I ran the original series through
> Sashiko, which found some other interesting things, a few miskates were
> made while rebasing across the iommu_debug_map() series, and a few other
> interesting remarks.
> 
> Jason Gunthorpe (5):
>   iommu: Fix loss of errno on map failure for classic ops
>   iommu: Fix up map/unmap debugging for iommupt domains
>   iommu: Handle unmap error when iommu_debug is enabled
>   iommupt: Check for missing PAGE_SIZE in the pgsize_bitmap
>   iommupt: Fix the end_index calculation in __map_range_leaf()
> 
>  drivers/iommu/generic_pt/iommu_pt.h | 24 +++++----
>  drivers/iommu/iommu.c               | 82 +++++++++++++----------------
>  2 files changed, 51 insertions(+), 55 deletions(-)

Applied, thanks Jason.
