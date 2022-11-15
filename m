Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242D924F29
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 18:04:16 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id 140so13365075pfz.6
        for <patches@lists.linux.dev>; Tue, 15 Nov 2022 10:04:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7hjDlcOlpzcZMaZmjaOdAYcchAu+QZ7y27zokjeIm+0=;
        b=knwpQhq6UHHVzOyJIuuqpYIvY5vApqtFQq52fophV6Eq3mo+INTLPMOveaNIByRd32
         q5bymQftooacaVaoSl6a2FvOACQKJLNLxYKsCAJC1eciNzHDcPeZR/P+VLC+wMgZNZ3O
         X85NbcEi2KCvzupC7Q7Hh5b45UUug83ibZNsMVCj4SiFUmtcVwraV9LXpS/KpqVboSe/
         aNd1+bXjruJ5F3E7qOA+KPxWImF9/58q+TBdpwE6/2VT60TYG//t+bvvCSnh7FvttYss
         mNlfIRZPUga99B7iL8wjjPBpSJ3grqEMvLXMsidVbx4/MBCVufbypMeZqiP+fUCAaH9O
         qHCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hjDlcOlpzcZMaZmjaOdAYcchAu+QZ7y27zokjeIm+0=;
        b=Qkz/NpmG3Vr8flEj0pmZnS/kUkv5n8Kt7iJhZG/AMMkdmIpB8YYQg5yGaaCUHOCbS4
         P8SQssT0OiHl2thHuUgGNu08vH3sLFmmbYnvOEAnrAefe+Pv85+F0kyRa82jtlWtflTV
         ZArUhq9A6mU5CYp7fUcz9/IEltC8F0+WxbcH+sbwN8gFa5h3ZJVb2cDJ2Q1kBAgzfJj6
         9LcqHLDznfv/gOeTUN9NODKs6eh9i/pdnLaIi1IRpzU3TgiqaGtczCuI1UmXMdh7aTT5
         zSwaZ3kwgHG9jzvPNIzMW5ID13YR67SdpJogBc2C0bAjIWgmcL6FEdv5apPPGGCh6BJc
         3Zfg==
X-Gm-Message-State: ANoB5plBI1NHgZyKrPvV3kaX0jTkSYck7moNV20zR9yy/ahNma1z5qwU
	CfBQfDyodn2/2f+aJIaMKFKgLJnbZfulMV0SsqA=
X-Google-Smtp-Source: AA0mqf54BVv9TveESwDR+SVTHOBdV5poFhZwiih1udbzORXO/rFlNXtnhKvgRU9LdeqkVxoWKRXgWommxnB1slCnf10=
X-Received: by 2002:a63:511b:0:b0:438:f2ce:2379 with SMTP id
 f27-20020a63511b000000b00438f2ce2379mr16579193pgb.333.1668535455571; Tue, 15
 Nov 2022 10:04:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 15 Nov 2022 10:04:04 -0800
Message-ID: <CAJq+SaD+dNPqxta8fM2pxYF3pdqfUU7YpgXwbHbWOj4ApK4bDA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
