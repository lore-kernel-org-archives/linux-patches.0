Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3042A8F55
	for <patches@lists.linux.dev>; Sat, 30 Dec 2023 15:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="M6tO5Iyj"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-28cc07d8876so122705a91.1
        for <patches@lists.linux.dev>; Sat, 30 Dec 2023 07:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1703948729; x=1704553529; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3TEYAiX+bNQzKptVufen3ugGP71A82gfbOiCal17chk=;
        b=M6tO5Iyj++PI0S4SJ0IEd7OB9ic1QqAxlCmnWX7BfzAFIgWoQF9gC2MO37hL3zIKX+
         oYGQaXDb+RPXzh24JdOi3rdh4R6lHxl/hDYAQOTcJ2ibBJuUs8pHfvLYyC1BUMaSPto4
         2hsE5IqijW7ds6MXD9EU3LmMRtBDbvXtYlsB/4J4GCN3k97z28GJbdrIT7G28P8qwmyf
         bVrWXDFDsvzJwGrUxrLgf3FrRUr4ux7S0CIXxzKqd73j6MmwYZdGqHxcWD/HtANOkLy7
         wop3d4Tq+Gx/OV/6p+ak9N8LuzH1F0PtfNVBm1DG2OwtJ0//7zYBuF5vczSOJjp4t4Xh
         Cb6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703948729; x=1704553529;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3TEYAiX+bNQzKptVufen3ugGP71A82gfbOiCal17chk=;
        b=QB5QM90zZnreMxRP/E/B3k3iz8XOBrulUux2K1cflXmLlWmiAMxdcGc8UhVUkIhWhT
         t7/y1ZtdWpYzqPWOvoRGLwggPO/Vx/D8XgV1/eXOC04Q1h4THGq8MoUcNmyOLydZNMEM
         h0EnRxNEKuQd4rfWTYlEUebG3Rl1/QgjtW/HqxZiA2O2CsCUREef11FroidxpxbBQRPN
         qfSESPU3UOdVi7CHyOHCAHJbT5ITCiqG2TJkwZoWjUfYDHIijFNhecqv28QE2vgli/yq
         dXyLYri8Hs3mbsoUFat/kxt2qqmn8bKXcD4JwuX3l7WKXnCARD3O0UT2gIPG7jvFS6sF
         uGKA==
X-Gm-Message-State: AOJu0Yw4cBvij7UNj95mrDVfiHy6a5+PfcXl/BCgZ1a8IXcjkElgx//2
	Gq/mnwtlLS7BrGQEJ4OMLx+LzeJeOlU3pUCsHUSsx6/3+0hhPQ==
X-Google-Smtp-Source: AGHT+IEmKJ6+SVcBplkQkP6nIVcPQFmJeBLzWGJdt3El4x6EUmZ7FEIfxnhfLwwI27JJCMsJdHQs7z4nykiFFhUIj+g=
X-Received: by 2002:a17:90a:f182:b0:28c:3b37:acb0 with SMTP id
 bv2-20020a17090af18200b0028c3b37acb0mr3473793pjb.17.1703948729452; Sat, 30
 Dec 2023 07:05:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231230115812.333117904@linuxfoundation.org>
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 31 Dec 2023 00:05:18 +0900
Message-ID: <CAKL4bV5hCwCxCX28akpXFE178ny0s_rSXuJK3JYz=RC6z=tYTw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/156] 6.6.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sat, Dec 30, 2023 at 9:01=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 01 Jan 2024 11:57:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.9-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.9-rc1rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 13.2.1 20230801, GNU ld (GNU
Binutils) 2.41.0) #1 SMP PREEMPT_DYNAMIC Sat Dec 30 23:43:57 JST 2023

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
