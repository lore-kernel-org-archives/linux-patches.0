Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D52C1C08
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 07:43:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 679E2C433C8;
	Tue,  4 Jul 2023 07:43:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688456636;
	bh=5VqRSuMpYumZIqE2wC2cou/STTVXEllMVqkTXJmrxnk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=OhL/ucFadRGJsdjIxYHH6pHgWRZryuy11gsj5A7B8/+/EZwY7DtLyfS4pudRKhfn4
	 lR2Es1OjZEQw2dm5vLVuGHSl+0dnBtd4uViVnu+8LQz3GgVW5JbKimoIZVV/DhyfYP
	 phSLQX3MRamnf1SMh3dYj44or8bVF1bNVtE77MJ4=
Date: Tue, 4 Jul 2023 08:43:54 +0100
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
Message-ID: <2023070411-steadfast-overtly-02a3@gregkh>
References: <20230703184519.206275653@linuxfoundation.org>
 <CA+G9fYvf-sw8tCHjxhoMvHrtzzdE69EwvB2PmypUkGDdCFFASA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvf-sw8tCHjxhoMvHrtzzdE69EwvB2PmypUkGDdCFFASA@mail.gmail.com>

On Tue, Jul 04, 2023 at 01:04:36PM +0530, Naresh Kamboju wrote:
> On Tue, 4 Jul 2023 at 00:26, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.3.12 release.
> > There are 13 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.12-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> 
> While running LTP hugetlb testing on x86 the following kernel BUG noticed
> on running stable-rc 6.3.12-rc1.
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Crash log:
> =========
> [   54.386939] hugefallocate01 (410): drop_caches: 3
> g tests.......

And this worked on 6.3.11 just fine?

Trying to narrow down what would have caused this...

Any chance you can run Linus's tree with thie LTP test as well?

thanks,

greg k-h
