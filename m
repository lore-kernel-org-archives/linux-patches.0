Received: from mail-yw1-f174.google.com (mail-yw1-f174.google.com [209.85.128.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35D8718AFE
	for <patches@lists.linux.dev>; Tue, 11 Jul 2023 15:16:54 +0000 (UTC)
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-570877f7838so69109987b3.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 08:16:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689088614; x=1691680614;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6rp97t0SvD8s0Who/ua4azUvnOtZZ5RKlcFsre7+/tw=;
        b=No/ajTRwPSPjGzw+zqK0C69lRYUT2GhTjdCRrCRDXXmjkKMkA7u0t9bxfamMWUsZMt
         rjiXGXvAvUQplRIpbmim6tjhU5iJCxEobjfjoACNMYKRuffkZERoX+iMLV0cdOxYCn2D
         B3QvR7Xm+GMI1vZjpardxcQT5H8Wlh2ovgT8urdgLPItS14kEbrYRScRLUQMOGUCnhE7
         gnEr7IAjJ5oL2N9sdzkFSZ/8MPHFAxZ09awKmj+p74Zli7l7jwq4qY3OW1GM2Z4srt5B
         jo+bfvSmwV458iKcYxJO7ZhD1CzVeXntjVBk6SR3AAVO1S+9YHYdzADn5DVw4/yemO1G
         L8Jw==
X-Gm-Message-State: ABy/qLa2joyjbsBaeNWUXdGxggRch/1tgimzxBEuqQc/ZNl+XEhLQB+I
	/qp1jl7LMKouPHFx+DP2EHTD0Ax421cedA==
X-Google-Smtp-Source: APBJJlGi4URzz0Kz5hfI0cVZ7kZWOGgFZM/1TS6QvOZKrR32k7EEiW+m6A6Q+COY+682Lu2PqWMYvg==
X-Received: by 2002:a0d:d5c8:0:b0:570:6d74:21d5 with SMTP id x191-20020a0dd5c8000000b005706d7421d5mr16867344ywd.13.1689088613756;
        Tue, 11 Jul 2023 08:16:53 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id s130-20020a815e88000000b005731dbd4928sm609235ywb.69.2023.07.11.08.16.53
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Jul 2023 08:16:53 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id 3f1490d57ef6-c84fd44593aso2585688276.0
        for <patches@lists.linux.dev>; Tue, 11 Jul 2023 08:16:53 -0700 (PDT)
X-Received: by 2002:a25:cd85:0:b0:c60:fb80:99f7 with SMTP id
 d127-20020a25cd85000000b00c60fb8099f7mr13925299ybf.16.1689088612983; Tue, 11
 Jul 2023 08:16:52 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230710142227.965586663@linuxfoundation.org>
In-Reply-To: <20230710142227.965586663@linuxfoundation.org>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Tue, 11 Jul 2023 17:16:38 +0200
X-Gmail-Original-Message-ID: <CAMuHMdVcZ2W7o42ZAdMHfPYZ9d0MCRat_PKWoh=JDHK=m=dM1g@mail.gmail.com>
Message-ID: <CAMuHMdVcZ2W7o42ZAdMHfPYZ9d0MCRat_PKWoh=JDHK=m=dM1g@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/424] 6.3.13-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Mon, Jul 10, 2023 at 4:29=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Jul 2023 14:21:05 +0000.
> Anything received after that time might be too late.

> Zhanhao Hu <zero12113@hust.edu.cn>
>     clk: imx93: fix memory leak and missing unwind goto in imx93_clocks_p=
robe

This commit was flagged to contain a bug by two reporters almost 4 weeks
ago, but no one took any action. Hence I have sent a fix
https://lore.kernel.org/all/20230711150812.3562221-1-geert+renesas@glider.b=
e

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
