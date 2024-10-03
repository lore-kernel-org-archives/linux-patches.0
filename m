Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 875161A7042
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 21:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727989492; cv=none; b=A7uOwoZ+5mhTp2oshhDcDRKos/LIvetOf0KaqvLw0SOeo4fo7RVWUNLFAICGGL75iC3mnqK2t6C1G3fX56PZNHPgZL14dIRBKDpqPh3OW8vsS7OpqBTPymlZOQRiNHHemXts7QRaS/RULm5QphqxwOHWPFnn9U1rUF0MJ74ubgw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727989492; c=relaxed/simple;
	bh=OCieWID+bbANtKcXubL5jg67fNWeMSGGGry/Ii02KsE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BCngyhualr0v+8VKvEOu1hVObVB+o9L7k+AhYi1twxO3avws+tWtMjLXOmbEh9mWgc16AAfcTjIDlcXT08sUiXVK1uwF3kVIiGuvJmZd/fbirHZTjwT/ii8OAxLOvAbqCB6EmUXBTo+AoVIw+8gEhFSbsglSCWn6veLdaRQP1gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DCRqXgOK; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DCRqXgOK"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-50a0bf4d4b8so407624e0c.2
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 14:04:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727989490; x=1728594290; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J5gQaf63hkNNcZ+deZSYAap7Pm/NsYaYJT/Td2soZD0=;
        b=DCRqXgOKCPGXVfHq/XN9PbvrEZMoCXs8q06tR6f0pqINAlofCq0sJJ+GmHwZcKTc5i
         PfuIW5W41oSb3y/5/ASuE2J8a+Z0KUI7Bzi2BVKKZifqBDeLp48XdZAAqjrev89iDmWk
         dRGosUjcQhrvzl0JJGIh5+/Fns28LgDGJdSWGgYy0SNGMDm3daLi6zhNNHxcjqkWiwwy
         Oh+s12NQ0RCUvJSWXvkxfX2HNaOtjRlomjMAdYH9wrc149r6+hiUfsiLgZ3ze+wvNHHy
         nKopJj8IFz3JPqhi+9EUEe4zXLNzTYImUwgRzMR0Mz89Hlhgm3yrISCwFf4E5m8/LG5M
         k6UA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727989490; x=1728594290;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5gQaf63hkNNcZ+deZSYAap7Pm/NsYaYJT/Td2soZD0=;
        b=smzlIPwCAPdU9Lmp0YbSyD+f/HD88rdtEhIB4M+B1DOA7VeYkKLmjFxPctbYejUvxV
         DclWHB/bPZLHzGdipFjxTWqPcFJ1rbHIka+KSQd9z+SUdgLmtqhDkSVrqBMudPyqymdF
         +FdfCFdBqWZtKZ5VP5ioY5zqUnM6dPD/RoWXtuUPETscjD2W8KbIrPdWBcDbQ49s4VDO
         ucEVj5inn0cICF5rAkbIhIVMPOPx1XCE9GO5bwikDmalKWj8hOySZBti7BOMLrVSzpAV
         vTHaGdrcVG/cVCDGNCWkB+mg1xA08OQA0Bc0lt2C51jTUrm5PrzJTFKPNdzGatwDfSyK
         s61A==
X-Forwarded-Encrypted: i=1; AJvYcCW+5DtCNoBNburW+oITaJI0sJzsTX1S1Pegp5K/sSX5OmNSrjezxZ7so2rP4rFRR0wLmCIss1ga@lists.linux.dev
X-Gm-Message-State: AOJu0YwNA0X9PjLXnK65rO7GHKyOUv7nm800DZhiHDfXkQmWD6vZfaFa
	EdOaeF2o3vT+9zzZy/BohshA6XGdAGWoJMjHRvsj/9mcnT1DuvoNMEK3Fa8hXteZ+QYY0on1zJ8
	HMgYZlw2dk7hABk4AqAOQ0z6wNWA=
X-Google-Smtp-Source: AGHT+IEnqPeRuhWH5MC2QJT18GB+oX5vHMjvBQAjuk20JM0hsn2zfIQdbT5FGpDoIZn6OMGAszgX60EsO0A/SoHspso=
X-Received: by 2002:a05:6122:2a14:b0:503:d877:b049 with SMTP id
 71dfb90a1353d-50c854741admr809264e0c.5.1727989490345; Thu, 03 Oct 2024
 14:04:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241003103209.857606770@linuxfoundation.org>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Thu, 3 Oct 2024 14:04:39 -0700
Message-ID: <CAOMdWSJ50xQ0K2EdF075=i3b_XCh9X+vMMk-nzjS8TfYdFi2ww@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.54-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems.
No errors or regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
