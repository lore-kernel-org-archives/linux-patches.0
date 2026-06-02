Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D8FB33B975;
	Tue,  2 Jun 2026 08:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780390008; cv=none; b=PPsQgHCjbdtaq8RZSSUwYz/1bEQxetlZ3dyxUJWSJs28/oywcW8xWo8kLAN+6XPU0qsvJmNis5VxhKe4kCjNV7H05KbRNlqfjcEIbxXQsnOsliXdKTpGCzUY8Xf7eXdOFydT5Ml45cFL13KErvNmHi+g4IONcpXPValdz/xRxP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780390008; c=relaxed/simple;
	bh=cBOt05zGzbEU1xLn+LgzyMbXoyfoUi9iDiE7os8XVZA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PxQwgRuZrfd/hS8rBS4D/fty9Z2xSFEM0sV5KGki0MNhaNy1Cd3xOjA0ypGoCP70zrPC6Ty5E8Apmq8P3fB00huV2sCSO/lXqcw0rXWSZfqaslnpyL4elRr67p1Y1o5Jmm6vE5uQX/azEPEn15NEJwwl2Ib29ZZkU2SxgD2m244=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Received: from 8bytes.org (p200300f6af4fc500cd665649150e3ae5.dip0.t-ipconnect.de [IPv6:2003:f6:af4f:c500:cd66:5649:150e:3ae5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 8107B1C6BB3;
	Tue,  2 Jun 2026 10:46:46 +0200 (CEST)
Date: Tue, 2 Jun 2026 10:46:45 +0200
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Weinan Liu <wnliu@google.com>
Cc: iommu@lists.linux.dev, jgg@nvidia.com, suravee.suthikulpanit@amd.com, 
	will@kernel.org, patches@lists.linux.dev, stable@vger.kernel.org, 
	robin.murphy@arm.com, vasant.hegde@amd.com, santosh.shukla@amd.com, chrisl@kernel.org, 
	josef@toxicpanda.com
Subject: Re: [PATCH v2 0/1] Don't split flush for amd_iommu_domain_flush_all()
Message-ID: <ah6YY7OlNFCxVmOD@8bytes.org>
References: <20260528223147.750229-1-wnliu@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260528223147.750229-1-wnliu@google.com>

On Thu, May 28, 2026 at 10:31:46PM +0000, Weinan Liu wrote:
> Weinan Liu (1):
>   iommu/amd: Don't split flush for amd_iommu_domain_flush_all()
> 
>  drivers/iommu/amd/iommu.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Applied, thanks.
