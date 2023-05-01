Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C77A48C1C
	for <patches@lists.linux.dev>; Mon,  1 May 2023 22:15:35 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-1aaf91ae451so13628045ad.1
        for <patches@lists.linux.dev>; Mon, 01 May 2023 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682979335; x=1685571335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0raH1j8ZUKh/4UCAXmruhx5VLOti7TNZ6SAauWoXEBk=;
        b=EqofVeRkP6qKn+AFCEdWEoQwXkRwWVvec95qDbq8HeK6vMA68+P1RGt1KssyIGeLdL
         /tidnKMvryR1PR6Hpn29CbgyWCqYZ5fxYSVCSssm64L0/g+bwjRC2QplRHP60mzb901U
         88mG1efHI5AW8gUEITxjRKtLyGSd7StlZxTEOasUC8pUt0i+OHlukmlzuyPRPCDmJAlQ
         Rn7RvNB1ilI61Mg/lhvU4bgkM3TFKnFp/GFuV52RkYXVfe2miETmw0aSD1KOoU0VAwG0
         rX0RqbILc2etOWcns02LhmqWmls83kR6vECdz55rKQEzogUsA+oJMj8HQWy+o/P1IgKz
         1AeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682979335; x=1685571335;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0raH1j8ZUKh/4UCAXmruhx5VLOti7TNZ6SAauWoXEBk=;
        b=jJRI0NoTX5VJYN5/6XTsuaE2IysKr0H1C2fCOdDOSmRaU3sp6aVXrAUiyr6bAtqohw
         iqugMcSiyjLDWG9ENOOJOwYaWkhpnlq1Nh7+m1E/UcnlCAQfQOGc+YUrgDxetNlGHcYS
         PFcjeRQYdPp/kwCzj835A3TN01JCqD1wiJQkhglpvbXTcWteExkmCH5u37bzLF2WY58H
         ohCfddmyDGNkfAxHBl0WiP9AkoF6U1xHXdDTO7fzmTM+mCKdvSitb97Bxmx9XD1f6tuP
         j+Um69i2NJcZkCDKnl6bEGf1aECGRZnaw2v22jsFOopuJR4wNVimgxRKX0cqC8uwmUhL
         ewCQ==
X-Gm-Message-State: AC+VfDzWhScqgn5H1UdbokLItipnOputenRThEXWIk2r8IYIq+93xMM9
	OpI+58jJ1Aw56iN3OqZbWZ85+UcpeNHWlJbC+Vuu8Q==
X-Google-Smtp-Source: ACHHUZ7SJ+lx1QcWYu/jxX/bM1Lg29Q4d4/tH6ynO/js+mvlBne7nKLId+HZvdaDY6JxiY/hDxZpydQmcN9fpXM6uhA=
X-Received: by 2002:a17:903:32cc:b0:1aa:f3c4:74e5 with SMTP id
 i12-20020a17090332cc00b001aaf3c474e5mr5834252plr.0.1682979335031; Mon, 01 May
 2023 15:15:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230501-sp7021-field_prep-warning-v1-1-5b36d71feefe@kernel.org>
 <20230501213714.GA1007102@dev-arch.thelio-3990X> <CAKwvOdkgSpKMkOGR9qNMxscxuYuYDxnsqTSZDmUtLP5QLSWWMA@mail.gmail.com>
In-Reply-To: <CAKwvOdkgSpKMkOGR9qNMxscxuYuYDxnsqTSZDmUtLP5QLSWWMA@mail.gmail.com>
From: Nick Desaulniers <ndesaulniers@google.com>
Date: Mon, 1 May 2023 15:15:22 -0700
Message-ID: <CAKwvOdm_prtk1UQNJQGidZm44Lk582S3p=of0y46+rVjnSgXJg@mail.gmail.com>
Subject: Re: [PATCH] clk: sp7021: Adjust width of _m in HWM_FIELD_PREP()
To: Nathan Chancellor <nathan@kernel.org>
Cc: qinjian@cqplus1.com, mturquette@baylibre.com, sboyd@kernel.org, 
	trix@redhat.com, linux-arm-kernel@lists.infradead.org, 
	linux-clk@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev, 
	Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 1, 2023 at 3:03=E2=80=AFPM Nick Desaulniers <ndesaulniers@googl=
