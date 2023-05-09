Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30FCB53B2
	for <patches@lists.linux.dev>; Tue,  9 May 2023 10:17:14 +0000 (UTC)
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-953343581a4so866174066b.3
        for <patches@lists.linux.dev>; Tue, 09 May 2023 03:17:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1683627432; x=1686219432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ohlbAzo5ypwXbaF7pM6OkdMeUeZBKkZUohq6OEP0kZU=;
        b=ziO7DvPc9SBB23k/jehuNJYdveEYLM7h0sazR78aoaxgiajd9ybCUcuDAf3VzW35L1
         iRc4Ae/FHc1FW73mx7JrbMQoc0ReumUMiG1MHR3J9JF+5Km1utCuV5aSAHlEHNTXty4X
         ryZko4DYK2p0Sc90zohTHW4dyo8hrxyiD2zfnp/lGPrn6U2JNu45UvUsj0SkJtNdHNWV
         gK7bptIul5zh9ro5ihYQtP1pQOlLM2h2gbgoiIC+F9DzrZ4ZoHrJd5gmvbMIwLLxum0j
         BByOL1WVXyQKzJPZMk9HDEHpqAl4OvV6+NMo5J8xrw7aCX2/b23SCLAPQy1HqW1FGBcJ
         mhAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683627432; x=1686219432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ohlbAzo5ypwXbaF7pM6OkdMeUeZBKkZUohq6OEP0kZU=;
        b=INBz5eCt08tyLHN96NarP3DK0UcbLzAqnupp+LOub0zcl48dWqfNb5S981MRxjmwnL
         6qNwQRj5UTq5SK1SbuzKaaNPW7oSkw2T3+Ri7jYlzUUvuwCRCmh/+apZXS5JTQIhhZ0E
         FwXN4Oo5aAhV5MaYokfcH/mCJMVwdtr+GGC8luauoZ0hRGxmwjWbLifhx+TwbowaNfzA
         b5BbaFFDa3XM8cJUxoox7OyQlELk1l4aZ4VLYKrVpefwEOGmSoQMU1WMO9xx1RCMledx
         VJrEloQxPC1RKc0CmTxBlVbR1QOPB0gYzx2jD/TFbxzo4LBJVwmuZcqMTwsWkx2LuLrY
         WRag==
X-Gm-Message-State: AC+VfDx6CH9j1zwymQmoJkksAvylNGzOyNND5Ic/YZhQ4PrOtFDmGCJO
	myWLJQDG66utEZlsX1aED0WYTibVOJtXI7EpzG9z7g==
X-Google-Smtp-Source: ACHHUZ4fpHBQjFItIPZmI0/7UCEWgb0vqm/e9/KBpogQJkDgd3uL/4mLaxg2DFynAPUZl/b50gJqaip9svkToh9hxNo=
X-Received: by 2002:a17:907:868f:b0:969:f9e8:a77c with SMTP id
 qa15-20020a170907868f00b00969f9e8a77cmr1058743ejc.64.1683627432167; Tue, 09
 May 2023 03:17:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230509030653.039732630@linuxfoundation.org>
In-Reply-To: <20230509030653.039732630@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Tue, 9 May 2023 19:17:01 +0900
Message-ID: <CAKL4bV7QsdCtqJfm1O1MvkHN1WcmzGZuTaiBqmBVd7Rw59TsVQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/610] 6.1.28-rc2 review
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

On Tue, May 9, 2023 at 12:27=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.28 release.
> There are 610 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.28-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

6.1.28-rc2 tested.

x86_64

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
