Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13099274B35;
	Tue,  9 Sep 2025 14:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757428647; cv=none; b=lnC2RxtKeUb4zfmjTzDY+JmrrHMr0OEYThRRIUtBPwRlgx5AfFhyA4enNEWSRhETgvFQCYwrgPdI93NU1OxBCGkbZIY4V3tGQ4qipFhro5JpAiY3i5Rfs1RV8Czn5v6DMOspZU1ZxCcNBA/uciTsmVK/E5xTnuoKWnikCXwkGaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757428647; c=relaxed/simple;
	bh=9B6l+1qvNym9F+Q7hWtNrLfb/xmJyDUu2VsCTOQjYKg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rjztbF4fXa8gO+HWIH7UDjtotT4ZT+OyA/C96gGKSKFnZ04BKfqSs2hNh5mrXTgV0a/SF4PFpWKZQA/LolBikE3NLWgrRnCElhEe7Zf8PRHVjVsaecGBl5GMwLrOMe3hJjiKBoIKwQHRRJp+wqZdaGtXcnyOrVSwyRmsakyJdXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ssV9vF/B; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ssV9vF/B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9237EC4CEF8;
	Tue,  9 Sep 2025 14:37:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757428646;
	bh=9B6l+1qvNym9F+Q7hWtNrLfb/xmJyDUu2VsCTOQjYKg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssV9vF/BGnSH78pTP1v0/PKZEau8qbV7tDq8XjNEIdU7rSA/FyiOteSSx1GaOMy5f
	 MKNSFznYslNyMp2TYcyWE8WcMj/JEb5mTY/xGOxc+x1jiANMzF3eTHIBh1I1mmqLYV
	 /NsJpdtcZVs1suvxRbSudOkfRrBeunS94d93Y2Hg=
Date: Tue, 9 Sep 2025 16:37:22 +0200
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
Message-ID: <2025090937-neglector-embattled-75ec@gregkh>
References: <20250907195603.394640159@linuxfoundation.org>
 <CA+G9fYvQw_pdKz73GRytQas+ysZzRRu7u3dRHMcOhutvcE4rHA@mail.gmail.com>
 <2025090948-excuse-rebate-e496@gregkh>
 <CA+G9fYvXsG1veoK-i93J2BgymNauvOU_FpO6d7BhUBnMkuZVCA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvXsG1veoK-i93J2BgymNauvOU_FpO6d7BhUBnMkuZVCA@mail.gmail.com>

On Tue, Sep 09, 2025 at 07:48:18PM +0530, Naresh Kamboju wrote:
> On Tue, 9 Sept 2025 at 15:59, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Mon, Sep 08, 2025 at 11:54:56PM +0530, Naresh Kamboju wrote:
> > > On Mon, 8 Sept 2025 at 01:43, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 5.15.192 release.
> > > > There are 64 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.192-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > While building Linux stable-rc 5.15.192-rc1 the arm64 allyesconfig
> > > builds failed.
> > >
> > > * arm64, build
> > >   - gcc-12-allyesconfig
> > >
> > > Regression Analysis:
> > > - New regression? yes
> > > - Reproducibility? yes
> > >
> > > Build regression: stable-rc 5.15.192-rc1 arm64 allyesconfig
> > > qede_main.c:199:35: error: initialization of void from incompatible
> > > pointer
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > ### build log
> > > drivers/net/ethernet/qlogic/qede/qede_main.c:199:35: error:
> > > initialization of 'void (*)(void *, u16,  u16)' {aka 'void (*)(void *,
> > > short unsigned int,  short unsigned int)'} from incompatible pointer
> > > type 'void (*)(void *, void *, u8)' {aka 'void (*)(void *, void *,
> > > unsigned char)'} [-Werror=incompatible-pointer-types]
> > >   199 |                 .arfs_filter_op = qede_arfs_filter_op,
> > >       |                                   ^~~~~~~~~~~~~~~~~~~
> > >
> > > This was reported on the Linux next-20250428 tag,
> > > https://lore.kernel.org/all/CA+G9fYs+7-Jut2PM1Z8fXOkBaBuGt0WwTUvU=4cu2O8iQdwUYw@mail.gmail.com/
> >
> > Odd, I can't reproduce this here, and nothing has changed in this driver
> > at all for this -rc cycle.  I see no one responded to the linux-next
> > issue either, so any hints?
> 
> Please ignore this allyesconfig build failure for now on 5.15 and 5.10.
> Seems like it is my local builder issue.

Great, thanks for letting me know,

greg k-h
