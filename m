Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDFC35675
	for <patches@lists.linux.dev>; Wed,  2 Aug 2023 08:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95A8FC433C9;
	Wed,  2 Aug 2023 08:32:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690965138;
	bh=WCYaS7WaNcg3pjGQ1y5KfJ2f08APy0pqC/hoQFKvh9A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FviH/yt2U1vWUE6LFvpQgWeIe8Wug2QurDoKIat1aeRLlclKM+q6B8SlFgppeacGQ
	 zP5YCQOtSG93RA+FK6zmokU3/UqdfC57uu1JgwF8HelIu9eBp9UabWtoLjezJYbGCI
	 SXdgL0zo0o4jwHF6UNbNRF/e7ngOwmXcYU5nIPEM=
Date: Wed, 2 Aug 2023 10:32:15 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Andy Shevchenko <andy@kernel.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Subject: Re: [PATCH 6.1 000/228] 6.1.43-rc1 review
Message-ID: <2023080200-expediter-dingo-8fd0@gregkh>
References: <20230801091922.799813980@linuxfoundation.org>
 <CA+G9fYsqEE6P8vKKvWgFDjpgT64FebUssPNS48n6qfUriu6Z1w@mail.gmail.com>
 <20230802082226.ok23iygasc3byc35@pengutronix.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230802082226.ok23iygasc3byc35@pengutronix.de>

On Wed, Aug 02, 2023 at 10:22:26AM +0200, Uwe Kleine-König wrote:
> On Wed, Aug 02, 2023 at 07:24:23AM +0530, Naresh Kamboju wrote:
> > On Tue, 1 Aug 2023 at 15:00, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.1.43 release.
> > > There are 228 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 03 Aug 2023 09:18:38 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.43-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> > 
> > Following patch caused build regression on stable-rc 6.1 and 5.15,
> 
> Looking at 6.1.x, cherry-picking
> 88da4e8113110d5f4ebdd2f8cd0899e300cd1954 can be done without conflicts
> and fixes this regression.

Already done and in -rc2!

thanks,

greg k-h
