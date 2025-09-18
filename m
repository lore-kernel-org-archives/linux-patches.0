Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E50124468C
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 03:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758164883; cv=none; b=m4rQO3geOfB9Xv6EddE3+5nCzgR4mq35iRyYAe83nMSAqleSqPQWo17METUK39PXvbQh0emyPPijPlKi3DIQjskcPZWd6dU7cWlcdc3JI/TQokKJmiETBggNof12FmnPVF6wuSLd1QMaurgenktAn9HAEnZdfpCYavThbY8F1HI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758164883; c=relaxed/simple;
	bh=ucCRcxsuGDClfG5heo1r5qIU5kMebbEElSVKOAPitJU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=utt+3047/WAB4fJAkthxIYOkLY8jl/xPJiN2CbsPm4Ij86PJx7/EWseDJREPiDQfRKEDbhddf9elQHiuV+2kCob8sr80i9VUSelSljHGvNFQqZk0reKOh5G3F9QP9YKI/VmfrDDzQ4ZjnvE0bk/XBExLNnHEgiBrnmMq35b1UbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b=wO0UXegf; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl.com header.i=@futuring-girl.com header.b="wO0UXegf"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-25669596921so5033895ad.1
        for <patches@lists.linux.dev>; Wed, 17 Sep 2025 20:08:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl.com; s=google; t=1758164878; x=1758769678; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cOr262x4SNCixfw6D+h2DN6gV7zkR61R9C2FM+lF078=;
        b=wO0UXegfY7u8MgPthQflomPnzKmYTVF5uqXATQxeBKH4wFk7tL4cvzY5cmpDtc58zZ
         EDnUB7Yr1JLc2dTWlni2bUt+j490vXjD4ru84nrTfmFyOPHcqC8nVNgIIXDGGRR8bajl
         aMoEz6YoHR5+4HcTVh/g94NlnDgllSFre3a5gYAGFK8t3Va6xywVtpgNWcCPLUGdCGjW
         cTEfN+VH0E396AWA8XlRhdqGFL6X8Ltb6dGRGVEdvN9vEYPmts37BYw/74Pku2gX2Fv+
         Z08/a+dj3P6kOclbFDcILu5oOlnEad0aIHHZM0Dywkl/MjwHBwGxrRKf7/xq78DHWEdf
         ddGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758164878; x=1758769678;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cOr262x4SNCixfw6D+h2DN6gV7zkR61R9C2FM+lF078=;
        b=P4Yo7Fd6FW7sMWx6gvHWHXQ6q/5oKAH6+1Dgt4RrbDHvhJ6rLvGxAyWAIlhid/W5Qa
         h/y+dSfRQGU04Yv0oKs4wd2M3mecUOTwI0WHnZxslgabbYJy2LBziUFNL2eyfEM+c4ir
         GOAZbHatZ4cKp+45D2Z/i7RyJf7eFTcC/cJ6yzVyjNEmv1mQZONNruu2PJx76+gKkp53
         N1njzu+JjgKKlJ+EysMJ5l9zqdK3ZYtzSm4LoNmf8Ed9bBrgjRzvNJXK1Iwqhh548FAZ
         cqCSpYLScFCwp8E3BMNkWGcvGCtrkBxp4fSu+DVSqCrePS6ZYt+BjYgg6VjBQM2ZhI45
         bKDg==
X-Forwarded-Encrypted: i=1; AJvYcCXHbRHC+SzWDJE2i+20qaNf5zwLKtVqdRrnhpaYByFTx6nIhBKOSnKzxOy8WzNjS6LOqcogXw3u@lists.linux.dev
X-Gm-Message-State: AOJu0YxXniydE/+rHXTnITgYa0VS4j0yMTkAW6r3lIXUrsMhUeRliu4j
	bNqB2dLbjT7ZovF41y/POFzlb9n0lwX9upRsQYc8gQdHsRz3ghOKYtsL3c8tifu3I7kqCQxkuxD
	NzLT+Ybip2t42tzNIaVtfzWxwbxCPJA0GeJzBt3X85A==
X-Gm-Gg: ASbGncuXNoEb73inEbHkyQ36EfSHliVAqPU1as7veSr8lNTO7YsH+KvLOzEz4FAdS2d
	1R/kVRKRWvLF8rukvPVjdbmV8qrCBqiEpSC0NRK0qdrkmxB0ODtUu+8eNy1QFjJsFTda0JGOF0Y
	zDksC4qBx9HEkOs0W+SXDFNyOdoyH7nFZL5bt3iPNc9UVvpzeEemw9AGby4zgOdAbcCmP5rZUr/
	FQjEqmNWVAaniFwLNUsu6cXDdw=
X-Google-Smtp-Source: AGHT+IESFnLmLGxL7zVRW9/AAJMJ3eUyMJy5//Ofo8Y4ShmsKybTu8OCYOtVcM347qhv52LF3IQYEflH+bF5I5G6ezM=
X-Received: by 2002:a17:902:d4cb:b0:24d:64bc:1495 with SMTP id
 d9443c01a7336-26813bf3d79mr48842325ad.41.1758164878562; Wed, 17 Sep 2025
 20:07:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250917123351.839989757@linuxfoundation.org>
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Thu, 18 Sep 2025 12:07:42 +0900
X-Gm-Features: AS18NWAHWPq2LKZaxfOvpUL1LbKclh98pn2Km87I8UZDUptfVR4FgiZQQobBzMs
Message-ID: <CAKL4bV5MDKDWPKJvQke1Lah=HzeX3=hO0rfQYb3S_nXMcEYOvg@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Wed, Sep 17, 2025 at 9:36=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.16.8-rc1 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.16.8-rc1rv-gfb25a6be32b3
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 15.2.1 20250813, GNU ld (GNU
Binutils) 2.45.0) #1 SMP PREEMPT_DYNAMIC Thu Sep 18 11:43:14 JST 2025

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
