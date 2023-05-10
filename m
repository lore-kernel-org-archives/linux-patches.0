Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5E38C0F
	for <patches@lists.linux.dev>; Wed, 10 May 2023 17:00:54 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-333866a265fso42884585ab.3
        for <patches@lists.linux.dev>; Wed, 10 May 2023 10:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1683738053; x=1686330053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oBtF7LYkXSUt83SUWJ9QjemTqyVA/iZGdvboiNmRLKo=;
        b=A+R7ioq0e74ZvC0NZ/Z7xGTuJG2Um8qhEGCM7Yx/wgrYSnsf353gWtHqFoThC9KRtz
         Z42CTDGdljcZXtww9Su9lbBYEPVrO+LdhoP/FPgP9+5UcL8lKMjE2ZHpMa/gkmcwBIFY
         GZiMb3Wdisz+9RzjXnvLQZBO5HG5Q4tZx0ca3ecPL2IQrVhYg1NSzADYmvCp/VZHLO4a
         8uqIKS0oXHj++3PgwXtyM7W2aXMk1uAQ2MsBedUgPQ3ymx2PQTpX0zDSL424EiROh/ap
         FgLDvZOCl3FAgr1VL43ll+L8Fk72JMowJiGc7hEVd9WE8Z/ldJHu3Clhl53HOzVyN9y3
         /axA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683738053; x=1686330053;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oBtF7LYkXSUt83SUWJ9QjemTqyVA/iZGdvboiNmRLKo=;
        b=MiXsOarqb6vmnnA/aY4fVzpY9xbn9yeCtuqCtSSEbLSGIYE+/lDDxUbIn8OGnSbsw3
         7zTYnbvykjISUKGC2enRRDWu2vL9Ec8fUJQo/Cf15upVIECOjH+shrE008cf2LwhejI5
         PBsAM3VmEAU9ADtvrs5ckuRKmyWExZaVoDfM4YCg/LvjFxUK8z7lTWYfzQx/GsULWhfE
         jumSfJ9DcEkOauPZz073jjhPI+Ch5rDmhvs8246bORqDKvHflWUU/tz/Yn6cP69gkEIE
         idmQpqWQK4ERTVXd7MqpDKtXI/66o+pZuvQEbUsA5EIp3VckQtH9S07Hic93zcDO+61P
         btrw==
X-Gm-Message-State: AC+VfDzQF/hj8crvisr0ZqHtTUOdryPTWD9kFr6o5ZEi0m06W0RQyMRm
	vwvVxoW+zoidkRZU2sGKB88zVzJMukrAGm/4m5oAxw==
X-Google-Smtp-Source: ACHHUZ5N9CS3CqU4NU1sy+urJFNG0b8bx2si2jJT7pLVYWpiBuXIOYmwNDCAOsTy75ZvINZV52K8ENNUmr4PnELimYw=
X-Received: by 2002:a92:d245:0:b0:330:f7b3:ea4 with SMTP id
 v5-20020a92d245000000b00330f7b30ea4mr13478553ilg.2.1683738053613; Wed, 10 May
 2023 10:00:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030611.521807993@linuxfoundation.org> <863a112f-f4a4-d580-9687-f6214d555939@linaro.org>
 <2023051035-monitor-sandy-2a5b@gregkh> <CAEUSe79AViqsHimbYbFjkKAxcvROGhFKA2yKVuC3aP1Gm=jc1w@mail.gmail.com>
In-Reply-To: <CAEUSe79AViqsHimbYbFjkKAxcvROGhFKA2yKVuC3aP1Gm=jc1w@mail.gmail.com>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Wed, 10 May 2023 11:00:42 -0600
Message-ID: <CAEUSe7_ZBW_hPUZYeKkZ6zuckeqYb+O46GdgGx0wE6T0=c5wZg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, laoar.shao@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Wed, 10 May 2023 at 09:46, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
> Hello!
>
> On Wed, 10 May 2023 at 01:43, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, May 09, 2023 at 09:12:33AM -0600, Daniel D=C3=ADaz wrote:
> > > Hello!
> > >
> > > On 08/05/23 21:26, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 5.15.111 relea=
se.
> > > > There are 370 patches in this series, all will be posted as a respo=
nse
> > > > to this one.  If anyone has any issues with these being applied, pl=
ease
> > > > let me know.
> > > >
> > > > Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> > > > Anything received after that time might be too late.
> > > >
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patc=
h-5.15.111-rc2.gz
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-5.15.y
> > > > and the diffstat can be found below.
> > > >
> > > > thanks,
> > > >
> > > > greg k-h
> > >
> > > New warnings are introduced for Arm, PowerPC, RISC-V:
> > >
> > >   /builds/linux/kernel/sched/debug.c: In function 'print_cfs_group_st=
ats':
> > >   /builds/linux/kernel/sched/debug.c:465:41: warning: unused variable=
 'stats' [-Wunused-variable]
> > >                   struct sched_statistics *stats =3D  __schedstats_fr=
om_se(se);
> > >                                            ^~~~~
> >
> > Odd, and this isn't on other kernels too?
>
> Only on 5.15, not on the 6.x RC's. I'll share more info after my
> bisection is done.

Bisection leads to:

  sched: Make struct sched_statistics independent of fair sched class

Reverting makes the warning disappear.

Greetings!
