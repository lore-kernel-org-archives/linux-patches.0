Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532893E4C87
	for <patches@lists.linux.dev>; Fri, 26 Jun 2026 11:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782473739; cv=pass; b=AjsX33wR46+hwsFijOeT6ABzPI47LGb88z23zaAEqyox95FrW9mmREuKZZwhO50dRlb2R4fUcubQOIeZAwDU5gMHJt5bmOCWVGfDieNW22YSIMjod07gTaNcNROdbhmoMJNX9HYJjXrTSiHpHhtkwtPI3XtIQNf5lVwqPrU8U2Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782473739; c=relaxed/simple;
	bh=Rxn+mtVvN3Y7QxGK90T8elQRrDVsU9c8naA3aeDQiu0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzUcjxvMEXtgIZOpKToKRKvdo0JHhVtU4+9G5CFicDKy3a2ZCFvzR0WMRWxhX8jpZ6bL9gM/sQNtRxP7YkpkOdbnNurvmZqJ0x4sWPMIs7ywSc/eNnk95T17fQFygtwAYxAPT0PF1sI0SHPrpUHUAv4cJswNxI5xIu9C/0chBLQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=eRE0nrAQ; arc=pass smtp.client-ip=209.85.167.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eRE0nrAQ"
Received: by mail-lf1-f42.google.com with SMTP id 2adb3069b0e04-5ad5e719157so730419e87.2
        for <patches@lists.linux.dev>; Fri, 26 Jun 2026 04:35:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782473736; cv=none;
        d=google.com; s=arc-20260327;
        b=HuJlqjDbd92J9dD1/fIl6N0s6KgUrjp6WtzunsoxU6llejH1bUCFHw01uZNydNGg9R
         dhp5KUvN51Hgr6yht4wmXDC18tbohvzdhzVqmulXA6f0YHpkr9hkuaYc2T0yCYNbsEXf
         MxKCNQMCGkBtfyZGuCjd40+JFCRVx/5EligdNXX2KP6uNhZxL2947BT/C0woerZGCIo1
         J7Jygbig5uF72dpxAYGj7TCK47+dGE5SF+Dkf2uJsjY1drbt2qzab8wiucez8OODvPbA
         jchbE3j2tOOov48EPW7CzIFTGxs3K14o5Gl7AKq9ugdeODGwNzAzdFUg4Nu+qbWrbJVB
         SAbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ayvyuM9q4TQVTTnyXokuwNJ9w3R2Smu2UIPkUGwjdlI=;
        fh=qQSXfH6rko+hn39ZDHZWIBdZhwh/A4QAjDfYnhoAN28=;
        b=klfx8f2AYzbtUPuJbsH3yy5g7qyqYff1yZpiQuzajqFAP58OWZGXEM/SkVyHp1HpX7
         6SyXRmEAttepb04IeD3djLmFJuI7SDKb/QUIkzcobIHak7PU+jxDidjw6Yr5OLpwOt+v
         GZne21iZa7ImMz+UTcTjj9uYb1H+fljstXQjeMqO80QlsG6iNC33M5V90ahDd9UA+USv
         6xSfUuDN0aVyEtrnBwEWNO4JavCGb82z8lcpSQ0BPSXGLODNk2+OCl33e/JuU6X56oqv
         pnxTDsY0LrWocZxumyA6NkpEjzLb+h5AaZtTA8hfae6XQiy+QwXJFuVUJQVPjRPWw2MT
         BFCg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782473736; x=1783078536; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ayvyuM9q4TQVTTnyXokuwNJ9w3R2Smu2UIPkUGwjdlI=;
        b=eRE0nrAQuqD63kyUCY8EHl8SrxO1rLRd5hyp8nHcteQNJ1Vk5bZCy5hpQ/mACSF96b
         EhZfxWZyGwo12GAlvt111POkOPOxJeNBCXi/QOKRV5Q8b8BuPUTnLwkJPEbynJCMgNdh
         rLw7o3aDXcxhN78T8g4r2OnWFFJ7vnVD0fKoBH+DzKtttBGNn5iTgZzNLaekNWieESW/
         2fBaAy0AYuLV2IkQaWLPYz8t5CrsEom5hQski5Hc5I4G7uzlhqYOycUiKVz5t9IOAeq/
         6VirO9b4Juk09Mp0ywrkPfD3AyPwjN7YWSY16SqhsJUkIo28EAzLVchTm5wA/PURiFkf
         rVTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782473736; x=1783078536;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ayvyuM9q4TQVTTnyXokuwNJ9w3R2Smu2UIPkUGwjdlI=;
        b=EjMxj2OqCx1zAa06KwHwlqoo0cBby7OWEQlBPmdoDxRZHWxD9KvNiFqUbIa3WL4dO2
         uQGjiNIv1eKE7M7UkrnMJ4WTZy1ZomDzBd7r+I00C7wu1Ud1cJ/HZOG0D78uIOOCxyhZ
         3RpSuLUG+T7Nc5jAdtLiU6vBCBA+9d79fCc4Au7uMPnlQtSTvgcPcSg31aduf/3U5gAY
         nFaGJi06HBzQoFvvO/t81hTQmEzKNX43YanfzboUzxziompyrxcRI3qM4k3yCk8Pz2T3
         Vpnyyfw9dtdZPzsuoSwFXYIxw/+CxCQNv0dvdhLOHCrftm642g2YIT9xHuVvLnJGMaTI
         PVEg==
