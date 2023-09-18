Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8B44C86
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 05:34:38 +0000 (UTC)
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-5230a22cfd1so5047188a12.1
        for <patches@lists.linux.dev>; Sun, 17 Sep 2023 22:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1695015277; x=1695620077; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JAs0kcdMl/DoP/iL5tBvKuG9qrkDrcB6k4947uVL0cQ=;
        b=HGqIsNK4PcamvKC6PZ3bmYmlO277ixark8vzLV/N2mucPmOAvAeQgR8AB23yREnRft
         OsfAbh2hQRrCXpcFqXMY1FBQ8wJfE+BRLnnhdQU4Dg6iUmV6hTttMPm6L/F52Nvvz6OJ
         hvHEJ2SqQFZXTQl6TfteEt1vM8yojh++nM/Rpd6bWXCH76F8LPoP8FLz5s8Fnj+P7Xng
         DL6nV6glUHyJ3CvrnVWjNdGvnHfgvfCwdwi+nt2Ic4qjcaDXJyXvJGfS368BGj0FJINT
         kJWQx517Z9klWPA2qNrLZavVxGSwjp0gKRqrSgp4vSYvJRhBO7oWwPNWe0ACcDI2g66A
         q0sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695015277; x=1695620077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JAs0kcdMl/DoP/iL5tBvKuG9qrkDrcB6k4947uVL0cQ=;
        b=bONBC0egWkQL9QNY941BLVlg5lHRaDPWYRDKUfv10+nwsdhf+UJBlQaoY58HydUOmV
         iSB1hVbiaj1jE7+cQBMDIN5TcF4ZVW/0RgyqDbYffrrz2DSTd86gTF6h5DeYrCyomXMK
         MIUpNrJeuVWTcSVi4wzQf26oKg6V32dh71AuWHrVdnM0OudzavvV5/T8UX0cBawwknIV
         p7n3TkUwglbmSmJL9rVpLdnxwOGjLA0GllQb9XqIDgSA8/bghtDBQ5S/+qLhRGajrBsw
         FJNG7tFAKZwppR8GiqWwFK7zo55YcwxTO57tAwGizzyQNL6C247f61WQZWbiBSEhEui+
         5Iqw==
X-Gm-Message-State: AOJu0YxR1ezSyafaOa8RgYLRjtaWT0ieyZh+GRd/HLKASTzWuIiBcYOa
	hMQGRxoa98VkQI75fn7DK+7VixXeQlbAOjEbCgE8Pw==
X-Google-Smtp-Source: AGHT+IHbQfrgDKC8eysrPXQk3qAY1NMSiNM+gX4sza0ZICIOgDc2Kb0HSY3yfpRZ3jeGXHl9hu5DnhCmo6Ef6NXxbOc=
X-Received: by 2002:aa7:dd14:0:b0:52f:3051:f7dd with SMTP id
 i20-20020aa7dd14000000b0052f3051f7ddmr6172159edv.35.1695015277156; Sun, 17
 Sep 2023 22:34:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191040.964416434@linuxfoundation.org>
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 18 Sep 2023 14:34:26 +0900
Message-ID: <CAKL4bV7k_Hi0rugjnx1Gf6Bqae93c=28nwhN1XfP7arqkLKqNQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
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

On Mon, Sep 18, 2023 at 5:03=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.54-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.54-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
