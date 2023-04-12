Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A4F33CF
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 10:15:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A02BC433D2;
	Wed, 12 Apr 2023 10:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681294500;
	bh=kVx2uEmlSJqfV3P6U9Ka2hB3giTbEccoKs096eDcBQA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cEf7KmezeoBfgWysLaL1qNkB6cvGd9B6h+jLWyRBf20SLSQcoaMjacM2mRf4wDilZ
	 3y3Q9hbgGi/4XFj0DSEoZH2MYACOHYXOq1F/mcNSDXTtR2uVcxs070s1SIQW7VcGVZ
	 IueYsR9JBrReZSd7foigLesUcBRKylnFP3t1fHjU=
Date: Wed, 12 Apr 2023 12:14:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Greentime Hu <greentime.hu@sifive.com>,
	Zong Li <zong.li@sifive.com>, Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 01/93] soc: sifive: ccache: Rename SiFive L2 cache
 to Composable cache.
Message-ID: <2023041232-luster-stream-e477@gregkh>
References: <20230412082823.045155996@linuxfoundation.org>
 <20230412082823.103777810@linuxfoundation.org>
 <20230412-mustang-machine-e9fccdb6b81c@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412-mustang-machine-e9fccdb6b81c@wendy>

On Wed, Apr 12, 2023 at 10:36:45AM +0100, Conor Dooley wrote:
> On Wed, Apr 12, 2023 at 10:33:02AM +0200, Greg Kroah-Hartman wrote:
> > From: Greentime Hu <greentime.hu@sifive.com>
> > 
> > [ Upstream commit ca120a79cf5a3323172c82e77efd70ae10d120ef ]
> > 
> > Since composable cache may be L3 cache if there is a L2 cache, we should
> > use its original name composable cache to prevent confusion.
> > 
> > There are some new lines were generated due to adding the compatible
> > "sifive,ccache0" into ID table and indent requirement.
> > 
> > The sifive L2 has been renamed to sifive CCACHE, EDAC driver needs to
> > apply the change as well.
> > 
> > Signed-off-by: Greentime Hu <greentime.hu@sifive.com>
> > Signed-off-by: Zong Li <zong.li@sifive.com>
> > Co-developed-by: Zong Li <zong.li@sifive.com>
> > Reviewed-by: Conor Dooley <conor.dooley@microchip.com>
> > Link: https://lore.kernel.org/r/20220913061817.22564-3-zong.li@sifive.com
> > Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> > Stable-dep-of: 73e770f08502 ("soc: sifive: ccache: fix missing iounmap() in error path in sifive_ccache_init()")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Did I just miss AUTOSEL emails for this stuff?

No, there was none as it was pulled in as a dependancy.

> NAK. This seems waay too invasive to me, and changing the Kconfig symbol
> for the driver in stable kernels sounds like a bit of a nasty surprise?
> 
> The two actual fixes that this is a dep of should be backported
> individually, please drop patches 1-7 (inclusive) & I'll give you less
> invasive backports for 6 & 7.

Ok, I'll drop all 7 now, thanks.

greg k-h
