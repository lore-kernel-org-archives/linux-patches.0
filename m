Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1851725D902;
	Thu,  6 Mar 2025 18:01:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741284096; cv=none; b=FbNTD2Y5fMCDFPZjgg74gZduymDbEGcQnIJI1+P7f/G0ufW0y4n/HX5RIMNFRBCTb+9p9nHbZ8cSJUIilMeL4b654gt4KgYjizitUpWiof0a/CTpE3Ams/5hLiX7e3usCyrir097hPqbvFaRpfVhCKyWdDm98502zz1xshdpWqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741284096; c=relaxed/simple;
	bh=1F6psxXG5PYekDj2pT2Oad07PvftAWewt/JsQ/FVuRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S34B1WfqQ/WDZhCRv71hM95rHcqYm8+m1Aw8k5sM/hZNWDVTMJrCJTS5MrAq8T4U+0J+p7eyDEcXNyjO9G2wUTGIVow6H29c2DNL8EbL5gThQhiaOrikQVzPquDLlpQArtc9/Mde1LkLOkSZCe7tHdK2JSXqErl+HV5XDhH6ob0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YoILhZpX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YoILhZpX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30FBC4CEE8;
	Thu,  6 Mar 2025 18:01:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741284094;
	bh=1F6psxXG5PYekDj2pT2Oad07PvftAWewt/JsQ/FVuRA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YoILhZpXoRdDAP//KzZS1JNNOVlmF+G2kFWRrNfXFDcHDxx13Esq1p4/WsneaoVb/
	 rowohGx+J4Fm82ccaWOBaRumwrHbofTCxdBzroLpd9AOxvG5B/e8xq840z8lhvi75A
	 SrdMS/joiMurlTvjL3w1wFczBKtZjUvERNRuQ1Kw=
Date: Thu, 6 Mar 2025 19:01:31 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org,
	Thomas Gleixner <tglx@linutronix.de>, nik.borisov@suse.com,
	Arnd Bergmann <arnd@arndb.de>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 6.6 000/147] 6.6.81-rc2 review
Message-ID: <2025030633-deserve-postcard-9ed7@gregkh>
References: <20250306151412.957725234@linuxfoundation.org>
 <CA+G9fYtfmMThUC+erk6jVk8BN0jWJCw=FnKh68ypwhgv65OZ+w@mail.gmail.com>
 <20250306174442.GHZ8nfCiXOJj_fnQa7@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250306174442.GHZ8nfCiXOJj_fnQa7@fat_crate.local>

On Thu, Mar 06, 2025 at 06:44:42PM +0100, Borislav Petkov wrote:
> On Thu, Mar 06, 2025 at 10:59:35PM +0530, Naresh Kamboju wrote:
> > On Thu, 6 Mar 2025 at 20:50, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.6.81 release.
> > > There are 147 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.81-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > 
> > Regressions on i386 the defconfig builds failed with clang-20
> > and gcc-13 the stable-rc 6.6.81-rc2.
> > 
> > First seen on the
> >  Good: v6.6.78
> >  Bad: v6.6.78-442-g8f0527d547fe
> > 
> > * i386 build
> >   - clang-20-defconfig
> >   - clang-nightly-defconfig
> >   - gcc-13-defconfig
> >   - gcc-8-defconfig
> > 
> > Regression Analysis:
> >  - New regression? Yes
> >  - Reproducibility? Yes
> > 
> > Build regression: i386 microcode core.c use of undeclared identifier
> > 'initrd_start_early'
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > ## Build log
> > arch/x86/kernel/cpu/microcode/core.c:198:11: error: use of undeclared
> > identifier 'initrd_start_early'; did you mean 'initrd_start'?
> >   198 |                 start = initrd_start_early;
> >       |                         ^~~~~~~~~~~~~~~~~~
> >       |                         initrd_start
> > include/linux/initrd.h:18:22: note: 'initrd_start' declared here
> >    18 | extern unsigned long initrd_start, initrd_end;
> >       |                      ^
> > 1 error generated.
> 
> Looks like we need:
> 
>   4c585af7180c ("x86/boot/32: Temporarily map initrd for microcode loading")
> 
>  after all. Stupid 32-bit sh*t.
> 
>  Greg, ontop of what do you want this backported? Or should I send you a whole
>  set again with this patch in the right spot and you can apply the whole set
>  again?

Let me see if that backports cleanly...

Nope.

A backported version would be great. If you want to just send me a
single patch, or a whole new bundle, anything will work, whatever is
easier for you.

thanks,

greg k-h
