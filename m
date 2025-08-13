Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 670671D54D8
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 14:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755095527; cv=none; b=Z44iamlustIWzBql8DnnBPZwMXvIIX7W2aGP90TU/ia9XE89dIZ9XlVhFFen9R1n0KUR/Ub2USLAswx9LIM+Tb1fXUVH7ObMMQXJzm5Gj4vY5nlM0jF7S8mcTLZrKzqi4GiHmMKri0lLhv3hE+NXWenU7gpq+3q1urdCWvstHew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755095527; c=relaxed/simple;
	bh=ipApUWXD/vc+gn0dpjkARbKTGMwSNJWFy53h/IiXXnw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tWr0VsQSzLQJmPp5rga8RJRFYi9VFJlCLxeduG2CUUM5HNgcCenf36XY+fYrlECItaXEOXveGFcZalOOtlETnkYFK5ahwQASIitemWY2FEQbJCZKQkRs9lz+sHxHqw/WBlfwDLrqVmxJw+lvmPq2vdvBa7UscgapXyTzqH54wcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Cc32MjTJ; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Cc32MjTJ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b34a6d0c9a3so7775494a12.3
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 07:32:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755095525; x=1755700325; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SdEySWA9pjFNhAetIdOe+TeBj+YFSkBbS61Z6xuGeG0=;
        b=Cc32MjTJpkCP1oCMxQh73LPmdBB4Q2qJID2XFrQAgIgcJWZ7bLYk84inoGUf21UBso
         FIQRYSD1l204/LnPCI/l6BWNad2dy22wgbZYClWVCPoTJChsUx2hDPGEQioMtBrDv1LU
         UutbmcO3qvodeJCW+DLraw6Tu9WKtIq706os21uTL1H6iu0pmzNnbA/Tl37bpRjVfSlI
         13F3OlJAHpntZXAm40I3xWLwe1NxgdZkcTs5Y/d+U/73qBEQP84ydUp+qtYQwCkpLeuY
         6E6VjUlYCinVPa80FOnNI5nIebNm2+vYaoPJbjgS3Wy8vYK2E5Bpfxakum32NcnRlnzi
         UinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755095525; x=1755700325;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SdEySWA9pjFNhAetIdOe+TeBj+YFSkBbS61Z6xuGeG0=;
        b=kj3YLn0MMc3XGtiTlD4xDY8Yg4WLe8vvT7Ql4e0+2vKJuFZ/RNHH2IGqzlJvbMYHOh
         2aXnxtZ23COu3JeRDsQUdRX1dWhiqYEjU9Ou5lzr49mvpR5RnpTnkHy3huY/NV1c9fE6
         G3MYVlDC9vdVx8OpmJLDR6L7ssOSHkJ/ERhyXWUimp42Tcs/g/MzDkLMDHvMMJBQo6BG
         XuntuOwPCTa+JDL3CX8xrvHp5NutM/mJvbZW934cXAbz5J4noJ0ZiOcFHNVFZE04BnoK
         Yu5TqjM0YFfnP81NyH0LNZXMB6M6isUsqZt3t0y293sbmByJfv3nUbzWvZTsNrH9hDXN
         peyQ==
X-Forwarded-Encrypted: i=1; AJvYcCXCkaltz0RefPUG3Ql2q5eNSJnqOOHSVCHX9K4AzRvEMW37PyKaRNRD9bS30jtMX2On6SRL6kY7@lists.linux.dev
X-Gm-Message-State: AOJu0YxQm8YaLvk8m8yjjdZkNI6sWVNQtEDFd2uYWE3Vz9HwVIZIuzsl
	czjZ+e/LCQXLOSXD32dd+zOOTjjJFE8IFjjHIVsqQ0lE0u0/Pm/xGvRKemyHFOi5Q7wyCzyy0HB
	cOtU/DtI1RtLl6Z9YWgHudh9HCuD+pfCKrXf+bKdqPA==
