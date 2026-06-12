Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A6D03DE43A;
	Fri, 12 Jun 2026 07:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781250527; cv=none; b=FddKqV83aiMSNr8g8O7NYsqWlX+Cp13m/3hDKpYg/SOqzWjLxxm7c9iPZGRFrlJ6/LQehlH4ot3VEwKKk5bDxSJIt9Ss/7SFEXW+QhU5kmWfx8aFl2pHrbh3/VPjnKbarln8gKs5htSqJSeFW8duWj3GRrAoXrPtqpTX9rnqCkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781250527; c=relaxed/simple;
	bh=sBdj3iO/PuOCjnBPjubMpJAlaxjVNJTZns2tNRnO8ag=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=k1M+YzVolAPGT+yoj2BD2/yX3NwLISyE1rLY/uwPNCmNTm5KrxUfD85m9RzR4JzZEVLLi1tcyNOs2P3xSxe9Xte0Ca78kns4BWFFwvYOsV9eN4QrHGnvU3VAY4lP+bvJVa//GqBFjS6jVPREvVFCad0bzvkuIHx2w+T+LxiZlXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p4ffe1d30.dip0.t-ipconnect.de [79.254.29.48])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 903B41C74F4;
	Fri, 12 Jun 2026 09:48:39 +0200 (CEST)
Date: Fri, 12 Jun 2026 09:48:38 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Srivastava, Dheeraj Kumar" <dhsrivas@amd.com>, iommu@lists.linux.dev, 
	Robin Murphy <robin.murphy@arm.com>, Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>, 
	Will Deacon <will@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH 0/5] Improve the invalidation path in AMD
Message-ID: <aiu0kMeaSNIUKwJH@8bytes.org>
References: <0-v1-a7b77c25974e+115bf-iommupt_inv_amd_jgg@nvidia.com>
 <83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com>
 <20260611115611.GE1066031@ziepe.ca>
 <airU7xpucwkZMAo7@8bytes.org>
 <20260611163317.GA1453429@ziepe.ca>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260611163317.GA1453429@ziepe.ca>

On Thu, Jun 11, 2026 at 01:33:17PM -0300, Jason Gunthorpe wrote:
> I understood he delegated this to Dheerja and this email from him is
> confirming the regression tests?
> 
> https://lore.kernel.org/all/83b8a0f3-2409-464d-a9e4-59b9eea926cd@amd.com/
> 
> Vasant reviewed it here:
> 
> https://lore.kernel.org/all/4cc8368d-3972-47c6-bd60-7fc8b9c7be3e@amd.com/

Alright, I applied it, but there were some conflicts due to

	69fe699afe1a iommu/amd: Don't split flush for amd_iommu_domain_flush_all()

in the amd/amd-vi branch. I think I resolved them, but can you please
double-check once the tree is pushed?

Thanks,

	Joerg

