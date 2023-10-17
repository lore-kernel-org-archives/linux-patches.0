Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C252015AD0
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 11:50:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="hXZA21iF"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-9bda758748eso617244866b.2
        for <patches@lists.linux.dev>; Tue, 17 Oct 2023 04:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1697543452; x=1698148252; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gWNFjq7J1b1bH2lphfT1Fu13xafbJk+ueucEMZRdQUY=;
        b=hXZA21iFN/Z9uJC0Nx/Ad6srV8pBuJ3mrc1/eEX7krulj/iwdw1G4T1KeefZxFN1DA
         JAAwfq9BiNwIF5KKHvjYIHlqVu0e0q30OQiWfbukQONQNRbSs/FKIHvfZbm1UjibiD1V
         rxGkKSl4LHP0Y4jE9jGmRmyKxKQnE6At+QbZMZJzbCgF53Kapy1IwF0WfJPJ1ePUEho/
         3D2B/eAKh2PCNn1M6OmGweiQDpEQrmtPY5Gmb02Tyycz/XaE7OtArizSlYVtqOBpERT9
         Jk7SYhljNsG8bm8PgFfxaVmC32O+ffzpaLLyYt+iLGJYRZYYgNh05GLZQmf3z4B+25Ug
         ilhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697543452; x=1698148252;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gWNFjq7J1b1bH2lphfT1Fu13xafbJk+ueucEMZRdQUY=;
        b=sY0bE+VZC64+GpJKCVeJz/hMML8U4zlhoKCejlKV62lahrlTQX+CawXQpGtu1MIO06
         7L0CkKI/GYKAvRIJ0HIYLk8aN75dpv9f61y+vLHNdNKoYo9vb5lBxUi7HFWZcNGZpT3y
         l46SFgKq9UaJEkkuw+Rt2FFpDCOxfyEHn5Xj7wZZFVkEKklMh4hgqnala6x8H1vmiI04
         5d2nppkVxzg0HyCm0RNeBaeA56PMpNG880lXJ/Xu7kxpG5kQtgSW5W08FWX9eE9uWSBq
         QMSrdmdw1ckN5W/YHrNWfYLXglyFWputR/tUT/ySywEM+jvMSGwdc8INV46SdluxBf2d
         KhHQ==
X-Gm-Message-State: AOJu0YzQbOjhG89KapLIQiWyRIztpkJGpClaQWuJ/ssydnls8ycmRj82
	eClqbtKnIE9REvMuLq4mG6ovEiR3ScD5XAU+0hEXXw==
X-Google-Smtp-Source: AGHT+IFg+ZLZEHu0kdf0bELio3Q7hx39EsGlyjfnPCLtBOZvQ7d8GQpkLSwxOk+q4t4K6UNt+The68B2G7eTkvc71yI=
X-Received: by 2002:a17:906:da87:b0:9be:6bf0:2f95 with SMTP id
 xh7-20020a170906da8700b009be6bf02f95mr1582393ejb.20.1697543451569; Tue, 17
 Oct 2023 04:50:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231016084000.050926073@linuxfoundation.org>
In-Reply-To: <20231016084000.050926073@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 17 Oct 2023 20:50:40 +0900
Message-ID: <CAKL4bV4Dy2qTKQ3NZo3Gh604c8Cn7t5n5xUkajkjkRys8xByzw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/131] 6.1.59-rc1 review
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

On Mon, Oct 16, 2023 at 5:52=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.59 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Oct 2023 08:39:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.59-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.59-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
