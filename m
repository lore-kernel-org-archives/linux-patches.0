Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42356380FE3;
	Sat, 16 May 2026 10:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778926313; cv=none; b=sDgb8BgsvWdCucIsSr8lSgNd6RCbS9bOjelhB5oQoLA6z3m6yeJASTFdMXUtUiynb4gZxEczvkN67wQnkEjX8LawKS70lP3Jrxd5jJLC5GbAjvmzs4HEYkG8qhR9ZiZoM2hkzeAfbzBPTHHdyg70oV5vY4hi508mphYrr9zOVjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778926313; c=relaxed/simple;
	bh=QhC/U8Rg9iVAzrP+qWY7nGgMieSOBiSPXBxNEXxdfJk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMG+2jwwoUBv9kWtXkO0NYWFRrBAArBGG+7AFaOUHdXpNiYYWii9NQtFWEVt0DuDkrWgK3ZVxXDrnAmsk+XGDbtR7xOwPFMhSlKiugqwkeXo2naSy1j1p5xT/NCQL7eAUMbq266KjAj/1iMZER2aVNfK6R2ASRCcmY+eBr0u1cE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XEBPaK67; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XEBPaK67"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E96FC19425;
	Sat, 16 May 2026 10:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778926312;
	bh=QhC/U8Rg9iVAzrP+qWY7nGgMieSOBiSPXBxNEXxdfJk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XEBPaK67GD7olsEXYuXArthFzKjrG5wRLDq9YRWoYmcz8ML967XpNbuQCpBebAylc
	 UvDSsDVz1kj+N3m8jZxFgOPfY29pzu75dN195QTIC0BOAv+/flJRKWcfiFlj2KjPOt
	 D7ZPlIo7IvXE31rShI/xNnlg5uMda7u7iqEAWLi4=
Date: Sat, 16 May 2026 12:11:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, Jiri Kosina <jikos@kernel.org>,
	Benjamin Tissoires <bentiss@kernel.org>,
	linux-input@vger.kernel.org, Johan Hovold <johan@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>
Subject: Re: [PATCH 6.18 000/188] 6.18.32-rc1 review
Message-ID: <2026051659-facing-superior-e50a@gregkh>
References: <20260515154657.309489048@linuxfoundation.org>
 <20260516020430.110135-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260516020430.110135-1-ojeda@kernel.org>

On Sat, May 16, 2026 at 04:04:30AM +0200, Miguel Ojeda wrote:
> On Fri, 15 May 2026 17:46:57 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.18.32 release.
> > There are 188 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> > Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> Via arm32 I see:
> 
>     drivers/hid/hid-core.c:2050:29: error: format specifies type 'long' but the argument has type 'size_t' (aka 'unsigned int') [-Werror,-Wformat]
>      2049 |                 hid_warn_ratelimited(hid, "Event data for report %d is incorrect (%d vs %ld)\n",
>           |                                                                                         ~~~
>           |                                                                                         %zu
>      2050 |                                      report->id, csize, bsize);
>           |                                                         ^~~~~
> 
> It is also reproducible in mainline, though. Cc'ing a few folks...

bsize is size_t, so that should be %zu, right?

thanks,

greg k-h
