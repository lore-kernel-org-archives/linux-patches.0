Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C48233D6D;
	Fri,  8 Nov 2024 17:54:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731088479; cv=none; b=OZSOdfbcjTUDKNC64wZ6wE/9B3d5ZWQA9sd6JM1wXmaQFYOgdNjIsvQKzCki0izUIVMm6LPvNfkQEUKWWdlURbcVyc6hhhDjAImF0Akn2HmV/O6QDXonVhqdZLk0Z+AWi1j2gqrtqMEKyorOBfa/OmVZqSgOE17JCwJGq0hg2EA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731088479; c=relaxed/simple;
	bh=Axl69qmAssizNl3JTCniHz4UH/x8jmb6A/wTmCshcWw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n/RFe5U2L5F4PzCnVSDHp09GC4oBGIlihIEXgBk/z7ziu11tTnpoA2igWSUNOLvZElOA0/TL8AwhDum9pdUU6rGvtBUghPpib0nobnPAIpuWJURCZJECqhGUitRh8+rkACWSy/CZuyynhpipObEnb1bSoP/VWyzOiV4ubjWUdtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lOy736lT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lOy736lT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E420EC4CECD;
	Fri,  8 Nov 2024 17:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731088479;
	bh=Axl69qmAssizNl3JTCniHz4UH/x8jmb6A/wTmCshcWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOy736lTkA3Zr+ce/znloYgzLks9CMUne3zuF0CoI5znnYWCxRG0vQfQ4xbYcBLEk
	 ZAlAnJwYn079ePB0uv8ux6yJgszAiW0Tqtyw/4KU80x/IgO3v3Lk6z6ACKal0tLW1X
	 yw9Zx0QWZl8549I2g//bcP/1qruTOeZttEDt2ZHvkwApqhXPXESMaCd5Urh8kvVzYV
	 OHMP/IYLXXtE4dbFiA3q7MRUAf3hUtQ+pKRQ0hNOGmMMLks82JeFWpQ/VS0KJChpjF
	 z9LNFTarqgXTXOD1VpcCxgLGZpyxh821HmdfScgk/3zkClMTHQbsYMtMBapRWc3ATG
	 JP/b3jYaL+qGg==
Date: Fri, 8 Nov 2024 10:54:37 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Thomas =?iso-8859-1?Q?Wei=DFschuh?= <thomas@weissschuh.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>,
	Nipun Gupta <nipun.gupta@amd.com>,
	Nikhil Agarwal <nikhil.agarwal@amd.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] cdx: Fix cdx_mmap_resource() after constifying attr in
 ->mmap()
Message-ID: <20241108175437.GD2564051@thelio-3990X>
References: <20241107-sysfs-const-mmap-fix-cdx-v1-1-2ed9b7cd5f8b@kernel.org>
 <f005d74e-7b35-42de-a80f-e5650e3d164d@weissschuh.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f005d74e-7b35-42de-a80f-e5650e3d164d@weissschuh.net>

On Fri, Nov 08, 2024 at 12:23:50PM -0500, Thomas Weißschuh wrote:
> Nov 7, 2024 12:07:56 Nathan Chancellor <nathan@kernel.org>:
> > Fixes: 94a20fb9af16 ("sysfs: treewide: constify attribute callback of bin_attribute::mmap()")
> 
> I'm not sure about the Fixes tag.
> cdx.c is not yet in mainline and this change should be folded into the cdx patch or the sysfs patch, depending on their order in the merge window.
> I guess Greg will take care of it.

This code is in mainline, so I think the Fixes tag is correct?

  $ git grep cdx_mmap_resource v6.12-rc1 drivers/cdx/cdx.c
  v6.12-rc1:drivers/cdx/cdx.c: * cdx_mmap_resource - map a CDX resource into user memory space
  v6.12-rc1:drivers/cdx/cdx.c:static int cdx_mmap_resource(struct file *fp, struct kobject *kobj,
  v6.12-rc1:drivers/cdx/cdx.c:        res_attr->mmap = cdx_mmap_resource;

The error is reproducible on driver-core-next since that is what I based
this change on.

Thanks for the review!

Cheers,
Nathan
