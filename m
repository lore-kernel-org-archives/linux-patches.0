Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BDED85628
	for <patches@lists.linux.dev>; Sat, 25 May 2024 16:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716654349; cv=none; b=l4jKuOmUMcyo2Ly6FYdqzlS8gA2t2K+2sdJw5Aime6L8LKSc8/yxFuslN8cFeBxxLlVeUaZVUNFxttMqLDQdYKgKlHIXvOHPglSrqtk4z2oCDMpfN+p4s2DXDETE8mtg1Bu6cN2EcIqCfZNy8u+9vELA9WDRA0vbD4c7cdghYqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716654349; c=relaxed/simple;
	bh=A/aCx4XM1+vEZ+hKgzSWLtqfTQVhIgq3/f7CSTw8z3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UbtlhNZz0psRHgJ9QdS1FZFbyhxgteDBfwGj+b4g0BgHUjn36OwrUPCjW88pv7OZCyYFwd+FXXNWDZak0bcl2Rvjv8IhRDOJeVSzl35LdldJP2jrFIxYG6130b4lr2i2E5SFq3WV7arbf3maY3hIuR46dHhh2+F1y+WlYiE7LhE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gUSGXD1X; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gUSGXD1X"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-804eb2e2159so186939241.1
        for <patches@lists.linux.dev>; Sat, 25 May 2024 09:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716654347; x=1717259147; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gCc6amA/iN9A1y2eIzXZ7JQYMZlMS+mlWjyS0IHIzOk=;
        b=gUSGXD1XNnnqS96gc4TZHEfLiOOpwTLV6WTyw53YQfcXxUKMfvLvgtrOL6xXLKsHCx
         srV5Uj1SJsBtuF2rr0ffTv1AAkNgvnGWgxyQOvD8cdUKLiN8DDgXQfhRcDGUIQoR+aJG
         VDc39ZMcw/KoA8nabbKdBcDsYRLIJzNKB7WFdEOpGQPKuiaxL1FCNdgZyB8bctN/fjVr
         O9XCwXmmPXtMx/jITu15mN8hurIaQr/ZgSJnpW+xF0iHcyLuhqmgkH/K072kz2Sdq+u+
         5bUq1AwkPcl1dGWLW2yRaRRQ2p74GgY+8xpPyfAHN30ojzrlpicDkqVyIQyRhv1noS8Y
         Xb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716654347; x=1717259147;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gCc6amA/iN9A1y2eIzXZ7JQYMZlMS+mlWjyS0IHIzOk=;
        b=l+vPGGZPbEjyFCok+OZRFsHOgYx12kY3yd4574Ymm3B679yKRWrdzXue5Cmc/a9PJg
         bXL0oHonGwXq9x/4e7uIrTGpkNwwG+C9ASAYWQrYUfm+v6bM1q8kAx4gOuqIvm3h4jrK
         vctlfdD/44y7iPQz7d1c/G8TyTV6XL0nmuTNOpqmD9zjZrm0jSvDI63AHkl/2sHY5jOY
         ynzyfKOTunUqnK9SxtKA2PQVM45h/txZIA1Wdlb57+m7snKwBXb1xXZvpsJrv7RjJ5mj
         19nUbRyvYOU6hMSFAI++GS8vf2JXtRx235OO3YZQH+YTrbccDVxYaxkaUZHOoJHHzvW5
         HDgw==
X-Forwarded-Encrypted: i=1; AJvYcCWis1mVehWJVh46/PcK6A6+al/r9+f8ljHp/4TsbolkYtFP5TK8iQwyJr5FXOrGRQLcDTd7Ii9QaKLHSToV+pZbjGy7Oa2mHw==
X-Gm-Message-State: AOJu0YyNq7Bv7YPJEMnMpaLydL8bCH0w4AD4WZz5txt0z3D0rx6an1NV
	72EAcXJL1mcz51KsZF+AmHnc2HcWzV0V9zF/kM+6n1MU+yubK5tK2GMJ/ZgSNJGG1mxgGE3J8kf
	89xXYOlZKeMbg1UYW504oTDgbVZ8=
X-Google-Smtp-Source: AGHT+IFjspeZqU4Kulke2iDRbL9ljkczjIrcb02G6weogmeXljvX/qRl43slyx2kOzNDbRgyb7vcl5Iwk55/MGWKBh4=
X-Received: by 2002:a05:6122:251f:b0:4e4:ee41:7412 with SMTP id
 71dfb90a1353d-4e4ee417e6emr6517570e0c.5.1716654347337; Sat, 25 May 2024
 09:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130342.462912131@linuxfoundation.org>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Sat, 25 May 2024 09:25:36 -0700
Message-ID: <CAOMdWSKQnNMzp2FLSGNvjsZnz=wOt2TRmq5O9aVnh42U7t6Whw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
