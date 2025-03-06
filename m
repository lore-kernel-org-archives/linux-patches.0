Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D25819D08F
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 17:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741283124; cv=none; b=SEyIhCG7XOcD3NSiO0y/rxeHzL5jh3ebMvNs1POxfyxVxuxByLdNjqUeyGPbnGxj6CB9H2SUzAFPZnf62H620OoN648A8LJpU4Vd/5H4jU7rCuUo+wAfWxJCvWyg46ExRzmdaD7ULcbuyHNt0UxBFGbndPY6QwIq0pBviP0HkJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741283124; c=relaxed/simple;
	bh=5lWulsIg4jkdihnck/WDJ0WPFGTkB2B+8Hywipz+u5s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RR26fejbisRJv9o3T4NjllDPY2XiLyS5qxbRmv0p3FL83qYBhciLzTDrfJyWFpwMePIf9hkD93MWSdJEgzHzpNzh6p9TeDVg7BFe7om2flzRI9bYo7Ued0+ryr4Mnx+fGWCVxw4T5TRn4xbvtz7a8MQ8gBrBbp+k/+ogmYI1L8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=d9L1sUlG; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="d9L1sUlG"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id C969F40E0215;
	Thu,  6 Mar 2025 17:45:18 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id rIEtiloqEHGE; Thu,  6 Mar 2025 17:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1741283113; bh=KkRfr5V8ohSFrfodBl7Oc0e/N+8WDDGwWL2d56xkG+k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d9L1sUlGUwwBuDnoFs6CSy3qWqQRqAnZWgJ+1qpyTOg5ox+pSd839Zgsj82P9BbZJ
	 FbMS3cAr4FuxQj9gOoJXi6qssT3iICgKcrbFnz9w22BgtYPtcMw5pgVlpozHwDVsbo
	 3R6Kv94FyDrPdX83JACOlSPt2yORodr02Qt0S/jTEmTlR9hqNDQOklX2EaG/DWSGmn
	 xBTJ5rEuP+32yi6qAvX5lNOYids7xYN15bkBSoA80XMi2CS2zMDditww9YpbUZWUk9
	 DYdLoB8t8n3EsLbOSHBD6MKJFM9BwjetTsDZVx8/v5NEP/6S/RTGJUM4rZefjPyPnY
	 J4wROnSkJaAhHM1ZfnO1tchnWv3BMlZuoJa22aXjIHCjypzajRog8HqvmV6+hu3KWS
	 B3p/cB0N8tpJWsnIdqJ/XnpJYXTMtTX9O5TXJyNzLboHas1qz8xBdBHsYdCaPwDgp3
	 2KORRoUEnY55IVeJW6SEUov/Xdwch9RfHjmCo8yMndHEnBDFTRIGY3tg0+Kgv/OfN/
	 EmJhynTZOraZJ1FGRKtkPTl4SgUwxKg/7AB0u2lyz75EItnQHVgExhJKkIft2dEAaz
	 IJVcoBWEdv8HCcfmeli/NeNcGBmQ4t1SYfyYgyy6WZvT+nTHbQ9Y3Jox/LfVvs0RXq
	 BuKEJ67yKDZ4hHqJUsVzDX3E=
Received: from zn.tnic (pd95303ce.dip0.t-ipconnect.de [217.83.3.206])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 4034640E01AD;
	Thu,  6 Mar 2025 17:44:48 +0000 (UTC)
Date: Thu, 6 Mar 2025 18:44:42 +0100
From: Borislav Petkov <bp@alien8.de>
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, nik.borisov@suse.com,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <20250306174442.GHZ8nfCiXOJj_fnQa7@fat_crate.local>
References: <20250306151412.957725234@linuxfoundation.org>
 <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>

On Thu, Mar 06, 2025 at 10:59:35PM +0530, Naresh Kamboju wrote:
> On Thu, 6 Mar 2025 at 20:50, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.81 release.
> > There are 147 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Regressions on i386 the defconfig builds failed with clang-20
> and gcc-13 the stable-rc 6.6.81-rc2.
> 
> First seen on the
>  Good: v6.6.78
>  Bad: v6.6.78-442-g8f0527d547fe
> 
> * i386 build
>   - clang-20-defconfig
>   - clang-nightly-defconfig
>   - gcc-13-defconfig
>   - gcc-8-defconfig
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducibility? Yes
> 
> Build regression: i386 microcode core.c use of undeclared identifier
> 'initrd_start_early'
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> ## Build log
> arch/x86/kernel/cpu/microcode/core.c:198:11: error: use of undeclared
> identifier 'initrd_start_early'; did you mean 'initrd_start'?
>   198 |                 start = initrd_start_early;
>       |                         ^~~~~~~~~~~~~~~~~~
>       |                         initrd_start
> include/linux/initrd.h:18:22: note: 'initrd_start' declared here
>    18 | extern unsigned long initrd_start, initrd_end;
>       |                      ^
> 1 error generated.

Looks like we need:

  4c585af7180c ("x86/boot/32: Temporarily map initrd for microcode loading")

 after all. Stupid 32-bit sh*t.

 Greg, ontop of what do you want this backported? Or should I send you a whole
 set again with this patch in the right spot and you can apply the whole set
 again?

 Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
