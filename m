Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15667150992;
	Fri, 10 May 2024 11:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715339245; cv=none; b=NrwktFTSQs1o5Ega8DErYPoBu3f5cEDrcEQ8Na1VlXfE837kmZ/sFGkT/EH9+mV84zeQTEL3kuNZOMUPBZVmnRcVZdgWpHUQNPHc1S+xAVuTrsezvBbQbwhDgrqqiCFD5/N1A+GWdxxyHEnmGKZjmoXwsJZ/3pqVndsk4ZQIPmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715339245; c=relaxed/simple;
	bh=Ti4R1feDOgYewiCguC3R+x2Cxr1vVdSX5lyv685gJr8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ok6Oe15uwJJze5zsR1qPXie8PNmdAcyRr912N5w5+wq26qkuvFJeN58AxreE6UfgsyWHB+HFVA4ML+EesfbqIw/nNubgAG1i8VwZCjVFXSIVOqVLX7TqWyfB1SDc1joAFuWmWN7+24iS7e5bZg/5NywVW0b2Nj4W0qY8TLrH4A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gJ7uoR8m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gJ7uoR8m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14705C113CC;
	Fri, 10 May 2024 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715339244;
	bh=Ti4R1feDOgYewiCguC3R+x2Cxr1vVdSX5lyv685gJr8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gJ7uoR8mCfEvC6X4zrZuZDgeoBZJBE6PUOZ/zztUqnQJ65qQSgJ/b23hpXOFa9BcI
	 dpFGQmDohh2TpDeng33MP2FNtw8sgDBCR+4MAOeQzRsUlYvKIFrMQkTz0RUoZpnMQ9
	 uJ4r9PcQAiaLmF/S/SkbGTHRhiDEJwYBhClb6Ui86zLES4OyGInZZkav6f4O3ukPie
	 vP6Fd2z/79LsuS77bhNyEAHP3q/bI7lmyjzh3PDL85QwwVkSwh+qYuDhhGealCxKdJ
	 zYA8/T+xIDPkoZZeW+EoX2kKe/bXvylWpARM8hGhnImnmAtvfbB0dJRq2DjhAT1EQz
	 FVQ23dhU1BJKQ==
Date: Fri, 10 May 2024 12:07:18 +0100
From: Will Deacon <will@kernel.org>
To: Joerg Roedel <joro@8bytes.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@gmail.com>,
	Krishna Reddy <vdumpa@nvidia.com>,
	Jerry Snitselaar <jsnitsel@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH rc] iommu/arm-smmu: Use the correct type in
 nvidia_smmu_context_fault()
Message-ID: <20240510110718.GB25675@willie-the-truck>
References: <0-v1-24ce064de41f+4ac-nvidia_smmu_fault_jgg@nvidia.com>
 <Zj3IoFN5SmCI9rjg@8bytes.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zj3IoFN5SmCI9rjg@8bytes.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Fri, May 10, 2024 at 09:11:28AM +0200, Joerg Roedel wrote:
> On Thu, May 09, 2024 at 02:45:51PM -0300, Jason Gunthorpe wrote:
> >  drivers/iommu/arm/arm-smmu/arm-smmu-nvidia.c | 4 +---
> >  1 file changed, 1 insertion(+), 3 deletions(-)
> 
> Applied, thanks.

Cheers, Joerg. I just acked the kunit test build fix over at:

https://lore.kernel.org/r/0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com

so you can grab that one as well.

Will
