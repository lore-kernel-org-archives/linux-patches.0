Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53BB015C8
	for <patches@lists.linux.dev>; Tue,  4 Jul 2023 07:31:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01C3EC433C9;
	Tue,  4 Jul 2023 07:31:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688455917;
	bh=PjGkpkF+D5SrFko09IJTFD6Zhw0UYMl5RKch1zse0Qg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qp+rv8Vv49+hvqq1oXM55Wa+O6EHGQZqgMJXYBFlr82XGZUgJ0xU6iTIBb/loM5UZ
	 anDO5a6Sh8n79een+STk7+DWV9JzvQEu/QK8eGRwFBCySPDB8KHpVrH7Lmj6Yp55dq
	 2tgMurMVVv6j58YTSa2VLA41B/TR9jgiT2ZrZfBs=
Date: Tue, 4 Jul 2023 08:31:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Helge Deller <deller@gmx.de>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>,
	linux-parisc <linux-parisc@vger.kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Vishal Bhoj <vishal.bhoj@linaro.org>, Arnd Bergmann <arnd@arndb.de>,
	Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Subject: Re: [PATCH 5.15 00/15] 5.15.120-rc1 review
Message-ID: <2023070427-filled-brewing-d678@gregkh>
References: <20230703184518.896751186@linuxfoundation.org>
 <CA+G9fYueycAbx7DDR3S57d43UX49SOGnW6igQUZ0voEcapxdYw@mail.gmail.com>
 <d25d0195-b40e-2a03-de75-1bdc1aaf404c@gmx.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d25d0195-b40e-2a03-de75-1bdc1aaf404c@gmx.de>

On Tue, Jul 04, 2023 at 09:16:36AM +0200, Helge Deller wrote:
> On 7/4/23 09:00, Naresh Kamboju wrote:
> > On Tue, 4 Jul 2023 at 00:27, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > 
> > > This is the start of the stable review cycle for the 5.15.120 release.
> > > There are 15 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >          https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.120-rc1.gz
> > > or in the git tree and branch at:
> > >          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Following build regressions noticed on stable-rc 5.15.
> > This build failure started happening from v5.15.119 from date June 28, 2023.
> > 
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > 
> > Regressions found on parisc:
> > 
> >    - build/gcc-11-allnoconfig
> >    - build/gcc-11-defconfig
> >    - build/gcc-11-tinyconfig
> > 
> > Build errors:
> > =============
> > arch/parisc/include/asm/assembly.h: Assembler messages:
> > arch/parisc/include/asm/assembly.h:75: Error: symbol `sp' is already defined
> > arch/parisc/include/asm/assembly.h:77: Error: symbol `ipsw' is already defined
> > make[3]: *** [scripts/Makefile.build:391: arch/parisc/kernel/head.o] Error 1
> > arch/parisc/include/asm/assembly.h: Assembler messages:
> 
> Greg, could you please pull in the following upstream commit?
> It was backported to kernels > 6.0, but with newer binutils it's probably
> needed for kernels < 6.0 as well:
> 
> commit b5b2a02bcaac7c287694aa0db4837a07bf178626
> Author: Ben Hutchings <benh@debian.org>
> Date:   Thu Jun 15 00:00:02 2023 +0200
> 
>     parisc: Delete redundant register definitions in <asm/assembly.h>
> 
>     We define sp and ipsw in <asm/asmregs.h> using ".reg", and when using
>     current binutils (snapshot 2.40.50.20230611) the definitions in
>     <asm/assembly.h> using "=" conflict with those:
> 
>     arch/parisc/include/asm/assembly.h: Assembler messages:
>     arch/parisc/include/asm/assembly.h:93: Error: symbol `sp' is already defined
>     arch/parisc/include/asm/assembly.h:95: Error: symbol `ipsw' is already defined
> 
>     Delete the duplicate definitions in <asm/assembly.h>.
> 
>     Also delete the definition of gp, which isn't used anywhere.
> 
>     Signed-off-by: Ben Hutchings <benh@debian.org>
>     Cc: stable@vger.kernel.org # v6.0+
>     Signed-off-by: Helge Deller <deller@gmx.de>

Sure, now queued up!

I'll be pushing out some -rc2 releases soon with this fix, and a few
others that I missed in a bit.

thanks for the report and the quick response,

greg k-h
