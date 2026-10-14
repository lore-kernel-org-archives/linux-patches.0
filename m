Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEF13499F06;
	Wed, 14 Oct 2026 09:01:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791968510; cv=none; b=UL5KpH0uRKpSls8Cir3pY9QbOSLAKE4ZmscBqRMttwNSt0Ztmv9pXhbX+iKHj1xHTkgT49HqxmB946+FHSwusYJ1tS5v2HgEPlbkHy5ROEzDJYx5yw0E59nYNuYPEZ2TKuk/SSrbBbX0l7/BzQwE8teAVlr/RMlBfYOFew9xgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791968510; c=relaxed/simple;
	bh=fK4EBgbsh8y/ygyHTRLW2d0pik1a4U3geawr9D0Cotw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XJ3D8LaCSV/okzl6y2eilwKUMtfjizkNW6Rv3ekEJ6SidQqkxcZRFHgelv7R3ikKvuUhdoCcJMxwuQ8YOY8FB68XPJwxpc/xjiDGsM0uDN9N6+RUqKTzrH6VebmIdIf0r2rGPyQBQNw0Lw+4/lCEIoRVT8B5iNxS8rdK7ZVYCQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y1f7c/Z1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y1f7c/Z1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81EB1F000FF;
	Wed, 14 Oct 2026 09:01:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791968508;
	bh=d+7qA8mWix34k0BGyINGvUZ3WOquU0CkExvHwCQqckA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y1f7c/Z1xVNfz7w+aWA4/TrYcE5cspE0wpsRMWXzOqMHpzWtkcqC5hyx2xJbrURxs
	 owCy6n/murUxKR4gmnmz/8eGz9Myh/MKV+NWrtY24aGMwDykiiF2/jAGfCuePR6oDi
	 zVu2WqCjnhX3PXW8OibGWSC2JYoTFQYyXmfpfrXQ=
Date: Wed, 14 Oct 2026 11:01:52 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Brett A C Sheffield <bacs@librecast.net>
Cc: Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
Message-ID: <2026101445-announcer-unreached-bd03@gregkh>
References: <as4kGIjqjrKzu0O0@auntie.librecast.net>
 <2026-10-13-1-daily-reply-0014-6-18-rc1-krb5-link-failure@kernel.org>
 <as8_EiojooHC5H-v@karahi.librecast.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <as8_EiojooHC5H-v@karahi.librecast.net>

On Wed, Oct 14, 2026 at 10:36:34AM +0200, Brett A C Sheffield wrote:
> On 2026-10-13 21:27, Sasha Levin wrote:
> > > Build failing on amd64:
> > >
> > > /usr/x86_64-pc-linux-gnu/binutils-bin/2.47/ld: vmlinux.o: in function `gss_krb5_get_mic_v2':
> > > (.text+0xfc2762): undefined reference to `crypto_krb5_get_mic'
> > 
> > Thanks for the report. The krb5 patches in the queue need a select of
> > CRYPTO_KRB5 that was missing. Queued for 6.18.
> 
> Thanks.
> 
> Will there be an RC2?

Yes, let me work on that today...
