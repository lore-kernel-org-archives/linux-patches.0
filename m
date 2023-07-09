Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 613F628E3
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 22:56:07 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-53fbf2c42bfso2938981a12.3
        for <patches@lists.linux.dev>; Sun, 09 Jul 2023 15:56:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1688943366; x=1691535366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QPdWGUJfSkwMpEftrHb4D0cEYRriyUH34Z10bwypwcY=;
        b=CLsejkqejApXka8e4+zbRWOj4b3p+RUdEXNs8qqyD/iTB1djayTt60FQuWqGiaNKCI
         /BqsFe9v42atzSr89uUZwE7J7VcBC5Namdf7xLM+cCDZd8NOlxVhE/laMU7A/cCHDzRe
         DFHght8gY1kanTVEZhcAygHGumfgVHxIDmhqd4Ib6R6ExQeyM+2HiZxzOFyU7FFMVT1C
         eeaAAE71uf2DpbVyEq5AyUMWD7lmTNTMchYxhXPTGOsYbB/Dsl2iYEW+v3R2TiWTdGAM
         YE9jr4dKWMolMisYUdXcifg3Tbkl10aWXyAek0zjaJb2qtpehDfr7PZECrp78xfCXNKo
         WujQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688943366; x=1691535366;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QPdWGUJfSkwMpEftrHb4D0cEYRriyUH34Z10bwypwcY=;
        b=MrQzaa/1nBGFP71+92Wwj89cGKfv0izWefd7J1kbeHdliIFv4+fI5o4EnjFOv/Jhdp
         mGTYmCHYn1UxgVDsJkDAHUQPIH62RaVjtQnMsKDrTpJazxs59+rAUFbp74Bknw0eajNz
         ghiwxWTJt7SAUZooUVzXBfHvuuUO2vuVsoYmBjbNjTAjtpm7aQEGRH0sgoW7JEKrH+bt
         gx+UXwzEqOJuBowaFP5Y2MwmeupFSeoaiGc7bnRignS12+v5M+T7w+V/ZWHZ6xXKDpD4
         hRtishxoQn1qqPcxyB7XiY5q9kYYkQlKQ1CF6GYgVHlZRbfuv4XDEd75knAB3VEppwcK
         GZdg==
X-Gm-Message-State: ABy/qLZRFeujdTMqHz2XubcdXAGcLedjaas6jVDj15Nt+osDfb5UyOSb
	r/0GYj1Rt7guKz/3IPCKJ4lbVQAEzWlDBleapFjW5w==
X-Google-Smtp-Source: APBJJlHR1RTkC5VFgPWsyq6+xGci00cEkBZUr3KXhTYYNqOa6OOJZOmGZA53j4DADL++r3rjSqPqo4w8ydU3ANiKpSU=
X-Received: by 2002:a17:90a:b283:b0:262:d661:75e4 with SMTP id
 c3-20020a17090ab28300b00262d66175e4mr11412368pjr.0.1688943366456; Sun, 09 Jul
 2023 15:56:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230709202353.266998088@linuxfoundation.org>
In-Reply-To: <20230709202353.266998088@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Sun, 9 Jul 2023 16:55:55 -0600
Message-ID: <CAEUSe7_KV_+jLJzE4u4_DHUPbi8Z=ASh-=aKB_JQr4+pz_8GVw@mail.gmail.com>
Subject: Re: [PATCH 6.3 000/425] 6.3.13-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Sun, 9 Jul 2023 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.3.13 release.
> There are 425 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jul 2023 20:22:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.3.13-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.3.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

This introduces a warning:
-----8<-----
  In file included from /builds/linux/block/genhd.c:28:
  /builds/linux/block/genhd.c: In function 'disk_release':
  /builds/linux/include/linux/blktrace_api.h:88:33: warning: statement
with no effect [-Wunused-value]
   # define blk_trace_remove(q)    (-ENOTTY)
                                   ^
  /builds/linux/block/genhd.c:1187:2: note: in expansion of macro
'blk_trace_remove'
    blk_trace_remove(disk->queue);
    ^~~~~~~~~~~~~~~~
----->8-----

This is again with Arm 32-bits on omap1_defconfig.

Bisection points to "block: fix blktrace debugfs entries leakage"
(d8c9d0067dbd here, dd7de3704af9 upstream). Reverting this commit
makes the warning go away.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
