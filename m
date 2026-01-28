Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C651A207A32;
	Wed, 28 Jan 2026 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769609689; cv=none; b=PoNMvpxAxB+omLAUudxJvlasJ/zAgg9bYwENToZFzu/djpB6Q6iHKHspgRreb/iHn8BbCY2KYEBCs37eTYuEnRLMAPAcYD9WslZtecWxGtnaS+vmtdP8T1531yZ7LAfT8NOuH7QXyIlfaK1tdwpcOgD3Q+oSGXVJE0ivZIyct4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769609689; c=relaxed/simple;
	bh=+2MqYXm55ZNxYj0lms2m+cR0rcBORP8r8Baw39QWR6M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QLrEAhzKuw5jPkcCuSg59HOVsIjElLK13orgzAGU4+bOJ0F7euGdCkiy4NvNbwY4nUYAPZXaUTaU68P4rIoYadCLjnfrwzvqrGPSAZ/FtludAn6DnFb/ykUDSR8+dfyyCf6+fR+sLfL1D9L6Sa7fCfmF04x3GMAUrRTxtoRPKjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=teR+dy6P; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="teR+dy6P"
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 5AD911C0959;
	Wed, 28 Jan 2026 15:14:46 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1769609686;
	bh=+2MqYXm55ZNxYj0lms2m+cR0rcBORP8r8Baw39QWR6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=teR+dy6PXty/9b4m9hVEKeOEv9qfekMciICkCoXja/RvVqzUs0K55PuOizO3r8Wme
	 +5wtN1ZQeVVg3XfgvT+ZYleH1OOaZqP35sz39r2w4AFIjSmhzqcVXHUPeIHznytrkC
	 ywGUGto9maOYag0hokCu7IxCVRs/I3OMGWJ2R68kqnXtbwsw3VE//STDf55FLDSeEY
	 fS6hz5o2cprZTxerDRdFD6ANWK5e2AXzFC+BhwqH36Jx9an48DeZB3qBlsgm129vzP
	 ezZE7FFiK4EOws7In5qpEqgHLarDsjTNP0/GlNckNdkhdWfaaiDn03f9Xfw7KzIDak
	 n/RtnctUBwf6g==
Date: Wed, 28 Jan 2026 15:14:45 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Matthew Brost <matthew.brost@intel.com>, 
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>, 
	Francois Dugast <francois.dugast@intel.com>, Joerg Roedel <joerg.roedel@amd.com>, 
	Kevin Tian <kevin.tian@intel.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommupt: Only cache flush memory changed by unmap
Message-ID: <cwpjyumxpavy24ljo5nlxddo4gozzztnwzrxcm5jkotwn34wg6@a4u7f7emsoph>
References: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-21ee371752fc+4c-iommupt_unmap_cflush_jgg@nvidia.com>

On Sat, Jan 24, 2026 at 05:00:21PM -0400, Jason Gunthorpe wrote:
>  drivers/iommu/generic_pt/iommu_pt.h | 11 ++++++++++-
>  1 file changed, 10 insertions(+), 1 deletion(-)

Applied, thanks.
