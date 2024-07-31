Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E196417579
	for <patches@lists.linux.dev>; Wed, 31 Jul 2024 20:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722458334; cv=none; b=XJB6ZL1QOnRGUx5DK+TTGpygB5AUQs5Z6Wg7cqSRa9gDgMl2LaK1YK/k1UXonURXbHslkpqvMlmmwlZuyJOlkDUtNrfy4AAxYAZNI+G/+5hiFlvz5h8zda+O/CFspkmAdlVZ2U3RhaMAXtpKm48LDsM1v38eGL0M1/52JyObY6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722458334; c=relaxed/simple;
	bh=QEDj+lYmdYwZjGej/erR7EUZaaRmzLc1Ns+v4v5sZQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SS7h5JVdB57TuP0Ouh5jUxJU0wjJaP/wMp/TI01A1vrb36eFmazCxcvuxk2MPFBv63nNRLxU4xRhvy/i8LvePi1sR7NOLfff8llI3QEbrUQyCYM3zFRtosAov+wHj8vXnVvhOysqQAHWNBkgOIVKzIUEnkemqOgd4Ho23ShHD+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=AKOkTiq0; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="AKOkTiq0"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4f887be28e7so590561e0c.0
        for <patches@lists.linux.dev>; Wed, 31 Jul 2024 13:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1722458332; x=1723063132; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=F5NFLGE5phJ2Liv5ktsunuY0p6FQr//tugyI0Kha3qE=;
        b=AKOkTiq0pE+pyKHrDFiJyM5pmCkBwAjZHBoNa9icj60SkDAMK0NVca35/F/OlLGxqT
         ChdETFmRQsK9L0BmWuzKzuku2guDC48RedGhcMO/mhXs+OvPW1ByNHWTbpHxTorWmw7M
         GJMXK8nQ6BCXed/RltiKGUqVr1qB3Qk3HecYdZNpgfj0sfJ4GiMD1xeYdfSKucXDdk3z
         dJXqFLny6Vo9aKvOcmVtN20mwse0lSWRM3REqOmuBLjnux/kfzmoXB/kGNXk1ktD6ncB
         sxFDVyMp2kw9PFzEvZ6CasqVYbBR9VF96N4ak+W7N/+p82eYG4jzMU8vIBQ1XyLQUNiT
         GrEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722458332; x=1723063132;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=F5NFLGE5phJ2Liv5ktsunuY0p6FQr//tugyI0Kha3qE=;
        b=V00uP1ippyuB0aDfuTEliPOijUyQkwkDPy2l8ZgcOKZ1MXdQr73UaDZUgQRtD4U1CN
         vXsIBFbgtx0pBbJhrRW4JAkZVPF1IMRIKWiKdkwt3/wKzIrDA2JnPRgqlrYJOC18qIg4
         waLV/h4UknzGoOSZAMsjh6A4py6me0ppIVWYgZG6mSq2OxzkLx0xwwjgjX2+cpBc130a
         AeE/8fFO3HdghSRDTvqTZXCSgdNjq6g8ovb2agmCZvufzD9DnGbTjKBKJ7FMzP7dGUsQ
         upNJy9guJuSaz6aLZ4loYZXZJimLeYvW6tr+nGe4QpP9S8SZDRRkDhtrE/lBrK6iZVJS
         inMw==
X-Forwarded-Encrypted: i=1; AJvYcCXDtz/TyUkdgRthe8i1n4tkmej0JDOieNUnTLDXW9TTsKQI6ibDkWIqfOqUgb5zAfrEEElUkYAS4zfOMI66PoWgbzJFAmqg/Q==
X-Gm-Message-State: AOJu0Yz2G0xdohgyXW5z9yTaIXKBf6hXFzh/P7CWN9BuiW1hdmAr4rVg
	1pl4Tgp37w/T2Mh+g2En5Sr5m1MchwJYI3B8vGquwM8UUOrGoPyNE7Amal7rBwrAR3+6BDiSoQT
	pVS2CLJjDjdGhg8/O2zq1pRq4YtI=
X-Google-Smtp-Source: AGHT+IGgZSRkGNf2/g2W4xP0fPTsJ1SSYgUFU1liK/NEoXAyyFyRcjq7ugG5iHnPf32al3X9PQJ+gEYtWcwDPgKfHCI=
X-Received: by 2002:a05:6102:3a14:b0:492:9b6b:f844 with SMTP id
 ada2fe7eead31-494509d0130mr496280137.26.1722458331878; Wed, 31 Jul 2024
 13:38:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240731100057.990016666@linuxfoundation.org>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 31 Jul 2024 13:38:40 -0700
Message-ID: <CAOMdWS+OnhEzLK1PyPKJWXAVauPwK8CA8jKvOs1j4D_G8n+Cfw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
