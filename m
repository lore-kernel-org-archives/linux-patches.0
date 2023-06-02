Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5350D816
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 00:27:57 +0000 (UTC)
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-97454836448so110523166b.2
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 17:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20221208.gappssmtp.com; s=20221208; t=1685665675; x=1688257675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/xJu9BcZB5C/voGBfDbupaISTWs3GOnx/oUC0CPT0tM=;
        b=EIANLU+vPLy6Zi8riN4tXuv4g1DfWX9eF4m68pwE8TOcvgIz77L9BFQrq4+9NOvWXm
         sgpHE2+2zwP8NnQzuxMxN0SPTtR+ntIsYpT/A06o7ZVi4y5jKKwhQfacGUEPxaA2MPu0
         WbVc3ehEa44Jo237ylJxYB+N2kiy+OMjkjB0hMcLkxKBEPy2LyfHleMPzgyqC8AAWPAB
         Y96JA0rhin/Vf0JtAQlzPunN2Bk7D+21FW0ulTB9aoJePJdRGFajy8awHeP4fydsPtRP
         mhE/WXn6GFSDOcuGc/2zzSr6FruoD3fVfbMMhpdsIiHSwSE3bcn9cObP67lT0ZX3Yo98
         vRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685665675; x=1688257675;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/xJu9BcZB5C/voGBfDbupaISTWs3GOnx/oUC0CPT0tM=;
        b=Rl1xUNZ8RLfA2OY/NjeOmMYiVq3GZcw0ueMKObaMSLd319Q0WiIjklaYuPVzhtQxSw
         3ds2She9p/+JGg8NNQFaDImLbkY61zQ/47Lkopot1vv0pk2WBGQB/BOdcMqFHqqtnq6D
         2w05M+V1WUIUBmaMqSNlYQ5Rwli2RkNelKMA5seO7iZalrxdbH2+co9qaaDrmHRa4NO9
         DTOHS6MiAXNDk1y515SQl83rJkCcWX7oU4qIXanY+a7Ocnemp6Nc2Xp0PY2cOsmPb5B/
         182zDzNChZBQK4hw3jqIFhu19/Dc0C+wzStgnNC3o54hCYl8zeDz93LqKQiy9U8NlSsD
         PAMw==
X-Gm-Message-State: AC+VfDymqgiJ4XkIIfuuOJR7p6wMHWvpehGNjj5NlzyH5+OPhVT286IV
	Sjmwj3JbLwdOJY+IeXx4kyPXBwx8OI5AhlqBRrawWA==
X-Google-Smtp-Source: ACHHUZ5UWjTnIVl0uJXpREFwe5ZHMrJM1SowU7wC+uGyasbLsGv40TqMHkjkr9JXp1Day86AsISTrIDA+XY52CBNLu0=
X-Received: by 2002:a17:907:8a11:b0:973:e00c:b9a with SMTP id
 sc17-20020a1709078a1100b00973e00c0b9amr9891996ejc.4.1685665675295; Thu, 01
 Jun 2023 17:27:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601143327.479886832@linuxfoundation.org>
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 2 Jun 2023 09:27:44 +0900
Message-ID: <CAKL4bV5hPWD+LyK1XFf5BvJrwGE91SKUZXTCtQROBkqnisVhew@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
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

On Thu, Jun 1, 2023 at 11:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Jun 2023 14:33:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.32-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.32-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64), arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
