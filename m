Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882821C02
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 15:45:22 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id v18so9196729uak.8
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 08:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681832721; x=1684424721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=L4xuHYnJcIADbZVCzqNAa7tRE/8fKfDvfp8oWIUoQkA=;
        b=vVrNiKKrFvSjmYjIYlffX2yP80cNVa3eT1BEDGMSrZdkz8HmxfzQCdlfmAjQA6zTiX
         XjIhliOPyuCLMWmXY0ASaWCusMWydjVVSZa+y+UBpfMSs//0q+JSQIbAnpmI4vPhNRkM
         qbD/0TKOIncXTZRcr2oLDLWyYCzS4WSMjwTChiT9qzXfi0hxzRY93BTsW0Qb3EHZLfVd
         hgDGyMHpUItvwfkauS3kE0bOJholTpusKn9eft0WharB0k8vXuQz6hNrcXJG5uwkJa7U
         YKj0mIDCLEKhCrsoXqmzkZ0IwrXOLROTJvlxTEpAT4M9ItB8j8jWU8gCGGfFJ9Cs8M9M
         w4tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681832721; x=1684424721;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L4xuHYnJcIADbZVCzqNAa7tRE/8fKfDvfp8oWIUoQkA=;
        b=A8NneEzlks4O2VWM+l0DQhTjzV6cC8fGrEYX41NcDO9WnS/6h0c4SN6q7+h9crYjPE
         g0yn39xWO+5M6qtVORlGoIGvo2tafEZItSmosrdwAaM0nC2mlMzOsO+WnUQM2AemVGPI
         9hhw7GtpG7a25jzi9GzK3xZX3Y+yUFtWeEK742ZMR3uZDGy1pW3s5ekREHZdQB5aKgbG
         lKKJ5JXHZtzrT4zt/edoLpuGzfpuSzqnZdhC8Y4vB4p9JDkGA7phgEzyFANIvQiHqfl8
         RCSG4+97lk/y5ehUYiVFNnGb+XFkdTPBy0aPgSVr6PESzmaWISaRj2LFsTfPnZUaREOh
         U5HQ==
X-Gm-Message-State: AAQBX9de+LvogsLq3WsiYCdT597zThEGscKopyY5maByyLplxPQolqj4
	8CJ20Lcrx6e/9v4CbR+TkJk0BP/etid4ImXbP9rOYw==
X-Google-Smtp-Source: AKy350bueRFhEfd8rpuE8PRIsAQFBVm9kpzb9vt+uVxvuzLomJF9oo3kckUH3tqFEAz3Iej1mogFesld2Lb7iWxbRKY=
X-Received: by 2002:a1f:5f81:0:b0:43c:ac58:3020 with SMTP id
 t123-20020a1f5f81000000b0043cac583020mr5990756vkb.3.1681832721233; Tue, 18
 Apr 2023 08:45:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120309.539243408@linuxfoundation.org> <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <2023041819-canyon-unarmored-38c6@gregkh>
In-Reply-To: <2023041819-canyon-unarmored-38c6@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 18 Apr 2023 21:15:09 +0530
Message-ID: <CA+G9fYuSwpBW-_PubGFYsKi08=KrmsR=g9D4HDOvZP5pd4t0MQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Waiman Long <longman@redhat.com>, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Apr 2023 at 21:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
> > On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 5.10.178 release.
> > > There are 124 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Following build errors noticed on 5.15 and 5.10.,
> >
> >
> > > Waiman Long <longman@redhat.com>
> > >     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
> >
>
> That's a documentation patch, it can not:

Sorry for my mistake in trimming the email at the wrong place.

I have pasted down of the email as this suspected patch,

cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.


> > kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
> > kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
> > (first use in this function); did you mean 'cgroup_put'?
> >  2941 |         lockdep_assert_held(&cgroup_mutex);
>
> Cause this.
>
> What arch is failing here?  This builds for x86.

Not for me.

List of regression builds.

Regressions found on x86_64:
 - build/gcc-12-defconfig

Regressions found on i386:
 - build/gcc-12-defconfig
 - build/gcc-11-lkftconfig

Regressions found on arm64:
 - build/gcc-11-lkftconfig

Regressions found on arm:
 - build/gcc-12-vexpress_defconfig
 - build/gcc-8-vexpress_defconfig

Regressions found on mips:
 - build/gcc-8-defconfig
 - build/gcc-12-defconfig


For 5.10 defconfigs failed,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.176-298-g19b9d9b9f62e/testrun/16291316/suite/build/test/gcc-12-defconfig/history/


For 5.15 defconfigs failed,
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.105-280-g0b6a5617247c/testrun/16291199/suite/build/test/gcc-12-defconfig/history/


- Naresh
