Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7B1FBB
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 12:34:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43356C433C7;
	Wed, 30 Aug 2023 12:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693398890;
	bh=8d8qwnFWVQY1RLSMwJC/I3j8wq+i0JvgFrwUBuG2jE8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=U7JY2OrFRfxYcCvGyk4JNgby3X0AZm8FT4Wn6ElOkfb3hpqRp1cLV/aM3hh7o1y9o
	 dsmKPr+6uks3ABosnRdZXuO6JS1MY64/tvTkwlGfxCQNCs4Olgc0LjyMyoUfSJqDdW
	 3g96B4aYOE2vBFO5OeL824h2qqJb1l1WgEBZVofE=
Date: Wed, 30 Aug 2023 14:34:48 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Tony Lindgren <tony@atomide.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Arnd Bergmann <arnd@arndb.de>,
	Anders Roxell <anders.roxell@linaro.org>
Subject: Re: [PATCH 4.19 000/129] 4.19.293-rc1 review
Message-ID: <2023083040-marital-mustiness-2891@gregkh>
References: <20230828101153.030066927@linuxfoundation.org>
 <CA+G9fYuQXq7-jkL59MMKfRbqqB509T3nQdtcW+4wVW_QRovx5g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYuQXq7-jkL59MMKfRbqqB509T3nQdtcW+4wVW_QRovx5g@mail.gmail.com>

On Mon, Aug 28, 2023 at 06:15:30PM +0530, Naresh Kamboju wrote:
> On Mon, 28 Aug 2023 at 15:54, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.293 release.
> > There are 129 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.293-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> Regressions on arm.
> 
> stable-rc linux-4.19.y arm gcc-12 builds fails with
> following warnings / errors.
> 
> Build errors:
> --------------
> drivers/bus/ti-sysc.c: In function 'sysc_reset':
> drivers/bus/ti-sysc.c:982:15: error: implicit declaration of function
> 'sysc_read_sysconfig' [-Werror=implicit-function-declaration]
>   982 |         val = sysc_read_sysconfig(ddata);
>       |               ^~~~~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> 
>  > Tony Lindgren <tony@atomide.com>
>  >   bus: ti-sysc: Flush posted write on enable before reset
> 
> bus: ti-sysc: Flush posted write on enable before reset
> commit 34539b442b3bc7d5bf10164750302b60b91f18a7 upstream.
> 
> The above commit is causing this build warnings / errors.

Now dropped, thanks.

greg k-h
