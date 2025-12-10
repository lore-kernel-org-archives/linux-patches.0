Received: from bregans-0.gladserv.net (bregans-0.gladserv.net [185.128.210.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AA5221540;
	Wed, 10 Dec 2025 19:04:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.128.210.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765393500; cv=none; b=uvAalUipnX++TTkCuctL6TAOerG6QdjHcMSzUK71GyaR80ucsJQwvLarVGK1UyLYsJh/BHHszRUir46/v+g4x4Lm7geAVx7a1HjqcX4rY3KJ2fet4rqGG7VKandxI7/kzeGFTohy2YsY5Fgus3GdzUKYUo9bjKVNTi2Qc4hDxoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765393500; c=relaxed/simple;
	bh=gkZGrQ3wotYnjKwpcdwl5qec7a8mn6FigFHgyTiV7Rg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HKk9+BGmX0JR9y8qZ8gulETEIkCKS6lwRTg1tSZlInoEP504oJ8PKm6T9tOVGbei0+KWJphPT9OIRfALOxsHIKZDZF6MUX9+0maX5LRBvf5NvMgxYtQoBvybfCbt55fS5muWnnVHYh5sm9dRzf/VPo43Ri6HyKlyhFW83b2q5fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net; spf=pass smtp.mailfrom=librecast.net; arc=none smtp.client-ip=185.128.210.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Date: Wed, 10 Dec 2025 19:04:47 +0000
From: Brett A C Sheffield <bacs@librecast.net>
To: Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
Message-ID: <aTnET5C2PGiKsW_2@auntie>
References: <20251210072947.850479903@linuxfoundation.org>
 <CAG=yYwm==BjqjJWtgc0+WzbiGTsKsHV3e4Lvk60fcartrrABDw@mail.gmail.com>
 <2025121046-satchel-concise-1077@gregkh>
 <CAG=yYwm0bVzYoccKKcdheGOc-exuxVCPeXSftDixS68qZZ7W7w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG=yYwm0bVzYoccKKcdheGOc-exuxVCPeXSftDixS68qZZ7W7w@mail.gmail.com>

On 2025-12-10 19:13, Jeffrin Thalakkottoor wrote:
> On Wed, Dec 10, 2025 at 6:17 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Dec 10, 2025 at 04:22:21PM +0530, Jeffrin Thalakkottoor wrote:
> > >  compiled and booted 6.17.12-rc1+
> > > Version: AMD A4-4000 APU with Radeon(tm) HD Graphics
> > >
> > > sudo dmesg -l errr  shows  error
> > >
> > > j$sudo dmesg -l err
> > > [   39.915487] Error: Driver 'pcspkr' is already registered, aborting...
> > > $
> >
> > Is ths new?  if so, can you bisect?
> 
> this is new related. Previous stable release err and warn disappeared
> (i think i changed  .config)
> 
> can you give me a  step by step tutorial  for git bisect

1) cd to wherever you have your kernel checked out

2) `git bisect start`

3) if you're already on a known-bad commit, then mark it as such:

  `git bisect bad`

4) Mark the last known good commit as such:

  `git bisect good <commit / tag>`

git bisect will choose a commit to test.

5) Build, install and boot your kernel as you usually do

6) Run whatever test you need to determine if the booted kernel is good or bad
(check dmesg in this case)

7) Mark the commit as good or bad. Git will choose another commit for you.

8) Goto 5.

`git help bisect` will give you more information.

At the end of the process git will tell you the first bad commit found.  You can
dump the bisection log with:

`git bisect log`

which you can reply here with.

HTH.

Cheers,


Brett
