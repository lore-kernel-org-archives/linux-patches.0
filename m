Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8569448
	for <patches@lists.linux.dev>; Mon, 14 Aug 2023 10:33:32 +0000 (UTC)
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5256d74dab9so368636a12.1
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 03:33:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1692009210; x=1692614010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uleSPCEhWYps/G0+jIIwOEt4SNkxmTT9PADtVhClwek=;
        b=rTS5GaH3NUE2HLbWYWh8BgcIglEgniZVG5sZ4i4ZlrWV4u3eTvI0cLZfvvVSfau1I+
         lnTS6cNyW+ANkwA+Vnrckw7gLIhib+rVsuu5AbdpmbOP2sJj2S+/L6a3qM3i7gBHYDxA
         9idSnN7Qg1YijsTeei97RINzROPvhctXrmZ0Zk4CtwjdjcS7NSFgOu5laR04tdV8L6px
         dFyQiAKJ69KxzeMmG19NmwnBX7WfxP9ko3qpng96T8yEK+I5O22i2sV0TjwYhfifYZKz
         Dsl5XgaPjf4UcmRdWpKcGWEDOv1VA5CHiMdY7xJJv4z9lVpe/Aoj6RTFI/X1WddREMst
         NIxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692009210; x=1692614010;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uleSPCEhWYps/G0+jIIwOEt4SNkxmTT9PADtVhClwek=;
        b=hGMeg0mGCTHeQSANmMAd90aZOWM0koMylFj8qEI1OiwdrCKWsdbXQJ94QSPMvMPWH5
         ef9tNzRjyt0l3JbwV0Z1mpcgBBuqRdtKbeNqqKwM2L+ien9bVk3OwFPbpoLgJ2QZqf6c
         T1uKxDY6k2xokJoaTHsCOz4hJnK/RfR2OdaxxYgs9p+lHGX8cGf5UKwEU9ii877KgS77
         HOU6sR+5PXoDs4ltajKLAZoea4Hqj+vHmHphiOIZnGqR4VC0YCXWAXAiv8bRYGI4/X3h
         Fp0iOa7HQDPRvpEh6/VRyHY8qJqLRTPH/gmCZm9TFUb02oxRL7qqlIX4FToZiV6K6y/n
         w6QA==
X-Gm-Message-State: AOJu0YxtvjJq2KHhukG56lmGKVeqRBa+/DO+xafKtzqqttbdAGrBtdjf
	KwV39LV+SY9KyeJYb3mhrjr3cWsz/tgp5JQeDV5FLA==
X-Google-Smtp-Source: AGHT+IErMvltuuNvb0Ql0I6gloiuj/IOh2manbi6gz3jz50UDeRT996wuxrHMof9qaZT/ImGdm9FiGAhgx3uc212J3w=
X-Received: by 2002:a50:fa8f:0:b0:525:440a:616a with SMTP id
 w15-20020a50fa8f000000b00525440a616amr4644893edr.20.1692009210277; Mon, 14
 Aug 2023 03:33:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230813211718.757428827@linuxfoundation.org>
In-Reply-To: <20230813211718.757428827@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 14 Aug 2023 19:33:19 +0900
Message-ID: <CAKL4bV4cCVqYHyf01=ZBTgX3-dU5Gh8NZxAGnYD__xWmACR=Wg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/149] 6.1.46-rc1 review
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

On Mon, Aug 14, 2023 at 6:34=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.46 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.46-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.46-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