e.com> wrote:
>
> On Mon, May 1, 2023 at 2:37=E2=80=AFPM Nathan Chancellor <nathan@kernel.o=
rg> wrote:
> >
> > On Mon, May 01, 2023 at 02:34:47PM -0700, Nathan Chancellor wrote:
> > > When building with clang + W=3D1, there is a warning around an intern=
al
> > > comparison check within the FIELD_PREP() macro, due to a 32-bit varia=
ble
> > > comparison against ~0ull:
> > >
> > >   drivers/clk/clk-sp7021.c:316:8: error: result of comparison of cons=
tant 18446744073709551615 with expression of type 'typeof (_Generic((_m), .=
..' (aka 'unsigned int') is always false [-Werror,-Wtautological-constant-o=
ut-of-range-compare]
> > >           r0 |=3D HWM_FIELD_PREP(MASK_SEL_FRA, clk->p[SEL_FRA]);
> > >                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   drivers/clk/clk-sp7021.c:45:15: note: expanded from macro 'HWM_FIEL=
D_PREP'
> > >           (_m << 16) | FIELD_PREP(_m, value);     \
> > >                        ^~~~~~~~~~~~~~~~~~~~~
> > >   include/linux/bitfield.h:114:3: note: expanded from macro 'FIELD_PR=
EP'
> > >                   __BF_FIELD_CHECK(_mask, 0ULL, _val, "FIELD_PREP: ")=
;    \
> > >                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   include/linux/bitfield.h:71:53: note: expanded from macro '__BF_FIE=
LD_CHECK'
> > >                   BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >=
     \
> > >                   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~^=
~~~~~~
> > >   note: (skipping 1 expansions in backtrace; use -fmacro-backtrace-li=
mit=3D0 to see all)
> > >   include/linux/compiler_types.h:397:22: note: expanded from macro 'c=
ompiletime_assert'
> > >           _compiletime_assert(condition, msg, __compiletime_assert_, =
__COUNTER__)
> > >           ~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~~~~~~~~~
> > >   include/linux/compiler_types.h:385:23: note: expanded from macro '_=
compiletime_assert'
> > >           __compiletime_assert(condition, msg, prefix, suffix)
> > >           ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >   include/linux/compiler_types.h:377:9: note: expanded from macro '__=
compiletime_assert'
> > >                   if (!(condition))                                  =
     \
> > >                         ^~~~~~~~~
> > >
> > > This is expected given the tyoes of the input. Increase the size of t=
he
>
> s/tyoes/types/
>
> Thanks for the patch!
>
> Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
>
> Nathan, do you think anything can be done in FIELD_PREP or even
> __BF_FIELD_CHECK using _Static_assert (or static_assert from
> include/linux/build_bug.h) to help elucidate to developers that their
> mask is too small?  I guess the line 71 of include/linux/bitfield.h
> that is trying to warn via BUILD_BUG_ON is itself triggering a
> -Wtautological-constant-out-of-range-compare warning that is perhaps
> distracting from what the issue is?
>
> If you're able to reproduce the issue locally still, does this seem to wo=
rk?
> ```
> diff --git a/include/linux/bitfield.h b/include/linux/bitfield.h
> index ebfa12f69501..762a27b5ae15 100644
> --- a/include/linux/bitfield.h
> +++ b/include/linux/bitfield.h
> @@ -62,15 +62,15 @@
>
>  #define __BF_FIELD_CHECK(_mask, _reg, _val, _pfx)                      \
>         ({                                                              \
> +               static_assert(__bf_cast_unsigned(_mask, _mask) <=3D      =
 \
> +                             __bf_cast_unsigned(_reg, ~0ull),          \
> +                             _pfx "type of reg too small for mask");   \
>                 BUILD_BUG_ON_MSG(!__builtin_constant_p(_mask),          \
>                                  _pfx "mask is not constant");          \
>                 BUILD_BUG_ON_MSG((_mask) =3D=3D 0, _pfx "mask is zero"); =
   \
>                 BUILD_BUG_ON_MSG(__builtin_constant_p(_val) ?           \
>                                  ~((_mask) >> __bf_shf(_mask)) & (_val) :=
 0, \
>                                  _pfx "value too large for the field"); \
> -               BUILD_BUG_ON_MSG(__bf_cast_unsigned(_mask, _mask) >     \
> -                                __bf_cast_unsigned(_reg, ~0ull),       \
> -                                _pfx "type of reg too small for mask"); =
\
>                 __BUILD_BUG_ON_NOT_POWER_OF_2((_mask) +                 \
>                                               (1ULL << __bf_shf(_mask)));=
 \
>         })
>
> ```

