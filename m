Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D2628314D;
	Tue,  3 Jun 2025 09:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748942457; cv=none; b=ZbozWJCXvLL6aaH/gpm2scsemL0DinIonxzpVb8dE+wPZXX+O1yr8VdjF/a1IFoNroJ51A/7H2cj3AbvfDrATF5lpC7Y2+KBTxC5ozMLPhbAbhlEQb89/IiyidW1pbj8o9jSV0wtgoSLjTcEx47q6FVoLZL5Rcbbt+lQCpzc8o8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748942457; c=relaxed/simple;
	bh=QxsUJLLyqh/gSrH5BkoGzeCnilbstI4k12xR0RNy35Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F44BbUV5wfonp2UnWrSgsS43YQ7iBL9MLNGj0CtVzkwCXa0ZJkxF99/dplNVXu4pstSvaPBPhOhC2zv80bm8kqIHgXcKFEvxy5LfJxgoBdULRRRpEOzw8rHXyY3lDlCnTrdJOidOGrvOn0HssiInJJxqRlPyHv5AaLLygwAus2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UB52Q0u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UB52Q0u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A89FC4CEED;
	Tue,  3 Jun 2025 09:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748942456;
	bh=QxsUJLLyqh/gSrH5BkoGzeCnilbstI4k12xR0RNy35Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UB52Q0u6sDHWZ0BWUBXdHkBiNyQzoUAA1JYxhBTJ7k4WkjUg5TYUBYEoVug7sH+Xg
	 5vTINg9ooL60+N2l1kZV7hjyVxWH/e5dlzZYFP2e/HhBbpv6CNq88uDRqFrRYB919v
	 JxNDi2T/v1GJNqAoZpjga0FTQUwZmRsYQ2Oaf1yo=
Date: Tue, 3 Jun 2025 09:57:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <2025060355-unlikable-subarctic-d99b@gregkh>
References: <20250602134307.195171844@linuxfoundation.org>
 <CA+G9fYvkMUv4vFcde9A_chiiKOSkRiydGwnahgZauGExdmWEtQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvkMUv4vFcde9A_chiiKOSkRiydGwnahgZauGExdmWEtQ@mail.gmail.com>

On Tue, Jun 03, 2025 at 11:18:34AM +0530, Naresh Kamboju wrote:
> On Mon, 2 Jun 2025 at 20:08, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.238 release.
> > There are 270 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> There are two issues,
> 
> 1)
> Regressions on riscv defconfig builds failing with gcc-12, gcc-8 and
> clang-20 toolchains on 5.10.238-rc1.
> 
> Regression Analysis:
>  - New regression? Yes
>  - Reproducible? Yes
> 
> Build regression: riscv defconfig timer-riscv.c:82:2: error: implicit
> declaration of function 'riscv_clock_event_stop'
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> ---------
> drivers/clocksource/timer-riscv.c:82:2: error: implicit declaration of
> function 'riscv_clock_event_stop'
> [-Werror,-Wimplicit-function-declaration]
>    82 |         riscv_clock_event_stop();
>       |         ^
> 1 error generated.
> 
> This patch caused the build error,
> 
>   clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug
>   [ Upstream commit 70c93b026ed07078e933583591aa9ca6701cd9da ]

Now dropped, thanks!

greg k-h
