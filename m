Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCED1F8908;
	Fri, 14 Feb 2025 08:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739522541; cv=none; b=n/JrkcaGNfshWk5oo6wgYyeu3SRN4LveUUjOzW0JVY6EP2pktLeOoaLZDHD1N9RRbXbgStuSGt4k5K/rLLefUV85vRL53KARvszCYUt3MafzaW0Q6vGpJr6CG9dnEQnXmoIkOZUlb1V2xQ+AAhIFgu2fmAzT/UQYRUebCAgKMWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739522541; c=relaxed/simple;
	bh=Y1dBNOVqrdm+zdidJafcYJgOI6M4dVaTsfFBEosrCC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cgDJ9Yf+TZ09Vq+m0xVlwX7CBuq0Oonxyvkz+T2d1/Gv0/cwP0JWZpYjKyk+a0hTq5omgk+Ssosj4Ghvgll6W/XPgo1Hry5nmhSNvoASvpml02E7uoMcrAgnawokFyqL9cYftsmT2ixqdr4NxU9M7eBAlA182HUSEOvPvNuWi9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LozZLDnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LozZLDnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73FF1C4CED1;
	Fri, 14 Feb 2025 08:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739522541;
	bh=Y1dBNOVqrdm+zdidJafcYJgOI6M4dVaTsfFBEosrCC8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LozZLDnHaeRHhKImbhqfCQ9c/XYtXJSOThPGEb5xDYbBLTiJ2x2X+USKJ8vfXUEfH
	 9MomGSfEsx0WJPc9VDwp0rcM80zrNUi4P6Xc+4r5ZoPy1VM5MlVIOz1qVO3LVV+KMD
	 kno8SvKNRJlsAHFmlt3U1n3HvazToLKFC/yhGKFA=
Date: Fri, 14 Feb 2025 09:42:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Holger =?iso-8859-1?Q?Hoffst=E4tte?= <holger@applied-asynchrony.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/443] 6.13.3-rc1 review
Message-ID: <2025021459-guise-graph-edb3@gregkh>
References: <20250213142440.609878115@linuxfoundation.org>
 <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e7096ec2-68db-fc3e-9c48-f20d3e80df72@applied-asynchrony.com>

On Fri, Feb 14, 2025 at 09:32:06AM +0100, Holger Hoffstätte wrote:
> On 2025-02-13 15:22, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.13.3 release.
> > There are 443 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Builds & runs fine BUT fails to suspend to RAM 99.99% of the time (basically
> one success but never again). Display powers down but fans stay on.
> 
> Tested on multiple systems, all x64. I first suspected amdgpu because why not :)
> but it also fails on a system without amdgpu, so that's not it.
> 
> Reverting to 6.13.2 immediately fixes everything.
> 
> Common symptom on all machines seems to be
> 
> [  +0.000134] Disabling non-boot CPUs ...
> [  +0.000072] Error taking CPU15 down: -16
> [  +0.000002] Non-boot CPUs are not disabled
> 
> "Error taking down CPUX" is always the highest number of CPU, i.e.
> 15 on my 16-core Zen2 laptop, 3 on my 4-core Sandybridge etc.
> 
> I started to revert suspects but no luck so far:
> - acpi parsing order
> - amdgpu backlight quirks
> - timers/hrtimers
> 
> Suggestions for other suspects are welcome.

Can you run 'git bisect' to try to find the offending change?

thanks,

greg k-h
