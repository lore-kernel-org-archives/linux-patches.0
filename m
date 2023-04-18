Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2618D1C02
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 15:09:00 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id w19so10955702uad.7
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 08:08:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681830539; x=1684422539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G/Weo+bvn0zooGajGBsSKQ5BWYoFH9k7Hf0s1B3WbB4=;
        b=LpflOLy/oZ1Wgd6AgyWbtDal97yPX2e0T2ha8bGLAjsmkiw7S5c505UCFXRLYnmlHo
         TvRw8ryyaQ6gaiBoEson4u5M/DzCyKDP53ZGVYq5GxTpOHIOtKc2eU5i34BJ4deLwAFl
         vpu9l3XoEbZQlaW/Cb69p2o181LaDSPPOgK//sXMx3IX7yKXSmCnF/z/6JLKzXI9YTGu
         NqrfyLrGzMHeuiYWFkMvmRwVQsZuYzedfkYVOwrXzl+cs18tJM4i+H90j8TVuRt1kuid
         OGE8cFXbWIpL4OlG2/mfg2JR7lrMWRTjQ7MHOX2Xs/ybqgXnVnOy8ajr5IAkBt3uQVCl
         RGvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681830539; x=1684422539;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/Weo+bvn0zooGajGBsSKQ5BWYoFH9k7Hf0s1B3WbB4=;
        b=i+rEvK6YDcOBgij0KyuJNScUTPDnnW4Hi+PY1312hS8J0uJiCwrEAqqrxFT4MW/+hH
         15+RYM3YACdIsPabyA4aZNw0EIPnWZDqhzjMxPMHbxVL2gDLyGzImpjcxBq9CEF6bFEN
         lQllDZcurePgmaDUYb1cXzjD1nzDFgNWrZUsRTr3s4xSdd2HrEi12686WvS+b87zOw51
         os45iawctYCDpUGx+GvvQbNkXWmqcX4WLX9GcbgOO093FLMRNJErbT8zl3jDkhMSAKKp
         xXaYw4OykLVSG7nYQzSIa0KGDuLC1vEy9yCO9N7AY09c4mkSXSZNRiQKM1IE2969Grax
         tpWA==
X-Gm-Message-State: AAQBX9c9GEnpNcrCt7gEuX/GNiEJYJh4BX9SjZuZ4CSUN+ODJQR+h+Sv
	/Ba83SbqVvqr9EQFSVhFc1YzsfLZME7knnyGGO9GxA==
X-Google-Smtp-Source: AKy350bGSNHdehMJISDHG7Mv19IDo2CuVhhF1lsE/6unr9f0Onv7sLFAfpSy40caB9YZV4/3KFrTGRmuEB1tHv9Nc64=
X-Received: by 2002:a1f:d084:0:b0:43c:6e7d:60b0 with SMTP id
 h126-20020a1fd084000000b0043c6e7d60b0mr5019506vkg.15.1681830538767; Tue, 18
 Apr 2023 08:08:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120309.539243408@linuxfoundation.org>
In-Reply-To: <20230418120309.539243408@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 18 Apr 2023 20:38:47 +0530
Message-ID: <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
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

On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Following build errors noticed on 5.15 and 5.10.,


> Waiman Long <longman@redhat.com>
>     cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem

kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
(first use in this function); did you mean 'cgroup_put'?
 2941 |         lockdep_assert_held(&cgroup_mutex);
      |                              ^~~~~~~~~~~~

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Suspected commit,
cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.


--
Linaro LKFT
https://lkft.linaro.org
