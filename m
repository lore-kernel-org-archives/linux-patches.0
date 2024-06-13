Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5281B7E76D
	for <patches@lists.linux.dev>; Thu, 13 Jun 2024 14:46:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718289974; cv=none; b=TLITGFh672yUVYhdK6e+avNzGKuJMfrmBt5aKjhsRG00pvNeLEsaK9V2aHmvsyq8jcT4NJx9RlQzIpzo4YhvA8tDPkGOczEdES7FkJpgtn4mFkQnuk8zfvWrGcqYOZyzT7mDEML8YCvIhszzfiTKIF+yEv6yZ4LtEpYmJB0Wbgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718289974; c=relaxed/simple;
	bh=xiHUK0Hl49OuL+qGWj5fc6IwTuTt+eReSxMzlJBq9LQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LptF4jIOYsKVSIfyTxCPhaL4ci3+9yizKwJYfRdyTFwYOBRxU0koBPcRpMYE/cCCcOBBvL/ly9rXXhkFG9ih37BIy60/HoZ/SAKXbeQdPOi66Ovky3+IpBDEgab+CVZENH4QctayzQPLJNVb5VOAMNG1GOrE8LS2/Kf4D3c+Cqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X9nDeO7B; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X9nDeO7B"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-48d7a7f3580so392345137.2
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 07:46:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718289972; x=1718894772; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rvoqFktMtHUyhGkKds1q+Wy+a/Ekxv2ikOOyTUk3yNk=;
        b=X9nDeO7BY7mLzln6vCsAehfGSJP5rppria5oEEbipxyA/+S26lvxlymC9/uSg0NTY1
         dJm652QqIFeYDSEIhy9omwutXdUPSq08M8LLiROZqBI8vER8kRtr3bze3NQG93Uws3W+
         IGRqUprnKbp3u59vWQ+ujWI6Kwyjy9DJmBD/+xodUwdRZP+q0mHFsFi3cvosHvXz5hFq
         LEsavQwJoHawEdEmC13AJ6/zL9iglMu/8fhW5jrLFyB8QftdHYboGChk9wL0kmDcfXee
         K8q6e77vJPS5pJYfGEWYscPgagD1kiDcMjRAOuwkxYdaJTtdV+HnAYLOg1Zd+zIvBRZE
         d/GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718289972; x=1718894772;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rvoqFktMtHUyhGkKds1q+Wy+a/Ekxv2ikOOyTUk3yNk=;
        b=Mrr/n1msrld+0DeApwZHK2p0uqmIlxmVELm6in56fkLc63WBeWSPRD4S9rNAJnU6Vw
         ++STbEhf00K/W+JPDLkcBWG/nl6+LbAzoV035hm/Mt0DZvgobwwtnJO4WPVQkQXRvKJd
         gpsxoZGnaQp5CHB6XzbUxOqcbOZjsqI3tfTNNE9DRup4jvU9m2aUv561W+0UbWXLRL9D
         n+ie4C0Ox9Gl/0hLl3Pwgssw12EEKuKl+Mz8nQVcFDDRTZvEUVlnGXvCRT9pevCNYdvh
         pAj402Jfq3SBeWQb7ARFygythPb/KOV2Wr1ccqFGshuIel2N1R3qq+3GQYC37obgmokD
         moyg==
X-Forwarded-Encrypted: i=1; AJvYcCUQNmADWzCriM2f+zpoUuD5mprY9SFd8uEEcymiyzimyGM7/lO3gDDKLi5kH4Eoox+RS/nbiffi6Dwvo7TKRReJ4pQDtuN1/A==
X-Gm-Message-State: AOJu0Yzh8e1DeBo9oHdUutCpB4FIgtJktbNuVmA4AoRd3FrBsIWiz8WY
	ukP2TWGSkSXghx520qzC3kpWbQoRkJMbebjG02gwq3BGZjXQDRtrQpM3OWyYWvfHi3AdFqMlnbX
	5ddWlHf/bITZmfbs3h3dq/aXTRLXctrxcQIg3LA==
X-Google-Smtp-Source: AGHT+IH38Aaw8rZu9RWd7Y+SDv6K4CnE1Hl3fG5nWdWaMlQqDlbOxbQUuo/F9YbFyeIsxIWTnw6Q7JRYBqIgCDcz8/o=
X-Received: by 2002:a05:6122:2012:b0:4e4:ea24:4c53 with SMTP id
 71dfb90a1353d-4ee3db819e4mr70580e0c.3.1718289971414; Thu, 13 Jun 2024
 07:46:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113223.281378087@linuxfoundation.org>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 13 Jun 2024 20:15:59 +0530
Message-ID: <CA+G9fYtEkcPasc62FH170nPyJTS83jfdAtHUfgwG+QDuQP060g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Puranjay Mohan <puranjay@kernel.org>, 
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Michael Ellerman <mpe@ellerman.id.au>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 13 Jun 2024 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The powerpc defconfig builds failed on stable-rc 6.6 branch due to below
build errors with gcc-13, gcc-8 and clang.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
----
arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit_comp64.c:1010:73: error: 'fimage' undeclared
(first use in this function); did you mean 'image'?
 1010 |                                 ret =
bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
      |
         ^~~~~~
      |
         image
arch/powerpc/net/bpf_jit_comp64.c:1010:73: note: each undeclared
identifier is reported only once for each function it appears in


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.32-876-g8429fc3308da/testrun/24327571/suite/build/test/gcc-13-defconfig/log

--
Linaro LKFT
https://lkft.linaro.org