X-Forwarded-Encrypted: i=1; AHgh+RqOBg+JPYMU1O7KttR6tygobcdazgv7rPGNJFLEbKbY7hB7cyoggU9pGYqQ5utPu8/0kKPCDXPk@lists.linux.dev
X-Gm-Message-State: AOJu0YwcdqNHHx0y/7rqTQTVNtCWUu5iT59tHP5D13PF8m2ukn4oVGd9
	9DC4BSEwM5HGOT5+l6T6h3T6KQGdbMMkAgtdyLtEveAA43qqb5ujVpRDwPGzzVtg8B9X4Io63cp
	LR6Hth/1BRM4v8u+Tkb+5ESB9vP/GyLw=
X-Gm-Gg: AfdE7clMdRcrSGSsWbbhGYmp767S6ubNy3m9yqFpi2KDCJYhFbuTwTMtVzmBlWlKr4P
	XAQtP5dmvA3onaRrEhKf2wa9VN9n8KEZz1/lJRJ94+8WbtXMJ88NXxt5UMgMjCWasNUM93ClaBo
	+4rUKGl21uUfJ6rvhvKmiyln75OYB0ambyLJVOLh8k+N49ScdgjjNHQQ53rMJvo9cMYvKohvu+l
	OztQU7NruBu7EV5XW5qtqqkpLHPyGJ9EPdlRflpVAC0bQBvvyuStKasJq97T6aZdYlqzYZnZlEH
	/CpKtjNW07cLUFhCkQk6VFGfcK82MQ==
X-Received: by 2002:a05:6512:8056:10b0:5ad:3035:c2be with SMTP id
 2adb3069b0e04-5aea1f564b3mr1482278e87.51.1782473735324; Fri, 26 Jun 2026
 04:35:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260625125613.243729608@linuxfoundation.org>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
From: Dileep malepu <dileep.debian@gmail.com>
Date: Fri, 26 Jun 2026 17:05:21 +0530
X-Gm-Features: AVVi8CfsdNoBWQSE0v-Hs5YLIHWBrb_3kjwmFWlET_3LOf1qtneq7ecokT3qaT4
Message-ID: <CAC-m1rq+6Fx3AARN=bDTLQ+oGV74mAdRCtq_iAtw86Qu_c9RUQ@mail.gmail.com>
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@nabladev.com, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 25, 2026 at 6:45=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-=
7.1.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
> -------------
Build and Boot Report  7.1.2-rc1

I built and tested Linux kernel version 7.1.2 using the default configurati=
ons
on both x86_64 and arm64 architectures in a virtualized environment.

The kernel compiled successfully on both architectures and booted
without issues.
I did not observe any regressions or new warnings in dmesg during boot.

Kernel version: 7.1.2-rc1
Configurations tested: x86_64_defconfig, defconfig
Architectures tested: x86_64, arm64
Kernel source: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux=
-stable-rc.git
Commit: ecd7772bf73899d9b6c14b7efe6d713949f18e74

Tested-by: Dileep Malepu <dileep.debian@gmail.com>

Best regards,
Dileep Malepu.
