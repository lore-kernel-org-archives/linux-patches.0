Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4E220F2A;
	Fri, 31 Jul 2026 06:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785481049; cv=none; b=K2DSS/vkhv/aorsJA3B5Ewp1shtnaWiEvQMfjMCO6+gtFug+HczmuhLeQgrTm90UcgJDzasv7uvfd5zouvc9kiSgP0GcZiJyGcxRPY6nuY+D/95qGjO59DnesOcAm1pPk8HA3Tb3NQjvT1mBVhmc4Wn4rfZ29ckk1meJiV9F1KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785481049; c=relaxed/simple;
	bh=kgMfG7+XKnN8FkNeC+WFR+A2vwomF1DP930mQ8Em2Ws=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vxk9bJM7g8aF1C67s6ONGhZ1WBvTASPewvfn896RO+4cohOUCCpT8Lrjy1MiqW9EQnCiSl74j9P3ix9jeMgdGSS9BY98+bQxyHBzQgP1NABawJsfMg5KE3ns9+TsaRsE6HLWaR6Zi/Ft0PHoH+10StXxo9AH2+sAIeQFwAlnnGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YwVsiwOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YwVsiwOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 363AF1F000E9;
	Fri, 31 Jul 2026 06:57:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785481047;
	bh=r7y8VIynFCQHZDQCckL6hl6AfuEFGx1T8F3uIT1Oe74=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YwVsiwOnsvhGApnpL8F7/m32g24kkCSvv3TJzuMoFnAM4OAmxlYGJB3JIc+1+IEfj
	 XKxWUZL9/oE19g9GxwR2r2XLx5GI1UW/t24gvn3d1jjjaD/izpuzatoXGj5JTndkAL
	 ESUEQ2RPBh1om2SsQuJRRDGReoFnlp/EyPABjhCY=
Date: Fri, 31 Jul 2026 08:57:05 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@nabladev.com,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	Joel Fernandes <joelagnelf@nvidia.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 6.18 000/675] 6.18.42-rc1 review
Message-ID: <2026073106-ajar-mantis-9f4e@gregkh>
References: <20260730141445.110192266@linuxfoundation.org>
 <20260730181717.95457-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260730181717.95457-1-ojeda@kernel.org>

On Thu, Jul 30, 2026 at 08:17:17PM +0200, Miguel Ojeda wrote:
> On Thu, 30 Jul 2026 16:05:30 +0200 Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.18.42 release.
> > There are 675 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 01 Aug 2026 14:13:45 +0000.
> > Anything received after that time might be too late.
> 
> Boot-tested under QEMU for Rust x86_64, arm64 and riscv64; built-tested
> for loongarch64 and arm32:
> 
> Tested-by: Miguel Ojeda <ojeda@kernel.org>
> 
> I detected in the middle of the build lines like:
> 
>     find: 'lib': No such file or directory
> 
> It looks like we need:
> 
>     ee8bfb15d02d ("drm: drop lib from header search path.")
> 
> to go together with the one that was backported:
> 
>     5e7b3c10420e ("gpu: Move DRM buddy allocator one level up (part two)")
> 
> Having said that, there is something going on a bit confusing: commits
> "part one" (4a9671a03f2b) and "part two" (ba110db8e1bc) in mainline seem
> to have been merged into just the "part two" above in this -rc. Is that
> intentional? I am asking because the original removal of the `lib`
> folder happened in "part one" in mainline, so I was expecting to have to
> point to that one above, but it doesn't exist on its own.
> 
> Cc: Joel Fernandes <joelagnelf@nvidia.com>
> Cc: David Airlie <airlied@gmail.com>
> Cc: Simona Vetter <simona@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org

Odd, looks like Sasha did it in one backport instead of two, perhaps
because we wanted a real patch and not a "move" patch?

Anyway, I'll go take the fixup change now too, thanks!

greg k-h
