Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4571CCECB;
	Wed,  4 Sep 2024 09:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725443178; cv=none; b=kEqT4cm0tZ2sSfErVBHquW0m0kzXQYXS6EtcZfGZfKb2DxaU5cbOqZRiKcQSB9uM7a3zJWrXWUYJDzU5qoJ1kky+h6RbF71E31k+8KjVmqpnhOVbfQIjV9m3xVKJ3ajFr2qfDULZ0poeOtgEbXHNaYBRxJNlTLBn+B3f3X/17JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725443178; c=relaxed/simple;
	bh=dIyubfnNsld2zEdy4ZUqK6BWciQYKqKZR8vjl0Ivpho=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dZyrs09OsLTkeFLzRETHdsPdX3lKbpBsaP027G8h7mM2/ot3frFzF4vZ7zuFFIH4rcwg7xXkPnOOkTUvm4vkYPazcyDDh6pLhRynW7kiKvqK/atjpJ14tm3UihzLht8ih8v3WWn/u2hUIZVx+YhLB3WpPCtqNmtwKv4fWJcxpJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2868FyP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2868FyP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B76C4CEC2;
	Wed,  4 Sep 2024 09:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725443177;
	bh=dIyubfnNsld2zEdy4ZUqK6BWciQYKqKZR8vjl0Ivpho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=h2868FyPZqlxY6SbvmQEE74WegLBjxyP+udhz5Usx8QVsgdtx1Gb7W6Iy5v6hDFYM
	 ftgEUR8nRqpizqRV+1PNOGzWMsQLsMuK8/264pOtnOJrE2qtgsZflS5v76AUQpMZPi
	 FtjA6jrqO9bRnioVXwuE22sdwflsHT9B5LuAGBWw=
Date: Wed, 4 Sep 2024 11:46:14 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
	Anders Roxell <anders.roxell@linaro.org>,
	aleksander.lobakin@intel.com,
	"David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.19 00/98] 4.19.321-rc1 review
Message-ID: <2024090459-second-vaporizer-eecf@gregkh>
References: <20240901160803.673617007@linuxfoundation.org>
 <CA+G9fYscUiPT0Eo9yo4UhJq2jjYtvLhOofQKhAMEOiVueR-Vaw@mail.gmail.com>
 <2024090449-reselect-charter-575b@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2024090449-reselect-charter-575b@gregkh>

On Wed, Sep 04, 2024 at 11:38:05AM +0200, Greg Kroah-Hartman wrote:
> On Mon, Sep 02, 2024 at 02:30:57PM +0530, Naresh Kamboju wrote:
> > On Sun, 1 Sept 2024 at 21:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 4.19.321 release.
> > > There are 98 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.321-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Apart from Powerpc build regressions we have noticed s390 build regression.
> > The S390 defconfig builds failed on Linux stable-rc 4.19.321-rc1 due to
> > following build warnings / errors with clang-18 and gcc-12.
> > 
> > This is a same problem on current stable-rc review on
> >    - 4.19.321-rc1 review
> > 
> > In the case of stable-rc linux-4.19.y
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Following two commits have been added on 4.19.321-rc1.
> > -------
> >   s390/cio: rename bitmap_size() -> idset_bitmap_size()
> >   commit c1023f5634b9bfcbfff0dc200245309e3cde9b54 upstream.
> > 
> >   bitmap: introduce generic optimized bitmap_size()
> >   commit a37fbe666c016fd89e4460d0ebfcea05baba46dc upstream.
> 
> Odd, this should have also shown up in your 5.4.y builds too.
> 
> I'll go drop this from both trees now, thanks.

Nope, I need it there, I'll go add some helper functions to make this
work, thanks.

greg k-h
