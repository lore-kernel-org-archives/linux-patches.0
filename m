Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E6192E973A
	for <patches@lists.linux.dev>; Tue, 30 Dec 2025 11:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767095892; cv=none; b=oSy3uuKzM1df4w0+nVz/mpyBV83yj1UP/Qo3XWSYo7vkt3f+2fUCkCsrPf+AllXY8IyvfdxdxZaNaq1f79FCj0DOzbGS6waiZ9SIJkr04DuSMvVnSGlpf6qEdWdAaAInMQEIT0K2SpUIWGTCyE8xiuPT8NY1w+r99ySHNjt65Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767095892; c=relaxed/simple;
	bh=yU9BTgCN2KGW7Kmuq3f5WUn3f2NWQpeeo26cW2X2XJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T+/m0MSaoCo30f7wz9pGAWQO4lNvTzjFkEAODG9ZowIJLg/b4e4U2OqwxhZSEp1cf3o8ilklCOQ0mGKvDIdBfbK4UQQA1EVO5yovyNAikZmY+7NiNamogeepzCYLlWOjHBX797a/+FqR4WEhnVWVZ8jdBOtAp1hkUwgpb+WKrqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=XHY8AVU2; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="XHY8AVU2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1767095888;
	bh=yU9BTgCN2KGW7Kmuq3f5WUn3f2NWQpeeo26cW2X2XJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XHY8AVU2x4w5kP3z9juCR2EciSZgxccG7Do4JjFTZxkS9M18naTum84Yt6xuq6zkG
	 m1R8bIF/hMY32CObsaFErESwi99YxnFc29eNgHcv4RmjWfzrftRAMQN2iNWlilX0Rd
	 PSD5SN6N+dILN8mnbDKvXkLT2YAKSxEhGxUEJaqQ=
Date: Tue, 30 Dec 2025 12:58:08 +0100
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/430] 6.18.3-rc1 review
Message-ID: <6acaaac9-f7bd-4696-859f-c0d491a0ea14@t-8ch.de>
References: <20251229160724.139406961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>

Hi Greg,

On 2025-12-29 17:06:42+0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.3 release.
> There are 430 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Dec 2025 16:06:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.

I am missing commit 4dbf066d965c ("leds: leds-cros_ec: Skip LEDs without
color components"). This commit is in Linus' tree, has a stable tag and
also I requested it's backport in [0].

Did I mess up or did it fall through the cracks?
Any chance to get it included in the next batch of stable releases?

> (...)


Thanks,
Thomas

[0] https://lore.kernel.org/lkml/6b4ad836-7c7e-471d-a491-b0e8e68673b5@t-8ch.de/
