Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5335666
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 09:57:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93301C433C7;
	Sat,  1 Jul 2023 09:57:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688205454;
	bh=rcb5fmM/YGXFaxmYPm09nzSE6MxfW1AoIbS68NK9hgE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lOB2tx/2N2H2VFd0tt8NrfjCdO5WWKUtaZRg+F3WbC1sM7/QuEMdwIUAdTf5uxR+1
	 OUNEOhpANcMhuuAp7BI/V2dfN+6BpJlcftZGmgIUbVq1Z4C15d2Vu1B9oTYnZI2K1C
	 KoDEWXpmcnGKlGb3y7NsLXyrOakCWKBwyCxFDqEM=
Date: Sat, 1 Jul 2023 11:57:30 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, Chris Zankel <chris@zankel.net>,
	Max Filippov <jcmvbkbc@gmail.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	linux-parisc <linux-parisc@vger.kernel.org>,
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
Message-ID: <2023070124-electable-gear-f99e@gregkh>
References: <20230629184151.888604958@linuxfoundation.org>
 <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net>
 <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
 <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
 <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net>
 <CAHk-=whh_aUHYF6LCV36K9NYHR4ofEZ0gwcg0RY5hj=B7AT4YQ@mail.gmail.com>
 <e4dd115b-1a41-4859-bbeb-b3a6a75bf664@roeck-us.net>
 <CAHk-=wgBAhFqD6aoD2rL0qws8S1erdbrvmQXuYi=ZFEUVNuVfg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wgBAhFqD6aoD2rL0qws8S1erdbrvmQXuYi=ZFEUVNuVfg@mail.gmail.com>

On Fri, Jun 30, 2023 at 09:22:45PM -0700, Linus Torvalds wrote:
> On Fri, 30 Jun 2023 at 19:50, Guenter Roeck <linux@roeck-us.net> wrote:
> >
> > Yes, the patch below fixes the problem.
> >
> > Building xtensa:de212:kc705-nommu:nommu_kc705_defconfig ... running ......... passed
> 
> Thanks. Committed as
> 
>   d85a143b69ab ("xtensa: fix NOMMU build with lock_mm_and_find_vma()
> conversion")
> 
> and pushed out.

Thanks, now queued up.

greg k-h
