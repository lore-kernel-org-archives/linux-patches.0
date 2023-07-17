Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CBC6A49
	for <patches@lists.linux.dev>; Mon, 17 Jul 2023 00:47:46 +0000 (UTC)
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-3fbc1218262so40326945e9.3
        for <patches@lists.linux.dev>; Sun, 16 Jul 2023 17:47:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1689554865; x=1692146865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7N1u8eQl3UsRRKVg1OGodBCRp/JnrugXMJVQcwxQKBU=;
        b=UkdkSlCyKNKLHW7JpS70p8fQoVVOAfioMsYBIiQW8id6Ati0A02j2P2Gs2a8vaqyAa
         osQtghP7+VWCByQQ/2bMQGuYDY3V6knsPzrgmkj6i+i+7khqn07O1iIIK3UaKGaNC8gc
         NPsPieZe5J8RdkbdsQp3sDwtG9Y70ZpD9Yp4icudmC4SMRi1tDXetQwLa53lJOVAXEFD
         xMESZ1vM0CEZvvtEpWmIKT3d1lzMju3jlEwj5BlTP2RqjZC4KwWAVKt8GByifOMf6zfB
         efbEUkl4htiBYFH44P5/ScpLRQ0V8kiA+F5rEnPy2kZhyYWiKZmXrkkoQd7qMR5oZbSK
         gwBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689554865; x=1692146865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7N1u8eQl3UsRRKVg1OGodBCRp/JnrugXMJVQcwxQKBU=;
        b=K2GlBjJEfvr84m7yz30FFMmTS6VeN4isY8+cCZckrBym/13dFHyMNKe0itPKN8BUyF
         cNSjy2QUyWQ3uE5+3cqxMZUx0BwWg6a1tHnfDITPJMd7WL2hYVSS39hD1lj89QXxpT3l
         7wwDaUhrRpisbgIp+K4+HpetrDdCbkyc5uH8XQJL3tPKODL+GXmEyFAB6XLIAI9Q/nvu
         CV2lkfynHDUN/NpHwMA3J6c3/nRkr6yWfO4RI2ROy50WhNxBhgfO1+QQQwOtRzlWdC0T
         xED2UWSnmqCv88bAv9motD3qXVIFFGaVdqEMGinW7srf/ppXFodHaxYimCHvxd6XJ5l6
         dXng==
X-Gm-Message-State: ABy/qLbr07hgG9qf7fNnVANgfv1epCsWQpugHoqHQOxLXvQeA/Ts632Z
	0DA2J7YUB/Lzk2FjQbsQwgiLlx7iZ/I8dBfWvXKYGQ==
X-Google-Smtp-Source: APBJJlF6Nj8sdVkDih4KkTUgJK3TCwMDEPBZEymJet0/wBV9/AmjuU71YQN7sYDfUbO01zqsPMSWlEmMchfPKumAd5o=
X-Received: by 2002:a5d:6904:0:b0:313:dee2:e052 with SMTP id
 t4-20020a5d6904000000b00313dee2e052mr8787758wru.26.1689554864863; Sun, 16 Jul
 2023 17:47:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230716194923.861634455@linuxfoundation.org>
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Mon, 17 Jul 2023 09:47:34 +0900
Message-ID: <CAKL4bV4sE0tNw-P+DjpasonZ8aMicxpXpHV59ddfYAGonPbacg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/591] 6.1.39-rc1 review
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

On Mon, Jul 17, 2023 at 5:31=E2=80=AFAM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 591 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 18 Jul 2023 19:48:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.39-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.39-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
