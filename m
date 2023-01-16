Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F2546B5
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 18:58:48 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id jn22so31166147plb.13
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 10:58:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wMdqQ9WKyEOKQ2nD0q5t9awURcXqCIpB7f7QhoNXh7w=;
        b=eQxeSlNM8DqlBq2Qx+xzIvO2vXE7sRUAOMnZYL6y9wLHQZ6+3Yt18SkihJVUvYI5hi
         MONR+Q6Qzo3J2UnVq8YuNZHQkD0H29AwFYbpuuPAPy1j0eSHsdBLiBgnJHKrB4k1SEaV
         lh4A7l2hwvngf7P2f0Guw5zK91C14nUH5W4DICYKX6IRnQioOKXuuAxQbnImj7cFosgx
         0bJw87uQhEYEBkeNsbqvsA9As7SPgCHJjYCiVs04Z3i8wfltTN9+Oe9gVh1QtWqQ5cfe
         htglaIAJa6OlYqo/6b7sXhtRogyD1d9sHFUxUXQQQnU4B8ca8OJq/rEdIaWqN8sUdOIc
         A7NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wMdqQ9WKyEOKQ2nD0q5t9awURcXqCIpB7f7QhoNXh7w=;
        b=sEqNd2PkS4iiCBl5Coy7ahgGBzjp8ja6YB6Nj6OavF3QorpezixPrRj7w+dymwKqfF
         tOFEarmUOV1MhJxIuXAmxWkg2kYBSror4pNK3RwWyg3woQ827wx44YiOKRk8Yb7UMK/s
         2Kt6Y9z4xG3Dp8IYi3MUYg9+XUIyNoKrlGEbdd3kP4vr8mtpou83mHkV3jmSPwoZfd8F
         S0kv3kHSYhS22F29yU7tnhmd4tR3GTX+434rSvOwXzfHPbTtR3cTyd91dngcwkmfJMt/
         aiPN2cILV6clVIVpgwXR70XrSrtFVutMkHwYCHNalZvPGuTp5u3UDlAX2S5ElPG6wm59
         X2zw==
X-Gm-Message-State: AFqh2kq01I2Qbh/ekA54NAW4Ss+ji2A1kEQk88UoSNjc7q04EWSbhlX8
	krSo+qkE8+AwBWasISKiv2QWDrr/wV1KP5NlXZudjw==
X-Google-Smtp-Source: AMrXdXvgQkJvZx20Qrm73O1WBO9QQPkNVWCNRY+MTHZzXqBOArJ7mPlGB32zLAUDQ/LLu4EgwsOEmrr1jY0zaGg48Ew=
X-Received: by 2002:a17:902:cf0e:b0:189:7441:1ada with SMTP id
 i14-20020a170902cf0e00b0018974411adamr70720plg.13.1673895527893; Mon, 16 Jan
 2023 10:58:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154743.577276578@linuxfoundation.org>
In-Reply-To: <20230116154743.577276578@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Mon, 16 Jan 2023 12:58:35 -0600
Message-ID: <CAEUSe786JgSDJOtCU_tB81ddYxJk_sSfgzM33r7iFccsU7O5QA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Mon, 16 Jan 2023 at 10:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.164-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Preliminarily,

| /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c: In function 'dp_aux_isr':
| /builds/linux/drivers/gpu/drm/msm/dp/dp_aux.c:427:14: error: 'isr'
undeclared (first use in this function); did you mean 'idr'?
|   427 |         if (!isr)
|       |              ^~~
|       |              idr

It's currently failing for arm, arm64, (not i386) and x86, with GCC 8,
10, 11, 12; Clang 15 and nightly. We'll test the extended set of
architectures and update momentarily.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
