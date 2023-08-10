Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B20122F08
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 19:37:01 +0000 (UTC)
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-99bed101b70so177917266b.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 12:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1691696219; x=1692301019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bxXYghb+eoRa0mcUhOiyjnEloU2cZwSMtKrX/TWEnDU=;
        b=he8HYHSJPSdntzb4i8YGrAwjyffGuiKA+woE/714lov/drFNz+XV9rfgGmQoP63wvn
         i3r2sKG8MCblRLEmyec50FnSvn5r7WMkU7Obv2t5smvlh1zTuVe+65A7hwv/VRCORTOm
         7LYPAzk87JhYV0o+MGL4GYOvaRAJbRm3vBfmg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691696219; x=1692301019;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bxXYghb+eoRa0mcUhOiyjnEloU2cZwSMtKrX/TWEnDU=;
        b=azaUZQNOgOEOT9//NS4O3feUKJfbNaMXK2JVbE0mFcEnZ4JqCO2fQxsVtI+Rli1W0w
         PJcw8rF9H+XAt+55kKoMr7PdDbHUjvS2xMO3CuG/XL+7YNzxLJn+Dhgv9w7SebRO0a9p
         YxV7aaGFAQH+CTl9I1bUPyV9ecN6cD6FPKYL4isdefmGmWKcPuxu/+Q8HbmT4se5kqhG
         Dj9OylC0/0P+9+kT2sCsfbBImtobAjffRXAJuWOZMMAWjvN/FYZbX971VJJVmj77diED
         SSaqfsFf8gYc2W9MwcUfPHY9EEx4U37bg6y688nWgISQkfbescuWi5ktlsMDIFjrmzUt
         vn3A==
X-Gm-Message-State: AOJu0YzvPxEQjeCn0tLT7gZLkg9Z4V35juhoDBs63tm9R8Ne2xxNlRhx
	5/TAM4UOYNh7aeuAomL4fmusU9FuvbHlVm7bWS+Zh9P9
X-Google-Smtp-Source: AGHT+IGH7SVEDKjtMfVE8n9+8wXv0Oe6GwBGr/hewPgA1vmIZomds58RVxz9NUGamIkLg03KLIZM1w==
X-Received: by 2002:a17:906:3ca1:b0:992:91ce:4508 with SMTP id b1-20020a1709063ca100b0099291ce4508mr3017433ejh.53.1691696219098;
        Thu, 10 Aug 2023 12:36:59 -0700 (PDT)
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com. [209.85.208.45])
        by smtp.gmail.com with ESMTPSA id v8-20020a1709060b4800b009930308425csm1328737ejg.31.2023.08.10.12.36.58
        for <patches@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Aug 2023 12:36:58 -0700 (PDT)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-523225dd110so1660318a12.0
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 12:36:58 -0700 (PDT)
X-Received: by 2002:aa7:d0cb:0:b0:523:5012:63d5 with SMTP id
 u11-20020aa7d0cb000000b00523501263d5mr3095069edo.16.1691696217947; Thu, 10
 Aug 2023 12:36:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103658.104386911@linuxfoundation.org> <CAEUSe787p3uDD9Q0wq=Y=PY0-wLxbYY8oY6T24dhm+qgK1MjNw@mail.gmail.com>
In-Reply-To: <CAEUSe787p3uDD9Q0wq=Y=PY0-wLxbYY8oY6T24dhm+qgK1MjNw@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Aug 2023 12:36:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wiTzjgRRPmfkwOr89uMuk5wdoG_6edMAnEdubX9bq8OSw@mail.gmail.com>
Message-ID: <CAHk-=wiTzjgRRPmfkwOr89uMuk5wdoG_6edMAnEdubX9bq8OSw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/323] 4.19.291-rc1 review
To: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, lyude@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 10 Aug 2023 at 12:28, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wro=
te:
>
> Two new warnings are introduced on x86_64 with GCC-8 (defconfig):
>
> -----8<-----
> drivers/gpu/drm/drm_edid.o: warning: objtool:
> drm_mode_std.isra.34()+0xbc: return with modified stack frame
> drivers/gpu/drm/drm_edid.o: warning: objtool:
> drm_mode_std.isra.34()+0x0: stack state mismatch: cfa1=3D7+112 cfa2=3D7+8
> ----->8-----
>
> Bisection points to the quoted commit ("drm/edid: Fix uninitialized
> variable in drm_cvt_modes()"), 991fcb77f490 upstream. Reverting makes
> the warnings disappear.

Bah. Stable should pick up commit d652d5f1eeeb ("drm/edid: fix objtool
warning in drm_cvt_modes()") from mainline too.

Sadly it didn't have a 'Fixes:' tag, so it didn't get picked up
automatically. My bad.

Although it's not like the commits it fixes were actually ever marked
for stable either. I guess commit 3f649ab728cd ("treewide: Remove
uninitialized_var() usage") got picked up as some kind of "make it
easier to apply other patches" thing.

               Linus
