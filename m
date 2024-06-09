Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441E31D69E
	for <patches@lists.linux.dev>; Sun,  9 Jun 2024 13:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717939560; cv=none; b=bxrAdqVO8BZxXgyZmg+IXw0sHxc6dOk5lmxMBJZ4uV+llvJE3sKEUEkNMIxJd00Ike+/30JVnm4DudjNFPkrJdCWeOwzOhHpAGvaMlnZWXNEfJVngBS0AZfK0jRSpkEbvsn92m6NEVDq9GIONl7Ke7v8Z0wh1ZrwQKLOPQAkItE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717939560; c=relaxed/simple;
	bh=u+u9QLYNu4HrAWgyPgFZCbJEI/NnuOHhXl5OP6+ZmdI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TL5D6EVYhL60o322u1n8CmNoLpZ/Z92t84H6c7d4rCB/Z1rbR/nwz7UlUjQBNxOPHZt9ifOeNcnA1Kw6js/u0NJHh0zBvb1Pa+6vUF6u70ooCezZuTHY1B6UZLn/6kmghALSjGxXq1r5xq/WCxfabcUT3anDFqYminKmoImyOtQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com; spf=pass smtp.mailfrom=futuring-girl.com; dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b=hKzch16u; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=futuring-girl.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=futuring-girl-com.20230601.gappssmtp.com header.i=@futuring-girl-com.20230601.gappssmtp.com header.b="hKzch16u"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-2c2ccff8f0aso1390399a91.0
        for <patches@lists.linux.dev>; Sun, 09 Jun 2024 06:25:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20230601.gappssmtp.com; s=20230601; t=1717939557; x=1718544357; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8fXq7SaL6D194sQwZh+H3HooqCMUEWewEfZ6pmv61pw=;
        b=hKzch16uJxVdILqZmwbSPJKMxApBEjGYYfszh315U7YzZcA4ocj15Iohy2xqOru6dk
         ANpaYbFOXs8FskzxvEY1q4DV/JjgpwqVXL2gqK0Pi9SdLvS4ecoAauaAhljZwKFnXIVp
         WhzjVxFknjDaBxEZXSO5ud/7wfg/4FVMZ4YglMEHhBr7n7eqkhiin1pP+1pmxtKia8LM
         IkpN4PslgoUQyQjZpdnt5FUkPurYUk+6l9T1qNCILwG3/3asU7/+bEWuMkeCrGYN10D2
         bibSXxikGRDK6HJd2eDjQvS/9yZUSwUtZotqf9su4DTwD5Hss7B0HzwcHq8YiwS/8u7+
         mRZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717939557; x=1718544357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8fXq7SaL6D194sQwZh+H3HooqCMUEWewEfZ6pmv61pw=;
        b=gUa0UhNc372oOuHUKse3heLvtRczsOtM+LmfK0YjhpGeKO4WJ/i59uUAlE5dw7T/Gp
         hmHARjeQUtbfz/f/XZNF6TKg+8XijqD8ByMLrHYYnBV8ZsCE3mbHFf9YRittdQpdsjd1
         kHt1sR0Ums2e0r/CVFhCvGoIZPFKDmbLS9lvK2aQ92Rd3x1byKXpboXxOhrdhs3BQZZZ
         nMrSm/Tfbw84QAy1ub/8l9HuQRSc6G7WYW54TNs+dKoqCVhPh8fyjUeMW/QqF0UWgwhL
         IISldYpQ+gsmT6RaEA/QrjmU6jI7FGbMv06LT68DNa4BfGCUt1XTZoDsZ6cWFkHdraO4
         0c/g==
X-Forwarded-Encrypted: i=1; AJvYcCXLJMrLwFm0dYqEOvr+2uRWknm+/ueLRUtt+27Eu/MDE0gnTLHu59criN2jqf2H4TgVUG37b0h9ts+FWtkKs3mYDBPbhfC1vw==
X-Gm-Message-State: AOJu0Yzv4eE6CuWUhsESYWEcArPgD+7+uYKQrynvYwGUu13wnePzaOhl
	SV7C0OGAQrsE38wd3qq8awBoldaSBwbmwFMYUCl6Ofz4iU+8oLgO3836WxKt+9C4jSf4/waeATc
	R+aPT4u+uKIPHvn/UIg6SFmG6f7aV7xBKnlwzbA==
X-Google-Smtp-Source: AGHT+IE1odL3BBZ9hhvpRx8NNX+yPBmqQqY4qii/zdBs8e8gtpn0Fcfehkq7fp6P+LBk9yP6x1KrUy0lPGjR7Qg/WhM=
X-Received: by 2002:a17:90b:19d1:b0:2c2:dfc3:eb7c with SMTP id
 98e67ed59e1d1-2c2dfc3ed08mr2450309a91.18.1717939557527; Sun, 09 Jun 2024
 06:25:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240609113903.732882729@linuxfoundation.org>
In-Reply-To: <20240609113903.732882729@linuxfoundation.org>
From: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
Date: Sun, 9 Jun 2024 22:25:46 +0900
Message-ID: <CAKL4bV5zSAu0iEvfHuiJjUZqi=zgr2e7xiEOaiYsWN70Ur9j8Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Greg

On Sun, Jun 9, 2024 at 8:41=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 741 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 11 Jun 2024 11:36:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.33-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.6.33-rc2 tested.

Build successfully completed.
Boot successfully completed.
No dmesg regressions.
Video output normal.
Sound output normal.

Lenovo ThinkPad X1 Carbon Gen10(Intel i7-1260P(x86_64) arch linux)

[    0.000000] Linux version 6.6.33-rc2rv
(takeshi@ThinkPadX1Gen10J0764) (gcc (GCC) 14.1.1 20240522, GNU ld (GNU
Binutils) 2.42.0) #1 SMP PREEMPT_DYNAMIC Sun Jun  9 22:02:19 JST 2024

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
