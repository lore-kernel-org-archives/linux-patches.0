Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA183131732
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 09:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718356540; cv=none; b=TTburtg97gEexCQ/SQ+SdvGQ93ZuSkR1HgazCcJ6QpaatEA96/SGbz3GShm0MyHoRDpjFBjN3N5G1WD2DvzCuhZeFAyyzAO+C1akiCrOVDwiXKCWkFPCc2ntkMRM3IIf1G4e44IZmsN1/6PrTSvZc5MK0QDHz/YMAtMkCyrluPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718356540; c=relaxed/simple;
	bh=/JZG/AGW8YO9YEwzpQSbeXxjZz1kRWU7PMN2yTnHC3Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aqWxK1YGUNqMo6Y1jD4u14jk+tG1dDrqUo7G2eIcUxzp7BSwVnbuT1F8KK7LsvBTGlM0aZLCIjDuOtPK2Sr6iMdTKqAA5qvZPm8c3kAh4OWPAW3llOrKO3CLhKNCYrf7H23jJGheebAVsYvPQridQmPcTUcyoTmCv8HV6jq0QJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=U2kLTrW/; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="U2kLTrW/"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-48da5edc11dso822042137.0
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 02:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718356537; x=1718961337; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p5t2Wj1oXu+8rhsC44ZuFPYafYW/0+ix7sLMBpjY/38=;
        b=U2kLTrW/NHWhxCDU42G+0g8Bn+HKoJ3tXyIkUsxFoUXDIK5CbKNV14yjPrnU0yiEaW
         NrDb1DloWNmr9OAhcUPREKc14AyDaEl7tlBl45GTBUfe5MoRbwKqD0uSOyxkLzWy+UxT
         qtA7JcFU5GBQxODZWQpNYTR5u96EImqF2cmpacR1d1vKlJznQvag5KyxXZpeq1Qcu/Ac
         TsQVf4d0iryCC3QDqCMvSfpPznzZbzH6faSsBZ93lsHevlemeUxs1tKe/XXxrWyKaUz2
         dwSmqmj7ZAvy6jJbdi+htsfJzlcJblP7MR66LWk2MG82o//zBg1RrhMoIYOH9lisck+2
         SlDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718356537; x=1718961337;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p5t2Wj1oXu+8rhsC44ZuFPYafYW/0+ix7sLMBpjY/38=;
        b=oduFdk2zuusD3ZFOaOrkM9Al/UQc/0BytYruSN/KGH6kSbgNeeXOGEaossgZtYDb/q
         m91X2IYWgRPUJ0lPocSYO/duQX0SmROMC8miBRF3hzK0Pq4ChvfcAAWyt8NIU4U4NkSx
         TgtzLSGFERNxJoecq7PlkX0cd8co7Dt+BVaAE/N3R3mV9ToO/PYOHbApmjna6dc1VQ5H
         FarSrpyCMr1H6EQpT+YRx8sGuOPBCJfGkCb6wLKNG6aW/iGMwyVznLPtAOvUbBLPuUUx
         Qv7DqATsWEP/6qyxWYVAoethxEisWbEmagPbRe5XmQGSyB5Qjop6sWfsjgfNwU2ow0gf
         45pw==
X-Forwarded-Encrypted: i=1; AJvYcCWyv4fc4ja7h2zdVsa7M/hXGbBUk0l+cGxN5LI9uS8sjbzhCz4OHOctUHadKdrNdcNc2Gx6rJ6PjKJGxplDO5y9P//OA9Xftw==
X-Gm-Message-State: AOJu0YxQddcZBY7nfU9t2eOME3q+hRjGI2+yBG35BLnGTaTeKfY19mGW
	dbKTovczdTW/VPvQzc12YVqfduA0W6jI9us0NJEWnmS9Kk5VCywq9iMr/qZtza5vPfUj7Yv9PrJ
	0c7atVSyWWp7tab2ZEDqqYpbZidZS8qbhkpku4g==
X-Google-Smtp-Source: AGHT+IE3eSj2stOVQBL5thdzjGaVBKFsIPShMAnCCjVqEowRbjHRfmjek5eDn/iLg3Kys0gPCOQmwn2hEbOoZKuDtZg=
X-Received: by 2002:a05:6102:304e:b0:48d:a16c:9c9d with SMTP id
 ada2fe7eead31-48db4f00688mr472940137.4.1718356537574; Fri, 14 Jun 2024
 02:15:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113223.281378087@linuxfoundation.org> <CA+G9fYtEkcPasc62FH170nPyJTS83jfdAtHUfgwG+QDuQP060g@mail.gmail.com>
In-Reply-To: <CA+G9fYtEkcPasc62FH170nPyJTS83jfdAtHUfgwG+QDuQP060g@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Jun 2024 14:45:25 +0530
Message-ID: <CA+G9fYvwJxJdsSeTGsKjKonkiJnDC13t1+mpjHhyCvc_2r3=-w@mail.gmail.com>
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

On Thu, 13 Jun 2024 at 20:15, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Thu, 13 Jun 2024 at 17:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.34 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.34-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> The powerpc defconfig builds failed on stable-rc 6.6 branch due to below
> build errors with gcc-13, gcc-8 and clang.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> Build log:
> ----
> arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
> arch/powerpc/net/bpf_jit_comp64.c:1010:73: error: 'fimage' undeclared
> (first use in this function); did you mean 'image'?
>  1010 |                                 ret =
> bpf_jit_emit_func_call_hlp(image, fimage, ctx, func_addr);
>       |
>          ^~~~~~
>       |
>          image
> arch/powerpc/net/bpf_jit_comp64.c:1010:73: note: each undeclared
> identifier is reported only once for each function it appears in

Anders bisected this and found following patch,
 first bad commit:
 [2298022fd5c6c428872f5741592526b8f4aadcf8]
  powerpc/64/bpf: fix tail calls for PCREL addressing

>
>
> Links:
>  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.32-876-g8429fc3308da/testrun/24327571/suite/build/test/gcc-13-defconfig/log
>
> --
> Linaro LKFT
> https://lkft.linaro.org

- Naresh
