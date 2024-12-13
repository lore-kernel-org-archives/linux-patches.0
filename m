Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070541E0DBD;
	Fri, 13 Dec 2024 14:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734099483; cv=none; b=cZin5dImLrLQsCAkpEBoaF1ZJchj8TtEKWlFl2yD3MnoYIGBcDniKAL3jS8y1MYjLx7kkjBPd/q3usKMvwV8CQRxbaaOgVAyTJ/F3wF8wn1WN9UinskMwEKBMmBtqArlGxykZz0WFUp0aXw+R2PGbHujtiJrNiA7GHe9Cggo/i4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734099483; c=relaxed/simple;
	bh=9nilt2SV4Cn8EmLpI6NyqyDQ8rtce5mecJJILHigRs4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ol65FqAZAB8RAuIO+gNToLwCEl9utCGWe1PvQ/IHCJHG3uiMcKVnZA0jJVsgsRtm7ZJmIxiAtW/lTVIsfunKdz7ZoKsEZqq18LM7lC/JOIiV0E5rQO5ez4uDOdfk6oOI3eMu7Nw6yNo4BBDwWGv8j7R4+uzltSE71KWlSMMJMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTQbPe3I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTQbPe3I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8D32C4CED0;
	Fri, 13 Dec 2024 14:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734099482;
	bh=9nilt2SV4Cn8EmLpI6NyqyDQ8rtce5mecJJILHigRs4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pTQbPe3IvLMvc4WE6c9BhFBGLgB57rl4wHyCt92C8m0LcDSzT4GZNjx28OKUZByxM
	 88JVAKdFYNBGI08O5IeS2gsD2t0jMsxX3Q12rataYZbrNUXmsVGHCd1OBffW6izsSo
	 iMHUW0PzaxUZm6CukTJLfJd+V4k8k9WCR8fWytaQ=
Date: Fri, 13 Dec 2024 15:17:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
Message-ID: <2024121351-attic-perjurer-d1c5@gregkh>
References: <20241212144349.797589255@linuxfoundation.org>
 <0a41eb94-445c-4497-9c60-129142a2e362@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0a41eb94-445c-4497-9c60-129142a2e362@w6rz.net>

On Thu, Dec 12, 2024 at 06:44:09PM -0800, Ron Economos wrote:
> On 12/12/24 06:49, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.120 release.
> > There are 772 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> New warning on Linux 6.1.120-rc1.
> 
> scripts/mod/modpost.c:969:44: warning: excess elements in array initializer
>   969 |         .good_tosec = {ALL_TEXT_SECTIONS , NULL},
>       |                                            ^~~~
> scripts/mod/modpost.c:969:44: note: (near initialization for
> ‘sectioncheck[10].good_tosec’)
> 
> Caused by commit 20e6d91ba71543164151fc63ef978f28dda75394
> 
> modpost: Add .irqentry.text to OTHER_SECTIONS
> 
> 

Thanks, I've now fixed this up.

greg k-h
