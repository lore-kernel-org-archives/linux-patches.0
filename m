Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51AA31C02
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 15:34:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 775E4C433D2;
	Tue, 18 Apr 2023 15:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681832079;
	bh=0qFKzUehbJ2vWu8bH2o2ePqZ/8AeK7d2HGLZjQsJIGg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=syMEZX6Z3GN6cpyq3Bz785LlFF+rS9iBRAeM7KS6cF+hUm5Egl1tKOV7lexf/qfsx
	 /RpsIrjWFSDFCDk8vpYs1zqHDOrkKmvOUPRGGjbZei34As9J7nAv+e1M85juV5hVNI
	 QiJB/nYRzYE6lnB3sj+oxsD/6F7rPAhDiPlXfMTQ=
Date: Tue, 18 Apr 2023 17:34:36 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
	Michal =?iso-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Message-ID: <2023041819-canyon-unarmored-38c6@gregkh>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>

On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
> On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.178 release.
> > There are 124 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Following build errors noticed on 5.15 and 5.10.,
> 
> 
> > Waiman Long <longman@redhat.com>
> >     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
>

That's a documentation patch, it can not:

> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> (first use in this function); did you mean 'cgroup_put'?
>  2941 |         lockdep_assert_held(&cgroup_mutex);

Cause this.

What arch is failing here?  This builds for x86.

thanks,

greg k-h
