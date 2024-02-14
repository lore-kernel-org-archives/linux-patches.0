Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBA22E62F
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 23:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707953301; cv=none; b=ZkaRPPO4DaaCvIuoPwy708gzIeCEK4HBFQR2Q2pAXOa+Tgg0HewnfEHwLnq+wHEdKCeq9qAy0UGfXu47vCSwBfLw70m6JR/ljPegrntFWxLiEirm6c1m/WH44Z/VnxKQ/OfPRjQXBVVScPCvDHzdDsdlYB1DZ1YMGYY8L06COUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707953301; c=relaxed/simple;
	bh=5h7Y8lbUNLMAQRCOLPW9ArsrBAoUhQhbkWbJuOI5ap8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MtNT9ioTIfYG5SztjqvYe7D4yQOnDPU/C3v7fBDDhilrMEHaIgJOxcu/R79XysDLVrqCuuoUAexZWWd+Hrhh7P4hSdrDH5JDsyddE/jMpv9/aUCWLSamtwFdubsmelNTR3IiUxXQJLgGzT4ezCdSiOlVorYOKXj8DPAsPS6GK8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lxu3q31L; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lxu3q31L"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7d2e007751eso113742241.1
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 15:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707953299; x=1708558099; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tz9FuZCe1t/s/sOzWyWj2VJKhDH3TaEC7G892r1B5/M=;
        b=lxu3q31LDJQA3GLOzAFfsr31LrHYxrgaYL9QiuDIlo2kboyG7AyVVgLv3VLtcz5DOF
         6b5drE3/rYxcvd+Mw9Fo1b56Hrts+anDIVfLunel32g6rZcqajRSQk5+FYismT5/4r3F
         0OCSUdNuMRUCGjsO0/0pnMq6GJBThhxMD14fBm6HTf8xDxOGLgQ8MzjUmbcw3TOSPw7p
         EUZGpRv7UZFWSP8elIEaT0IUi2k+wqOlc2/jchHy9FvKP7u404rVPEWTVuiiD9dCTuW4
         orjW4dtuHzQztJxbnqNGDO4dUMPaDqFl9aksj56FRCTNFC/sXpqMQsi/P5pVJcmiMbsg
         uD8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707953299; x=1708558099;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tz9FuZCe1t/s/sOzWyWj2VJKhDH3TaEC7G892r1B5/M=;
        b=IHVcg2Ak6XfDTBaT9n9438oLyt8L7Ayh9vDIarRRc9MlqYkW8F+n3byg+d1k4RnF15
         2gx2oWveGydhRxjsSys/l7qEw7AbWma7qEc6x7a/DgNZVsDM5IHeQ/5v9ejDTBjG1N+Z
         +grR05qL7BapzTJLDbLpdA8Z6I/mPVdgk+QnkPp46cmuJUdkiGyzo8Um3+zAnYm+zKr5
         oW0K9aaR74Z2a0SKjZeeArvWMVFNhwquGO0AejYjXBt7x2GKgT8ArsR1oOxIdrszCh8f
         O7O8PzCgwUvl8w5QpBHvyPg/ogvTGpqq2KClBGOflHAzVjvAxLdS6Q0NMAtLWRihjRnt
         iDHQ==
X-Forwarded-Encrypted: i=1; AJvYcCVS+ROyK3KQ2d9MK55gda4sBHFrWZp7SR2QyumM+ERjFdqGwWxx8/2b/LFv6px+GoEZGYy0c//fsNPeWcXCh3oeTd8qzt91Qg==
X-Gm-Message-State: AOJu0Yyj4S6hA4wu+RYFRL9CbBiiI3SJYwu+CFQdtzYmDJ4ihNfcFfCW
	g+prXiPcZNXHUKaUbNSYmbVqxucl/IEwb/4SrZ7wmGhhTpkADo4918ZM8NxbqcEhsAQbUR87Z3u
	feCxag08l2kYVKBZl8eB+jRAFIg8=
X-Google-Smtp-Source: AGHT+IGGaF2GFe2/KikEaqiK30P94DS+IncALzUVkEmkbzsrhehvMIx3y8vq2VpyOfV1iYqslom2UvHXddgzvvjkSO8=
X-Received: by 2002:a1f:6242:0:b0:4c0:24e6:f49d with SMTP id
 w63-20020a1f6242000000b004c024e6f49dmr4185961vkb.1.1707953298928; Wed, 14 Feb
 2024 15:28:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142247.920076071@linuxfoundation.org>
In-Reply-To: <20240214142247.920076071@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 14 Feb 2024 15:28:07 -0800
Message-ID: <CAOMdWS+=9Zp=rCJf8X0eXghkhOOwYTzWaEH2Z-8kjMx9w4DrgA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.17-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc2.gz
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
