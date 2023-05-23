Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08441E501
	for <patches@lists.linux.dev>; Tue, 23 May 2023 10:11:16 +0000 (UTC)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-50be17a1eceso1245507a12.2
        for <patches@lists.linux.dev>; Tue, 23 May 2023 03:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1684836675; x=1687428675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4ijudp9Skl+/hs6LWpF+HBcWDTyNQo9dZLQJN0P0dpY=;
        b=OlsHHZ+ZFshfg4doBhBO7bFHKerast6jJS2F+kf4fzdm/OxntZK8BUHlVngzx+9d01
         KI0n9KUp3OIlh2pjeaBmVMh3vGJL2LiyrvXoMKjTllim2ffpFY3QGrI8nOTc1/Ohp5an
         xGFpMimtSEq4EsqYieO//USw9Mh6iKCmGwGHMU5P8H7vqWkH/FSi4JQ6dCdj+xaLF/D7
         c2lISgb47P5h5nzeK3ft0q2nui6VexpHRcmHWqtT+aNSRQHKlXbQEMTrnLqVrLxQ/0d4
         ExiKTGhi7jmlFkEaHBVNksHpm8MSno/DghUwesTE5SPyx61vVSMO6trb4hnD41W+k0HQ
         5pdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684836675; x=1687428675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4ijudp9Skl+/hs6LWpF+HBcWDTyNQo9dZLQJN0P0dpY=;
        b=P0VJe+qYlsuComFXMvyjK23ERjzRUofBcmGJVQxsG3q/R+o4d7m1jSGx7hRgwHPyKd
         UG/Ar/gJkdzfAi6sMmphavRkF5tRcJ5AvV9yV5uksQ5Mj/Jm60fjuCDDGFu+B2K5OlkY
         VHdaboDXaBZoP496M8jCzdkFlkEAc1c6l6dsniwX0EIEzHKu9fPKQu2O2MGzb73bVO3d
         w7tkSJors85FpDWwU1IH8xRXVa5+rC6oYXl+kAn7o7kb6nYI2CQS/RPmdVC5yUrvR8wg
         YNCpXxq7BoYFCIwsXf/ei2GvFYiXgk4EDqbsArYb3Ra4cBlkcXN3Qjxo1ADPpFPxdJqE
         qp7Q==
X-Gm-Message-State: AC+VfDwDP9PbFHmRH570UuRl61MLyNxhjbeJPgYo5Q9T8dmcSMN1Y2Yr
	wqQRDrmAOcjj19qDr/EgkQKYX9di0eVeolD+B26qyg==
X-Google-Smtp-Source: ACHHUZ5iZ5hWmJx6UvpfTPUcGeGBx0h4ALR+xxYj49G7EeE3YFmWnbwM7CBo5BW8uNNQmbAUWXXkvAW85AbrBN0a1t4=
X-Received: by 2002:a17:907:7b9e:b0:96f:b58e:7e21 with SMTP id
 ne30-20020a1709077b9e00b0096fb58e7e21mr10380440ejc.52.1684836674758; Tue, 23
 May 2023 03:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230522190405.880733338@linuxfoundation.org>
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 23 May 2023 19:11:03 +0900
Message-ID: <CAKL4bV69TwgqL0GBe6NwxhpOzJhTMthQQbbx=Yc8TwOp=2J6dQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Tue, May 23, 2023 at 4:23=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.30-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.30-rc1 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
