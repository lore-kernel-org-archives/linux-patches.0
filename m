Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0013F281508;
	Tue,  3 Jun 2025 09:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942451; cv=none; b=D43CBTnU0Cgs8CINwYz729JnzNOKI9H9daCQ/ropACfaEdzNJ1LThbYxq6QaIORpdAVCXn3rbS+HSptbSkXSnZXyMta1pIrm8iiPSYidGbL/sEw6IPulD2rrDslyWKZxOuvVhtPoccyCRlZh1y0HKp8dz+qaGsFkrHhINYbzRsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942451; c=relaxed/simple;
	bh=ZL14hC1dAIHZdXSl5YAhODlyy8QDnfUkUI8TrQuCGN0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=W5rKCm24G6S99roUm5EQTOYS1xNI/9KSCnTuxf3B/A34CFA6C0nRrIXuBhyeKwvklX5CWLQjTpjKh+7S9n8fledgqlMQ9n4G5MRDbmAlffuJlT8W04NQEW8H7NrhhMad3f/GhfJM6ggKC7sxATKI20mJE6UIhfycq84XfPK3xIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bmoaSfMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bmoaSfMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB628C4CEF0;
	Tue,  3 Jun 2025 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748942450;
	bh=ZL14hC1dAIHZdXSl5YAhODlyy8QDnfUkUI8TrQuCGN0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bmoaSfMiiGR09IWSB3DmLMeDlJUNL1V5QT8JnjsKSZq7d79q14lx1U/GwAflPjaAN
	 cSfrPjXSnaJalyW/IRGmtF7oFJF8nYBYHdmPeW4O7rLIUKFyI3FzwF+PIYdejDpYzs
	 NQ5pvOJZruysTm1zgF0ucHZymTz8r9Xut5oVYRsM=
Date: Tue, 3 Jun 2025 09:56:34 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Nick Hu <nick.hu@sifive.com>, Anup Patel <anup@brainfault.org>,
	Alexandre Ghiti <alexghiti@rivosinc.com>
Subject: Re: [PATCH 5.15 000/207] 5.15.185-rc1 review
Message-ID: <2025060324-huntress-ideally-ffb4@gregkh>
References: <20250602134258.769974467@linuxfoundation.org>
 <CA+G9fYt12w2ZvFdGf-m5d1y4BKd6rZXYya_2-++s1qLqZT=Dcg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt12w2ZvFdGf-m5d1y4BKd6rZXYya_2-++s1qLqZT=Dcg@mail.gmail.com>

On Tue, Jun 03, 2025 at 09:32:22AM +0530, Naresh Kamboju wrote:
> On Mon, 2 Jun 2025 at 20:22, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.15.185 release.
> > There are 207 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.185-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> Regressions on riscv defconfig builds failing with gcc-12, gcc-8 and
> clang-20 toolchains on 5.15.185-rc1.
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducible? Yes
> 
> Build regression: riscv defconfig timer-riscv.c:82:2: error: implicit
> declaration of function 'riscv_clock_event_stop'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Now dropped, thanks.

greg k-h
