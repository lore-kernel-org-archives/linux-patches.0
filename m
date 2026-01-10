Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB35A280318;
	Sat, 10 Jan 2026 20:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768075256; cv=none; b=WuiKkgAt8qzjprJhL+zyYUjlE7zZ3V+EPHmP0bbBIlKlIGlaUKGX579Lq6LbaLUFQdhW01tMQCbSHCUapxrcXJyu8iVVZEq2mBgFIfA29ymBJqId+Rwga9BzP+eMWnq3P6cv9bjPuKftdByEw5wqKJrvOVg1NGq5nKZhFKVqH5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768075256; c=relaxed/simple;
	bh=iDEooV8M1FIE6NrEc1WqXO8vEsWBfWB7mucwmF57VF8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OYuW3KEkRy36XII8VBGi4Yy3ezF1w28vfpICbP4x1whgZhBgqv7PTtud29nVA7ulduALxIOVESkg7BPNpSNzU1fSu43pvT8PGs0lj6EML6xziZI3MnWdIdtmnwE9KjYq028CXnNtN0GsrDP2iU00JCRpJSlwWWyzA5BOwnjXwgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nw2496p6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nw2496p6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAEC4C4CEF1;
	Sat, 10 Jan 2026 20:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768075256;
	bh=iDEooV8M1FIE6NrEc1WqXO8vEsWBfWB7mucwmF57VF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Nw2496p6vJl98sdGrhsi8PEwy0MCVrBwofO60tXfe+6YbG2kG6F1zxReyAeGD2aGv
	 FC7W1Zht+65SRGPM3GEIAEUMYJSUXfbHIRxUo3Jw4QE/ZUzcUZTIzkGrWrRIvGe0sN
	 tWCIehKynFL887/gX2atWg8IF+b7RwIvS6CymgHc=
Date: Sat, 10 Jan 2026 14:50:57 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jon Hunter <jonathanh@nvidia.com>
Cc: Mark Brown <broonie@kernel.org>,
	Francesco Dolcini <francesco@dolcini.it>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
	"linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/634] 6.1.160-rc1 review
Message-ID: <2026011035-grudging-shelving-cf98@gregkh>
References: <20260109112117.407257400@linuxfoundation.org>
 <20260110084142.GA6242@francesco-nb>
 <2026011010-parasitic-delicacy-ef5e@gregkh>
 <aWI2qATUQXAW-Bxx@sirena.co.uk>
 <aWI43lUAfpKZWSx3@sirena.co.uk>
 <c019d930-d565-449e-bfcd-a4a5ea3a7b0d@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c019d930-d565-449e-bfcd-a4a5ea3a7b0d@nvidia.com>

On Sat, Jan 10, 2026 at 12:50:49PM +0000, Jon Hunter wrote:
> 
> On 10/01/2026 11:32, Mark Brown wrote:
> > On Sat, Jan 10, 2026 at 11:23:20AM +0000, Mark Brown wrote:
> > 
> > > I'm also seeing bisects of similar boot failures pointing to the same
> > > commit on at least i.MX8MP-EVK and Libretech Potato.  Bisect log for the
> > > board Francesco originally reported, the others all look the same:
> > 
> > Pine64 Plus, Aveneger 96 and Libretech Tritium are also affected.
> 
> 
> This is impacting some Tegra boards too.

Odd, that commit is in released 6.6 and newer kernels.  I'll go drop
this now and push out a new -rc release, thanks everyone for letting me
know!

greg k-h
