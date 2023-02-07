Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA54D566F
	for <patches@lists.linux.dev>; Tue,  7 Feb 2023 17:05:31 +0000 (UTC)
Received: by mail-vs1-f51.google.com with SMTP id k4so16958833vsc.4
        for <patches@lists.linux.dev>; Tue, 07 Feb 2023 09:05:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jy30Q5CoBNY/fYhc8eo/JNrKPpHvqjYzbsThzSZQ05U=;
        b=Y31FS5ez5mYuEOMGf2wYCnFBEFEciLaVqR+RLWmFlbxCWqOcmkY14QtUZ7dkFhmC+O
         PDMSq5yzcXI0T51xRc/2s/UUFykhNMSyTQzICJHHIJRU2izA1t4KSHk8yktXRxJNxVrT
         ZiT8DXZJ5smC06drjvdCOyyl7mjXb42jQEBBKggsQI+/+KFu841IuGjrTVshxJ6Av/0+
         QqaZKhEPbLglpIHV8DjD3RJiOR8xMrEwyxhEQXoO2NuEEafSRYCBlBMshBy1jA1qpsOp
         MO2V3JVupMw82IwwE7ysHQm4YaNsvaLHusal1GRsGQQM4P5uH6J3KdukdTJeqkJVjalb
         Xqiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jy30Q5CoBNY/fYhc8eo/JNrKPpHvqjYzbsThzSZQ05U=;
        b=l4UVjdv9e217d0CMpIHstw9dNcl2LsLN0LuhTdew9j8ZUvSZmw8njxJ9su5OvLKlx3
         TZgLNGhSjCDaMGPtEgI8T8lcSj6TfEJW5N74WT3QUzZcN9xfW+92z/6f26WV50vTDSDc
         Kwg3m8seF+ZWu47CUPMz59RMpWEFmjQb0DEQ/Y/rrcobP2DqxI52bPX+w+M6vy/W0p6R
         WQDfu7HoTOYNlgYl3OJpxbq7Tww6XZf1jfC3S/yvbFWGBV/3bcUklBbKjfI/8in4KHgO
         OUxigCU/BuqL2PaAWg5i3XkYbClHLJ4EtjH7eWZKnh1upjoFyGqd5lQRumvd68AhbN8r
         8UiA==
X-Gm-Message-State: AO0yUKWywuGbx3Mj3haNkBCF8hsCewn8m0N4MIXIHIDT0PpFdYxEigN/
	pt44naM7RZPmK4bRodp5gCwqAroTMqPLgxNBKafDjw==
X-Google-Smtp-Source: AK7set9uk3OElOHb0yhkRGf2onss+eUAKY+U2mMVPjOU31IcxZDvidX54UErqpO3uYDm9FSXb5UH8kR/BztMfS422qM=
X-Received: by 2002:a05:6102:3c4:b0:3ed:7a8f:d181 with SMTP id
 n4-20020a05610203c400b003ed7a8fd181mr794571vsq.3.1675789530500; Tue, 07 Feb
 2023 09:05:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230207125634.292109991@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Feb 2023 22:35:19 +0530
Message-ID: <CA+G9fYtgJX507GJ3fG7-G+vGhG4BnU=kzu3fOH_a-_aMU0S_0w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Peter Xu <peterx@redhat.com>, 
	Mike Kravetz <mike.kravetz@oracle.com>, Jann Horn <jannh@google.com>, 
	Anders Roxell <anders.roxell@linaro.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 7 Feb 2023 at 18:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Following build regressions noticed while building
selftests/vm/hugetlb-madvise.c
with kselftest-merge configs.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build errors:
----------
hugetlb-madvise.c:242:13: warning: implicit declaration of function
'fallocate'; did you mean 'alloca'? [-Wimplicit-function-declaration]
  242 |         if (fallocate(fd, 0, 0, NR_HUGE_PAGES * huge_page_size)) {
      |             ^~~~~~~~~
      |             alloca
hugetlb-madvise.c:289:27: error: 'FALLOC_FL_PUNCH_HOLE' undeclared
(first use in this function)
  289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZ=
E,
      |                           ^~~~~~~~~~~~~~~~~~~~
hugetlb-madvise.c:289:27: note: each undeclared identifier is reported
only once for each function it appears in
hugetlb-madvise.c:289:50: error: 'FALLOC_FL_KEEP_SIZE' undeclared
(first use in this function)
  289 |         if (fallocate(fd, FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZ=
E,
      |                                                  ^~~~~~~~~~~~~~~~~~=
~
make[3]: *** [../lib.mk:145:
/home/tuxbuild/.cache/tuxmake/builds/1/build/kselftest/vm/hugetlb-madvise]
Error 1

Build log:
https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc/-/jobs/372819=
8425#L1676
https://storage.tuxsuite.com/public/linaro/lkft/builds/2LPeQeCIu0YEfltwqAFC=
vDaj29A/

--
Linaro LKFT
https://lkft.linaro.org
