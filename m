Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26A2A3EE1EE;
	Tue,  9 Jun 2026 08:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780994195; cv=none; b=OadrrfSZJSlvsU8QNDuWkG7jSYN95m0m4BEQvcSXAug0TuL4yn+HzrWsDRuW7886q1IuHvwSGJtyOeXNDyaC9Ro2TIwqDyr9dPSi+570Jld6zE9YCEnqVFc6yysml0h2xluJFIuZNzalLaGSuYDE7GKdCFw/UDjo2aIXH+UdO8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780994195; c=relaxed/simple;
	bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=p6oSzWvfAJWJ1WDN0Ryi83U2qPoivTHSimL+74r2HNMqXDBKuGvNCEhTw9RAreccGXwiNTEP/CyVbN1nLXm5GP+URIIf6Jd8pFDx1ElM0d6u/sBTzf3bHXHh8W8ZKEbteYQvlv2ZyarSemQArwJC3aN3iHF9rlw1o799U8TE7H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 0265A68B05; Tue,  9 Jun 2026 10:36:27 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:36:27 +0200
From: Christoph Hellwig <hch@lst.de>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Leon Romanovsky <leonro@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Luis Chamberlain <mcgrof@kernel.org>, Mark Lord <mlord@pobox.com>,
	patches@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH rc] iommu/dma: Do not try to iommu_map a 0 length
 region in swiotlb
Message-ID: <20260609083627.GB11664@lst.de>
References: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-8536728bc89f+469-swiotlb_warn_jgg@nvidia.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

