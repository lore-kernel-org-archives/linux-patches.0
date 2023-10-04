Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AA01B27F
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 20:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-6910ea9cddbso192794b3a.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 13:19:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696450788; x=1697055588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7v3t9u9xgvHxweeBD/U81J25d0Zdsy2WU/FAEhA0NzQ=;
        b=oBTLNRnfdA6EvdA1D+SxAauvwEYXiC0YkDQnqmhXIgfi8xP+gmdsJUcaMktPOp0eCa
         fRARqKuR6tiRX5E7/h0dJ8DU0XD3DW4VibOUvHVdVhsX5QxIRuAaLicewLNHpwUxoZ/k
         z9mSFjZ7+CgIAOYumIhRgYFMUvgxUO7qp0NkhgaIxBLSJBp3ADjsTKRyAJ+n9wFi9Aly
         T/G1iXUH17Pi/t7yxHAaWHDe2jz4Aw+OWmzGgPGq+VgrxxOH7fqY+tCXQScYBHlJs6O2
         8QYbsR8Bgzxjgmf+dJsIoUYvectv2RX56/RvP5ry2S9I54cxncB/KMHaVMzfsHFaDh63
         6P/w==
X-Gm-Message-State: AOJu0Yy9uMiSbYXvZLs6yhIybC57zzy2K20dwHIJK+ti68jYLVgfUuic
	bb1dNU3vh78QcrfDerVR96wAZswZQ7ghRSZZ7DQ=
X-Google-Smtp-Source: AGHT+IGPv8onFbtjmjOREUljXHQuutqUtArE0vQV6pGiJVksloGH7rtiiM1slP9BD4ouPRf6YY58b/SxfW9v+Hu4h5E=
X-Received: by 2002:a17:90b:4a91:b0:274:729c:e4f with SMTP id
 lp17-20020a17090b4a9100b00274729c0e4fmr3233005pjb.15.1696450788288; Wed, 04
 Oct 2023 13:19:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org> <f0115175-975e-4fde-aa69-666568ce5c6a@gmail.com>
In-Reply-To: <f0115175-975e-4fde-aa69-666568ce5c6a@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 4 Oct 2023 13:19:36 -0700
Message-ID: <CAM9d7chUnxjPdOwZZ0imYs+i8+dd9GL=O3gqJXzaRd1VGZJxBg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/259] 6.1.56-rc1 review
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	Ian Rogers <irogers@google.com>, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

On Wed, Oct 4, 2023 at 12:33=E2=80=AFPM Florian Fainelli <f.fainelli@gmail.=
com> wrote:
>
> +Namhyung, Ian,
>
> On 10/4/23 10:52, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.56 release.
> > There are 259 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.56-rc1.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
> perf fails to build with:
>
> fixdep: error opening depfile:
> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/=
pmu-events/.pmu-events.o.d:
> No such file or directory
> make[5]: *** [pmu-events/Build:33:
> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/=
pmu-events/pmu-events.o]
> Error 2
> make[4]: *** [Makefile.perf:672:
> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/perf/=
pmu-events/pmu-events-in.o]
> Error 2
> make[3]: *** [Makefile.perf:240: sub-make] Error 2
> make[2]: *** [Makefile:70: all] Error 2
> make[1]: *** [package/pkg-generic.mk:294:
> /local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_built=
]
> Error 2
> make: *** [Makefile:27: _all] Error 2
>
> due a80fd00cb1a7793ead4d7c3fa7d3f1e898231c27 ("perf build: Update build
> rule for generated files"). Reverting that commit fixes the build for me
> and then all is good in terms of testing.

I think it's ok to drop the patches if it's not applied
cleanly.

Thanks,
Namhyung
