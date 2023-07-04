Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DC64694
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 08:39:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E67EC433C8;
	Tue,  4 Jul 2023 08:39:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688459998;
	bh=mCVClS7EcoGBFNazRWSxsNvPRy+H3H1JIh9ATrI8UCk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dd/FuTChwX77AfBKIZnW69EFpeMNFMO/AelldNOoD3O6jQfKZtW4Zf+VR/DCsv8Ey
	 xVgFKzUD/3TtMbKNzA8X4XhWmAg9Rgz7SsveJGTlWG4kyMzdAiTq/hFkSBYOC74dMn
	 PjxXZ+TaUQlZxMaxC4IivTT4HZyprNFS9mvice/s=
Date: Tue, 4 Jul 2023 09:39:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org
Subject: Re: [PATCH 6.3 00/13] 6.3.12-rc1 review
Message-ID: <2023070436-evident-constant-890f@gregkh>
References: <20230703184519.206275653@linuxfoundation.org>
 <CA+G9fYvf-sw8tCHjxhoMvHrtzzdE69EwvB2PmypUkGDdCFFASA@mail.gmail.com>
 <2023070411-steadfast-overtly-02a3@gregkh>
 <2023070416-wow-phrasing-b92c@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2023070416-wow-phrasing-b92c@gregkh>

On Tue, Jul 04, 2023 at 09:24:37AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jul 04, 2023 at 08:43:54AM +0100, Greg Kroah-Hartman wrote:
> > On Tue, Jul 04, 2023 at 01:04:36PM +0530, Naresh Kamboju wrote:
> > > On Tue, 4 Jul 2023 at 00:26, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.3.12 release.
> > > > There are 13 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > >
> > > > Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.12-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > > 
> > > 
> > > While running LTP hugetlb testing on x86 the following kernel BUG noticed
> > > on running stable-rc 6.3.12-rc1.
> > > 
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > 
> > > Crash log:
> > > =========
> > > [   54.386939] hugefallocate01 (410): drop_caches: 3
> > > g tests.......
> > 
> > And this worked on 6.3.11 just fine?
> > 
> > Trying to narrow down what would have caused this...
> > 
> > Any chance you can run Linus's tree with thie LTP test as well?
> 
> Ah, I can hit this here locally too!  Let me bisect...

Found it.  I'll drop the offending patch and push out a new -rc release,
thanks.

greg k-h