Hmmm....maybe not:
```
drivers/gpu/drm/i915/i915_hwmon.c:97:14: error: static assertion
expression is not an integral constant expression
        reg_value =3D REG_FIELD_GET(field_msk, reg_value);
                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./drivers/gpu/drm/i915/i915_reg_defs.h:87:44: note: expanded from
macro 'REG_FIELD_GET'
#define REG_FIELD_GET(__mask, __val)    ((u32)FIELD_GET(__mask, __val))
                                              ^~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/bitfield.h:154:3: note: expanded from macro 'FIELD_GET'
                __BF_FIELD_CHECK(_mask, _reg, 0U, "FIELD_GET: ");       \
                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/bitfield.h:65:17: note: expanded from macro '__BF_FIELD_CHE=
CK'
                static_assert(__bf_cast_unsigned(_mask, _mask) <=3D       \
                ~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/bitfield.h:61:70: note: expanded from macro '__bf_cast_unsi=
gned'
#define __bf_cast_unsigned(type, x)     ((__unsigned_scalar_typeof(type))(x=
))
                                                                         ^
./include/linux/build_bug.h:77:50: note: expanded from macro 'static_assert=
'
#define static_assert(expr, ...) __static_assert(expr, ##__VA_ARGS__, #expr=
)
                                 ~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~~~~~~~~~~~=
~
./include/linux/build_bug.h:78:56: note: expanded from macro '__static_asse=
rt'
#define __static_assert(expr, msg, ...) _Static_assert(expr, msg)
                                                       ^~~~
```
so there's probably a use of REG_FIELD_GET that is
__builtin_constant_p but not an integral constant expression. That's
too bad...

>
>
> > > temporary variable in HWM_FIELD_PREP() to eliminate the warning, whic=
h
> > > follows the logic of commit cfd6fb45cfaf ("crypto: ccree - avoid
> > > out-of-range warnings from clang") for the same reasons.
> >
> > Gah, I forgot:
> >
> > Reported-by: kernel test robot <lkp@intel.com>
> > Link: https://lore.kernel.org/202303221947.pXP2v4xJ-lkp@intel.com/
> >
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > > ---
> > >  drivers/clk/clk-sp7021.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/clk/clk-sp7021.c b/drivers/clk/clk-sp7021.c
> > > index 8fec14120105..11d22043ddd7 100644
> > > --- a/drivers/clk/clk-sp7021.c
> > > +++ b/drivers/clk/clk-sp7021.c
> > > @@ -41,7 +41,7 @@ enum {
> > >  /* HIWORD_MASK FIELD_PREP */
> > >  #define HWM_FIELD_PREP(mask, value)          \
> > >  ({                                           \
> > > -     u32 _m =3D mask;                          \
> > > +     u64 _m =3D mask;                          \
> > >       (_m << 16) | FIELD_PREP(_m, value);     \
> > >  })
> > >
> > >
> > > ---
> > > base-commit: d54c1fd4a51e8fbc7f9da86b0cd338a4f7cd2bb2
> > > change-id: 20230501-sp7021-field_prep-warning-223f17aeea8e
> > >
> > > Best regards,
> > > --
> > > Nathan Chancellor <nathan@kernel.org>
> > >
>
>
>
> --
> Thanks,
> ~Nick Desaulniers



--=20
Thanks,
~Nick Desaulniers
