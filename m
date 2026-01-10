Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4FD9521771C;
	Sat, 10 Jan 2026 09:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.214.250.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768038100; cv=none; b=rPE5dCLkYvIdLbWCm15V2eGw+bNzazjTGYnHj38ef+xfawH2DGrvh3m+yBc3ECprcklcOjwjudhwW97X0ntrKaxXt7R3utYNY4MFtwHE/c57N74BToJtPCOjFYSS3mfKCweZabg2BRBp4dcK9u+cmORNux4TLSomuLiU5QtFYBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768038100; c=relaxed/simple;
	bh=97kj6NbcSZ1ah8oiUcYBe/jHNxkUWJmjCNuc8ugXpls=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YhHSFaefodQyrZvnvfWs9Bf7VPSfG97HLYtyVajW2FYeDN7sHeb7iBVqdX3D/4c/ac/0c6T5yrKYo/W+tiG+Y6TFOlvVKBoRD7W4c/+hb0E7ScvdCgE9m8Jo03Veb0hRz88/NJfer2zuvZ9wVh03Awkwu7JDGOxAfvyhaJhKP0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org; spf=pass smtp.mailfrom=8bytes.org; dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b=I+o4nKf1; arc=none smtp.client-ip=85.214.250.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=8bytes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=8bytes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=8bytes.org header.i=@8bytes.org header.b="I+o4nKf1"
Received: from 8bytes.org (p200300f6af1d9600dfc71246d978d903.dip0.t-ipconnect.de [IPv6:2003:f6:af1d:9600:dfc7:1246:d978:d903])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 4689C5EC7D;
	Sat, 10 Jan 2026 10:41:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768038098;
	bh=97kj6NbcSZ1ah8oiUcYBe/jHNxkUWJmjCNuc8ugXpls=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I+o4nKf1r3sWe0TyTDSCcZ6HbBDYt7UfQ9t2oBeSIIUPldVfxmbw6m13b36Legv2s
	 PgNOpdsaNyEO4FieUMYOqhph8uEG0udMHRjUVurB5DvqqQ5RDwC4tRqAFuXpJmBpSc
	 BCNIKR/bdYy2ldkkheTA8KSzTcRmSA6E1sXZaDnceynRF8C+OURHchAmQpqnx0QWih
	 pzQHbm8+yfunBksD03aoGrT+L6gmAmIvhoPR8ssG8bOsIeOVv4gzf1w0w3YfPFIk6+
	 7ZNw2hZIeKxbRRd4lmAo7HyOVS9902NSpTnr2i/srSjP6SP8teyQZtzdg4EBEG0R31
	 EGDimyqQHNDew==
Date: Sat, 10 Jan 2026 10:41:37 +0100
From: Joerg Roedel <joro@8bytes.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Alejandro Jimenez <alejandro.j.jimenez@oracle.com>, 
	Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert+renesas@glider.be>, 
	Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>, 
	kernel test robot <lkp@intel.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev, Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH rc 0/3] Fix some kconfig related issues with iommu pt
Message-ID: <b35etzxdizrzegxfyyzxxd62zbuzo5rdjph6fdb5c6nmdqxjsz@mqv3uxdw7x7s>
References: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v1-946859fdf97e+1bc-iommupt_kconfig_jgg@nvidia.com>

On Tue, Jan 06, 2026 at 03:22:09PM -0400, Jason Gunthorpe wrote:
> Two issues found while checking the kunit against rc4, and one from some
> build bots.
> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Jason Gunthorpe (3):
>   iommupt: Fix the kunit building
>   iommufd/selftest: Add missing kconfig for DMA_SHARED_BUFFER
>   iommufd/selftest: Prevent module/builtin conflicts in kconfig

Applied for -rc, thanks.
