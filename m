Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33381859
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 14:31:57 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id u19so29614104ejm.8
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:31:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kKA2m1GpNhmHLnfnQbZcy+sQ/FmMKp62G6SqfzzaR/M=;
        b=GDczp8FDlsiECF3tY8paH+ODlk3YQmcQFUEjE/Oa2vdD3wnxeYKa9SJqSCLsn+kB+K
         Tk3MEwBVsD5awvi2o5OLix9zX7WpBiC428wLOjBDVzB/gkY8mbD5GuzMWelCVN6EAWVu
         hezcxEreawPnKBIm4oUTx07+MJ6ku5nnwX61E9kHg/1O7TkLnXdFlYqOy6XKau+TFp6/
         9vFym2pLNuT3dRTXHZHlJ0KHABWb8/FXdXdFRZe55XI1PTqabwb31Xt9/Q+KEYjb+NO8
         9VgBPf4JscWb3Qu0gKJUbklaFUvRpgAfc/DH5eq3j1yNizPOQMfy9krmfkiTIVBuaoTh
         7yEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kKA2m1GpNhmHLnfnQbZcy+sQ/FmMKp62G6SqfzzaR/M=;
        b=7zCMEq7tVARLQncZRHeZc7KsHCSJzCuHAtdeCPH9Vl7IDX7+Yt/6SBd7QO2m6JeYsR
         no+6eifkAogkrljHTA8wRB3azMQ85+mnki/G4ps+zp6AfzNBsUCsJ2P1ykaUttc7hUOq
         pLgDVqBN1iShf37W4PEkSD4mt1kDy9XVG1gz4dMV2chlAtyKyGWi4m2oFC3lE6JML4Ys
         EvikriPN35HYR3M4Eg7yIBPzsA2hC6jI4n+gMTfaG0pUOc3DiyfwZAXO9s2lrnoqH9re
         uVG9Nd+GUhqJaIiGD6sQixTepikvlPLHTKqLNCSi0VR6aY69zYT4F1o/yfQbbII7+GM+
         gKGQ==
X-Gm-Message-State: ANoB5pmVWs83K4x+q9aPUNGC0k+WzSJtW7WdXEe8Vn3DeHHpQYzAvXOt
	gIg2O/Pe9zYmwiTCJ6dMboCiyTRBBRtGm/OoUsc=
X-Google-Smtp-Source: AA0mqf4Df+9Kirvr72XWWNGdIIHj0am8gCWMVFtNo1gKBiqkjG+h4fG/V2e23bwp/xaEEI/U1+5KQF9JWa50d/cJwm4=
X-Received: by 2002:a17:906:6d03:b0:78d:9d0b:a9f6 with SMTP id
 m3-20020a1709066d0300b0078d9d0ba9f6mr38397050ejr.661.1671546716154; Tue, 20
 Dec 2022 06:31:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org> <Y6Gp25YJ/m+DcgWH@debian>
In-Reply-To: <Y6Gp25YJ/m+DcgWH@debian>
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date: Tue, 20 Dec 2022 14:31:20 +0000
Message-ID: <CADVatmM9_d6gOo7VTM1ybVgNDM_w2+NdKM3DC67L9KjeWL7Ltg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

On Tue, 20 Dec 2022 at 12:26, Sudip Mukherjee (Codethink)
<sudipm.mukherjee@gmail.com> wrote:
>
> Hi Greg,
>
> On Mon, Dec 19, 2022 at 08:22:39PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.1.1 release.
> > There are 25 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
>

<snip>

>
> Boot test:
> x86_64: Booted on my test laptop. No regression.
> x86_64: Booted on qemu. No regression. [1]
> arm64: Booted on rpi4b (4GB model). No regression. [2]
> mips: Booted on ci20 board. Regression.
>
> Note:
> networking.service is failing on mips ci20 boards. Issue seen on v6.1 also.
> Will report upstream after bisecting.

This has already been fixed in mainline by:
ca637c0ece14 ("MIPS: DTS: CI20: fix reset line polarity of the
ethernet controller")

I have tested 6.1.1-rc1 with the above commit cherry-picked and it has
fixed the issue.


-- 
Regards
Sudip
