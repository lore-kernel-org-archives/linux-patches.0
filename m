Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793277028;
	b=wZCLSCiXg1mYqddNnrVPG/Kq089Jw29ooywqeqkHf2h+Ei0JWaxyhcJmdWX9H+eMyAJ+
	 WY6SviWWBJxRsj5+uf3Yg8Qbiz7oMmYTjlsdvre4PJjqNd13h1gDkngxx73c9LbU3To1c
	 0SUKppnaXXz3nCZcbhNghZZOeQthZW4Jxrncgz7lx/RZWOxJPZrtD5rqPg5iNvvXpNRA9
	 8sE/85MFWnZSfv0F158fOccYDe9kienvK8YeRbyFv2tPJQTrqosyEvNni5MK03cP+Hv+P
	 rTKSi5jj8VtEvKOgmvuNAjoM+GpRPjmIYCunvY/n9FVsBUq7xBWLQMTf8/Ptbbq9/Hg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793277028;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=iX+WJMOzweYYCWYdTjv2i47XFmlyJt8DsIdNFEtw0FI=;
	b=XhKDks34HjVCwDN8EbUUfBs0Hu6aju7PrsO4vZtImfAQIOI4gTsID09Khcy9+HFa5Yve
	 W0ot/OnR2k38PYPxEidYf/GWjLyTOcBPP8DfnYKCP1QCl/YgX5YUbfbcVMyK+Mcjp9UiK
	 N7Iil2DimE8hqSUkFJOqrBKDvw1++jv40GcvqSnZK2kMfkmdGF96hqsZkOaoeGhS92hyO
	 ha5p+qOjO31Au7wsFK+u587QZeSx52enXTjXIxwn5PmE4jkb7ShRvSfI3DOi3lyAMrkCA
	 IMTUqJBdkKcWkf+4ccSAOT7IL5bjYSsFrwkeTzT2D16INy6PVxSRLc8BuiGT21tOKEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhJnm1Ut;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40CF7606A31A;
	Thu, 29 Oct 2026 12:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QhJnm1Ut
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 239A71F01825;
	Thu, 29 Oct 2026 12:30:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793277027;
	bh=iX+WJMOzweYYCWYdTjv2i47XFmlyJt8DsIdNFEtw0FI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=QhJnm1UtA/L055WakykspnI6rXXv8etSJLokn/6YsZjMNKGrm+UyDS0/KXeTN7+rs
	 kTwdq6zdyuZSSNu0WGCzNjj2yNn2zFMw9vukOtJVbL2YeanUnLm8DiXEaTT3wgfEHd
	 hcmeTv0yonJXPgm12fPsqLSsnFR9YfSNChYSCloU=
Date: Thu, 29 Oct 2026 13:30:25 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Pavel Machek <pavel@nabladev.com>
Cc: bernard.f6bvp@gmail.com, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/247] 6.12.115-rc1 review
Message-ID: <2026102942-obligate-trolling-3dbf@gregkh>
References: <20261028165947.349197979@linuxfoundation.org>
 <auMe3fAAMqYKZ-qf@duo.ucw.cz>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <auMe3fAAMqYKZ-qf@duo.ucw.cz>

On Thu, Oct 29, 2026 at 11:24:29AM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 6.12.115 release.
> > There are 247 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> What is up with these?
> 
> They don't have usual "Commit upstream XXX" markings. They do have
> commit ids in the sign-off area (which is a logical place), except
> that those hashes don't exist in mainline.
> 
> Best regards,
> 								Pavel
> 
>     Signed-off-by: Bernard Pidoux <bernard.f6bvp@gmail.com>
>     
>     (cherry picked from commit 741a4863ad570889c75f7a8e404567d8f3e46335)
>     Signed-off-by: Sasha Levin <sashal@kernel.org>

These are coming from the out-of-tree rose repo as this code has been
dropped from the newer kernel versions.

thanks,

greg k-h
