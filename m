Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19DB7142E9F
	for <patches@lists.linux.dev>; Mon,  8 Apr 2024 17:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712596558; cv=none; b=QxdFq9fubRAp0MNlQ5bcse5DCdwgdTiOVlngM25LkgIvTXm1Mc5063pnvTH6h6Fb9k5AvfwtSPeXPYW39gR+GHUHOWD+8dtitXSGUCzMEzhIeCckT4LodsQ7vQr+aGjd+8/T8xyA1On6uiAJ1WZCzlQWt/ODM7tMQRH0z7ZSrhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712596558; c=relaxed/simple;
	bh=WzIOBFBkD2VF+X/O36wHgqJzYEwGWtCcZYrHSWH0pUE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aIY9TRpukg6Ah62zjzO01MM3t9se18aAOXzdZQEO87bLZKQfodqk8ZcprniASfNjxYcLP+s8jLLrMqhHWa+lJ0xNgxTcWHaZ6XxnF4NV9sXd5NocqX2SWOd5fi62Jgdz56IV31q6/T1696p/hDGVkue0YZ8j92o9XWJD4icY0eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wG46l7lV; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wG46l7lV"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7e3d5cfd81fso722315241.3
        for <patches@lists.linux.dev>; Mon, 08 Apr 2024 10:15:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712596556; x=1713201356; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qMNf7A6k8nLtZDPsfj34GNgCGUzYdTJ3ArVvRF7NLxI=;
        b=wG46l7lVKeYHyRWLu6gyl8DgKW300dn+LigTz9RKge6LVtSXMHC/0SMs9nygVcDBr0
         8sGvpXBReBaKEhHq0e7vr0fco5aENQ8nr4LcmG7JY2rxfaYOoUE7xRaOw8sRZtSc7dQv
         0GWspBwTYcI06g5RB+z3jpgi08Q0mSXlCNbFcI6LfOtl4uuBZtyRWzTDm+UfbM04GLNt
         iXZWIJqD/FB1XKu3ThlazMRNMZUVTM9nmyXSjiDzXX9btVWliIvjOGehNjMRlwQyzT1z
         FrwvhrXVYASftoBnLewaaXeOO8I7dmQKDepatolI0GwVvfTA6+B1JOnKk6qQS9GH6HES
         RdmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712596556; x=1713201356;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qMNf7A6k8nLtZDPsfj34GNgCGUzYdTJ3ArVvRF7NLxI=;
        b=Iq3Am1+YCuaoH0/WQDUPdSe+Vizg4WQKEYHmft7SZMn2IyGJMcRHyHT7XHYSn0KK5V
         kI/u4h0qHK7SDxLWnqEOMbJHc0dDWwzsM/GyGXnVXrYLpTYYMLCYWpeLOgs8Mgq4QZp5
         PcmGpzGMq4idm4yd2KZgLX//mX6D8kYhCXJMfkfguxv0U3Lo80wIUNa8PvHuEfNJ8vOq
         EOKl/BEvGXhgpfO6MUflIEvOS2IjR/uoUO5zwIweiN6AMFN/1S32UZCgFpLZT4q9YWX4
         mK7axq4oSCyC02A/Ks1Pw47uBrkML9oUx/vM7ySfFGwo9lFB5eVza2Oldxl6jmpG8Wo6
         +/QQ==
X-Forwarded-Encrypted: i=1; AJvYcCXkHTKXglYrT+uZE29NwUfLWPYTKvWKJJEunNC/TToaxRm4ODV1GkTk5jXmgwS0nw9pLSpiXZwLtzRZhjdkFlL1c1MgTgLrEg==
X-Gm-Message-State: AOJu0YxXQmpWexSCgO8i26DtL2mQn/NNqMmdySJ64SsRC34pz8pYVb4k
	bQPLVMZVbNAb/cF5PAcnsNK8ucFM8liungjyE3CSIdmLoztrtpA2CiaxsCDPEzikPP5oouKzzXr
	wenN9t9CQLpuENC+fh478txLREh/bT7pBypbF0Q==
X-Google-Smtp-Source: AGHT+IGH5m+zw44aHKIWpc2eCPDcCytI9gca4fjAbaev/T3kTlbpcREmReh2WF2ua2H28ryZdpuTMcSK6lK7YYEObFE=
X-Received: by 2002:a05:6102:6ca:b0:47a:ff5:fcc5 with SMTP id
 m10-20020a05610206ca00b0047a0ff5fcc5mr1097660vsg.4.1712596555926; Mon, 08 Apr
 2024 10:15:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240408125306.643546457@linuxfoundation.org>
In-Reply-To: <20240408125306.643546457@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 8 Apr 2024 22:45:44 +0530
Message-ID: <CA+G9fYsvgN2ixfmDKc_x8yFnZ3SfrmSV5Ck1QC5KfmYN89CFYQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/252] 6.6.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Thomas Richter <tmricht@linux.ibm.com>, 
	Sumanth Korikkar <sumanthk@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Apr 2024 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Apr 2024 12:52:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The s390 defconfig build failed with gcc-13 and clang-17 due following
build warning / errors on Linux stable-rc linux-6.6.y.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build error:
--------
arch/s390/kernel/perf_pai_crypto.c: In function 'paicrypt_stop':
arch/s390/kernel/perf_pai_crypto.c:280:51: error: 'paicrypt_root'
undeclared (first use in this function); did you mean 'paicrypt_stop'?
  280 |         struct paicrypt_mapptr *mp = this_cpu_ptr(paicrypt_root.mapptr);
      |                                                   ^~~~~~~~~~~~~

Commit detail,
  s390/pai: fix sampling event removal for PMU device driver
  [ Upstream commit e9f3af02f63909f41b43c28330434cc437639c5c ]

Steps to reproduce:
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig

Links:
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.25-253-gec59b99017e9/testrun/23347738/suite/build/test/gcc-13-defconfig/log
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.25-253-gec59b99017e9/testrun/23347738/suite/build/test/gcc-13-defconfig/details/
  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2eozoS8GQGxb94EUWNTPuXvYjVU/


--
Linaro LKFT
https://lkft.linaro.org
