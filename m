Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BBAC47017
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 18:26:34 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5147f4bbfdaso1753264a12.0
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 11:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1685643992; x=1688235992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oYKP8X4gWjJxyCtHS6ykuTOjFxBhcKNgMGvxxqoTk1c=;
        b=mpivmLWeT2XXwXzvLHfqx+6grbH7Ah1Cef2/9rsLjrH8+dv7e4Hw8MCy4n69enjGw6
         rDSb2wUvrKdOGLImrg99vSkOtRxY4OYiqdaqutPbbjU4oVTHkmR6jZS77Sjhi42LesM9
         y3MeBPPlbknIjqpNpS8Vh1fI6gfFtJQWn1aAmDPl4gGrSrwmbcz2iPPQI6T4YaI7MV42
         7Njga6jXZi4l6g1LMXdBWaAFaJ4V02mGk69WRwTqt4dRIg/ABQMSn8xh74lWG+2enFaR
         ocABxCbmijjNB9QkFBp+WbhHY7Udhw4HMkmFdBYRV3khdxF1bfUd36Wtn7PZJPHuy1P1
         jqCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685643992; x=1688235992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oYKP8X4gWjJxyCtHS6ykuTOjFxBhcKNgMGvxxqoTk1c=;
        b=bg6otld0Iivb5DraYFITeIJ13NRb4EoTHyhm7yiec/ToCxzmS8xt24KxQU8/+r4dgS
         IiUEltUU3MxeqMwJ2ZiR4kp13QDnTwenb0t448qQrixvF+qoqlXFDeq7yuFwEzAwGxkt
         s2dUasXGME7tBJPACHEeKbco7R6OO8EXbvmgd/PHJCGZR/VNuP9WesADni+qnH+9DuKN
         uLe2/RIO7ObyypY+3dN1HJNwCP/HezNDYNHu0iuET9Ey1v1jfZKUbJCN7IK1bt2FHZkD
         VkX/NjBfQDNc1gPxodR5AWybMUoXru9aQjmcAw6RV/nMXKmja9VRUdxOWtoT02QEvzrx
         PKfg==
X-Gm-Message-State: AC+VfDwJNbu0vj7sLHZugrUEXrYmO96RAOpHTuv8qfo2hPkOgMH8NzoT
	ITAtCZtLdMPkM+x6RQ9KWOHlRy6+pcipdsHZftOoeA==
X-Google-Smtp-Source: ACHHUZ4+VwIgSX0cU0yNNOSKDeYqdM9TOoBQfm9J5ytzdxeTZK7wvojLZQXwlIxJcjpjnaUnnVdSLHHbecMLtAmbFBA=
X-Received: by 2002:a17:907:1c22:b0:94b:cd7c:59f4 with SMTP id
 nc34-20020a1709071c2200b0094bcd7c59f4mr9718734ejc.16.1685643992479; Thu, 01
 Jun 2023 11:26:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601-zswap-cgroup-wsometimes-uninitialized-v1-1-35debdd19293@kernel.org>
 <CAJD7tkYZxbEyP6-yjcobws_6Cvjib9c9YnBQRBjhwrK3KaHs7A@mail.gmail.com> <20230601181849.GA1528196@dev-arch.thelio-3990X>
In-Reply-To: <20230601181849.GA1528196@dev-arch.thelio-3990X>
From: Yosry Ahmed <yosryahmed@google.com>
Date: Thu, 1 Jun 2023 11:25:55 -0700
Message-ID: <CAJD7tkZHfmY_0-Many96y5YCb2K_+nfoe2WHkPDPXb2x3hBRdQ@mail.gmail.com>
Subject: Re: [PATCH] zswap: Avoid uninitialized use of ret in zswap_frontswap_store()
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, sjenning@redhat.com, ddstreet@ieee.org, 
	vitaly.wool@konsulko.com, ndesaulniers@google.com, trix@redhat.com, 
	nphamcs@gmail.com, linux-mm@kvack.org, llvm@lists.linux.dev, 
	patches@lists.linux.dev, kernel test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 1, 2023 at 11:18=E2=80=AFAM Nathan Chancellor <nathan@kernel.or=
g> wrote:
>
> On Thu, Jun 01, 2023 at 11:09:48AM -0700, Yosry Ahmed wrote:
> > On Thu, Jun 1, 2023 at 8:26=E2=80=AFAM Nathan Chancellor <nathan@kernel=
.org> wrote:
> > >
> > > Clang warns:
> > >
> > >   mm/zswap.c:1183:6: error: variable 'ret' is used uninitialized when=
ever 'if' condition is true [-Werror,-Wsometimes-uninitialized]
> > >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> > >         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   mm/zswap.c:1327:9: note: uninitialized use occurs here
> > >    1327 |         return ret;
> > >         |                ^~~
> > >   mm/zswap.c:1183:2: note: remove the 'if' if its condition is always=
 false
> > >    1183 |         if (objcg && !obj_cgroup_may_zswap(objcg))
> > >         |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >    1184 |                 goto reject;
> > >         | ~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   mm/zswap.c:1158:9: note: initialize the variable 'ret' to silence t=
his warning
> > >    1158 |         int ret;
> > >         |                ^
> > >         |                 =3D 0
> > >   1 error generated.
> > >
> > > Set ret to -EINVAL, which seems to best match the situation the comme=
nt
> > > mentions and matches an earlier bailout due to an unsupported type or
> > > situation.
> >
> > Shouldn't this be -ENOMEM? I think this was the error code returned in
> > this situation before 6804144bf1cf.
>
> Sure, I can update this to be -ENOMEM if that is appropriate. I am not
> sure it actually matters though, since as far as I can tell, this
> function is only called via the ->store() call in __frontswap_store(),
> which is only called by frontswap_store(), which in turn is only called b=
y
> swap_writepage() and its return value is only checked against 0, no
> other error values. I could be missing a macro call though.
>
> If I should send a v2, please let me know.

You are right that no one actually checks the error code now, but it
would be nice to stay consistent, just in case we want to do proper
error handling at some point :)

>
> Cheers,
> Nathan
>
> > > Fixes: 6804144bf1cf ("zswap: do not shrink if cgroup may not zswap")
> > > Reported-by: kernel test robot <lkp@intel.com>
> > > Closes: https://lore.kernel.org/202306011435.2BxsHFUE-lkp@intel.com/
> > > Closes: https://lore.kernel.org/202306012152.o4FL7Y6J-lkp@intel.com/
> > > Closes: https://github.com/ClangBuiltLinux/linux/issues/1861
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  mm/zswap.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index cff93643a6ab..e8313e2f5807 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -1180,8 +1180,10 @@ static int zswap_frontswap_store(unsigned type=
, pgoff_t offset,
> > >          * local cgroup limits.
> > >          */
> > >         objcg =3D get_obj_cgroup_from_page(page);
> > > -       if (objcg && !obj_cgroup_may_zswap(objcg))
> > > +       if (objcg && !obj_cgroup_may_zswap(objcg)) {
> > > +               ret =3D -EINVAL;
> > >                 goto reject;
> > > +       }
> > >
> > >         /* reclaim space if needed */
> > >         if (zswap_is_full()) {
> > >
> > > ---
> > > base-commit: b2424568bd9b947b2698b693ff24fec63bb4b36a
> > > change-id: 20230601-zswap-cgroup-wsometimes-uninitialized-b549ff4247e=
d
> > >
> > > Best regards,
> > > --
> > > Nathan Chancellor <nathan@kernel.org>
> > >
> > >
