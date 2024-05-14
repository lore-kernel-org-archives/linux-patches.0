Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39224180A6C
	for <patches@lists.linux.dev>; Tue, 14 May 2024 20:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715717309; cv=none; b=GHNas3pbxX5JlVwgnfQKc9JnrtVG1eJlnY/eVGvCpLUojFxv2E+9HuVW1U8MOjLZ8+Rby9ZectUfGLUUH0LeKOL+3rgJfkay+a6UmRmYCj/59LjyCHo6D5tOMxBoBLRna94g5MY2kwQuLKbI+3exbBnSqdbUgJLvwJGFOM55a04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715717309; c=relaxed/simple;
	bh=cKYDeecydpzGb/O5fET85WmiV/33NCb/HD7oeJKbfRg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mTVbZe3i+wMa4Wps41Fqh03S8f+23+Pm1m2RjuUIb5AsFArfc10710HlAz84odIWd8XdplUNWckmx/7APlkGjPEbX+wQL6NQeWxKHwrgVYqoTfKaKDUdHupxNHFNg9sj3dUoGeoz/Vg12cRx1HE/EO/+detqGgCr+e3DcgG/UoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FpJnjZ8+; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FpJnjZ8+"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4df32efa5baso2029990e0c.2
        for <patches@lists.linux.dev>; Tue, 14 May 2024 13:08:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715717307; x=1716322107; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fvjoJ3H6892IQ+WG+yDZXENruQLJb/czhTtD/pn2XzY=;
        b=FpJnjZ8+shm0HPKAqFkJ2gPZ/1y2Z2GIJTkUkvZaxV5rXd03DaRy3abtHp/sqN/bkR
         mENR+f9O6Ct0Oo7MNWTH0glaxYGr4WYUlgMe8kK5KWrXalGImdrUvUraCLe+eJ3rj3+M
         Sv8ebGmVRpgbRQ1oyWkjxdsAsbZ5k3Sj2puvsLc/SIJrUZ25vFT5T8CLQmt24gheytC2
         eSsmKBmKefF3DY5Ajl3nelAQ31BpEnDjhgk5zty1DhijXcvezwq1Uo868CLOi9HKmhf+
         BxvZvyuYBQE/fIGToe11U0NkSaeeU/bgqa1k4amGypBvCfqpKst0vmzIya7FmDygIemk
         A2Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715717307; x=1716322107;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fvjoJ3H6892IQ+WG+yDZXENruQLJb/czhTtD/pn2XzY=;
        b=lhHUAQMBnCquSq5VvSHj11NoXha3vl2O/prU4ANzjmc0J3RqgLLp9qUS2O6CyiVY/t
         nKmM85pkjla72NZdnsZFzt/J59k0+MKK2NVcRY8EeRM77Uoh0FKRVqCy0/iZUOyTSENx
         xZqiQzX7hQZyAzuXRhA7Bkx2VNIUtnYON2Qw2rQAJylRBwBjaahZIWc0ZfbbdrxVoazP
         9OlNkGuuhSp+IOrDAdCGuRWKnss6IBioH8KNhhKeb/wcI/JFoF3Ett0LdxdZuEbg0aO1
         KYW9IzUcAMAW7H0PA8yqM3MhnAwFOaR0eoWIMBYAfEIpE8a3GS6ZJr/qgEMrRNkGNXBG
         O+eA==
X-Forwarded-Encrypted: i=1; AJvYcCXjGfSvzBUsjxvjdJApplnrFsGk810mORYY893ZCbgdfYV3SxncPyvRTRaWaqB+dBF42t0CJs9kQ4MHZkHVyD+zipbGKIfvQw==
X-Gm-Message-State: AOJu0Yx7Eb2cvtsk7oUGo3nydRoL8dxzJkICaHHv6XJe/KkVXL9SU/rh
	SbeE52EDyMUpfDnvIwG4mcCzvJlnDdb9UL/GXL6MrgfUnbjuyyU4D2ZWVoj8v/ly4fC+jw7X8cG
	w/3RWWsYhd96yv9fBEqKZM6ztDY4=
X-Google-Smtp-Source: AGHT+IEPLqc+S8mwOzSlD9qkOiMIP3L1kSLyeSw+t3/KMw5TNbtUgeOPShHGNCog8hcDpyKJCP2QHrDpVrC0Qsd0ug4=
X-Received: by 2002:a05:6122:d0e:b0:4d4:126b:2c8 with SMTP id
 71dfb90a1353d-4df882ea840mr12437198e0c.9.1715717307146; Tue, 14 May 2024
 13:08:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240514101038.595152603@linuxfoundation.org>
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 14 May 2024 13:08:16 -0700
Message-ID: <CAOMdWS+Fow2jJm9j66Pb2hQH_uyvUtHxM9+HdFwmT_eHL-Qo-g@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/336] 6.8.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.8.10 release.
> There are 336 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
