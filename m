Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B93614A612;
	Thu,  9 May 2024 15:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715268208; cv=none; b=Sx1ewpIc6nREWWOu+xKP+zZx3tLnufQFEM8Roh9wuzkVM4kGG4C6pJcbneZWkNNJ0vtAoBbWVRV4ArTI++eV5eYnLB7JW8E7UBed9oqJTkSwQLI/a44KpLHwN+krVGzoKQi7GDVd+MN4PiLaGxYA+jPgsHa6btyHrCS02dj+vm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715268208; c=relaxed/simple;
	bh=XhQRq4Ns4VHWDwjnjvJd8t9wHZh7rXDyyHrWhOzYg+g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FCy0F1hMriK/W6I/jUhVO1RceUkk5KLZfskJ04l5ulx6+E3nxU2Oh9YWedrE3sfCoOKsM0oLH6ssS5URIM0DKGjN8XDmYIDbQQbj0ZdY8smQHub18OjV1Oufc7PL5IhI79TdRvHTX5aErUhHx4qBsL2Ukdost0Qo1OAODBO50M8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qEC9KgR8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qEC9KgR8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C295BC116B1;
	Thu,  9 May 2024 15:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715268207;
	bh=XhQRq4Ns4VHWDwjnjvJd8t9wHZh7rXDyyHrWhOzYg+g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qEC9KgR8PnkZ6cvWTvhxe99GtZcDTdSRROjT7u/Fnfibp6tH4LtPt3HTGMbTGHPcM
	 eg1K1cRiWsaWZbqN1VBhUlsyvQR1DTqZEhLYY/0pcN3lTY77IpUDVckzHcHRDxCHf5
	 Kqz2u+l+isPlflLq36UZiNo0RX4Cz6LipFn9HaBCYcsh9W7YdQM/apCwFDs3xqKNet
	 hdmnN5evWcLUMF88jeQgqUOroEthgHJ0LiWPMGZDSdWXcROJQXs0OZbHgq9/recdC8
	 WYrobhyVfqwrxcUN4XLrIlUEt+XoCjavu7UJznUPCo6fRb+aPfqxYBpSUY6XAr7314
	 HYeEpQUAw1Gsw==
Date: Thu, 9 May 2024 16:23:22 +0100
From: Will Deacon <will@kernel.org>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thorsten Leemhuis <linux@leemhuis.info>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	arnd@arndb.de
Subject: Re: [PATCH] iommu/arm-smmu-v3: Make the kunit into a module
Message-ID: <20240509152322.GA24667@willie-the-truck>
References: <0-v1-24cba6c0f404+2ae-smmu_kunit_module_jgg@nvidia.com>
 <20240507135817.GA22408@willie-the-truck>
 <20240507140946.GO3341011@nvidia.com>
 <20240507142248.GA22453@willie-the-truck>
 <20240507143321.GP3341011@nvidia.com>
 <20240508165333.GA23294@willie-the-truck>
 <20240508180423.GN4650@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240508180423.GN4650@nvidia.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, May 08, 2024 at 03:04:23PM -0300, Jason Gunthorpe wrote:
> On Wed, May 08, 2024 at 05:53:33PM +0100, Will Deacon wrote:
> > On Tue, May 07, 2024 at 11:33:21AM -0300, Jason Gunthorpe wrote:
> > > On Tue, May 07, 2024 at 03:22:48PM +0100, Will Deacon wrote:
> > > > On Tue, May 07, 2024 at 11:09:46AM -0300, Jason Gunthorpe wrote:
> > > > > On Tue, May 07, 2024 at 02:58:17PM +0100, Will Deacon wrote:
> > The DRM_XE one is tristate and has this interesting variant:
> > 
> > 	depends on ... && (m || (y && KUNIT=y))
> 
> Yeah, that is one of the novel ways to write the 'compatible
> modularity but not force enabled' check

Bah, and it looks like this has its own set of issues anyway:

https://lore.kernel.org/all/20240224121528.1972719-1-arnd@kernel.org/

> I suspect alot of these just predate the EXPORT_SYMBOL_IF_KUNIT
> infrastructure and should probably just be moved into
> modules.. modules clearly work better with kunit's ecosystem.

Fair enough. I'll suck it up given that this seems to be the new and
improved way of dealing with this problem. I'm just a bit paranoid about
exporting symbols (even within a namespace), probably thanks to my time
working on Android.

Will
