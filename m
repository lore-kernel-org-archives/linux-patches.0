Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D49335238
	for <patches@lists.linux.dev>; Tue, 16 May 2023 08:47:26 +0000 (UTC)
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-b9e27684b53so12327534276.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:47:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684226845; x=1686818845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g5Fr1JqN2Ov4AHR8zy4YwIGPB2ZpmLeycQl8ETfUv/E=;
        b=Ocb0Xp5xpxIHb+oR0wlACD9zpmdxNG0GUBysO93Qxn9wnSC4msnV42tLKU2IWrTsx0
         TIzOjlMd5967hvE1ofFDkuzVsmzazz2lHD8zkduzu/ZWlEf3tEzniKZFgCGpxbexdyrT
         TMxs8GB6REcLI4B+vRJg0ETZTk52qX+NAlL1rTuXCcwZTescgT4X+7Q3nv96weWCBx0D
         AA13yo6vDgSL1Z35NcfgxTFBHdfDRikLQrGxnbdFUKu5vqpXnHXLoG4Xd4pqiIthwOZV
         TlhnEY6RYkOoYHN/0NTP7U3IFcmTFOLBZbv3cMp5NRAlyvMtFmnmwQ0+2qo/niKqLX4Y
         tyhQ==
X-Gm-Message-State: AC+VfDzzsR6N63O5kU4k5Okw1VTB3SPY9iGq8LL3zohxj3TGetl0zAds
	4VpduHN19z1DDHLNozvHtsGyL/N+ERbM8w==
X-Google-Smtp-Source: ACHHUZ5xhTDI8IaDMcxbEultyzQ5RYhUmcHG63HfP64hBd5G1AkcDzumi6qu4gh1b+5jsVeZSNOhxA==
X-Received: by 2002:a25:760c:0:b0:ba8:1961:28c8 with SMTP id r12-20020a25760c000000b00ba8196128c8mr1203554ybc.7.1684226845597;
        Tue, 16 May 2023 01:47:25 -0700 (PDT)
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com. [209.85.128.173])
        by smtp.gmail.com with ESMTPSA id d11-20020a25824b000000b00b92426aba45sm334456ybn.57.2023.05.16.01.47.24
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 May 2023 01:47:25 -0700 (PDT)
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-55a8019379fso127966347b3.0
        for <patches@lists.linux.dev>; Tue, 16 May 2023 01:47:24 -0700 (PDT)
X-Received: by 2002:a0d:d4c3:0:b0:55a:9d84:2e4e with SMTP id
 w186-20020a0dd4c3000000b0055a9d842e4emr32699001ywd.18.1684226844519; Tue, 16
 May 2023 01:47:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230515161707.203549282@linuxfoundation.org> <20230515161707.460071056@linuxfoundation.org>
In-Reply-To: <20230515161707.460071056@linuxfoundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 16 May 2023 10:47:13 +0200
X-Gmail-Original-Message-ID: <CAMuHMdWjkZ-FAKrwQkoyZRHLpyvaVYT0NvAUwaCs+30qC2VZmA@mail.gmail.com>
Message-ID: <CAMuHMdWjkZ-FAKrwQkoyZRHLpyvaVYT0NvAUwaCs+30qC2VZmA@mail.gmail.com>
Subject: Re: [PATCH 4.19 007/191] IMA: allow/fix UML builds
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Randy Dunlap <rdunlap@infradead.org>, Fabio Estevam <festevam@gmail.com>, 
	Richard Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
	Johannes Berg <johannes@sipsolutions.net>, linux-um@lists.infradead.org, 
	Mimi Zohar <zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, May 15, 2023 at 6:39=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> From: Randy Dunlap <rdunlap@infradead.org>
>
> commit 644f17412f5acf01a19af9d04a921937a2bc86c6 upstream.
>
> UML supports HAS_IOMEM since 0bbadafdc49d (um: allow disabling
> NO_IOMEM).

0bbadafdc49d is in v5.14.
Was it backported to older versions?

>
> Current IMA build on UML fails on allmodconfig (with TCG_TPM=3Dm):
>
> ld: security/integrity/ima/ima_queue.o: in function `ima_add_template_ent=
ry':
> ima_queue.c:(.text+0x2d9): undefined reference to `tpm_pcr_extend'
> ld: security/integrity/ima/ima_init.o: in function `ima_init':
> ima_init.c:(.init.text+0x43f): undefined reference to `tpm_default_chip'
> ld: security/integrity/ima/ima_crypto.o: in function `ima_calc_boot_aggre=
gate_tfm':
> ima_crypto.c:(.text+0x1044): undefined reference to `tpm_pcr_read'
> ld: ima_crypto.c:(.text+0x10d8): undefined reference to `tpm_pcr_read'
>
> Modify the IMA Kconfig entry so that it selects TCG_TPM if HAS_IOMEM
> is set, regardless of the UML Kconfig setting.
> This updates TCG_TPM from =3Dm to =3Dy and fixes the linker errors.
>
> Fixes: f4a0391dfa91 ("ima: fix Kconfig dependencies")
> Cc: Stable <stable@vger.kernel.org> # v5.14+

"v5.14+"

> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Fabio Estevam <festevam@gmail.com>
> Cc: Richard Weinberger <richard@nod.at>
> Cc: Anton Ivanov <anton.ivanov@cambridgegreys.com>
> Cc: Johannes Berg <johannes@sipsolutions.net>
> Cc: linux-um@lists.infradead.org
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  security/integrity/ima/Kconfig |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/security/integrity/ima/Kconfig
> +++ b/security/integrity/ima/Kconfig
> @@ -7,7 +7,7 @@ config IMA
>         select CRYPTO_HMAC
>         select CRYPTO_SHA1
>         select CRYPTO_HASH_INFO
> -       select TCG_TPM if HAS_IOMEM && !UML
> +       select TCG_TPM if HAS_IOMEM
>         select TCG_TIS if TCG_TPM && X86
>         select TCG_CRB if TCG_TPM && ACPI
>         select TCG_IBMVTPM if TCG_TPM && PPC_PSERIES

Gr{oetje,eeting}s,

                        Geert

--=20
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k=
.org

In personal conversations with technical people, I call myself a hacker. Bu=
t
when I'm talking to journalists I just say "programmer" or something like t=
hat.
                                -- Linus Torvalds
