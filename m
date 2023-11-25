Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC668FBE9;
	Sat, 25 Nov 2023 15:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkAv3cJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B353FC433C7;
	Sat, 25 Nov 2023 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700926209;
	bh=31n5C6JKrWIHSje0ilrkHsM3yCh1HSsj5jAlHU3/AoQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bkAv3cJlO8TBetnPiPYluPlVKIOkyMH0N+ULI4COp6OkUU1Y3xgQeY3sZxSebzUxX
	 YNxmpjSlaftfzFYl0nTB2hgLPqJJQp376FYkWOYjYdfW7XtAu+ZbyZdGO4ucsmkGWZ
	 bHunmPgEomJIcGD3xuowOt2s5PaB9n23DAoNcdKQ=
Date: Sat, 25 Nov 2023 15:30:06 +0000
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Zhen Lei <thunder.leizhen@huawei.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	Frederic Weisbecker <frederic@kernel.org>,
	"Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Subject: Re: [PATCH 6.1 000/372] 6.1.64-rc1 review
Message-ID: <2023112555-grief-reanalyze-2a8a@gregkh>
References: <20231124172010.413667921@linuxfoundation.org>
 <CA+G9fYs1QwVjKK0wBcm2EtDbSbvG7fu7Ca=SBAZfGDAsEJLPZw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYs1QwVjKK0wBcm2EtDbSbvG7fu7Ca=SBAZfGDAsEJLPZw@mail.gmail.com>

On Sat, Nov 25, 2023 at 12:48:17AM +0530, Naresh Kamboju wrote:
> On Sat, 25 Nov 2023 at 00:17, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.64 release.
> > There are 372 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 26 Nov 2023 17:19:17 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following build warnings / errors noticed while building the
> arm64 tinyconfig on stable-rc linux-6.1.y, linux-6.5.y and linux-6.6.y.
> 
> > Zhen Lei <thunder.leizhen@huawei.com>
> >     rcu: Dump memory object info if callback function is invalid
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> Build log:
> kernel/rcu/update.c:49:
> kernel/rcu/rcu.h: In function 'debug_rcu_head_callback':
> kernel/rcu/rcu.h:218:17: error: implicit declaration of function
> 'kmem_dump_obj'; did you mean 'mem_dump_obj'?
> [-Werror=implicit-function-declaration]
>   218 |                 kmem_dump_obj(rhp);
>       |                 ^~~~~~~~~~~~~
>       |                 mem_dump_obj
> cc1: some warnings being treated as errors

Now dropped from everywhere, thanks.

greg k-h
