Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD914253B8
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 18:47:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96476C433C8;
	Mon, 17 Jul 2023 18:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689619670;
	bh=U9KSDUaK48mxwIkUB9gVMtsU6bZcH8Z+BG0MJPZ2rzs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q2GATplUsdKR/SCrAK1GFa1PRADjhM2k1W9HnVkrNfMzOty/ikgGoR7iGLkBcRk1F
	 GC+8qkrXKAhd9WAS3JqiNCweUQ5WxXPMKFh9Y9eLeUBxogo2idsZGJW5uHVoksBImi
	 1Kj03naXGQb2yjUVEMIMEthOp+7IodN+BXEvLso4=
Date: Mon, 17 Jul 2023 20:47:47 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/591] 6.1.39-rc1 review
Message-ID: <2023071722-churn-yoyo-1d08@gregkh>
References: <20230716194923.861634455@linuxfoundation.org>
 <CAEUSe7-XjSvLKxFuHbKUrJBWAmgKRg5oZRppnDYn1CuoWCUURw@mail.gmail.com>
 <0b2e2708-b658-1640-1ebd-4c84c3552714@roeck-us.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0b2e2708-b658-1640-1ebd-4c84c3552714@roeck-us.net>

On Sun, Jul 16, 2023 at 05:01:55PM -0700, Guenter Roeck wrote:
> On 7/16/23 16:40, Daniel Díaz wrote:
> > Hello!
> > 
> > On Sun, 16 Jul 2023 at 14:31, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 6.1.39 release.
> > > There are 591 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Tue, 18 Jul 2023 19:48:07 +0000.
> > > Anything received after that time might be too late.
> > > 
> [ ... ]
> > We're seeing build failures on i386 and x86 with Clang:
> > -----8<-----
> > /builds/linux/block/blk-cgroup.c:1238:6: error: variable 'ret' is used
> > uninitialized whenever 'if' condition is true
> > [-Werror,-Wsometimes-uninitialized]
> >          if (init_blkcg_llists(blkcg))
> >              ^~~~~~~~~~~~~~~~~~~~~~~~
> > /builds/linux/block/blk-cgroup.c:1288:9: note: uninitialized use occurs here
> >          return ret;
> >                 ^~~
> > /builds/linux/block/blk-cgroup.c:1238:2: note: remove the 'if' if its
> > condition is always false
> >          if (init_blkcg_llists(blkcg))
> >          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > /builds/linux/block/blk-cgroup.c:1223:33: note: initialize the
> > variable 'ret' to silence this warning
> >          struct cgroup_subsys_state *ret;
> >                                         ^
> >                                          = NULL
> > 1 error generated.
> > ----->8-----
> > 
> > More info to follow soon.
> > 
> 
> Caused by 3b8cc6298724 ("blk-cgroup: Optimize blkcg_rstat_flush()")
> which is missing its prerequisite b5a9adcbd5dc ("blk-cgroup: Return
> -ENOMEM directly in blkcg_css_alloc() error path"). With three Fixup:
> patches following, it is one of those patches where I wonder if it
> is worth the trouble.

Yeah, I'm going to just drop this mess for now, thanks.  If the block
developers think it is worth adding, let's get them to submit the
working backports :)

greg k-h
