Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CF9331A54D;
	Tue,  9 Sep 2025 10:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757413745; cv=none; b=AIEhmnHAkoUQu6+CHwzOXGjbdKhgM2wTXIp1HryWtomrrEvCpVAxI14pP0NxTzrlhbd5nqwd0EtwQGouK5Soan6h4Sg49e0JZoh7Q16JLjMDVPWYnHSAQt0NWDsohVuq5a59tX1Xm9qinMx4OpARlxJHtbL7C4Pl7A7/FmNk1So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757413745; c=relaxed/simple;
	bh=l7zRj6dxQGgcSZ09GbWzOqSTRBdDhbfjkwyl+rjpuPA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a5FUzh9/LEjG0TEXb4lpxcx/0XiB0Q0gf9LaX6oV5dSkgf9xpVZRqqAoPrYK3pqV41DI0b/nDBggQWnAmhk3fv68wO5Ed2EO4toeyE03u/fhz0hJax+Jugu5InczEmAtTrTFl+DR790TAwf0YViti6zzUBfi4+v61LwxAPW2Rdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XewCZgb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XewCZgb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48ABDC4CEF5;
	Tue,  9 Sep 2025 10:29:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757413744;
	bh=l7zRj6dxQGgcSZ09GbWzOqSTRBdDhbfjkwyl+rjpuPA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XewCZgb2uGHdj2F4vnjSiyFbBfcXl31BQomkh+xyO765+je1/KyEIDnRqmIgZ0DIK
	 ZyG7yQb/mQRX+J0H1xHFj3lJjwHZ77vvqvsfcxMC8DvgyzhcYgP1ArJBIFDfwTmDqq
	 qACO3YG6tKuM+IqGnkkY4WYzigdZUQLra0zGV0Rg=
Date: Tue, 9 Sep 2025 12:29:01 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, Anders Roxell <anders.roxell@linaro.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Ben Copeland <benjamin.copeland@linaro.org>
Subject: Re: [PATCH 5.15 00/64] 5.15.192-rc1 review
Message-ID: <2025090948-excuse-rebate-e496@gregkh>
References: <20250907195603.394640159@linuxfoundation.org>
 <CA+G9fYvQw_pdKz73GRytQas+ysZzRRu7u3dRHMcOhutvcE4rHA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvQw_pdKz73GRytQas+ysZzRRu7u3dRHMcOhutvcE4rHA@mail.gmail.com>

On Mon, Sep 08, 2025 at 11:54:56PM +0530, Naresh Kamboju wrote:
> On Mon, 8 Sept 2025 at 01:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.192 release.
> > There are 64 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> While building Linux stable-rc 5.15.192-rc1 the arm64 allyesconfig
> builds failed.
> 
> * arm64, build
>   - gcc-12-allyesconfig
> 
> Regression Analysis:
> - New regression? yes
> - Reproducibility? yes
> 
> Build regression: stable-rc 5.15.192-rc1 arm64 allyesconfig
> qede_main.c:199:35: error: initialization of void from incompatible
> pointer
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ### build log
> drivers/net/ethernet/qlogic/qede/qede_main.c:199:35: error:
> initialization of 'void (*)(void *, u16,  u16)' {aka 'void (*)(void *,
> short unsigned int,  short unsigned int)'} from incompatible pointer
> type 'void (*)(void *, void *, u8)' {aka 'void (*)(void *, void *,
> unsigned char)'} [-Werror=incompatible-pointer-types]
>   199 |                 .arfs_filter_op = qede_arfs_filter_op,
>       |                                   ^~~~~~~~~~~~~~~~~~~
> 
> This was reported on the Linux next-20250428 tag,
> https://lore.kernel.org/all/CA+G9fYs+7-Jut2PM1Z8fXOkBaBuGt0WwTUvU=4cu2O8iQdwUYw@mail.gmail.com/

Odd, I can't reproduce this here, and nothing has changed in this driver
at all for this -rc cycle.  I see no one responded to the linux-next
issue either, so any hints?

Also, the definition seems wrong from what you built, here it is with
the -rc patch applied:

	$ git grep arfs_filter_op
	drivers/net/ethernet/qlogic/qed/qed_l2.c:       op->arfs_filter_op(dev, cookie, fw_return_code);
	drivers/net/ethernet/qlogic/qede/qede.h:void qede_arfs_filter_op(void *dev, void *filter, u8 fw_rc);
	drivers/net/ethernet/qlogic/qede/qede_filter.c:void qede_arfs_filter_op(void *dev, void *filter, u8 fw_rc)
	drivers/net/ethernet/qlogic/qede/qede_main.c:           .arfs_filter_op = qede_arfs_filter_op,
	include/linux/qed/qed_if.h:     void (*arfs_filter_op)(void *dev, void *fltr, u8 fw_rc);

No u16 stuff at all here.

thanks,

greg k-h
