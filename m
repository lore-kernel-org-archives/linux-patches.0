Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B96B138A
	for <patches@lists.linux.dev>; Mon,  3 Jul 2023 23:02:21 +0000 (UTC)
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-51d810010deso4686961a12.0
        for <patches@lists.linux.dev>; Mon, 03 Jul 2023 16:02:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1688425340; x=1691017340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ugEEPDI78ePccslV5nFSda7Y+u/b3y8toq3vF1cGXRM=;
        b=Gxg1d296aYhiThTBErhnK4dFyBlXUAQZR1j5FPxBeNRWewzsI9EYOok18orw1+ka1x
         +bln1Pl9uVN9FKWcvin7zQoyOTdfSeP7iYT1KquHv/2Guvb2gEQwQ0bS3yurHb84tRcd
         UZn/uttOqZ42oBsM2Lu7jsF+dofR+ZkktI39f1FtTVw5cnxdpAv0WkPyPnEqoLhgumXg
         y6tUYBc+rnuSm1I4rgSIcZhOPR2nIvmgJ5+hSjhmOY/sX7RqoCZY37moGpkZjpQ94Fn6
         SwfY8aaKo0F2wt8qwbc3NJqvuyTok8oCtlw8LNWm7yoWR9iVHYiXNBGMdl+HkL7AJrLc
         BnQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688425340; x=1691017340;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ugEEPDI78ePccslV5nFSda7Y+u/b3y8toq3vF1cGXRM=;
        b=ZDQ1oDw1GBi0oJ9iWkcDpv7xsNLQGPKkwFb4PPbFyM9/dD0jO5oUq/NTDZshyIz2Mg
         4X/RIvAv8rGeieYDhpUNbNwyXKDjW8hAIJImFVeaCTHvO/ObLEWwZM3zylaVaSnTQZSg
         E8eNo5XgA7ju1zNcgoQUUtDK5PGUiv8+a3i6c7e6IqYgmQ+vrY/f3y0y7GFy65HAXmDG
         41wLqWgHm+JO/6HHd5+HBmOIDKtUk0Fhq3GioFTwsqmra/+HGAa8bYyKqzOfZ0Lboz8p
         7uume7SzMKIr6afi2GGcLhuIE4V8AnmitVfOzh1/mawbjXWSUqTEZVXOuINTyD5ZG7+5
         DQRQ==
X-Gm-Message-State: ABy/qLZvEtRCGa1WP9KwPB/Bf3OCgwXXagtwEw+KXButeyWu0FrqtOpa
	8eZFTUkjY+lScIVHXim36Z5G/4SxuQDPi93dG1iyPg==
X-Google-Smtp-Source: APBJJlFfCePKSzholqHXh1bDMosUBsG+EpDt5w4T90POrytUx446YR+AKSabi0OjjX5yBnw0LUAcyx0QPDihFPk1n/8=
X-Received: by 2002:aa7:c697:0:b0:51d:960d:5fce with SMTP id
 n23-20020aa7c697000000b0051d960d5fcemr6204738edq.14.1688425340062; Mon, 03
 Jul 2023 16:02:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230703184519.121965745@linuxfoundation.org>
In-Reply-To: <20230703184519.121965745@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 4 Jul 2023 08:02:09 +0900
Message-ID: <CAKL4bV6wTXVoYP7Ui9u0vSfx4Ga0GY+VPZeQp8TLJ+zvxjoHhQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/11] 6.1.38-rc1 review
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

On Tue, Jul 4, 2023 at 3:57=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.38 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Jul 2023 18:45:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.38-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.38-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
