Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA89F182BB;
	Fri, 10 May 2024 12:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715344037; cv=none; b=nTbCNeFIFO/pkyD4xRNqHsmJc6j9lMv1Y99NudfxEZDRAsRXwZ5/fJ4EfM7ueRMFlL2hyRHH0VWNc7BvqWM1x7bFkRYOWrpIudcvIS6oMjREDmqI/0EFKjqbu+wn7UnfmFtp7qY3DZT/j9bAYFYdSBWnk9+Crm+i2SJ8Fghgp4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715344037; c=relaxed/simple;
	bh=XHvQE8Fhd76ZcXM9wZZ079yJloGJnu9F4wLgxaL3Apk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=H7XTQuYQdyUSLrepxnurmRVwbJHYTaNV4j8lfMMO0V1JYsIEZ3OYUec/W/nKuWEKTKhRq/azsMMnhuJc84/9neX574fnJygr9DfUPnNdeHSYkc0MNdm+/drUw5Wm2yUufcmJcmQX4UXnCAEObS7UNc1zbslHidH+SFMeygPFHD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=gGw5FV9X; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="gGw5FV9X"
Received: from 8bytes.org (p4ffe0bdf.dip0.t-ipconnect.de [79.254.11.223])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 5F9351C2843;
	Fri, 10 May 2024 14:27:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1715344033;
	bh=XHvQE8Fhd76ZcXM9wZZ079yJloGJnu9F4wLgxaL3Apk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gGw5FV9XSIQB3sCF3fdb3lWG7FCtAFcfH10LmUozJhtEZWPLnwx8aMmM/gxQ9TT3U
	 NuddAytjz+jhehgNlxrUqYsFNwkiqieBcY3D4SyCaKrqcdgRfddkTK767I8JLYpWv2
	 xODhE6rjUxBO36hNGNhEg/LmOnwxc255rF3uf2rlyEl984ctXxI3VYF9v1s0x0qPgK
	 cGhSFXlWFZ1vep5u9WStp+5DS9OWcUWmrLVbWBNggb8mjZoICgoVZTnQK4ABZ4+8Cf
	 tQO7UbEWjhxcOqVHxjbSbB0dH31TrAFJFBjSwsq0m01+x7aMdDsF8lgpbFvVbkLNxX
	 FFGLpUTxhf6hA==
Date: Fri, 10 May 2024 14:27:12 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Will Deacon <will@kernel.org>
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <Zj4SoIzDLra2rXTq@8bytes.org>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>

On Tue, May 07, 2024 at 10:21:10AM -0300, Jason Gunthorpe wrote:
>  drivers/iommu/Kconfig                            | 2 +-
>  drivers/iommu/arm/arm-smmu-v3/Makefile           | 3 ++-
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-sva.c  | 1 +
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c | 3 +++
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c      | 8 ++++++++
>  5 files changed, 15 insertions(+), 2 deletions(-)
> 
> Joerg, can you pick this to solve the linux-next issue for Thorsten?

Applied, thanks.
