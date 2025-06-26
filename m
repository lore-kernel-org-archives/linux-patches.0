Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4139A1EE032;
	Thu, 26 Jun 2025 10:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750934945; cv=none; b=ATfwi+RNn0YEFhfVq1u7mcjINDfUgBoGykxmubW4+P4rPG5Z/74viBGmVOm5mEDK7Olhg6X7zyI1hEbdtYK+vv3X4bXzTaaAnuLlX1JKsbmHsavINrguBF1Z9wLAew0YEzXkDQ7nh3/+Ce+bTC4yJFrt/uNre2KSbCohX8v4LRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750934945; c=relaxed/simple;
	bh=Y8QzlyWNEPVDLFxgbo10QucC3pjTZRGt4npACr6ebTg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jvVRxvbwtm4HKToJ5QZW3sbA+Tat0YAEtBEYsu0KBPG7sA7BO+Rj7AIWf6eJ3zfBi3VjWDM+VLkjWq466wiSjRcFTp3mq3ex4KykVxel/Hv1uTNECaM7yJ9czsOKePQk6y8s0cXBQ5L/DK9+8nP/bvrqd/RdO0yrVT1UfC16Ps8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nOGjrXGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nOGjrXGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8F8C4CEEB;
	Thu, 26 Jun 2025 10:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750934944;
	bh=Y8QzlyWNEPVDLFxgbo10QucC3pjTZRGt4npACr6ebTg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOGjrXGVNRBCfoW467a4KIkGTN//hZhVuZ6XXG6YivZXJmXM9/1Ci3o/3gVwlZDlp
	 YAwEnuUJ8xvoZM99+095H47V3Paz+lVbdZy16JCYHo16Ve0FPBkRW2jNO4r9XdMfJC
	 41O6Plldc86JdC1XQwjx18wGT52AaPyQiaTV381g=
Date: Thu, 26 Jun 2025 11:49:01 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Barry K. Nathan" <barryn@pobox.com>
Cc: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Christian Brauner <brauner@kernel.org>
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Message-ID: <2025062645-espresso-exchange-1ace@gregkh>
References: <20250624121449.136416081@linuxfoundation.org>
 <e9249afe-f039-4180-d50d-b199c26dea26@applied-asynchrony.com>
 <2025062511-tutor-judiciary-e3f9@gregkh>
 <b875b110-277d-f427-412c-b2cb6512fccc@applied-asynchrony.com>
 <6d3b0f28-98cb-46dd-b971-8a11e3b69d68@pobox.com>
 <7069cc77-a224-4753-8088-0302fc444710@pobox.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7069cc77-a224-4753-8088-0302fc444710@pobox.com>

On Thu, Jun 26, 2025 at 01:59:32AM -0700, Barry K. Nathan wrote:
> On 6/25/25 05:15, Barry K. Nathan wrote:
> > On 6/25/25 02:08, Holger Hoffstätte wrote:
> > > On 2025-06-25 10:25, Greg Kroah-Hartman wrote:
> > > > On Wed, Jun 25, 2025 at 10:00:56AM +0200, Holger Hoffstätte wrote:
> > > > > (cc: Christian Brauner>
> > > > > 
> > > > > Since 6.15.4-rc1 I noticed that some KDE apps (kded6, kate
> > > > > (the text editor))
> > > > > started going into a tailspin with 100% per-process CPU.
> > > > > 
> > > > > The symptom is 100% reproducible: open a new file with kate,
> > > > > save empty file,
> > > > > make changes, save, watch CPU go 100%. perf top shows
> > > > > copy_to_user running wild.
> > > > > 
> > > > > First I tried to reproduce on 6.15.3 - no problem,
> > > > > everything works fine.
> > > > > 
> > > > > After checking the list of patches for 6.15.4 I reverted the
> > > > > anon_inode series
> > > > > (all 3 for the first attempt) and the problem is gone.
> > > > > 
> > > > > Will try to reduce further & can gladly try additional
> > > > > fixes, but for now
> > > > > I'd say these patches are not yet suitable for stable.
> > > > 
> > > > Does this same issue also happen for you on 6.16-rc3?
> > > 
> > > Curiously it does *not* happen on 6.16-rc3, so that's good.
> > > I edited/saved several files and everything works as it should.
> > > 
> > > In 6.15.4-rc the problem occurs (as suspected) with:
> > > anon_inode-use-a-proper-mode-internally.patch aka cfd86ef7e8e7 upstream.
> > > 
> > > thanks
> > > Holger
> > 
> > For what it's worth, I can confirm this reproduces easily and
> > consistently on Debian trixie's KDE (6.3.5), with either Wayland or X11.
> > It reproduces with kernel 6.15.4-rc2, and with 6.15.3+anon_inode-use-a-
> > proper-mode-internally.patch, but not with vanilla 6.15.3 or with
> > 6.16-rc3.
> > 
> > By the way, my test VM has both GNOME and KDE installed. If I boot one
> > of the affected kernels and log into a GNOME session, I don't get any
> > GNOME processes chewing up CPU the way that some of the KDE processes
> > do. However, if I then start kate within the GNOME session and follow
> > the steps to reproduce (create a new file, save it immediately, type a
> > few characters, save again), kate still starts using 100% CPU.
> 
> After some testing and bisecting, I found that "anon_inode: use a proper
> mode internally" needs to be followed up with "fs: add S_ANON_INODE"
> (upstream commit 19bbfe7b5fcc) in order to avoid this regression.

Thank you!  I'll go queue that up now and push out a new -rc release

greg k-h
