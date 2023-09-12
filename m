Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E5214F63
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:56:40 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7a7e11a53c3so2675924241.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 04:56:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694519799; x=1695124599; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hM+GZDrqeSJbN3AByx2ZfKWwBecQmUtkdjQEAlP2iy0=;
        b=UOqKh2F8bBZq+uyjR/SX4q03jPAA97Q/ncXtDGaz45NKf83jSo6BC3fz6sJLhwQnc/
         EKdP0B4dXUuTUuPY6hG6yL09/gKfzvTDuwXTRpVzz9yY1+iZa8AXwAwWgMCyWvGwdzIi
         BJdt5xzyb9drWGB0KWApcJBuAQVXXjSZ0jeK//aBG5pfMub6xK0sr2VdjGCSIqnDkfrN
         8kushtts+cMZPNUzk1qaAnFLLL4e40Zq5Fe2wFNHiJSCAIfrgku9Fl7kiMFLySCHkHoN
         ArWwAUzlW33kRaaKR+XxlqQIne4CIesu7dToaDEsCjOjp8I5m4hs+CDHhtVf7/ZBK0Us
         o2MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694519799; x=1695124599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hM+GZDrqeSJbN3AByx2ZfKWwBecQmUtkdjQEAlP2iy0=;
        b=lAakyFbwoAMrzIHjpmzzt5o6nyLQbYnN+g4RJ5oMxcDHmQPIuEzz7MvULAfbGLMFOn
         vhE8KG2OoYK2oM9ybZ9HWwZfTCoObILsDT3AvxILelj1efmJHAcUzhnYKE44EcMONQjS
         EYgp471WdYb+ddLuG/a0HlvptNOsd+dJuOWQGJfcghV3zu74f3QpDgisb6CNGGrSqhwd
         zjLdAc1IkmWdR1DPfa3W3nS88rZ6PmHnTGS/IvesDMft+fFtzTvPsbhRce6OK2KItdLf
         CxBHrBatFL9tIlQno1QybVD9ailb6DJsEYxSSfGJKzioRbQegpzUTexu2pGjti62jvFs
         Y7yw==
X-Gm-Message-State: AOJu0YwOMOMoshxTCgGdphDRY/DZWqoxzHGG9KdAiCrmQT6dRGarGs4w
	SsVKg1F4iVIOgYidsYDsan+gxUH8Aajb3i1Qi970jg==
X-Google-Smtp-Source: AGHT+IGgWWHDG3U3xZjhxJlUgNBntR20hjZb21XDRq5dpijLuAigU2VJD5bsWfFlFRPo7V/LoyZy0iqN5FJ9h/3IbKI=
X-Received: by 2002:a05:6102:3564:b0:44d:6320:f0c5 with SMTP id
 bh4-20020a056102356400b0044d6320f0c5mr1070772vsb.12.1694519799125; Tue, 12
 Sep 2023 04:56:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134633.619970489@linuxfoundation.org> <1ffe4f64-f238-859a-ab14-7559d03c4671@linaro.org>
 <CAEUSe7_XA16yZAHA+YTbJygwaUYkU5gs=FnV9BAmQRYzwgVjvQ@mail.gmail.com>
 <CA+G9fYsiWEKSV0EeU0cXsJZ3U75fbdGyCmDx07ksFMUW5jouyw@mail.gmail.com> <2023091233-boots-line-a3d4@gregkh>
In-Reply-To: <2023091233-boots-line-a3d4@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Sep 2023 17:26:27 +0530
Message-ID: <CA+G9fYt2Jnxwvpzcd66HCqkPi6CNistHfmxQYAzX22OWHUoUSA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/600] 6.1.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: jack@suse.cz, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	=?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>, 
	Tom Rix <trix@redhat.com>, Nathan Chancellor <nathan@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Sept 2023 at 16:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Sep 12, 2023 at 02:19:34PM +0530, Naresh Kamboju wrote:
> > On Tue, 12 Sept 2023 at 07:55, Daniel D=C3=ADaz <daniel.diaz@linaro.org=
> wrote:
> > >
> > > Hello!
> > >
> > > On Mon, 11 Sept 2023 at 14:58, Daniel D=C3=ADaz <daniel.diaz@linaro.o=
rg> wrote:
> > > > On 11/09/23 7:40 a. m., Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 6.1.53 relea=
se.
> > > > > There are 600 patches in this series, all will be posted as a res=
ponse
> > > > > to this one.  If anyone has any issues with these being applied, =
please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >       https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/=
patch-6.1.53-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-=
stable-rc.git linux-6.1.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > > We're seeing this new warning:
> > > > -----8<-----
> > > >    /builds/linux/fs/udf/inode.c:892:6: warning: variable 'newblock'=
 is used uninitialized whenever 'if' condition is true [-Wsometimes-uniniti=
alized]
> > > >      892 |         if (*err < 0)
> > > >          |             ^~~~~~~~
> > > >    /builds/linux/fs/udf/inode.c:914:9: note: uninitialized use occu=
rs here
> > > >      914 |         return newblock;
> > > >          |                ^~~~~~~~
> > > >    /builds/linux/fs/udf/inode.c:892:2: note: remove the 'if' if its=
 condition is always false
> > > >      892 |         if (*err < 0)
> > > >          |         ^~~~~~~~~~~~~
> > > >      893 |                 goto out_free;
> > > >          |                 ~~~~~~~~~~~~~
> > > >    /builds/linux/fs/udf/inode.c:699:34: note: initialize the variab=
le 'newblock' to silence this warning
> > > >      699 |         udf_pblk_t newblocknum, newblock;
> > > >          |                                         ^
> > > >          |                                          =3D 0
> > > >    1 warning generated.
> > > > ----->8-----
> > > >
> > > > That's with Clang 17 (and nightly) on:
> > > > * arm
> > > > * powerpc
> > > > * s390
> > >
> > > For what it's worth, bisection points to 903b487b5ba6 ("udf: Handle
> > > error when adding extent to a file").
> >
> > I see the following commit is fixing the reported problem.
> >
> > commit 6d5ab7c2f7cf90877dab8f2bb06eb5ca8edc73ef
> > Author: Tom Rix <trix@redhat.com>
> > Date:   Fri Dec 30 12:53:41 2022 -0500
> >
> >     udf: initialize newblock to 0
> >
> >     The clang build reports this error
> >     fs/udf/inode.c:805:6: error: variable 'newblock' is used
> > uninitialized whenever 'if' condition is true
> > [-Werror,-Wsometimes-uninitialized]
> >             if (*err < 0)
> >                 ^~~~~~~~
> >     newblock is never set before error handling jump.
> >     Initialize newblock to 0 and remove redundant settings.
> >
> >     Fixes: d8b39db5fab8 ("udf: Handle error when adding extent to a fil=
e")
> >     Reported-by: Nathan Chancellor <nathan@kernel.org>
> >     Signed-off-by: Tom Rix <trix@redhat.com>
> >     Signed-off-by: Jan Kara <jack@suse.cz>
> >     Message-Id: <20221230175341.1629734-1-trix@redhat.com>
>
> Wait, where is this commit?  I don't see it in Linus's tree either, nor
> in linux-next.  Where did you find it?

Can you find this commit id ?

Commit id: 23970a1c9475b305770fd37bebfec7a10f263787
subject: ("udf: initialize newblock to 0")

- Naresh


>
> confused,
>
> greg k-h
