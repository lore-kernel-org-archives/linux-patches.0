Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F8C88C05
	for <patches@lists.linux.dev>; Mon,  1 May 2023 22:03:41 +0000 (UTC)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1aaf91ae451so13522855ad.1
        for <patches@lists.linux.dev>; Mon, 01 May 2023 15:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682978621; x=1685570621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kRTLMNTnm7jLZvB7zImjhZAt3fQDl4d7j0DZ12oTynU=;
        b=SjoF/r87Ly7yb6mvY51eSWl0JYzfx8DkLAIFlt/yn3D9JR9u/h7EvQaoz28Q3iyxKb
         TYLfVRASlDNwxevx7mcP837OBGWdBVmG7CQHoIwl+8/YozQMIH/dLexjMDonVVUnY9KF
         s74MXE6bgpXZFjb5F5pLihucV4fChoUXpjjjwvvZR+dSw1/fbnFntxEkUDAM+Bp/xknF
         48LUniyfNp1aNmywghTzLzLwdfq9TB4y01rDtJt7gmCu4vQTVl9iqcaQWmDfVOvpwOWF
         7Y/bR4qfax8rOe+j0dvK/5AsB/bPN+BqEFiDOPZTHkUUjo6YsB0qihELNFSuoLJtr8ll
         LoEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682978621; x=1685570621;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kRTLMNTnm7jLZvB7zImjhZAt3fQDl4d7j0DZ12oTynU=;
        b=foakjc0xQwgcl4MyemJJrxDln4rnAkUMKGCM93pN05yvlPNdQjkyiYEguSaaBm+tWO
         nCvthgK25+S4C2zOlZlxSeZyXa3awCx8+/WZTw4Dr+7b+Y+qM82ozMJSliKelDvw6cxO
         D7dF2CbcnsC7qPN4/aS6MMHEMdivZlrbooajk51UydKJ0mdEPOJOWu/ce7w5/b4lQJnQ
         VF2mUaR7k5/NWsKQ4ShzJ2UxjztUsr9APwq+ENwgQ/s2Y9Go+NF6Gbp5HK80vheTsHSj
         IhNSR68Ntjb4l7PBkR8fn8MC0Rr9QCIAQxg11hSYnaJKfeYcTWEBGG9HGMEDiFnYREVN
         jvhw==
X-Gm-Message-State: AC+VfDzpoI0h076Nku+uP4h0rfhfyO9m5DEeoJsIrKKejTb7UNz6WA5h
	g9g1ff+DqKmY8XvA63G49roQy9Ixs5SN35zkspy3bQ==
X-Google-Smtp-Source: ACHHUZ69l7W0VZmoQayM1+G45wrpcB67SZor/fcZ2EER9a8ynjRBz6vl/JpFgbsNvZ9YiY5Tv3cti85nPas34SFyNts=
X-Received: by 2002:a17:902:db03:b0:1a9:8ff5:af51 with SMTP id
 m3-20020a170902db0300b001a98ff5af51mr20717089plx.60.1682978620861; Mon, 01
 May 2023 15:03:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org> <20230501213714.GA1007102@dev-arch.thelio-3990X>
In-Reply-To: <20230501213714.GA1007102@dev-arch.thelio-3990X>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 1 May 2023 15:03:29 -0700
Message-ID: <CAKwvOdkgSpKMkOGR9qNMxscxuYuYDxnsqTSZDmUtLP5QLSWWMA@mail.gmail.com>
Subject: Re: [PATCH] clk: sp7021: Adjust width of _m in HWM_FIELD_PREP()
To: Nathan Chancellor <nathan@kernel.org>
Cc: qinjian@cqplus1.com, mturquette@baylibre.com, sboyd@kernel.org, 
	trix@redhat.com, linux-arm-kernel@lists.infradead.org, 
	linux-clk@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 1, 2023 at 2:37=E2=80=AFPM Nathan Chancellor <nathan@kernel.org=