X-Gm-Gg: ASbGncszWYID1W9S3fDZ5IxdQUzudBH5rq8oy5MwbpNF2V+EoiR5kxBupdvAjIOI+zl
	VaEtCPC2vnfIbcnAxmzVgaRfIeZxAX5sEgN7dmXTtLC5lBLFrqRGKOn3yOHymGCVdWSjdQNHMjt
	6nkIDvyjtgQButBB4uYIbrcTKVwZ0UvE9jLey6MCqVuhRAZSF9UplvIYQrCuhHOUkedyzf3RARg
	2HJJl+d1uYuJi+0cS5MXOAcRqOzxVqj7QD+f7QIUB2NUs0wxFV3eheLXr3jjQ==
X-Google-Smtp-Source: AGHT+IFzsa7z2LB/NwMV+7ODMzwtQZ5c6SDjL/beKBH/4CiDe3n9MltwqzwrpDodhDWNKfzJI3ZmU6XpdnvXzSkeC14=
X-Received: by 2002:a17:90b:39c7:b0:321:cfbf:cbd6 with SMTP id
 98e67ed59e1d1-321d0d6912bmr4596811a91.6.1755095524619; Wed, 13 Aug 2025
 07:32:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812173419.303046420@linuxfoundation.org> <CA+G9fYtBnCSa2zkaCn-oZKYz8jz5FZj0HS7DjSfMeamq3AXqNg@mail.gmail.com>
 <2025081300-frown-sketch-f5bd@gregkh>
In-Reply-To: <2025081300-frown-sketch-f5bd@gregkh>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 13 Aug 2025 20:01:51 +0530
X-Gm-Features: Ac12FXzTlKbJUDUafTa4ZlpVkqfN8sdY7Wfx9w4NKXTaujZ4mJCVSf-u4y5vZP8
Message-ID: <CA+G9fYuEb7Y__CVHxZ8VkWGqfA4imWzXsBhPdn05GhOandg0Yw@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/627] 6.16.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, qemu-devel@nongnu.org, 
	=?UTF-8?B?QWxleCBCZW5uw6ll?= <alex.bennee@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>, 
	LTP List <ltp@lists.linux.it>, chrubis <chrubis@suse.cz>, Petr Vorel <pvorel@suse.cz>, 
	Ian Rogers <irogers@google.com>, linux-perf-users@vger.kernel.org, 
	Zhang Yi <yi.zhang@huaweicloud.com>, Joseph Qi <jiangqi903@gmail.com>, Jan Kara <jack@suse.cz>, 
	linux-fsdevel@vger.kernel.org, linux-ext4 <linux-ext4@vger.kernel.org>, 
	Zhang Yi <yi.zhang@huawei.com>, "Theodore Ts'o" <tytso@mit.edu>, Baokun Li <libaokun1@huawei.com>
Content-Type: text/plain; charset="UTF-8"

Hi Greg,

> > 2)
> >
> > The following list of LTP syscalls failure noticed on qemu-arm64 with
> > stable-rc 6.16.1-rc1 with CONFIG_ARM64_64K_PAGES=y build configuration.
> >
> > Most failures report ENOSPC (28) or mkswap errors, which may be related
> > to disk space handling in the 64K page configuration on qemu-arm64.
> >
> > The issue is reproducible on multiple runs.
> >
> > * qemu-arm64, ltp-syscalls - 64K page size test failures list,
> >
> >   - fallocate04
> >   - fallocate05
> >   - fdatasync03
> >   - fsync01
> >   - fsync04
> >   - ioctl_fiemap01
> >   - swapoff01
> >   - swapoff02
> >   - swapon01
> >   - swapon02
> >   - swapon03
> >   - sync01
> >   - sync_file_range02
> >   - syncfs01
> >
> > Reproducibility:
> >  - 64K config above listed test fails
> >  - 4K config above listed test pass.
> >
> > Regression Analysis:
> > - New regression? yes
>
> Regression from 6.16?  Or just from 6.15.y?

Based on available data, the issue is not present in v6.16 or v6.15.

Anders, bisected this regression and found,

  ext4: correct the reserved credits for extent conversion
    [ Upstream commit 95ad8ee45cdbc321c135a2db895d48b374ef0f87 ]

Report lore link,

https://lore.kernel.org/stable/CA+G9fYtBnCSa2zkaCn-oZKYz8jz5FZj0HS7DjSfMeamq3AXqNg@mail.gmail.com/

--
Linaro LKFT
https://lkft.linaro.org
