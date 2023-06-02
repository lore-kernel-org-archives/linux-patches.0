Received: from mail-oi1-f178.google.com (mail-oi1-f178.google.com [209.85.167.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC66615B2
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 04:18:01 +0000 (UTC)
Received: by mail-oi1-f178.google.com with SMTP id 5614622812f47-38dec65ab50so1381790b6e.2
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 21:18:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685679481; x=1688271481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vaor9B7ytmBLnF/mg6K2j06Vq4pPXWveXsf5U762TYs=;
        b=P2TJ51Hcs8Z90748VedFGenHvY4i1qRFesaQUemqCGyMQAc4xNWVOeE6HvIhe1HhGO
         cfiA3tPESfpXybPf+neHGkx+tV1z8+PRFZFgtUqMcH5pjLUjJBJ+xs0FiYR/GOLCc8ER
         EGAStRTdrfY7TEfketa7P9QhOGR2KpkI0JxkdIg2AIOIhwHNr0hiExfpUGKxLPZqt3We
         Y3IgW7+tN5rawz2aQy5FHn7yPsmHSBLlWdMxCRuWhbD9WkP4Kr0yzHy1g/HbbuDkOCf9
         /xIk+pgoBUByf4T63dODK0EZ/KdoFny3Nj3gs49ZWbSvWu0sz4DVzNHlc+BKjqGTCIS+
         qUIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685679481; x=1688271481;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vaor9B7ytmBLnF/mg6K2j06Vq4pPXWveXsf5U762TYs=;
        b=gY7TxEY05yNgFLXf6TEgKyVYDhCWz8gpCL1CC2QReY4rHSmQpyVkg1LjMDS7B4NpQp
         7tGpN61UNR0ycd59XnuvmDtrsCMAMlLCOV0ODNYxgRi58Z0Z2gdFM9rsCCoS5D0VbSqh
         poFyfu+vYgZlTMx8Z1mij3lm9xwczkMl9Lhqy7tTmsLQe3+ZB+Zj3rLUDiALdy0kqSNe
         87CR46hC1yCqJZRhiG9Tgb4EqfzfkF1O9QXblH7u0IevZZMV+fYcKtWeQmIaKBCG74bX
         TQ3Pj6H9yyMDWEopDGjRd3iVt1D/Rvd3Ma98cGrSbI35pkh/dWfHXPdNdjW62XQ744tq
         66AA==
X-Gm-Message-State: AC+VfDwJISpKx2h6U9I6t90H6s+Arkjriy5EiKYpZJBHde0lINCom607
	fYbEzDmuvb8FL7YkCCxMpyxl5SLdJzhUNqzZ4e0GsA==
X-Google-Smtp-Source: ACHHUZ5gFgl83oydMh7X1UbVitCRWYnh1+vdbphPi9Zy6PqX5Co/bKzTW4/pEL6saHBe1zPgQb6X1+uvWwf+XxEXcjs=
X-Received: by 2002:a05:6358:3398:b0:123:42d7:e6f4 with SMTP id
 i24-20020a056358339800b0012342d7e6f4mr7837897rwd.26.1685679480696; Thu, 01
 Jun 2023 21:18:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601143331.405588582@linuxfoundation.org>
In-Reply-To: <20230601143331.405588582@linuxfoundation.org>
From: =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date: Thu, 1 Jun 2023 22:17:48 -0600
Message-ID: <CAEUSe7-qcYwBbeFGKAOvf-rPMdgAMfE6t42Urnhjam9nWN-gFg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.115-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello!

On Thu, 1 Jun 2023 at 08:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Jun 2023 14:33:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.115-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Build failures on System/390:
-----8<-----
  /builds/linux/arch/s390/kernel/uv.c: In function
'should_export_before_import':
  /builds/linux/arch/s390/kernel/uv.c:204:40: error: 'mm_context_t'
has no member named 'protected_count'
    204 |         return atomic_read(&mm->context.protected_count) > 1;
        |                                        ^
  /builds/linux/arch/s390/kernel/uv.c:205:1: error: control reaches
end of non-void function [-Werror=3Dreturn-type]
    205 | }
        | ^
----->8-----

That's with defconfig and GCC-8, GCC-12, Clang-16.

Greetings!

Daniel D=C3=ADaz
daniel.diaz@linaro.org
