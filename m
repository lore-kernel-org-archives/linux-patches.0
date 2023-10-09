Received: from mail-vk1-f173.google.com (mail-vk1-f173.google.com [209.85.221.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D53838BB6
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 16:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cvEFXzGe"
Received: by mail-vk1-f173.google.com with SMTP id 71dfb90a1353d-49e15724283so1031884e0c.1
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 09:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696869835; x=1697474635; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h74o2AZcTC7GyQaZvo8+es5i4OkJLBnswUlj7gMbv2U=;
        b=cvEFXzGezJwd8BEInbsqch9xvGHd9wY1yEbc41uJFwsjBQTUqn3gDS2iN0U3QvCMIu
         edddjh/pESkyV543M5PbTtu+NrOiR1vCgJtwtjZrRNLvpFLAjlV31I2rbBNlUP8h3LVD
         lSBDhUdAYe+wRebmewNpD2uk6+9IruFVVryzJI3Qcukg8TPK+5Ks9TYFye2r1BUcJlXm
         06sgS3c5EE91V/ldx2barDMjdmovql95HfbcPB0qM3IaosfYYKDI0X8Aw3xaLwV2rNB/
         Ye9jiIN682zEPXSZwcJOeew6dXB7OiX6n1fJ9DjQbYnvi4Nt8BhFVNftcYtlZRWcNeb5
         rltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696869835; x=1697474635;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h74o2AZcTC7GyQaZvo8+es5i4OkJLBnswUlj7gMbv2U=;
        b=wTii9Q8LXTpoivo2HKzoCYr9ZlP8JCQ08GFVr/DzYPV+tBBFnXsj2rCSXQqKWeGeLt
         dPG4ydqGINsq44VRtDapYTAdXBxOr3HNblIH104o84ndAtj8KHAV4VszSGB4/hW2w8nM
         /vo83W3h5ETivl8PahLKQCI1b5XhUg6GvfU2+2G6G3hhGCDlwd87Qe5xZQ6FryPNxq0h
         uR/+YlgAJzFWibdhjxOP9aX4H0Crdd6fn4TYyXl3FtBwYeSoDLIKzAGJWjKWEI+TIgyY
         Vp+YVMNZfNtD3vzAoFx+Z15HFCkk/K0xNuIWY0hyhBAJcuEWhW0BBD0igZ1zWa0p6jZH
         EkMQ==
X-Gm-Message-State: AOJu0YzhP3FtydpTADcaWfkVMPsY98gYdTSdX7DdQGqJvbxoiJNkBbOO
	3BBCa2hntGsCSGfvl1s9c0M61oBvs4s6fawM9Z0utQ==
X-Google-Smtp-Source: AGHT+IEkXqZBLHppN9aD1rPab7CXnRnbSPIio7BIWqrTQXvtR6190yK7ITH0FWBWUzGCmJoQh0UXep8/jjC65cWusQM=
X-Received: by 2002:a1f:d686:0:b0:49d:a52a:441f with SMTP id
 n128-20020a1fd686000000b0049da52a441fmr12470392vkg.7.1696869835132; Mon, 09
 Oct 2023 09:43:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org> <CA+G9fYsqbZhSQnEi-qSc7n+4d7nPap8HWcdbZGWLfo3mTH-L7A@mail.gmail.com>
 <CAEUSe78O-Ho=22nTeioT4eqPRoDNfcWCpc=5O=B59eaMvOkzpg@mail.gmail.com> <2023100755-livestock-barcode-fe41@gregkh>
In-Reply-To: <2023100755-livestock-barcode-fe41@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 9 Oct 2023 22:13:42 +0530
Message-ID: <CA+G9fYvzV03=-LTmburzzwRpw0xuxoAXBKo0n1muYwOOiVG_bw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	linux-nfs@vger.kernel.org, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	Olga Kornievskaia <kolga@netapp.com>, Benjamin Coddington <bcodding@redhat.com>, 
	Anna Schumaker <Anna.Schumaker@netapp.com>, 
	Trond Myklebust <trond.myklebust@hammerspace.com>, LTP List <ltp@lists.linux.it>, 
	Petr Vorel <pvorel@suse.cz>, Richard Palethorpe <rpalethorpe@suse.com>, Eryu Guan <eguan@redhat.com>, 
	chrubis <chrubis@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 7 Oct 2023 at 14:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Oct 06, 2023 at 12:42:04PM -0600, Daniel D=C3=ADaz wrote:
> > Hello!
> >
> > On Thu, 5 Oct 2023 at 10:40, Naresh Kamboju <naresh.kamboju@linaro.org>=
 wrote:
> > > On Wed, 4 Oct 2023 at 23:41, Greg Kroah-Hartman
> > > <gregkh@linuxfoundation.org> wrote:
> > > >
> > > > This is the start of the stable review cycle for the 6.1.56 release=
.
> > > > There are 259 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >
> > > > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/=
patch-6.1.56-rc1.gz
> > > > or in the git tree and branch at:
> > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git linux-6.1.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > Results from Linaro=E2=80=99s test farm.
> > > Regressions on arm64 bcm2711-rpi-4-b device running LTP dio tests on
> > > NFS mounted rootfs.
> > > and LTP hugetlb hugemmap11 test case failed on x86 and arm64 bcm2711-=
rpi-4-b.
> > >
> > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > >
> > > LTP hugetlb tests failed log
> > >   tst_hugepage.c:83: TINFO: 1 hugepage(s) reserved
> > >   tst_test.c:1558: TINFO: Timeout per run is 0h 05m 00s
> > >   hugemmap11.c:47: TFAIL: Memory mismatch after Direct-IO write
> > >
> > > LTP dio tests failed log
> > >   compare_file: char mismatch: infile offset 4096: 0x01 .   outfile
> > > offset 4096: 0x00 .
> > >   diotest01    1  TFAIL  :  diotest1.c:158: file compare failed for
> > > infile and outfile
> >
> > Bisection led to "NFS: Fix O_DIRECT locking issues" (upstream commit
> > 7c6339322ce0c6128acbe36aacc1eeb986dd7bf1). Reverting that patch and
> > "NFS: Fix error handling for O_DIRECT write scheduling" (upstream
> > commit 954998b60caa8f2a3bf3abe490de6f08d283687a) (not a clean revert
> > this one) made ltp-dio pass again.
>
> So this is also an issue in Linus's tree?  Or is it only on the 6.1.y

 It is only on the 6.1.y branch.

- Naresh
