Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3482B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:24:13 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-523100882f2so1033791a12.2
        for <patches@lists.linux.dev>; Thu, 21 Sep 2023 05:24:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1695299052; x=1695903852; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bnhBiFBKyPiQHRaYS9dfvLmsrYNmtEwUZ70lBW9wVas=;
        b=tFMeE94wWKi2LRKonvw9QFm5x416AaPWWcbLZa0v+0+HtbVNHyvmiRSN3O3qZy2snT
         i8lX4ZYBMZsVYQ7pwLvjrzEzrzgoFBgUcDFtkKfDKVvLHNwWOnjyMwKpCDjvWsQKVCfq
         E1ePdoWVYRt2ql7P6ksFCKAr89Fy5Nk9Z3l8u5GWGU5i6D1nyorL+pEbjPoolDnMzLDf
         sIMVGY/Czw/3/JZG10gLYJGl+jLXb/jLryQe2/e1VxjsrADjEEsjytltbdS/IF5L3HgP
         CpNHHfp55KkadGdx4HLUbMin3jn3uen692nksKrsJx8jgjr21YoAZkOYmqq87vF+KLei
         w2fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695299052; x=1695903852;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bnhBiFBKyPiQHRaYS9dfvLmsrYNmtEwUZ70lBW9wVas=;
        b=K1RiMkoOYKP6dzo0DezG0vdyXQt2ZUC7WbXmBe9vhN/u/6jM2Kmqn1TH1KiTGVyyW2
         7ZRWSZEqg7umqfH5QLHJnpsDNlxLrxjFRRFBz2FwGQbqmB6MVlrJiuPYxWLTU3teJjrg
         TsdGNypKfvww359zXlwbEiBBzUE+1SiaGB+d7b9HDAs+WRK1SITz2WmjnaZf6b3WigCh
         PVFIamKnh83j8QyVMubXKXFsCSE0ZH6KhuDQB5xdhpfqkOViEcsrpuFQVBZbv8X9XiAE
         MaF8aGlVGxNDTeXP0jMVhTG0xHeLNJVp0y6WABg3LPnVYL1E+HXsSZ5cdqIo8i8kLtVm
         Bv5A==
X-Gm-Message-State: AOJu0YyV8+TDnzFW73aLE18LvmXKahvh17fmW888HSXFEdiGBZhdIHWM
	GvdMSbVnQ5sKvH71vjMxqKxo7Z1ppfyVvf1QOQLoAw==
X-Google-Smtp-Source: AGHT+IFZArCnDCg0IaUGDU5EJzWdv+w4dn7a4FoKjDrxayQwXMP+yWbdPJpvIebBcd22esKd9Y9YYWiI1e6z6nvhVig=
X-Received: by 2002:aa7:c992:0:b0:52f:b00a:99be with SMTP id
 c18-20020aa7c992000000b0052fb00a99bemr4603308edt.33.1695299051958; Thu, 21
 Sep 2023 05:24:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230920112835.549467415@linuxfoundation.org>
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 21 Sep 2023 21:24:00 +0900
Message-ID: <CAKL4bV6gnu5Ufjru10sWG-3dew25WKtmtdPXQNfdrgLc0nfX_g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Sep 20, 2023 at 8:55=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.55-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.55-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
