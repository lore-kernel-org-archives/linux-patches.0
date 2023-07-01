Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02FB1C2F0
	for <patches@lists.linux.dev>; Sat,  1 Jul 2023 15:01:31 +0000 (UTC)
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-98e39784a85so514867366b.1
        for <patches@lists.linux.dev>; Sat, 01 Jul 2023 08:01:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1688223690; x=1690815690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0wvLshWsSLBZ/5yypeB0xY2a5lfsRQLT8GONX/h7vZc=;
        b=Vzh8noQVqqW864cbnbZfuwXl8zqhfSTBu2+WsqTsynBDuuI7zabbsV7BA0Zw8phT9+
         SxSj/0aocyVKBgaBVVL5TjjrvGE5pK6NJilunjsycq99mi4sM+lSALLMt/U8apFunZZk
         CcKf5ISen06w3p+s6yqmayVbMEaiY5uvtU5Kg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688223690; x=1690815690;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0wvLshWsSLBZ/5yypeB0xY2a5lfsRQLT8GONX/h7vZc=;
        b=TS361v3/ugVuchJEPmsmWe1SxkDn716G0JzDWJUx1vd4XfHYn5yL9zZr5SPsPK7pZj
         rYQHLYWYV59d+/zvjTql5YbGLB6mWIuWGeZk2YfWOoVTWY6aZEKr/FxuLZEvzvSzr91U
         +t/Hi4T5lBGAO23tAhMEef9GWLBLHvvEdVEmISdvj/zj1DPb+cIff2T8Qg38itIrqHki
         FE77E/EvbnZNF06qtbRDwhkI4KwsHLrlQ38/wIZtW88NSOl3I827ixSCPFg2EPf5YDLm
         epKRpYpBeNBegiCS7oFGG8P1IIL2eRj+ItxpG5ufaY5J3Cfns3PQMayy9gfNxS1oPWa2
         qrig==
X-Gm-Message-State: ABy/qLYsYpcoC89OSeTZhHSbI/5y81zQjgJ6Md3D9YbbFuzfX3X5oGZQ
	+AwSiky9j5LbP02PGX5srf/tu/XBU94vesWiklUHUQ5V
X-Google-Smtp-Source: APBJJlFnQL4mOpTNoQ3Eynv4pFr+BQRiNauCVUT/oOST7DKWJQZW87wiHvWoaRSFFPfhbME0Y7D5MQ==
X-Received: by 2002:a17:906:2a48:b0:98e:2413:952f with SMTP id k8-20020a1709062a4800b0098e2413952fmr5071812eje.18.1688223689998;
        Sat, 01 Jul 2023 08:01:29 -0700 (PDT)
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com. [209.85.208.47])
        by smtp.gmail.com with ESMTPSA id y7-20020a1709060a8700b0098f99048053sm7883230ejf.148.2023.07.01.08.01.28
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Jul 2023 08:01:28 -0700 (PDT)
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-51a52a7d859so5073350a12.0
        for <patches@lists.linux.dev>; Sat, 01 Jul 2023 08:01:28 -0700 (PDT)
X-Received: by 2002:aa7:d047:0:b0:51b:f862:7b6a with SMTP id
 n7-20020aa7d047000000b0051bf8627b6amr9564270edo.14.1688223687666; Sat, 01 Jul
 2023 08:01:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230629184151.888604958@linuxfoundation.org> <CA+G9fYsM2s3q1k=+wHszvNbkKbHGe1pskkffWvaGXjYrp6qR=g@mail.gmail.com>
 <CAHk-=whaO3RZmKj8NDjs4f6JEwuwQWWesOfFu-URzOqTkyPoxw@mail.gmail.com>
 <fbe57907-b03f-ac8c-f3f4-4d6959bbc59c@roeck-us.net> <CAHk-=wgE9iTd_g20RU+FYa0NPhGSdiUDPW+moEqdHR4du1jmVA@mail.gmail.com>
 <CAHk-=wiN5H-2dh2zCo_jXE7_ekrxSHvQcMw4xfUKjuQs2=BN4w@mail.gmail.com>
 <fb63ea7b-c44b-fb1b-2014-3d23794fa896@roeck-us.net> <CAHk-=whh_aUHYF6LCV36K9NYHR4ofEZ0gwcg0RY5hj=B7AT4YQ@mail.gmail.com>
 <e4dd115b-1a41-4859-bbeb-b3a6a75bf664@roeck-us.net> <CAHk-=wgBAhFqD6aoD2rL0qws8S1erdbrvmQXuYi=ZFEUVNuVfg@mail.gmail.com>
 <CAMo8BfJ+FcR8ZfNk8GNL5pRsJO13O=on8ewRHSJkuQ85_WPk0A@mail.gmail.com>
In-Reply-To: <CAMo8BfJ+FcR8ZfNk8GNL5pRsJO13O=on8ewRHSJkuQ85_WPk0A@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 1 Jul 2023 08:01:10 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgy=8CEGoGJnHkuz4p0pR+Q-5RvsM4VNyYeWabshYr5yQ@mail.gmail.com>
Message-ID: <CAHk-=wgy=8CEGoGJnHkuz4p0pR+Q-5RvsM4VNyYeWabshYr5yQ@mail.gmail.com>
Subject: Re: [PATCH 6.4 00/28] 6.4.1-rc1 review
To: Max Filippov <jcmvbkbc@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, Chris Zankel <chris@zankel.net>, 
	Naresh Kamboju <naresh.kamboju@linaro.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, 
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de, conor@kernel.org, linux-parisc <linux-parisc@vger.kernel.org>, 
	sparclinux@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>, 
	Helge Deller <deller@gmx.de>, Jason Wang <wangborong@cdjrlc.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 1 Jul 2023 at 03:32, Max Filippov <jcmvbkbc@gmail.com> wrote:
>
> Thanks for the build fix. Unfortunately despite being obviously correct
> it doesn't release the mm lock in case VMA is not found, so it results
> in a runtime hang. I've posted a fix for that.

Heh. I woke up this morning to that feeling of "Duh!" about this, and
find you already had fixed it. Patch applied.

            Linus
