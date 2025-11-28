Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 948EF272E51;
	Fri, 28 Nov 2025 07:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764316114; cv=none; b=eA3BiYGmyPBRH+N2fL4hNBhcY92neTh5NWOg2ZCulhgVTU65rnxR3wKfABPn0i1CETTQ6mXQLwfDNljk9GpVVhSxU2ATRi7mkLhPrmUxBLRH+zDnkbFVfwxADdfJ4bcVgympTqQblXO6ISOA2AC1P80x3d+unGoSZAnbP/Utvpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764316114; c=relaxed/simple;
	bh=WU8GRXCH+cTmIKuvWs+WdALBqqiLJHS7leE0isADJqU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n4EcIutVUYc581EldxmgUFgQEo1CcGy0FF4lQH5SF3cBrOgpyKs2jsSBO7iXUsCt1NETolraJvJOz+KqRwubcqHKsqESpylVVjxVMOq+PiLCBu6pM/ZdrqV+gjdXQzA9jgT4D/EPB1w823kQL61j5L/Y8nj8O6kSfYzWnduRNqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=DGI1dLxp; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="DGI1dLxp"
Received: from 8bytes.org (p549214ac.dip0.t-ipconnect.de [84.146.20.172])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 272835C786;
	Fri, 28 Nov 2025 08:48:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1764316111;
	bh=WU8GRXCH+cTmIKuvWs+WdALBqqiLJHS7leE0isADJqU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DGI1dLxpeZxNBrefTLhNZLAazT+nNO0/N1jM2b8wpynRS4Q1r23JfMnbBUZ/3rPGN
	 aOnVTrwu9eslfrsMbvxoorSbuKrzSvQ8LVQtQ7C4tMb4Bh2FvRyWlcCv1B7okkkumS
	 k3b+LUafl4VxjReqny76xa2erCZTcg7enH4bFB/IazOhhai7rgHL3fMpJNxD8m3OFG
	 R4UP+VNvi+9avJlankQKoF3isEMVWJyPEgDi1RVtAOKI7NYlllsAghdGtH6xPx0jnw
	 uF8B1glI1PPexzYByTAbuv/GZ6SQMDkvzKAb0UwSjbfaNGuOvTHjgdwWMqhQcn+I6y
	 Z5pd1HkOC1goA==
Date: Fri, 28 Nov 2025 08:48:30 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Woodhouse <dwmw2@infradead.org>, iommu@lists.linux.dev, 
	Robin Murphy <robin.murphy@arm.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>, 
	Calvin Owens <calvin@wbinvd.org>, Chaitanya Kumar Borah <chaitanya.kumar.borah@intel.com>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev, 
	Tina Zhang <tina.zhang@intel.com>
Subject: Re: [PATCH 0/2] Fix VT-d when the IOVA limit is small
Message-ID: <6sjloezxl5e5owo4ym6u6vf225fp2izmgsrnloowap37ugj3y2@nnza6myja6cq>
References: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-ae5d7f0f2620+13b-vtd_mgaw_jgg@nvidia.com>

On Thu, Nov 27, 2025 at 07:54:06PM -0400, Jason Gunthorpe wrote:
> Jason Gunthorpe (2):
>   iommupt/vtd: Allow VT-d to have a larger table top than the vasz
>     requires
>   iommupt/vtd: Support mgaw's less than a 4 level walk for first stage
> 
>  drivers/iommu/amd/iommu.c             |  7 +++-
>  drivers/iommu/generic_pt/fmt/vtdss.h  | 19 +++------
>  drivers/iommu/generic_pt/fmt/x86_64.h | 17 ++++----
>  drivers/iommu/generic_pt/iommu_pt.h   | 14 +++++++
>  drivers/iommu/intel/iommu.c           | 58 +++++++++++++++++----------
>  include/linux/generic_pt/iommu.h      |  4 ++
>  6 files changed, 73 insertions(+), 46 deletions(-)

Applied, thanks.
