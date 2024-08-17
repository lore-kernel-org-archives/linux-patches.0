Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8940012CDB6
	for <patches@lists.linux.dev>; Sat, 17 Aug 2024 05:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723874273; cv=none; b=PJshbA44KNXNEOScg4J1WGncFuXXx7+BNVeuCL7g5q3JcCyfkTZKZbCKPYdfBr3+AbzLl1RafdO8Bv3EXOyLBeH9qF4P1XdaAfMdEbErFnsugDb5+kq03sgn8Y5Q5+U387TFVKEimuc6HuazBFSbNYnhEW+Owow29M1s7WXUXx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723874273; c=relaxed/simple;
	bh=L6/kkT9rKApXwS91JQDNsORr/X1GI+rDEPlBF/B/ELo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MJKRo/dlQxuhB5hjk3DXTBZ7v5b7WgcncctfhuSllg8Q+odQHk+RTWUrH55O5RGF+vTo0pWqNYR8MhbygINO7/3nCNkrtC3Vc2LztjmmGUzan74HmuXD1eAK6y3oEQyu2lnBReTWzYGYMDENNEeBCtGvJG01IHbpPQ2nSFsw9RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=npmGRmUE; arc=none smtp.client-ip=209.85.219.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="npmGRmUE"
Received: by mail-qv1-f50.google.com with SMTP id 6a1803df08f44-6bf7a2035d9so18376386d6.1
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 22:57:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723874270; x=1724479070; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Lu4Nl0GB1iED2MWCr04OB+Jfo3hv8Ww3jPrNd67fLNQ=;
        b=npmGRmUEEYm0uv2cw/QZ+CWcB4TpGc8mfgGuKGraf5pYiq53hoawg/oxeaDHUABSmu
         ExWq9QMNXLlH/lUleKn2kp3JcnCvU2jUalOp3jgxW4yNuVwf8z5SQMq6S+oe2TlmFE8q
         XRE4TYcAmc1vzx3BeBqIEgV5DBl5QdHPA6czrQ5y/aar6uaYs8YrMhLh/VkZLvb13Q7c
         S8K6j1dn7Jtbf12EWyZs1wyYIC9fEMsmOHsQMGJX8qqthuOdZoHujUSwh+5rmQh14oap
         rSYu1FsxaRoL7wC/4ETcTLasvkyJD8Ne4PISXiq7r64Z8P4huHtXhMkTrzBYuxb4W2qJ
         uwag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723874270; x=1724479070;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Lu4Nl0GB1iED2MWCr04OB+Jfo3hv8Ww3jPrNd67fLNQ=;
        b=Is9QFLOhJkw93lgQelcD99us0/iesTs4IPaSsS7dETv55eV+NVjgMvUxEMJL2y2Fv9
         gIHZMKCI0+5UPelo9givfIZwJpY2nJ4RfvwL13Sv4J2YLcWUmhS6C22oEp2DdZwZLMw8
         x2lGPCw+OeC4RvF7o07EPCDFIgZSTZO3ainDNlJnNW+05niPXE+3JITK0x18oIz8rDLK
         aKlEwvXZPuye6yr7sluYUUdU1UxXI5SAU3hpFUKV5xg7X53oQu7tWuFhwR4CZoP/VFb7
         ec1ZFAsB0WWdog5tM6aoNo/agdZkI81tz7hZNR9Kb5+aI8Pglb0/W5rXepAr6CEg43ka
         0PhQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAJgHeSNasz/sqopv6BirnhkgrADc6tvzWMBqBJjcvdrdfZrGSg+OnlLuguac7e7obew5jXfNmmfHHDh18v91GWdES1hnLjQ==
X-Gm-Message-State: AOJu0YwUyaHZDvV64Q/6NTmkpQz3LXxEprWD+ngofwr+9XD8ranXh59V
	esrWfCG+1GqW5km5geAIAs4bYjRBadUNwRp+7C+DOLPHZV8S4PTDFLi0BHD/adABWSz/oCo/ESv
	OAuTa3YNz6adM1a3okUHR9kH/Gof63dIHudKP1aETk1QDvAVhePJXKw==
