Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF76405C22;
	Sun, 17 May 2026 04:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778992635; cv=none; b=NKY8boAfu6em7gqiCoGfjv4zMAVnDXvoyrW9GBhiDg1AmL5+x/cRSZbeOIy9ubpmGkbuyPO9SbVpVz1DjX5GLiAH4auTEFNOQ/7HF+y6zZxaVY6vAfqVE9CgKIn0cXUasD9gDdTtso741q78qfcnydTpVf1r0mBSSK8mnsGPMWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778992635; c=relaxed/simple;
	bh=4tCss4+MpZL1Sng5kKdHtEx5exMywGFuCrBOXlhBTqI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QjcUUaNQXeC9LSa8Q3/qy63RYnwFKaWu6eYuVvqquSjxfu7a8dhOJyjiPsdukQ3m0XKlCNCcxT6EZgnoU/wATF8LSR6SNqhRRF9IL0uDyNJ51PPE3mP7aW+E25LPDYOVqoOTIs1lLnBmGoLnYaGDQ8OFubbuoJgJVEBkTPJ3+ZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iz+PW5dR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iz+PW5dR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 130C7C2BCB0;
	Sun, 17 May 2026 04:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778992634;
	bh=4tCss4+MpZL1Sng5kKdHtEx5exMywGFuCrBOXlhBTqI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iz+PW5dRk6r2Pkn6kCRu+6iKJps2enRk+9KaTj6KFPverUHVfkqv/pSGBlKuw2Y7X
	 AR9k+MbAKlWcY3WKNfQGfEk1/mOToU5kg56fuicRjjPRtyU/mhAz3tkFcWM9b76tBr
	 Oyr2Gf/f/pHnOP/Cr/u1qlvVh//0V6hu0Lx5JprEPGzn1TRG++op+GZ0sV14t7m0Uf
	 wADSss//qI5d/99eNRDTSpffKtzXvMkwgTLg2oAx7oV/mg4TN2Kt5yGULTS99W4ycF
	 GFP4Suv6hUJCwV520w5HvZMkJw75VYOZg36YGD8pD3LOMrUgGPjo3qWyNcXPtCbJEh
	 gEaJ7U6SL3ONQ==
Date: Sun, 17 May 2026 13:37:07 +0900
From: Nathan Chancellor <nathan@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, achill@achill.org,
	akpm@linux-foundation.org, broonie@kernel.org, conor@kernel.org,
	f.fainelli@gmail.com, hargar@microsoft.com, jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org, linux@roeck-us.net,
	lkft-triage@lists.linaro.org, patches@kernelci.org,
	patches@lists.linux.dev, pavel@nabladev.com, rwarsow@gmx.de,
	shuah@kernel.org, sr@sladewatkins.com, stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com, torvalds@linux-foundation.org,
	Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org, Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Message-ID: <20260517043707.GC1534263@ax162>
References: <20260515154657.309489048@linuxfoundation.org>
 <20260516020430.110135-1-ojeda@kernel.org>
 <2026051659-facing-superior-e50a@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026051659-facing-superior-e50a@gregkh>

On Sat, May 16, 2026 at 12:11:56PM +0200, Greg KH wrote:
> On Sat, May 16, 2026 at 04:04:30AM +0200, Miguel Ojeda wrote:
> > On Fri, 15 May 2026 17:46:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.18.32 release.
> > > There are 188 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> > > Anything received after that time might be too late.
> > 
> > Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> > for loongarch64:
> > 
> > Tested-by: Miguel Ojeda <ojeda@kernel.org>
> > 
> > Via arm32 I see:
> > 
> >     drivers/hid/hid-core.c:2050:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
> >      2049 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
> >           |                                                                                         ~~~
> >           |                                                                                         %zu
> >      2050 |                                      report->id, csize, bsize);
> >           |                                                         ^~~~~
> > 
> > It is also reproducible in mainline, though. Cc'ing a few folks...
> 
> bsize is size_t, so that should be %zu, right?

Indeed. Does not look like anyone has sent a patch yet so I will send
one shortly since this is breaking i386_defconfig in my tests since
-Werror is enabled by default there.

-- 
Cheers,
Nathan
