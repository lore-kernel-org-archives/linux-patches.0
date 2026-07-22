Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B3643603F8;
	Wed, 22 Jul 2026 12:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784722499; cv=none; b=CTteY+67m2udEVQ81gcJeJh5sGdY6E9qeg+Nno7czN0tqcG42CAADB9CS/O5hcAvniAQC3Kp/HwEBk+1Q+KO8N/ANGbSW20cG2QNN5S/zdXHgYTWq89AKrXyrYxOkxgvNqQieOmE+85M3kl3b2VxzEusSC0mqypXtzSm+/SPrec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784722499; c=relaxed/simple;
	bh=7W4Fljmc2HJiNWqNeBP1OPLp59bfWsf0d95alVl2mzU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rL6Orbc5A0xrLkuyZwRfSrdOuYWwEMADNWgMSSDZc9sZeG7USBEog/rovHiYVyvDF4D4jCTZNPbOXvg0IJPieQ6HflUhtEVG3QuqLOgb73IhOBjN14pmt+kT7XXD4AJggXWaRsP1J24DeT8FZp+BUKjQKN3w4kxsRKHFc64KsIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZTNvlXfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZTNvlXfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1571C1F000E9;
	Wed, 22 Jul 2026 12:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784722497;
	bh=oCwivelmJkLha9pvqrwRcYGR53d4ntiAagF0/i9SY3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ZTNvlXfJ0v+BejmPlS/UIcZL4Q8vW+T/JZNUAceIRQMalyFfW56KTz2Z4SvvBr20+
	 jVdbeEZu3wBTu8Fvpco0mOUnGCflwl8pleh0nqAjOIPnksuTC5nmwhGAjwMEeXO5rt
	 GapdTmSSDTuF4jG24X/5YRVRj9IzRlf45CT3PigU=
Date: Wed, 22 Jul 2026 14:14:47 +0200
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
Subject: Re: [PATCH 6.18 0000/1611] 6.18.40-rc1 review
Message-ID: <2026072215-deck-glitch-3692@gregkh>
References: <20260721152514.750365251@linuxfoundation.org>
 <8869a0f4-8e26-4f83-b258-f633a6eb6da3@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8869a0f4-8e26-4f83-b258-f633a6eb6da3@gmail.com>

On Tue, Jul 21, 2026 at 10:48:11AM -0700, Florian Fainelli wrote:
> On 7/21/26 08:01, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.18.40 release.
> > There are 1611 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.40-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> perf fails to build with:
> 
> util/arm-spe.c: In function 'arm_spe__inject_event':
> util/arm-spe.c:472:37: error: 'struct perf_sample' has no member named
> 'evsel'
>   472 |         struct evsel *evsel = sample->evsel;
>       |                                     ^~
> 
> due to commit ca625699a8d5ddea7213231f090dab1e0ec0380c ("perf event: Fix
> size of synthesized sample with branch stacks"), it looks like we need to
> backport aeae075a0352eb6ab363fb1910f209eaa296a175 ("perf sample: Add evsel
> to struct perf_sample")

That commit doesn't apply, so I'll just try to drop the offending perf
commit instead.

thanks,

greg k-h
