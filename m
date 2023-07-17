Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE710977
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 23:33:40 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-51cff235226so10512773a12.0
        for <patches@lists.linux.dev>; Mon, 17 Jul 2023 16:33:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1689636819; x=1692228819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WtXV9MJdcWQ3yaerrpPcjHyyt3tkQWswQOvaKX/GEv4=;
        b=AXom64Os+zYpFFbJFpA7yN+yjwv7MLG+dd1a10zyYdYkUiY+hVeeuTcd8Qzhwq1sFl
         +FVQvNGvvll/9H0+ds/XeV8zxRgFCk/4R2TjVZlQp2fFJPEABK7U6eydAvx92FJtNXLv
         IRk3v2qOB0qe1Ji7EpHJFmj/DAzwXKRZbNbklizNqEY/yoIN4clW4oIpQTQe7NX2T1xM
         6EsZBknMshQHJvLfQsW3RHZYjm9XP1REIBCjl94Hrlu/FwuZRuSsPFSANYpvguJ0PtFL
         cL+di9cryna8vWVRysZViHLhsO0msQBJ267NT1QwJC1uYWSmN/arM18LljigrsnBCFQC
         7EGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689636819; x=1692228819;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WtXV9MJdcWQ3yaerrpPcjHyyt3tkQWswQOvaKX/GEv4=;
        b=HsKxQxiZsHFWYT0O+8tVENV+lvUMgv7MJ5tcsvRwoyksU51y7d5O4J9RsQ170nSfts
         lAI2cP2ltGQkzjMs1IfEgXnLC0545eLqefxzf58SM4hnsOASAPs2YiU/3DIT85GB5qNj
         R06JFJm1ZkLoWbkmjWQsIRQY9vRLxubOc3aaZTs8d2H8ziRpvQ4Pp3FDJvVFMiaB08ch
         nvN+WKRR1a5NUZzAgITN6encp2Pf/Qw5Y6EOeAW5kQ7RVzFTh7talTLqNE/ptWTZsOCI
         fdZ2e4ae0ScypJu38EBjGuc16qf5893rNeXyd5apJ6zVd6lwhWlFJxBoAeHtqqxPM+SL
         ZB8A==
X-Gm-Message-State: ABy/qLaRF+aiF6e4z+rSW4jozz9wV+leUpRb32QAI4QQfwx6LB6UKUoT
	sXy6RxJHOQ0E8eMh6r2An3PDsklWoCE24MJWstshzA==
X-Google-Smtp-Source: APBJJlEkO9vBaq0tdrTZcAH9NKIi3lBK7EEzRiXGXEIxDfsWPOwtrZFhOu+BC/Mbx5dohxK7P4AbEru/SpswUzzgcaE=
X-Received: by 2002:a05:6402:2695:b0:51e:5bd5:fe7e with SMTP id
 w21-20020a056402269500b0051e5bd5fe7emr13121576edd.17.1689636818850; Mon, 17
 Jul 2023 16:33:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230717201547.359923764@linuxfoundation.org>
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 18 Jul 2023 08:33:27 +0900
Message-ID: <CAKL4bV4TnJamH7j3Z8OF=r706KSe4cv9Z-rYteeNJxD1ktgqrw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
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

On Tue, Jul 18, 2023 at 5:34=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.39-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.39-rc3 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
