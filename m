Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50D52373;
	Tue, 24 May 2022 12:30:57 +0000 (UTC)
Received: from mail-yw1-f172.google.com ([209.85.128.172]) by
 mrelayeu.kundenserver.de (mreue109 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1M5Q6l-1nseCo3Eer-001So8; Tue, 24 May 2022 14:30:56 +0200
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-2ff90e0937aso105131497b3.4;
        Tue, 24 May 2022 05:30:55 -0700 (PDT)
X-Gm-Message-State: AOAM531EMZRwvxk8RTSGGj7AsJD2kUqbVbpq44mDDIyLP2lurByl5A9l
	sycHZxWZ5H+QCjz9S9baRqPxd9jfhZ9BWwTlppw=
X-Google-Smtp-Source: ABdhPJydwm9ZeQkJCZTDhTWemb3DUsSF1BiWMivHtJQfFJ6OjF0fBSQWMxFqbwtza36HGeAy93l3UAAU+B1mkG6N7Ok=
X-Received: by 2002:a0d:efc2:0:b0:2fe:d2b7:da8 with SMTP id
 y185-20020a0defc2000000b002fed2b70da8mr27015519ywe.42.1653395454413; Tue, 24
 May 2022 05:30:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220523150521.2947108-1-nathan@kernel.org>
In-Reply-To: <20220523150521.2947108-1-nathan@kernel.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Tue, 24 May 2022 14:30:36 +0200
X-Gmail-Original-Message-ID: <CAK8P3a1pRmTeufSUOrRZx_B=VafmG33P1_vzn-YTpcSKDjfvVA@mail.gmail.com>
Message-ID: <CAK8P3a1pRmTeufSUOrRZx_B=VafmG33P1_vzn-YTpcSKDjfvVA@mail.gmail.com>
Subject: Re: [PATCH] misc: rtsx: Fix clang -Wsometimes-uninitialized in rts5261_init_from_hw()
To: Nathan Chancellor <nathan@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Nick Desaulniers <ndesaulniers@google.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, clang-built-linux <llvm@lists.linux.dev>, 
	patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>, 
	kernel test robot <lkp@intel.com>, Tom Rix <trix@redhat.com>, Ricky WU <ricky_wu@realtek.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:ZEvQpwApMRMv9LBe/JmXup9pF7PZonKJm1RjC7wV3vnK353HZHa
 KUl0Aq8VLvF61MQEBs5IPR5s226cYmuS4Jn2Ng4docbWsuHexamjJWWleHD7mJdmc/wXxUg
 kYtDai1JSszyquhUs4xQu5FEQTSzIzjJL1e/oRiyPvvtUPrgb37vBaDUSqsh4EiZz94YGYT
 3XxUnmhFtpVn+HjsINxEw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:x7wKNaKBUSQ=:aWm9J+BJWINxPozxKrU/Cw
 alNT2l62/V8zWGEscSDNmeQIvrBhTVKVeSjzseuL+Xw9Kbe5lLMwyo01/dUxjRyVeAL5BZO7/
 CeNLdqUXUJQ1vg6QjbXwWBu4ZPkONHV7mnj6DCGuFjPVoELj42/AAW0zsksNq8bzzg7JmLj9P
 Y9g+t6FoMq4yqU0tYcmtY8dTrkVWaCNs/v2Hq0OBVJ+kE9c13IVJnZYgt38ke9Idlw7XAA6eA
 pK0i5kmD1t4IQUQzrlBWjQEDbVcTvKt07xeVF/wDGoq+/nXyPGBFVWdzQquZ9fqpH80sR59JK
 ayFfXIxdjQ3k5ZsQ3WKKddkMkCmrg8zzW8Q9vZkvc8mPRjod9qums4DfXCoOomt0Aw2uLWafQ
 J8QWx3RIftbSS3QKcBZVgRZ0HJWgIiytjtVX0AeMxQDAf7oVC9Yu8gbLcQq/CAH9sK833PiEj
 gHArQA0z0eggEkBfdjC4ofmqqz/UEDRd4+sj5qxQP1DLB5JpJEk8MGjzorlFFw7lGKGKhP91/
 CwEUfEbaGsa5CAEvcKnmzhf9vqVuRdc13slIdCXpv2OW4tcVUjE/dolnEPm6brQW66S3zDyYP
 GpuHGPu902iLSQ6NlWZgnml2F2c/7XqX54mEd+X2DTURFiNvSSdRsxu5pBw/9nwUkU0Y4KNIl
 GfFc/P2GEaoYZxiCiMRFA2kyw8r0Kk9rn4AjP7arQm4MMCc5vpOogYgGp8A58bz32IZrjdL7+
 9HsuywgPd2JNZpB3xCv6MBCvGnCkGTUz6r0nJ7SjIky63Lz5E9AZqY23uSAIZ2oolZVTaMMg0
 8hUZ/1nktEL4WNaX9orl9OPho3ZkQYOKVq9ELo4LJdoJ/g7TbuezOYgnhcul5ZO8f69wXx7a0
 BXAy1z+kmlhwvxD7T8uQ==

On Mon, May 23, 2022 at 5:05 PM Nathan Chancellor <nathan@kernel.org> wrote:
>
> Clang warns:
>
>   drivers/misc/cardreader/rts5261.c:406:13: error: variable 'setting_reg2' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>           } else if (efuse_valid == 0) {
>                      ^~~~~~~~~~~~~~~~
>   drivers/misc/cardreader/rts5261.c:412:30: note: uninitialized use occurs here
>           pci_read_config_dword(pdev, setting_reg2, &lval2);
>                                       ^~~~~~~~~~~~
>
> efuse_valid == 1 is not a valid value so just return early from the
> function to avoid using setting_reg2 uninitialized.
>
> Fixes: b1c5f3085149 ("misc: rtsx: add rts5261 efuse function")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Tom Rix <trix@redhat.com>
> Suggested-by: Ricky WU <ricky_wu@realtek.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Looks good to me,

Acked-by: Arnd Bergmann <arnd@arndb.de>
