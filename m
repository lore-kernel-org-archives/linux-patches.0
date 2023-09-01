Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50AEC12A
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:42:24 +0000 (UTC)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-9a21b6d105cso258027166b.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:42:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1693582942; x=1694187742; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3IOQaLWTlXCahS+2Exjx/ttKfGVk+cooC5ON3tQFxnA=;
        b=hK0ble2fChZkdWZdbsrApsroBOXl96IGJ5aK8M97i4rkwmwZkWdXiVBM1pphwW8jhS
         R7bi/oajjGh1Iqe2ZjliS5wkXQZMpfemUVf0S3//c7yArSWQqugElf1h5/BEkZKpvQ9g
         d3RfiiP1Lr3HMA3CAg70VULTKIk+3yAqZ5zMbc81wQ/1fUK452M617yfZrRexHKTbAoM
         5uhvkiFTEel2pb5rb6fKyHsNpQ0PJiR+hL4h71uq3x7aOXWWbwYPDBlraMduPXKTRG8J
         nBlo7hV9mES7cLLkeB5Jg5pDx0uQn7+FVgwXfR64Ibq8mLQCT3eB1HIepXRM7T+g68B5
         i+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693582942; x=1694187742;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3IOQaLWTlXCahS+2Exjx/ttKfGVk+cooC5ON3tQFxnA=;
        b=V2TUdgxtKGXyKxBlTk8WgZiugrYAZcHTcZeSOKFZJPLLRjHs8LdP3micsky3Ez7bf/
         S3xdkG2q6Sn0Xvinb4MGmne1pTl5KNmKiFj5cXbKKDZxTRb2PrsorJTKbZQi2WcusPwE
         f6QGzQSRVIa/336NRjbiUfipiYGxWjJvCMPykzqlmEoyBFVvfgc/jq8NTeXy8KcFr2v7
         /+q0sjA43CjG3DQFKneWtcfxCJEb03PJ/NL4Oelu7viodv2cTqXBFrpuo4OoKd8xyNNY
         V7tokY0P8DQvnw+NmdG37veUgzDqZxpkj1crzkkMH6kZfmQ+fbyMmt6nsb4kXr4CF2/d
         sY0A==
X-Gm-Message-State: AOJu0Yx2Q6K+XL2+s5sFCrjPoggAG0aHhpUKjCZAddCh8yb/9pjDAy2D
	8OqIJ/lMNG7x79P1bJWVZ+q+jhHc6Q+QvNl2q5smTw==
X-Google-Smtp-Source: AGHT+IHCqAphpIIxpllHgJAshq74M2a8hIBLJFdOm7z9SehjsCRmY3laVtJkFhZphrQP5jfH0urpKFbxzEZ6yeMG1M4=
X-Received: by 2002:a17:907:7625:b0:993:f90b:e549 with SMTP id
 jy5-20020a170907762500b00993f90be549mr1986984ejc.37.1693582942376; Fri, 01
 Sep 2023 08:42:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110831.079963475@linuxfoundation.org>
In-Reply-To: <20230831110831.079963475@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sat, 2 Sep 2023 00:42:11 +0900
Message-ID: <CAKL4bV678zDbX7dwoqdRpkoda=c49EskC+fgX=BLoH-dvvb5MA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.51-rc1 review
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

On Thu, Aug 31, 2023 at 8:12=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.51 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.51-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.51-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