X-Google-Smtp-Source: AGHT+IE+sUu9pWEuBlQvuPiIymkPTnth27ELlW5XvrnyJPCs70aN5KVC2LtEGJ+bMm2rNvH1MKufn+f3an7JwP3laYM=
X-Received: by 2002:a05:6214:1c48:b0:6b5:2062:dd5c with SMTP id
 6a1803df08f44-6bf6dd61a57mr140443316d6.8.1723874270359; Fri, 16 Aug 2024
 22:57:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240816101509.001640500@linuxfoundation.org>
In-Reply-To: <20240816101509.001640500@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Sat, 17 Aug 2024 07:57:39 +0200
Message-ID: <CADYN=9+gT_me8D_+KtWqmS9_vZg7=dTat90dPCNSieSjq9sFXg@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/350] 5.10.224-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Claudio Imbrenda <imbrenda@linux.ibm.com>, linux-s390@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 16 Aug 2024 at 12:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 350 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Aug 2024 10:14:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following S390 build failed on stable-rc 5.10.y with gcc-12 and clang due
to following warnings and errors [1].

s390:
  build:
    * gcc-8-defconfig-fe40093d
    * gcc-12-defconfig
    * clang-18-defconfig


Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

The bisect points to 0fbb54ce4bff ("KVM: s390: pv: avoid stalls when
making pages secure")
as the problematic commit [ Upstream commit
f0a1a0615a6ff6d38af2c65a522698fb4bb85df6 ].

Build log:
--------
/builds/linux/arch/s390/kernel/uv.c: In function 'make_page_secure':
/builds/linux/arch/s390/kernel/uv.c:240:19: error: 'UVC_CC_OK'
undeclared (first use in this function)
  240 |         if (cc == UVC_CC_OK)
      |                   ^~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c:240:19: note: each undeclared
identifier is reported only once for each function it appears in
/builds/linux/arch/s390/kernel/uv.c:242:24: error: 'UVC_CC_BUSY'
undeclared (first use in this function); did you mean 'SIGP_CC_BUSY'?
  242 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
      |                        ^~~~~~~~~~~
      |                        SIGP_CC_BUSY
/builds/linux/arch/s390/kernel/uv.c:242:45: error: 'UVC_CC_PARTIAL'
undeclared (first use in this function)
  242 |         else if (cc == UVC_CC_BUSY || cc == UVC_CC_PARTIAL)
      |                                             ^~~~~~~~~~~~~~
/builds/linux/arch/s390/kernel/uv.c: In function 'should_export_before_import':
/builds/linux/arch/s390/kernel/uv.c:270:40: error: 'mm_context_t' has
no member named 'protected_count'
  270 |         return atomic_read(&mm->context.protected_count) > 1;
      |                                        ^
/builds/linux/arch/s390/kernel/uv.c:271:1: error: control reaches end
of non-void function [-Werror=return-type]
  271 | }
      | ^
cc1: some warnings being treated as errors
make[3]: *** [/builds/linux/scripts/Makefile.build:286:
arch/s390/kernel/uv.o] Error 1


Build log link:
--------
[1] https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-351-g470450f8c61c/testrun/24890569/suite/build/test/gcc-12-defconfig/log

metadata:
--------
* kernel: 5.10.224-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 470450f8c61c0d2248174891cb188c5378eb5d22
* git describe: v5.10.223-351-g470450f8c61c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.223-351-g470450f8c61c
* arch: s390
* toolchain: gcc-12, clang
* config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2kjlITR0fntaWX0F0o4bJ62HPb6/config
* download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2kjlITR0fntaWX0F0o4bJ62HPb6/

--
Linaro LKFT
https://lkft.linaro.org