> wrote:
>
> On Mon, May 01, 2023 at 02:34:47PM -0700, Nathan Chancellor wrote:
> > When building with clang + W=3D1, there is a warning around an internal
> > comparison check within the FIELD_PREP() macro, due to a 32-bit variabl=
e
> > comparison against ~0ull:
> >
> >   drivers/clk/clk-sp7021.c:316:8: error: result of comparison of consta=
nt 18446744073709551615 with expression of type 'typeof (_Generic((_m), ...=
' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-out=
-of-range-compare]
> >           r0 |=3D HWM_FIELD_PREP(MASK_SEL_FRA, clk->p[SEL_FRA]);
> >                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   drivers/clk/clk-sp7021.c:45:15: note: expanded from macro 'HWM_FIELD_=
PREP'
> >           (_m << 16) | FIELD_PREP(_m, value);     \
> >                        ^~~~~~~~~~~~~~~~~~~~~
> >   include/linux/bitfield.h:114:3: note: expanded from macro 'FIELD_PREP=
'
> >                   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: "); =
   \
> >                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   include/linux/bitfield.h:71:53: note: expanded from macro '__BF_FIELD=
_CHECK'
> >                   BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >  =
   \
> >                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^~~=
~~~~
> >   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-limi=
t=3D0 to see all)
> >   include/linux/compiler_types.h:397:22: note: expanded from macro 'com=
piletime_assert'
> >           _compiletime_assert(condition, msg, __compiletime_assert_, __=
COUNTER__)
> >           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~
> >   include/linux/compiler_types.h:385:23: note: expanded from macro '_co=
mpiletime_assert'
> >           __compiletime_assert(condition, msg, prefix, suffix)
> >           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> >   include/linux/compiler_types.h:377:9: note: expanded from macro '__co=
mpiletime_assert'
> >                   if (!(condition))                                    =
   \
> >                         ^~~~~~~~~
> >
> > This is expected given the tyoes of the input. Increase the size of the

s/tyoes/types/

Thanks for the patch!

Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>

Nathan, do you think anything can be done in FIELD_PREP or even
__BF_FIELD_CHECK using _Static_assert (or static_assert from
include/linux/build_bug.h) to help elucidate to developers that their
mask is too small?  I guess the line 71 of include/linux/bitfield.h
that is trying to warn via BUILD_BUG_ON is itself triggering a
-Wtautological-constant-out-of-range-compare warning that is perhaps
distracting from what the issue is?

If you're able to reproduce the issue locally still, does this seem to work=
?
```
diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
index ebfa12f69501..762a27b5ae15 100644
--- a/include/linux/bitfield.h
+++ b/include/linux/bitfield.h
@@ -62,15 +62,15 @@

 #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                      \
        ({                                                              \
+               static_assert(__bf_cast_unsigned(_mask, _mask) <=3D       \
+                             __bf_cast_unsigned(_reg, ~0ull),          \
+                             _pfx "type of reg too small for mask");   \
                BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),          \
                                 _pfx "mask is not constant");          \
                BUILD_BUG_ON_MSG((_mask) =3D=3D 0, _pfx "mask is zero");   =
 \
                BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
                                 ~((_mask) >> __bf_shf(_mask)) & (_val) : 0=
, \
                                 _pfx "value too large for the field"); \
-               BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >     \
-                                __bf_cast_unsigned(_reg, ~0ull),       \
-                                _pfx "type of reg too small for mask"); \
                __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
                                              (1ULL << __bf_shf(_mask))); \
        })

```


> > temporary variable in HWM_FIELD_PREP() to eliminate the warning, which
> > follows the logic of commit cfd6fb45cfaf ("crypto: ccree - avoid
> > out-of-range warnings from clang") for the same reasons.
>
> Gah, I forgot:
>
> Reported-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/202303221947.pXP2v4xJ-lkp@intel.com/
>
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> >  drivers/clk/clk-sp7021.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/clk/clk-sp7021.c b/drivers/clk/clk-sp7021.c
> > index 8fec14120105..11d22043ddd7 100644
> > --- a/drivers/clk/clk-sp7021.c
> > +++ b/drivers/clk/clk-sp7021.c
> > @@ -41,7 +41,7 @@ enum {
> >  /* HIWORD_MASK FIELD_PREP */
> >  #define HWM_FIELD_PREP(mask, value)          \
> >  ({                                           \
> > -     u32 _m =3D mask;                          \
> > +     u64 _m =3D mask;                          \
> >       (_m << 16) | FIELD_PREP(_m, value);     \
> >  })
> >
> >
> > ---
> > base-commit: d54c1fd4a51e8fbc7f9da86b0cd338a4f7cd2bb2
> > change-id: 20230501-sp7021-field_prep-warning-223f17aeea8e
> >
> > Best regards,
> > --
> > Nathan Chancellor <nathan@kernel.org>
> >



--=20
Thanks,
~Nick Desaulniers
