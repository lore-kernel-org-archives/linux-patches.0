Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E27D32D3EEF;
	Fri, 27 Jun 2025 15:35:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751038504; cv=none; b=lTH1iNOEY9ZtW7Ltfy1pnZr/ukLNdaBw9L4JsM5T+QaxgJhIr8k46aJoH7NoDvzfHYw629ckUM4JsgMp453LzxjHHOPeWOUwnKMhET9dWqF74cR/FldW7skI5gW0Vy1pv3XsDwPSp8AFxzkL9uZiU8IRj6rR0+JPSCIA6sF/+w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751038504; c=relaxed/simple;
	bh=AcJS8zEIgvrM6xzr9e5LCAw5uvraDFnTURDqSsoCQFM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pUx8Ob7bUedJB4KOloobGFD6SU8Ix/j7KvX4PAV5Lpm2GvtZPV7oxEIyzqOPGByEII0JxIJO1T/CNOryCdDnRoFEzHC4P4oVvBCsAZ3kWseG8gsGQg3FeHzmI3KOJ6Qso+reL+N3w0eYMCUEy1XcH3pNLn+X9DCGncFV7msODL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=seiUzu0J; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="seiUzu0J"
Received: from 8bytes.org (p4ffe03ae.dip0.t-ipconnect.de [79.254.3.174])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 14CDF4EFDE;
	Fri, 27 Jun 2025 17:34:56 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1751038496;
	bh=AcJS8zEIgvrM6xzr9e5LCAw5uvraDFnTURDqSsoCQFM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=seiUzu0J5pF91dl7UmH+KL0pOHeL6IhLuTDNG5qV4eYBzeMpYjoOQxPYKAUdQ/zSB
	 p/1Q+kRTegEsF4EeKflXx2BbKlxe3TXbX7ID+4m86Xb4Z7LGOEMAG8U75pNF7TAcQY
	 zzDXOO9Iwd2oBTFQLoNOkxr8Z9vDf2h5wuLP7+XIZrsM6xDdLlME+3DnUhOYvJKmob
	 XlTz0nlSn3SlHfXEux0utyU+DxxUBtfbLI4uqipNciicL5w7xY0iQLqdgaOCfLhwZG
	 5lZv8qEaTnkoeyTRTUVK7MPftthtuCwLvBvGf4mgdD9EZc8gwQdYmEAuSlMIvEVBY7
	 n9Zm58rrh4sBg==
Date: Fri, 27 Jun 2025 17:34:54 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	patches@lists.linux.dev
Subject: Re: [PATCH] iommu/msm: Remove ops->pgsize_bitmap
Message-ID: <aF66Hifxw2FWOnP9@8bytes.org>
References: <0-v1-662aad101e51+45-iommu_rm_ops_pgsize_msm_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-662aad101e51+45-iommu_rm_ops_pgsize_msm_jgg@nvidia.com>

On Fri, Jun 27, 2025 at 10:02:10AM -0300, Jason Gunthorpe wrote:
> This driver just uses a constant, put it in domain_alloc_paging and use
> the domain's value instead of ops during finalise.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/msm_iommu.c | 7 +++----
>  1 file changed, 3 insertions(+), 4 deletions(-)

Applied, thanks.

Queued it right before "iommu: Remove ops->pgsize_bitmap" in the core
branch.
