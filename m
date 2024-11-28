Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9538538B
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:45:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732761917; cv=none; b=oeMxDZ1UxIEZAm+tgwf3ZC4huuWdkC8t3tr93NqK0gpxDHs2nFUIvQ5x+3M6MWc9QVuDxEnxzB1bFINP9OXoIhMKF/5/BKw4Nwgq6NMNW2+do0Vmo2mKp3avm8n5fTR5L922m6TQ82D6FPHCdCssfcLFOan3v2RPUgLJysnhHcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732761917; c=relaxed/simple;
	bh=x2ko6OskUBAROEv5dV+nVq7t4JDKbjgTOjztEW1xDn0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a5ALHkVw3kZPW2jNFGibpgZCO7FFvxCQJ+ozR6enbXxlki1iHIJ90BZ+tOW+/J8Y9/eCI5xyGON7EWifiKJxwqUX+fl/t7Rcmfn08xoAAAES+khcM9bB9H2C5vnUvjRxU31BC9tC3GvfB6QtD72WxaZaNC/E3QVFgL4Ay0Zs8sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oaKACNqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oaKACNqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4213AC4CED8
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732761917;
	bh=x2ko6OskUBAROEv5dV+nVq7t4JDKbjgTOjztEW1xDn0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=oaKACNqOjx92aXKDHxuWOhHdLdX0Ics8teEE5AD07HclUpnCEPAVe8OGBM3bqko6/
	 rDdHEvwtwuWVevXhmkNJA9l8WDTwbekrWXxpC1I57np9vcnA2Df5bIC20HeaRLuwQk
	 6ZQUpF/dbWpMV/jOCsvItstY1EBGcB2CmJLG8h0bSym/TFUzEwz0ZrwFfOxFJoh4Oz
	 hdEZhsEFNh+CXgQ/Xp4uBPPPF07+VEtKEUhQCxZAEggQ8MJoNXTd/bz5oHlSolBHZq
	 Wxhjs7TLgdK5eFe5sRBd7GDijnBmRZ6WzjJkJppAglYQvR/AnErHEpf8dun2XARBmz
	 +XXfwt6XE5YyQ==
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-53df67d6659so169100e87.3
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 18:45:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXc4rvymXCbL0pq7y1MCbesWQAQ144nlzSHkzrbj9Z4tTvvg6hVz+d+Rl9UQlfh+yEbFudhxvUP@lists.linux.dev
X-Gm-Message-State: AOJu0YwmggRnO3Xh1MbuHFqIn4JlL7zQorM0NDBnJy3LFl1NL/U+25oL
	qpWtrM/Q6fShASMl4YFDa2VxgxoRZwpTQZf/d+bij3Ex1tzqvskFFrMxsP6YFcKnxB2etuU0Le0
	qH8zLxQPVo02ZfSMX0VtYkhEdU6U=
X-Google-Smtp-Source: AGHT+IEbnNjEp9chqDFN/4LI+G21SL+4pQvYDxo0c+3G4+ZIB770we8POFNgpRW9OMSGNydGIOMghSOT+DMuLzUusLQ=
X-Received: by 2002:a05:6512:3d19:b0:53d:ed8d:9a0b with SMTP id
 2adb3069b0e04-53df00a974emr4463102e87.10.1732761915801; Wed, 27 Nov 2024
 18:45:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org> <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org> <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com> <Z0fT4hC30NISjmi_@bombadil.infradead.org>
In-Reply-To: <Z0fT4hC30NISjmi_@bombadil.infradead.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 28 Nov 2024 11:44:39 +0900
X-Gmail-Original-Message-ID: <CAK7LNATRDODmfz1tE=inV-DQqPA4G9vKH+38zMbaGdpTuFWZFw@mail.gmail.com>
Message-ID: <CAK7LNATRDODmfz1tE=inV-DQqPA4G9vKH+38zMbaGdpTuFWZFw@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, 
	petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 11:22=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> On Wed, Nov 27, 2024 at 03:56:48PM -0800, Linus Torvalds wrote:
> > On Wed, 27 Nov 2024 at 15:26, Luis Chamberlain <mcgrof@kernel.org> wrot=
e:
> > >
> > > On Wed, Nov 27, 2024 at 02:35:36PM -0800, Luis Chamberlain wrote:
> > > > Sorry about that, I'm on it.
> > >
> > > OK here is a fix, goes double build tested and then run time tested.
> >
> > No, you misunderstand.
> >
> > I don't mind the tests being built. That's *good*.
> >
> > I mind them being built *twice*. That means that there's some
> > seriously broken lack of dependency logic.
>
> Ah, gobble gobble, got it.


No. You still misunderstood what Linus said.


Linus did not suggest changing Kconfig or shell script or whatever.
He just pointed out "your Makefile was wrong".

I guess you should take some time to study
Documentation/kbuild/makefiles.rst






