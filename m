Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D46D31877
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 05:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-565334377d0so412361a12.2
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 22:15:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696482928; x=1697087728;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWwQRb/XtfECORlbJaPIokf0S+U6RkqOPHFRazouw+M=;
        b=DtmzNWBWIGYU2Y5lopvBvBAU0KOgBmVUYO2WUZo7u8t/w3XJT2zDJCaYjhn9kGxVVP
         GLzP0ayPIi5GjKbaFybQ2bmN6GbJl1RFFO0YgYhLR6/pW0j/CeEW6qWf8JhqND9m0Qj0
         m0qlVZCm9yxshSSNBigHoTUWzRPNitby2iBGx2ibdiaTPZaScp9PbfDqDSlaFpEC/MOF
         r+FJkO6j5dIUE51Nt9K776EOrZzC8PkWa7Jubxk7Fh8zbtLgPjqXc7h5GFISYyor9GkW
         xDZlr/cTjE/neq6ebwqv54JPeeoXFPiIl6cmX7Kv+BRAAZeO/YTEGSCjGkT+zVRS7HLN
         BRhw==
X-Gm-Message-State: AOJu0YwdslLqDudH8dVhZl/K5dp9DBrvbKq3yI4pFigU4RqyzHQecI5a
	HJmQaNWDVDfd/Jcf93krRRjYEsiabh6MdfpBAhs=
X-Google-Smtp-Source: AGHT+IFgLfvo1oegfrzeQvDg8A+plJfnaldXDVwHe7iwyPSK91s2WY58rzBuwDkayDOgh0mRN9ApFzOpeM5z8cMN6CE=
X-Received: by 2002:a17:90b:3b92:b0:273:cec7:23ee with SMTP id
 pc18-20020a17090b3b9200b00273cec723eemr4213933pjb.37.1696482927938; Wed, 04
 Oct 2023 22:15:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231004175217.404851126@linuxfoundation.org> <f0115175-975e-4fde-aa69-666568ce5c6a@gmail.com>
 <CAM9d7chUnxjPdOwZZ0imYs+i8+dd9GL=O3gqJXzaRd1VGZJxBg@mail.gmail.com> <d2b80a6d-63c8-46ec-bf0f-83217a7c517d@gmail.com>
In-Reply-To: <d2b80a6d-63c8-46ec-bf0f-83217a7c517d@gmail.com>
From: Namhyung Kim <namhyung@kernel.org>
Date: Wed, 4 Oct 2023 22:15:16 -0700
Message-ID: <CAM9d7cjf8uct-xMr0Sj8=3kdcH6mavx5pCCsg+G8v53d+kxWjA@mail.gmail.com>
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

On Wed, Oct 4, 2023 at 5:52=E2=80=AFPM Florian Fainelli <f.fainelli@gmail.c=
om> wrote:
>
>
>
> On 10/4/2023 1:19 PM, Namhyung Kim wrote:
> > Hello,
> >
> > On Wed, Oct 4, 2023 at 12:33=E2=80=AFPM Florian Fainelli <f.fainelli@gm=
ail.com> wrote:
> >>
> >> +Namhyung, Ian,
> >>
> >> On 10/4/23 10:52, Greg Kroah-Hartman wrote:
> >>> This is the start of the stable review cycle for the 6.1.56 release.
> >>> There are 259 patches in this series, all will be posted as a respons=
e
> >>> to this one.  If anyone has any issues with these being applied, plea=
se
> >>> let me know.
> >>>
> >>> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> >>> Anything received after that time might be too late.
> >>>
> >>> The whole patch series can be found in one patch at:
> >>>        https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/pat=
ch-6.1.56-rc1.gz
> >>> or in the git tree and branch at:
> >>>        git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-sta=
ble-rc.git linux-6.1.y
> >>> and the diffstat can be found below.
> >>>
> >>> thanks,
> >>>
> >>> greg k-h
> >>
> >> perf fails to build with:
> >>
> >> fixdep: error opening depfile:
> >> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/pe=
rf/pmu-events/.pmu-events.o.d:
> >> No such file or directory
> >> make[5]: *** [pmu-events/Build:33:
> >> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/pe=
rf/pmu-events/pmu-events.o]
> >> Error 2
> >> make[4]: *** [Makefile.perf:672:
> >> /local/users/fainelli/buildroot/output/arm/build/linux-custom/tools/pe=
rf/pmu-events/pmu-events-in.o]
> >> Error 2
> >> make[3]: *** [Makefile.perf:240: sub-make] Error 2
> >> make[2]: *** [Makefile:70: all] Error 2
> >> make[1]: *** [package/pkg-generic.mk:294:
> >> /local/users/fainelli/buildroot/output/arm/build/linux-tools/.stamp_bu=
ilt]
> >> Error 2
> >> make: *** [Makefile:27: _all] Error 2
> >>
> >> due a80fd00cb1a7793ead4d7c3fa7d3f1e898231c27 ("perf build: Update buil=
d
> >> rule for generated files"). Reverting that commit fixes the build for =
me
> >> and then all is good in terms of testing.
> >
> > I think it's ok to drop the patches if it's not applied
> > cleanly.
>
> AFAICT the patch applied cleanly. There was some bizarre interplay in
> stable kernels prior to < 6.1 as reported here:
>
> https://lore.kernel.org/all/dcb9997a-2e8a-5eb2-7a34-f8af418d4bf1@gmail.co=
m/
> https://lore.kernel.org/all/6a577578-8adb-aa70-1bf8-b1a4573152cf@gmail.co=
m/
>
> Does this make sense to you that on 6.1 which does have Ian's commit
> 00facc760903be6675870c2749e2cd72140e396e ("perf jevents: Switch build to
> use jevents.py") that we would still get this build error somehow?

You can drop the pmu-events part of the change if possible.
If not, I'm ok to drop the entire patch as it's intended to fix a
corner case only.  Normal builds should be fine before and
after the change.

Thanks,
Namhyung
