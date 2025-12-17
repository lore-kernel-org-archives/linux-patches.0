Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 966E9355030;
	Wed, 17 Dec 2025 14:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765980887; cv=none; b=W2+fpYpzC5FC9tpS0cMhSHx6Bp0fyqC2mMcspF/8sHhHcfzLo4JdpefAlJLGwrjQAKd+0yXF+cE0EUO9iaAQo9zNLb9qbjXMwmfydsr4nzIUz5MvEN0OMsjbNcqC7tGQ4Wjhx6tMMunFkyPzv+r0D4h7YJHpq1J34lgu1D9arAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765980887; c=relaxed/simple;
	bh=DNX16y9M6/fM40PAzSir0K34pXh29R4s/L3kpN5EpBI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vw0z3/YRONDxK7QxFYffUJlq3SUWJkfqOTVjiIRfF2L+PRYYiEYtYER1Kp8coTqNFbp1dSbXlLwz5Ukpnl5FZ2EyLhfuwYI0zJQriAeYPH+old+vXSE1J9wvfs+ja3wS4oxfZ0mUWgZqybozPJH542Gx6e/oNOrO5bo7GVVjFhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCoJeYbK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCoJeYbK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A57C4CEF5;
	Wed, 17 Dec 2025 14:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765980887;
	bh=DNX16y9M6/fM40PAzSir0K34pXh29R4s/L3kpN5EpBI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=xCoJeYbKrsvjE2E6m41B+4MSDYLRk9qwH9trEHAxWZX3bflUHq5l02ur5RVQoLFt/
	 xeuQu9tobo8t3Hero+R2ZdVyJlVUn7y+iC7uiiipEm8o0JBF58LfnmfB57OlIvTRt4
	 Bwh5m2QEzQqd68+Q22J0xaibVUa+RxLEe3Nl8aIQ=
Date: Wed, 17 Dec 2025 15:14:44 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: achill@achill.org, akpm@linux-foundation.org, broonie@kernel.org,
	conor@kernel.org, f.fainelli@gmail.com, hargar@microsoft.com,
	jonathanh@nvidia.com, linux-kernel@vger.kernel.org,
	linux@roeck-us.net, lkft-triage@lists.linaro.org,
	patches@kernelci.org, patches@lists.linux.dev, pavel@denx.de,
	rwarsow@gmx.de, shuah@kernel.org, sr@sladewatkins.com,
	stable@vger.kernel.org, sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org, dan.carpenter@linaro.org,
	nathan@kernel.org, llvm@lists.linux.dev, perex@perex.cz,
	lgirdwood@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
Message-ID: <2025121736-boogeyman-refund-24a6@gregkh>
References: <20251216111320.896758933@linuxfoundation.org>
 <20251217135249.422394-1-naresh.kamboju@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251217135249.422394-1-naresh.kamboju@linaro.org>

On Wed, Dec 17, 2025 at 07:22:48PM +0530, Naresh Kamboju wrote:
> On Tue, 16 Dec 2025 at 16:48, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.12.63 release.
> > There are 354 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> 1.
> I'm seeing the following build failures on s390 due to,
> 
> ## Build errors:
> arch/s390/include/asm/fpu-insn.h: In function 'fpu_vst':
> arch/s390/include/asm/fpu-insn.h:381:36: error: 'size' undeclared (first use in this function); did you mean 'ksize'?
>   381 |         kmsan_unpoison_memory(vxr, size);
>       |                                    ^~~~
>       |                                    ksize
> 
> The commit point to,
>   s390/fpu: Fix false-positive kmsan report in fpu_vstl()
>   [ Upstream commit 14e4e4175b64dd9216b522f6ece8af6997d063b2 ]
> 

Thanks, will drop this one now.

greg k-h
