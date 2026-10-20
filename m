Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792482211;
	b=J7AoVhn4nMJSX4dbdwRy0RMnuCLA4opaHMKWhH86j81JiTc52Gwvw5wXm+MjTJyD2C2k
	 9SBhPtAwPrlz8YPZcRiRVGlP9gokoSCaZ+Fnsv5VuVEMzqnAZuwTxHAbuNdG2K+5FgtHr
	 ifyIGGnaTJ8W9JnU6ySe3zY4V+N5xmEMD7rW9d7B088t261YFVlIold947LFfwVcxP1Ae
	 2dRLnN/1nkOc20ygsYU79HaDi0ZyO+87FWozlSiQOh/tleSmmizzO3/cKXqChMmxdzgtX
	 CUbYptTJZHFyIG7UFqe9UVLAhuzEsM/1c68qDBZeqhJyE99hbatmb/1ELs9MVBTzsnA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792482211;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=vU0z7m5xe8g7wdR48TxjDcDkibjrJE+rIqBFjrvHAwc=;
	b=v6GeV5XYBisCnL592pmI1qkcG0nv3YFSSfBk4bEEUPF/hxJo9JrlYLGCCC8xpMeUHCcV
	 x0nXD0/jN8qxHWNM3cu4mtFTPPgooqYGJbyauHy+ameelSGEvBZJ2MnP9+514uvSlCDO1
	 /JcbhfSNkGAAbVWKxvgOy4Qw3hYrhMkTmYyAFHhxmrdXd8iOq+xSPHD417uIQ/QpidHgv
	 GR7cRcONe+aMT8auEX7fZjXBKtcG1AWm4cCp3maIQdQ5oPj5PR2CJaJz7bOtQsoltz4LG
	 rK72AmTiEfVn+grjJpj53Q11hRzUYc1v/r6d7gHdIsHt5NOJtKfuhD93sZEiYWenWhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="b/gEWzmI";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8293606A319;
	Tue, 20 Oct 2026 07:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b/gEWzmI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDA711F000C6;
	Tue, 20 Oct 2026 07:43:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792482210;
	bh=vU0z7m5xe8g7wdR48TxjDcDkibjrJE+rIqBFjrvHAwc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=b/gEWzmIn5UmvCA0H08E+zVeH7GIr0bew5OcqfsbMynh7eqTZzFaXEpn/wY3JTa7C
	 xv4ZZNszgfeIxh4AUfpmCrYqo/UGmhDmLSMja9HHBCw2TzauBuA4vmK4ZuA9+a6hAC
	 3Q/ADSjv3Mes060W5MrECqih86p6fAzySbxensj4=
Date: Tue, 20 Oct 2026 09:43:27 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Schneider <pschneider1968@googlemail.com>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
Message-ID: <2026102018-staunch-evidence-bc19@gregkh>
References: <20261017160431.119607952@linuxfoundation.org>
 <827e9f8d-5654-4964-a999-5ce94bd98fd4@googlemail.com>
 <7201018c-20e8-4187-832a-aeb0e5db98ca@googlemail.com>
 <rc-reply-0001-6f27dc9abcab@kernel.org>
 <892078c7-7fa1-4e32-a00f-1ac907c0ebcc@googlemail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <892078c7-7fa1-4e32-a00f-1ac907c0ebcc@googlemail.com>

On Mon, Oct 19, 2026 at 09:10:50PM +0200, Peter Schneider wrote:
> Am 19.10.2026 um 18:54 schrieb Sasha Levin:
> > On Mon, Oct 19, 2026 at 06:02:37AM +0200, Peter Schneider wrote:
> > > # first bad commit: [7c1e132b0967210526de05e7af6f1c26ad0c1516] sysfs: Introduce a mechanism to hide static attribute_groups
> > 
> > Thanks for bisecting this.
> > 
> > > I think the problem is, that if you take this patch for stable, you need to also take the patch which is upstream [
> > > cd69fedf58f8ab1ab511f7c6ac1969cebf1c935f] sysfs: Fix crash on empty group attributes array. It addresses the exact crash
> > > that I've run into.
> > 
> > Rather than adding cd69fedf58f8, I dropped d87c295f599c ("sysfs: Introduce a
> > mechanism to hide static attribute_groups") and its dependent c7fbb8218b4a
> > ("sysfs: check visibility before changing group attribute ownership") from the
> > 6.6 and 6.1 queues.
> > 
> 
> Yeah, that seems to be the cleaner approach. I just tested this, and this works fine, too.
> 
> Will there be an -rc2?

Based on all of the reports, yes.
