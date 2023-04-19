Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400FB1C04
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:57:12 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-3ee6c339cceso101595e9.0
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681880230; x=1684472230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LCRs4ZT1NMucVRTV4T7ESOYqv5BN2PQbexcodDRyfMQ=;
        b=uxDD6c2HREJe0YlUGLQhAW6jUOghV2gl3yqQyLE8D1DCSkAH6obgYK9hLOC1PRYiFe
         O2LOQR+g0im6/ZRyhdfLrK0YStnrbw3e0mn/Ln2Y5Y+eez9XdTEXkjdGKHMTq6tADWlR
         VX9gpE2Vy8L6UYq7g8EdXlMnWZVvLlcG4Nqi361M0rCXB9Hp6Bz9SB+jtUelKZQhH2rB
         MTwoYPmBx/6r7EtA8RV93lYtuHCcUKVQvgtWJY8bCHxH8M23lmmdX6ELT1bA9vpclQ5+
         CSBFMgY0Wz5CPYZwWP/h6+5LOWFvZwG9g9eESlKKtexygzJJuYpZ3zoRu40jm2+2jBNA
         tyHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681880230; x=1684472230;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LCRs4ZT1NMucVRTV4T7ESOYqv5BN2PQbexcodDRyfMQ=;
        b=N1zn+kMzLkvR/MxPXImnC7iPF0/7eAntYRvtRTGYVjk2+8/hHW5OVmPqUT/tGNDm4r
         l7mGd90bYGWTi/dPHUDE/Ts3ShMhw0NUTyjoRsV9lBXe5hU4imG6VE58BxkGZXXFrzu8
         MLLKhPofQLIsXCBM2Ev0KPe4JhYoCNyEy+Y/sLYOAlnqHvKXRdLrh69hugUfwGs/Or7i
         /eYgfgLYyaF+4X1qH+LTxQDao9Y2aodF3Fn8U53KtG1S6A6mszIksBMydheUFQm5Yw72
         pAPrU2tZMl8gCqbkTmFn9pUV5Z2svYNnfm5dTKvMA9+lsslQqAt3AmAcEW6gwHW3ox/a
         jt8Q==
X-Gm-Message-State: AAQBX9cErHpcgzFVaBIYn/8rSWkGsymSNeDXqIdkja8ZCjHta+YG6XMb
	WHKJN8Mw2QzoX6fI3Vl8D+5ewsIwHQeIibA/TYzZ5A==
X-Google-Smtp-Source: AKy350Ym9AgVWLy367+bnRhY6AG1ScJrgNkD1/7T5WwvBqykfqn/+ktGpoxXbQm1J15J422IZEIzWeru3nZngskvhk4=
X-Received: by 2002:a05:600c:1c9e:b0:3f1:6aff:60e5 with SMTP id
 k30-20020a05600c1c9e00b003f16aff60e5mr113901wms.0.1681880229465; Tue, 18 Apr
 2023 21:57:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120305.520719816@linuxfoundation.org> <CA+G9fYs9sHnfhn4hSFP=AmOfgj-zvoK9vmBejRvzKPj4uXx+VA@mail.gmail.com>
 <bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com> <20230418165105.q5s77yew2imkamsb@oracle.com>
 <ZD9rfsteIrXIwezR@debian.me>
In-Reply-To: <ZD9rfsteIrXIwezR@debian.me>
From: Yu Zhao <yuzhao@google.com>
Date: Tue, 18 Apr 2023 22:56:22 -0600
Message-ID: <CAOUHufa9-AKwwx7oVpQkV355TTmVSfi8roBKEsRjRNbeuGUkbw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
To: Bagas Sanjaya <bagasdotme@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Tom Saeger <tom.saeger@oracle.com>, 
	Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Waiman Long <longman@redhat.com>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Darren Kenny <darren.kenny@oracle.com>, 
	Vegard Nossum <vegard.nossum@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 10:18=E2=80=AFPM Bagas Sanjaya <bagasdotme@gmail.co=
m> wrote:
>
> On Tue, Apr 18, 2023 at 10:51:05AM -0600, Tom Saeger wrote:
> > > Tom Saeger identified that the below commit moves it out of ifdef.
> > >
> > > commit 354ed597442952fb680c9cafc7e4eb8a76f9514c
> > > Author: Yu Zhao <yuzhao@google.com>
> > > Date:   Sun Sep 18 02:00:07 2022 -0600
> > >
> > >     mm: multi-gen LRU: kill switch
> > >
> > FWIW - partially backporting (location of cgroup_mutex extern) from:
> > 354ed5974429 ("mm: multi-gen LRU: kill switch")
> >
> > fixes x86_64 build for me.
> >
> > Regards,
> >
> > --Tom
> >
> > diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h

...

> Yu, would you like to provide formal backport?

Are you suggesting backporting the entire MGLRU patchset (>30 patches)?

I do have the backport ready for 5.15 and multiple distros have taken
it. But I don't think Greg would welcome it. I'd be happy to be wrong
though.
