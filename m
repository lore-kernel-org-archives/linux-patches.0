Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480172E406
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732762142; cv=none; b=JZ5pmohNkulpTVrosN3/qrKzaD4nbLz8XCpjiGL2Qgqflr7WbSRiz/whPQe/8vhPSQdywBEDNGnJWpojY4RKLLbLN6pbrfJOEMw1vu5ZrU+HVF7aihhZq6iUr71MNoWvDpUUOwhfuAMBk9fv80xgBRqmL1ggRcb5VjVMFM/TJQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732762142; c=relaxed/simple;
	bh=jJ2y3vCLtFLQCosfBaBQ23Jyli+WiQf7FlPX60S9HDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ph7nOta1VoaRwLkcrBujlsOfd1LIgB3xIB19zFveuf9P/LfwI/Rl5tk3PS5tMZ8DWpPDjL2mhQdyWybkgLArZMFsmDrYrfqYsl1adnmWe5e6fyxblRyU9FQWDMMlsSNRm7mhUZbmxT4Eh4jpn2ChjqSlhio0qk4n8AaXlwz+MAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jwZtzJp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jwZtzJp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3A4C4CED3
	for <patches@lists.linux.dev>; Thu, 28 Nov 2024 02:49:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732762142;
	bh=jJ2y3vCLtFLQCosfBaBQ23Jyli+WiQf7FlPX60S9HDQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=jwZtzJp2Yq56xkKUZLw4sbV3BvgPPqDvDlHx+q/JxjEJhTijrpLo/qTHIZ8zyyZMo
	 Cql11qs8JHnyXe0+uYMpaFzWsOodfGFbzTdtHiVg62EVGQEIbJeGVVcDOdnANPkdXa
	 7yFrJ9yxwZrCQpe0Y1II+sq56kqU7NgZATrzacrvRDYiOcBnha6AQK3P7KNC+BETL5
	 xzGfn61TG6+vT+LJNNjWSRbq4TvY1+m2lTBy5ecSqYrYeHyTMW+oHeQXikw498HCry
	 734/CGFVYtm37bfojqHxfFqYDA+ESHWGWAeQWc//jQvIesV7IEEGszeLvBPSsb3efG
	 vBq9zCqIbheww==
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-53dd668c5easo423604e87.1
        for <patches@lists.linux.dev>; Wed, 27 Nov 2024 18:49:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVibf7ZhB0+w9A4bCqNzFAJumzYjnON7NdtSAAMxl1RoYDov68dablIWdJxDcCCRxmWsD+R/CEZ@lists.linux.dev
X-Gm-Message-State: AOJu0YylQgLDLmaenawq7p1wLRRGF1vWtTT5csWChtEqFmMM2Lr+IcbZ
	DR8iIAXpEyiuxU5e8oNQ9rekbyiR7fe0rjVwMRkYKechik+xeyiMz27zXNVcM8ZGi6ftLKtNz9E
	omh4bUU60PxdzbK3PhEkDzIQgabw=
X-Google-Smtp-Source: AGHT+IFkxvmqPjHU33u25P8S6FFTgUr3u6w9XWoqzYocX/qYmOJ/jQipLr4QnKiAIFq7KStyJBa+c5YtB4lO+kqq+VE=
X-Received: by 2002:a05:6512:230d:b0:53d:f5e9:ec4b with SMTP id
 2adb3069b0e04-53df5e9ed27mr279265e87.0.1732762140603; Wed, 27 Nov 2024
 18:49:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <Z0ZxiLw9hauUynTS@bombadil.infradead.org> <CAHk-=wjCkJsdLageTx6C4n--aYFoO6gSRe0Rwcbk1jQdOdiPfg@mail.gmail.com>
 <Z0eeuCyUGcKgsc5h@bombadil.infradead.org> <Z0eqiayuv1w4a_dc@bombadil.infradead.org>
 <CAHk-=wj+imfGvW73XoYn60bAMzRtPfXFqwFTUqBoEq4=u5_oUg@mail.gmail.com>
 <CAK7LNAQyhxPZfpK3hVPtYvCYjad4pTUim5jVsEsuXqefY8KhWQ@mail.gmail.com> <Z0fXshsZI8J0NhQo@bombadil.infradead.org>
In-Reply-To: <Z0fXshsZI8J0NhQo@bombadil.infradead.org>
From: Masahiro Yamada <masahiroy@kernel.org>
Date: Thu, 28 Nov 2024 11:48:24 +0900
X-Gmail-Original-Message-ID: <CAK7LNAQ1ahFWeChwBjgPs9Y3AGieVznFoPdbVkWP9rrW0T5-Dw@mail.gmail.com>
Message-ID: <CAK7LNAQ1ahFWeChwBjgPs9Y3AGieVznFoPdbVkWP9rrW0T5-Dw@mail.gmail.com>
Subject: Re: [GIT PULL] Modules changes for v6.13-rc1
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com, 
	petr.pavlu@suse.com, da.gomez@samsung.com, linux-modules@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, mmaurer@google.com, 
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 11:38=E2=80=AFAM Luis Chamberlain <mcgrof@kernel.or=
g> wrote:
>
> On Thu, Nov 28, 2024 at 11:09:43AM +0900, Masahiro Yamada wrote:
> > diff --git a/lib/tests/module/Makefile b/lib/tests/module/Makefile
> > index af5c27b996cb..8cfc4ae600a9 100644
> > --- a/lib/tests/module/Makefile
> > +++ b/lib/tests/module/Makefile
> > @@ -3,13 +3,12 @@ obj-$(CONFIG_TEST_KALLSYMS_B) +=3D test_kallsyms_b.o
> >  obj-$(CONFIG_TEST_KALLSYMS_C) +=3D test_kallsyms_c.o
> >  obj-$(CONFIG_TEST_KALLSYMS_D) +=3D test_kallsyms_d.o
> >
> > -$(obj)/%.c: FORCE
> > -       @$(kecho) "  GEN     $@"
> > -       $(Q)$(srctree)/lib/tests/module/gen_test_kallsyms.sh $@\
> > -               $(CONFIG_TEST_KALLSYMS_NUMSYMS) \
> > -               $(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
> > +quiet_cmd_gen_test_kallsyms =3D GEN     $@
> > +      cmd_gen_test_kallsyms =3D $< $@ \
> > +       $(CONFIG_TEST_KALLSYMS_NUMSYMS) \
> > +       $(CONFIG_TEST_KALLSYMS_SCALE_FACTOR)
> >
> > -clean-files +=3D test_kallsyms_a.c
> > -clean-files +=3D test_kallsyms_b.c
> > -clean-files +=3D test_kallsyms_c.c
> > -clean-files +=3D test_kallsyms_d.c
> > +$(obj)/%.c: $(src)/gen_test_kallsyms.sh FORCE
>
> Thanks! We can also just replace the FORCE with $(KCONFIG_CONFIG), no?


Nope. Absolutely.

If you change any unrelated CONFIG option,
(e.g. CONFIG_DRIVER_FOO), the timestamp of .config
is updated, then lib/tests/module/test_kallsyms_*.c
are rebuilt for non good reason.







--
Best Regards
Masahiro Yamada