> That was also fixed in the patch but it I
> also changed the default build to go fast, ok we'll revert back to the
> older defaults (TEST_KALLSYMS_LARGE now) now and just make it clear the
> double build was the issue being fixed.
>
> From f7da80262bd89a0d2c2c1a9e59f5a14b84e34f3f Mon Sep 17 00:00:00 2001
> From: Luis Chamberlain <mcgrof@kernel.org>
> Date: Wed, 27 Nov 2024 14:10:57 -0800
> Subject: [PATCH v2] selftests: kallsyms: fix double build stupidity
>
> Fix the stupid FORCE so that re-builds will only trigger
> when really needed. While at it, document the sensible ranges
> supported and fix the script to accept these alternatives.
>
> Reported-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  lib/Kconfig.debug                     | 32 ++++++++++++++++++++++++++-
>  lib/tests/module/Makefile             |  2 +-
>  lib/tests/module/gen_test_kallsyms.sh |  9 ++++++--
>  3 files changed, 39 insertions(+), 4 deletions(-)
>
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index b5929721fc63..da8c35bfaeaf 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -2986,9 +2986,39 @@ config TEST_KALLSYMS_D
>         tristate
>         depends on m
>
> +choice
> +       prompt "Kallsym test range"
> +       default TEST_KALLSYMS_LARGE
> +       help
> +         Selecting something other than "Fast" will enable tests which s=
low
> +         down the build and may crash your build.
> +
> +config TEST_KALLSYMS_FAST
> +       bool "Fast builds"
> +       help
> +         You won't really be testing kallsysms, so this just helps fast =
builds
> +         when allmodconfig is used..
> +
> +config TEST_KALLSYMS_LARGE
> +       bool "Enable testing kallsyms with large exports"
> +       help
> +         This will enable larger number of symbols. Only enable this if =
you
> +         are a modules developer. This will slow down your build conside=
rbly.
> +
> +config TEST_KALLSYMS_MAX
> +       bool "Known kallsysms limits"
> +       help
> +         This will enable exports to the point we know we'll start crash=
ing
> +         builds.
> +
> +endchoice
> +
>  config TEST_KALLSYMS_NUMSYMS
>         int "test kallsyms number of symbols"
> -       default 100
> +       range 2 10000
> +       default 2 if TEST_KALLSYMS_FAST
> +       default 100 if TEST_KALLSYMS_LARGE
> +       default 10000 if TEST_KALLSYMS_MAX
>         help
>           The number of symbols to create on TEST_KALLSYMS_A, only one of=
 which
>           module TEST_KALLSYMS_B will use. This also will be used
> diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
> index af5c27b996cb..5436386d7aa0 100644
> --- a/lib/tests/module/Makefile
> +++ b/lib/tests/module/Makefile
> @@ -3,7 +3,7 @@ obj-$(CONFIG_TEST_KALLSYMS_B) +=3D test_kallsyms_b.o
>  obj-$(CONFIG_TEST_KALLSYMS_C) +=3D test_kallsyms_c.o
>  obj-$(CONFIG_TEST_KALLSYMS_D) +=3D test_kallsyms_d.o
>
> -$(obj)/%.c: FORCE
> +$(obj)/%.c: $(srctree)/lib/tests/module/gen_test_kallsyms.sh $(KCONFIG_C=
ONFIG)
>         @$(kecho) "  GEN     $@"
>         $(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
>                 $(CONFIG_TEST_KALLSYMS_NUMSYMS) \
> diff --git a/lib/tests/module/gen_test_kallsyms.sh b/lib/tests/module/gen=
_test_kallsyms.sh
> index 3f2c626350ad..561dcac0f359 100755
> --- a/lib/tests/module/gen_test_kallsyms.sh
> +++ b/lib/tests/module/gen_test_kallsyms.sh
> @@ -7,6 +7,11 @@ NUM_SYMS=3D$2
>  SCALE_FACTOR=3D$3
>  TEST_TYPE=3D$(echo $TARGET | sed -e 's|lib/tests/module/test_kallsyms_||=
g')
>  TEST_TYPE=3D$(echo $TEST_TYPE | sed -e 's|.c||g')
> +FIRST_B_LOOKUP=3D1
> +
> +if [[ $NUM_SYMS -gt 2 ]]; then
> +       FIRST_B_LOOKUP=3D$((NUM_SYMS/2))
> +fi
>
>  gen_template_module_header()
>  {
> @@ -52,10 +57,10 @@ ____END_MODULE
>
>  gen_template_module_data_b()
>  {
> -       printf "\nextern int auto_test_a_%010d;\n\n" 28
> +       printf "\nextern int auto_test_a_%010d;\n\n" $FIRST_B_LOOKUP
>         echo "static int auto_runtime_test(void)"
>         echo "{"
> -       printf "\nreturn auto_test_a_%010d;\n" 28
> +       printf "\nreturn auto_test_a_%010d;\n" $FIRST_B_LOOKUP
>         echo "}"
>  }
>
> --
> 2.45.2
>


--
Best Regards
Masahiro Yamada
