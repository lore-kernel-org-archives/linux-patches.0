Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF80417E4;
	Sat, 22 Nov 2025 06:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763794028; cv=none; b=XkO2I0asTep3szf/T0Vi1pAa50bJ2E/XACMrabUEAkEfRFlRwe4sAZAnagAAGg+jq51iGPZC6T+FmXmvKWTaPxht4ZvAzmGSgRwFEn4LVclaPVXI4PAdmACNjpApbAKQLy1C+ecDLLurD62zsVCm4RuX+GUt1bmr6zcoojBUMHQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763794028; c=relaxed/simple;
	bh=5go9l/9D1n9oWJDFXgXAk53nECOliW6QxvhpU8lqXnc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A+hCFL/dG3/vQU2OF7ClLvW1yNyyDpxtYlei+p2/jilA/aZDq4IhN+vQGrpjQuTnLFGRtXsCEq2U1BrhLRUxoy9HFZ2echmqW4pWM+X9AlE+KBnbXyYW59geiOZm2HKuSZBlI5cwS5QcyzI2d/f7iTlDouiwNZxsF5tHkBQQ9aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j5vCQTLR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j5vCQTLR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E3BC4CEF5;
	Sat, 22 Nov 2025 06:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763794028;
	bh=5go9l/9D1n9oWJDFXgXAk53nECOliW6QxvhpU8lqXnc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=j5vCQTLRW80QF9F/wW5gV4TiqOuPY+muMhy/mUp0lo0Ri/Gxc86RLhSOUisNz83zX
	 mGUYSg8DeHDWMeL6uqgzMo3+kRF34wkgkFhWpxZEgnyPa8kPFVzK9Pg7CUxr+pEVYO
	 WUQPuOt8vhfbf0NOcGynwU8FLC/bxnHkLlBERNE4=
Date: Sat, 22 Nov 2025 07:47:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/185] 6.12.59-rc1 review
Message-ID: <2025112248-sprout-chapped-149a@gregkh>
References: <20251121130143.857798067@linuxfoundation.org>
 <CA+G9fYvyiLxwGFN-3QuK4PR2nAmFSp8whe6yfTMXB+FoKHhjrw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvyiLxwGFN-3QuK4PR2nAmFSp8whe6yfTMXB+FoKHhjrw@mail.gmail.com>

On Sat, Nov 22, 2025 at 10:16:09AM +0530, Naresh Kamboju wrote:
> On Fri, 21 Nov 2025 at 18:56, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.59 release.
> > There are 185 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.59-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> The LTP syscalls listmount04 failures noticed across the 6.18.0-rc6,

So this is upstream, has it been bisected and reported there?

thanks,

greg k-h
