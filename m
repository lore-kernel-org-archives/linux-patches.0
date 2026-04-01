Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C0C03DDDAE;
	Wed,  1 Apr 2026 11:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775043765; cv=none; b=gwCgYjWCXhxd+T6GOwoqHitA+ud8uh7ab1LUmiwEP6hTxmmn0ehGBQzQyiYwbC9zonTj0LmM8cdVoPCx1s8kEZBbGhs4CD4IutoVqLXHbT7bmZF0FsioFX70/dHVzasAlyK36n1+uD2brFPOiP2gw8m/5YKLWHWepaEbA+Bh+2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775043765; c=relaxed/simple;
	bh=5Hbo+3hn02akVUd+nLqMZ4fteGYSMtwLyOhqdMmKPSQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O/zkJio7z8nI923DxIWgNZzpTT6alGaWXMep2iVnvUf5wdnoyEF66ELClnkaBeE3EmZ+mQ0s8VivuKmfBmC5bHsLNGouHQeQtMwQYP+qSC7LCGLPVlnPWkkzr9AADlRfEEWh0xtG8/bx1H5DfJKIC2oIl/C+lmgLBZMcbyCwKr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cJZgogvk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cJZgogvk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D16AC2BCB3;
	Wed,  1 Apr 2026 11:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775043765;
	bh=5Hbo+3hn02akVUd+nLqMZ4fteGYSMtwLyOhqdMmKPSQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cJZgogvkqorEOUT+itTYmYFANmMSsioHSqj68yPexh/LXjUKPF5FWRSyhFsX8yoBT
	 4FmkfPmaZnvaH3MTEsmhHY4gfiCzCgHLCFn6gx8ujOa1hV1ZA67UcP0tFMYJqCbaid
	 MhlFHD6wkN2TwKfclB9XRRwW6gyWHcoD8Ea/J/yo=
Date: Wed, 1 Apr 2026 13:42:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/342] 6.19.11-rc1 review
Message-ID: <2026040131-audio-opponent-b94c@gregkh>
References: <20260331161758.909578033@linuxfoundation.org>
 <200019ee-d40a-414f-9dfb-c3fcbdbed969@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200019ee-d40a-414f-9dfb-c3fcbdbed969@gmail.com>

On Tue, Mar 31, 2026 at 03:18:19PM -0700, Florian Fainelli wrote:
> On 3/31/26 09:17, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.19.11 release.
> > There are 342 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf still fails to build for arm64 this was reported bck in 6.19.7. Can you
> revert b56111d7a4642ea7ef776ae97ecb1dd2724a1503 ("perf jevents: Handle
> deleted JSONS in out of source builds")?

Now reverted, sorry for missing that before.

greg k-h
