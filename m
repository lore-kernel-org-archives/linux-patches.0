Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1220518B48B;
	Wed,  6 Nov 2024 16:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730910176; cv=none; b=gKnohb87Q+6POTOaYKPnp8/Fk08tqZQCQO8T3uGAcVOhpDaTcoD/hEEj3FeHfe15pQTJ3VohGHFLLKVr1wLtHSI4CZomVgIZrqy3xxOdoa7aCFraWNf4WCCNzfP5boDAK3AyQmMYDQzvqAFMiOBCgISOivQaHGyVoxzotfE/ygQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730910176; c=relaxed/simple;
	bh=fko2d8Xv/YYA+GV+21EM8ZaKw6eqvgyyyHl4/3gL/Gc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=By9WZihtym/SZaJTgqNhCYvbh9RtUgZbu4b6p1u+QvJD0FiWfplA8wx8bzXIUD1VgMDCy1wwL4sN4D6/gFbjanWRGaN01HpXFWDdlQ1fq2ruU/mqUpQaJe+wMBw7e5M1Kjf1GsMMxK/iyp7UJi1VrN1/vYQKFMiyvFa55L4bzVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=vNCduIyL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="vNCduIyL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E12EC4CED5;
	Wed,  6 Nov 2024 16:22:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730910175;
	bh=fko2d8Xv/YYA+GV+21EM8ZaKw6eqvgyyyHl4/3gL/Gc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vNCduIyLgJ/+J00/AAxsHgY8tBhMN97vlbiNC2skrfGXhUHojPNpgznfYgpVGiCGv
	 8LM72hveI+/iUDqpsvHhCLWX8KT2YyUC0wiNlGIWe69Mb5+PJA4dKZqxkiPsL7L5ic
	 rmQVgoluQYSC1H++FEXNMXdjQNdI/xbEAec21SeHwkK448/T/fMptFOdAn0PRUV6qq
	 8WTKpjAqoARgTcPhp6m6eTgv1Hgn1h93WEReHGmvOU7O/w8PM2d5IKtqyP37KCFeDV
	 3aiqC55DjPNRJ2l3PFjCOPbfkpT1WgFohFWAqwaZS2LJUtxqDRTKrtk1o5Yh3ntO9V
	 Jx2Ohi2F0fPrw==
Date: Wed, 6 Nov 2024 16:22:50 +0000
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, catalin.marinas@arm.com,
	kernel-team@android.com,
	Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org, Liviu Dudau <liviu.dudau@arm.com>,
	patches@lists.linux.dev, Steven Price <steven.price@arm.com>
Subject: Re: [PATCH v3 0/3] Remove split on unmap behavior
Message-ID: <20241106162249.GA14615@willie-the-truck>
References: <0-v3-b3a5b5937f56+7bb-arm_no_split_jgg@nvidia.com>
 <173090505900.4167208.10850898110820689849.b4-ty@kernel.org>
 <20241106161520.GJ35848@ziepe.ca>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106161520.GJ35848@ziepe.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Nov 06, 2024 at 12:15:20PM -0400, Jason Gunthorpe wrote:
> On Wed, Nov 06, 2024 at 03:53:23PM +0000, Will Deacon wrote:
> > On Tue, 05 Nov 2024 14:14:23 -0400, Jason Gunthorpe wrote:
> > > This is the result of the discussion on removing split. We agreed that
> > > split is not required, and no application should ask for anything that
> > > would not unmap a full large IOPTE.
> > > 
> > > Instead of split the two ARM drivers will now WARN_ON and return 0. This
> > > is in contrast to what several other drivers do of removing the whole
> > > IOPTE and returning 0.
> > > 
> > > [...]
> > 
> > Applied to iommu (arm/smmu), thanks!
> > 
> > [1/3] iommu/io-pgtable-arm: Remove split on unmap behavior
> >       https://git.kernel.org/iommu/c/33729a5fc0ca
> > [2/3] iommu/io-pgtable-arm-v7s: Remove split on unmap behavior
> >       https://git.kernel.org/iommu/c/fd50651636fb
> > [3/3] iommu: Add a kdoc to iommu_unmap()
> >       https://git.kernel.org/iommu/c/6ac7dffe7cca
> 
> Thanks, can you add this hunk to fix the W=1 warning?
> 
> --- a/drivers/iommu/io-pgtable-arm-v7s.c
> +++ b/drivers/iommu/io-pgtable-arm-v7s.c
> @@ -820,7 +820,7 @@ static int __init arm_v7s_do_selftests(void)
>                 .pgsize_bitmap = SZ_4K | SZ_64K | SZ_1M | SZ_16M,
>         };
>         unsigned int iova, size;
> -       unsigned int i, loopnr = 0;
> +       unsigned int i;
>         size_t mapped;
>  
>         selftest_running = true;
> @@ -868,7 +868,6 @@ static int __init arm_v7s_do_selftests(void)
>                         return __FAIL(ops);
>  
>                 iova += SZ_16M;
> -               loopnr++;
>         }
>  
>         /* Full unmap */

I think I'd already folded that in, but please check!

Will
