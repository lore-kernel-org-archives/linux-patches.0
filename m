Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FA012AB36
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 18:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gkYzHS9Z"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-694ed847889so2165445b3a.2
        for <patches@lists.linux.dev>; Fri, 06 Oct 2023 11:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696617738; x=1697222538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UUg2EZ7t6QbVRPnDWD48q594BNWRx78W4j0XN10BHAI=;
        b=gkYzHS9ZKVoF19Io75PTsdhP2otY5vDWYdoIp3KqASxow+TnpjX/yfAQju2tQr4rCb
         mriGFQgq9y7OEcNiMqXGOfs7PbrWhhT30NqKAv3RE0ucY7aHI/CkEWA1J6/Cmwg18kRO
         B/bys6eP5efBqYdp5fGfj0vhgmj8altTAa2KPisfNstA1ZkX/GnQIWrZA2hiUnVYZDA1
         ifYLSC2vv+VfQC5nsgWUClMHYp4EhJou3zJYfvjEEE3EX+hza+kUr9hzDX+4asPBeA9e
         11sBBz+9XncerSOaaYeDY9VAzAl176puJey3c/1Vy6ch/mYCXagEmyCNXTuhFvkINe32
         za5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696617738; x=1697222538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UUg2EZ7t6QbVRPnDWD48q594BNWRx78W4j0XN10BHAI=;
        b=k9DMwJwUyYbAy8KdcJJev0vth9CnjcbFJUem19yzMN9cX25rz+LQGBWBM88SIjQ4mN
         /C+WvbDdpzb38DgYnrAccA7CCzSG+3aRJlC28F+doxX2R7MFu2MCMrZXF1hHZHS1dayn
         sDHK4BdAtgjJ/R7AlvBkno7NXDlWwolKGmUSyRRveyzEuX7CbrZ/H201n6A23GakIxUa
         f4eIMK2IMsb1BieswjLcLuBowV2ai+mhTSO1oTSIrN0qYiuP8mUKfVLJ0Pz2t+xhpZ6T
         u3fa8kCuAVb6j6DV/8NsEa2G8U6EvNnNkSklQLd8shEMBB7P30z/yZl3TT+mWJt+vH2R
         +SAw==
X-Gm-Message-State: AOJu0YyuDXA+jwXOglFTS4inE8NbG/giXi3bUN+USv8qR556HGtnBKxb
	2dEkByhLUVbs1KXiVIODSkvHsMUnqmRSgWmaHREtMQ==
X-Google-Smtp-Source: AGHT+IHUgHZyUTaGNx4dt+tc7IETfj4Jd3vKuta+Ow98vKSTFqxL8VKDeSZBqnX6bo8pJV9HXU1eh1GpPub4W8AU5JA=
X-Received: by 2002:aa7:88ce:0:b0:690:b8b1:7b9e with SMTP id
 k14-20020aa788ce000000b00690b8b17b9emr8463628pff.0.1696617738312; Fri, 06 Oct
 2023 11:42:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org> <CA+G9fYsqbZhSQnEi-qSc7n+4d7nPap8HWcdbZGWLfo3mTH-L7A@mail.gmail.com>
In-Reply-To: <CA+G9fYsqbZhSQnEi-qSc7n+4d7nPap8HWcdbZGWLfo3mTH-L7A@mail.gmail.com>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Fri, 6 Oct 2023 12:42:04 -0600
Message-ID: <CAEUSe78O-Ho=22nTeioT4eqPRoDNfcWCpc=5O=B59eaMvOkzpg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>, linux-nfs@vger.kernel.org, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, Olga Kornievskaia <kolga@netapp.com>, 
	Benjamin Coddington <bcodding@redhat.com>, Anna Schumaker <Anna.Schumaker@netapp.com>, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, LTP List <ltp@lists.linux.it>, 
	Petr Vorel <pvorel@suse.cz>, Richard Palethorpe <rpalethorpe@suse.com>, Eryu Guan <eguan@redhat.com>, 
	chrubis <chrubis@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, 5 Oct 2023 at 10:40, Naresh Kamboju <naresh.kamboju@linaro.org> wro=
te:
> On Wed, 4 Oct 2023 at 23:41, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.1.56 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.1.56-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> Results from Linaro=E2=80=99s test farm.
> Regressions on arm64 bcm2711-rpi-4-b device running LTP dio tests on
> NFS mounted rootfs.
> and LTP hugetlb hugemmap11 test case failed on x86 and arm64 bcm2711-rpi-=
4-b.
>
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> LTP hugetlb tests failed log
>   tst_hugepage.c:83: TINFO: 1 hugepage(s) reserved
>   tst_test.c:1558: TINFO: Timeout per run is 0h 05m 00s
>   hugemmap11.c:47: TFAIL: Memory mismatch after Direct-IO write
>
> LTP dio tests failed log
>   compare_file: char mismatch: infile offset 4096: 0x01 .   outfile
> offset 4096: 0x00 .
>   diotest01    1  TFAIL  :  diotest1.c:158: file compare failed for
> infile and outfile

Bisection led to "NFS: Fix O_DIRECT locking issues" (upstream commit
7c6339322ce0c6128acbe36aacc1eeb986dd7bf1). Reverting that patch and
"NFS: Fix error handling for O_DIRECT write scheduling" (upstream
commit 954998b60caa8f2a3bf3abe490de6f08d283687a) (not a clean revert
this one) made ltp-dio pass again.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
