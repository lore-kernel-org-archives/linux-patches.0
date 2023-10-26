Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700772D7A9
	for <patches@lists.linux.dev>; Thu, 26 Oct 2023 12:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-5a7b3d33663so6531917b3.3
        for <patches@lists.linux.dev>; Thu, 26 Oct 2023 05:20:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698322845; x=1698927645;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rwfH/fI/oq7RyoHmXtZ7J/iC1NW7ZB+6I+gOPXF7UYQ=;
        b=hEQ15aOJjXCbnbQ+PON2ysSkaik3O1iv4B4EvOq1KJqtu1ZIZSUDbzGJJfsdx4A3Ik
         mw2KhdvyaTbEenf/iQOJzw+72n/3z4b+QW78VQ8CNSplcuzYbnziNp/X5nX8xLnOdzZp
         qai7Jc6xgQHFZ78fZ8AAQwF4tZY23qaVDTmkL/Myey1+t8ETyhUYs/mS2Pf02VwBTK06
         P/VhSO9B/GbYS0Z/qt94AIQI/Rgeh5Aaq0zb1LbmyyiWdulDabz058jf1dRtVU+qcsiL
         QVju4F8m3iTSSBI89nLh0ZIMIri3UOdWBkDIZ+MIHoE+37AIclEv3L8stxvlJdBHnsAB
         D7eQ==
X-Gm-Message-State: AOJu0YwaAkxcy+bztyu/Be4bhn3TAg1pRU3pb5ImOgMyUAnESA3TY+ln
	HaBttXuJhWZV2WTaNdGAdV8rav255PYRaw==
X-Google-Smtp-Source: AGHT+IFIecAlTksmd72HiVMChPaf6uWq9dqijwGnJ66zbisEPD93kFc5V0jmz3odKv3L+IotkRwACw==
X-Received: by 2002:a81:7bc1:0:b0:5a7:a81d:e410 with SMTP id w184-20020a817bc1000000b005a7a81de410mr15482250ywc.18.1698322845217;
        Thu, 26 Oct 2023 05:20:45 -0700 (PDT)
Received: from mail-yb1-f173.google.com (mail-yb1-f173.google.com. [209.85.219.173])
        by smtp.gmail.com with ESMTPSA id n20-20020a819e54000000b0059f766f9750sm5921853ywj.124.2023.10.26.05.20.44
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 05:20:44 -0700 (PDT)
Received: by mail-yb1-f173.google.com with SMTP id 3f1490d57ef6-da077db5145so558936276.0
        for <patches@lists.linux.dev>; Thu, 26 Oct 2023 05:20:44 -0700 (PDT)
X-Received: by 2002:a5b:608:0:b0:d9a:e947:447b with SMTP id
 d8-20020a5b0608000000b00d9ae947447bmr18024321ybq.14.1698322843939; Thu, 26
 Oct 2023 05:20:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130126.697995596@linuxfoundation.org> <ZSRVgj5AqJbDXqZU@duo.ucw.cz>
 <ZSRe78MAQwbBdyFP@duo.ucw.cz> <ZSUy+zA0+Chm6dFb@duo.ucw.cz>
 <ZSU+GHl1q7T/TBp5@duo.ucw.cz> <ZSWg1fv3gOyV5t+h@shikoro> <2023101057-runny-pellet-8952@gregkh>
 <ZTgZa1ic1iFbdaTM@duo.ucw.cz> <CAMuHMdXQApuOPfU1zNKcHKN5=fCuLBSDiLtF06U7e4Tx0+noyA@mail.gmail.com>
 <CAMuHMdVrdmBgopnPnJK_ij52wz2WVBdYRHur2KfosFnT945ULw@mail.gmail.com>
 <CAMuHMdWZvTGrFgx_o3g3usOwkDvD2rw5QH9_ibo=OKdw17sAzg@mail.gmail.com>
 <CAMuHMdXvpiGQ7jqAG69Zo=10wV-E0bioC9AYUHwwhRGmLXygWA@mail.gmail.com>
 <7d7a5a15-3349-adce-02cd-82b6cb4bebde@roeck-us.net> <CAMuHMdXbPZ0uz0NnE1xhUD=QtaAq+TinSW-PrWPMpGe4h=7Spg@mail.gmail.com>
 <CAMuHMdXNjopzEFCFBxxuYNCFMmj4SvMQ2PmZ4hZDHLGZGUHf=w@mail.gmail.com> <CAMuHMdU7-5R4NkwMdbLxovBY4=ePtPDs2SYXjWeGc_Yz3JcjPg@mail.gmail.com>
In-Reply-To: <CAMuHMdU7-5R4NkwMdbLxovBY4=ePtPDs2SYXjWeGc_Yz3JcjPg@mail.gmail.com>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 26 Oct 2023 14:20:31 +0200
X-Gmail-Original-Message-ID: <CAMuHMdU=O=gYEA_qOh7Unr8ovtnKJi12qxWb447KxvkhqyRshw@mail.gmail.com>
Message-ID: <CAMuHMdU=O=gYEA_qOh7Unr8ovtnKJi12qxWb447KxvkhqyRshw@mail.gmail.com>
Subject: Re: renesas_sdhi problems in 5.10-stable was Re: [PATCH 5.10 000/226]
 5.10.198-rc1 review
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pavel Machek <pavel@denx.de>, Wolfram Sang <wsa+renesas@sang-engineering.com>, 
	Ulf Hansson <ulf.hansson@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	niklas.soderlund+renesas@ragnatech.se, yoshihiro.shimoda.uh@renesas.com, 
	biju.das.jz@bp.renesas.com, Chris.Paterson2@renesas.com, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, Linux MMC List <linux-mmc@vger.kernel.org>, 
	Linux-Renesas <linux-renesas-soc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 26, 2023 at 2:08=E2=80=AFPM Geert Uytterhoeven <geert@linux-m68=
k.org> wrote:
> The solution is to backport commit 9f12cac1bb88e329 ("mmc: renesas_sdhi:
> use custom mask for TMIO_MASK_ALL") in v5.13.
> As this doesn't backport cleanly, I'll submit a (tested) patch.

https://lore.kernel.org/r/1b9fda30f2d86fab50341a947d17b5206a2c7507.16983213=
54.git.geert+renesas@glider.be

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
