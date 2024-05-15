Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FB8615ADA4
	for <patches@lists.linux.dev>; Wed, 15 May 2024 19:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715802581; cv=none; b=nnPPttF2B2HG96eR6u8/0zFZIwWCP8g8uX0IRR/lnARFdVeG360mQoT+vlJ5jNgAtlMwMKTbBRE5m4C73qXfm37r9oUJGTMdoocqdxOdK5csfEcEy8ek220kUDrD0/4wMfJMNUv0z7pDrTPNRw4tFdhHiffWJa+hc0VsDJA1Gg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715802581; c=relaxed/simple;
	bh=kZ6t4klUyIMJn16H55r0wYiMd4UJePBx6iySXQTyR1M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G0Xhuk4eT3kDxa+uK4y5l6jP9BPhXGREU9KCTwj7ypA4/BKdOG5k4W2da06a2SNSOqyO1eeKMFfD+38V6CHvy4Iuw+SSfe+afh6aaaiLU1qgkhp+q0YlwAUZQz05T3J+aRvW5OQntCUiaYf6YrPfJQhZ4+i4cPFBZt07+0QSAQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=THUZ1xLq; arc=none smtp.client-ip=209.85.217.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="THUZ1xLq"
Received: by mail-vs1-f43.google.com with SMTP id ada2fe7eead31-47ef8c9991dso2153138137.0
        for <patches@lists.linux.dev>; Wed, 15 May 2024 12:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715802578; x=1716407378; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=fg7/SnhYZO0IrKL7k9gXi4LAAZywPSttMr41QqUb75E=;
        b=THUZ1xLqeRPzcFjoVqzdtR02eJ6TOwoX8gIuRcsTyiBOnrRYmilyMt4Z7dNmcuEhYO
         9bVauum42KVmuo/SEnPnVutG9zd1f0TeR2jnsX32Q/9HOCgGulm9ueDvVOaKMFsVFFND
         8hHEHSTmAzzyhlWQ6CDVibXECPRfUI2LlV+6zCqeHgRbmW60VLCkerk6sKDtsbFUUPmM
         L0vYye6jyybqtkiB5vqXwup/gMJmTn0zAvPh4ER1IjTWqO8rwadI2tabBp6QU+TjxaGY
         DdfYWphx8s86aLxVUaG+t1PVDBXy/kHlXKU2C7ZV55vUbSdqmxKwTdzlS2ebu/LzbaXX
         l8rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715802578; x=1716407378;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fg7/SnhYZO0IrKL7k9gXi4LAAZywPSttMr41QqUb75E=;
        b=kN5fRepdDJ/1xscfisQKD5CI47A9/8UIdgz6c13Ju+Kz+IBcYFBVEsKI9V2X1nnGf/
         L5MUapz2tykcAh05Pz0O6ksikr+OwzP7U36VBFObObIsuzE4sFls/9UqnbsCC5woed+D
         ETh4XXGiNcnECXD/Mg3gfvRwqiIBN68cCCBNzI1ngvioNkU10fvE7xArVMYb+ozeEvNb
         OU88wvXgEVdDmSIxK1O++qv27NFqVmFeHhcglcYNfVPMQP5MZEqrUS11gcQJWpvqGq/p
         cYGb/YGocSgohqFSa190do84cI2ndb7JLsRbD4Jggpq1mmdHdcGxwjtRZYglxZp8od1K
         y7cQ==
X-Forwarded-Encrypted: i=1; AJvYcCUmSXLmxYxX4XwLw2h+Ou+Dqd6NLcEfnhjlNIyZBxcqe/d9lpoNOVd2oR0Iaeq2k9SusRIUrF8sF1qt5URkzYbFtoryVgD5KQ==
X-Gm-Message-State: AOJu0YxCLnFCMHaWF/JDmjUwmnu8+Av6TjIGmrCW1UPVZveEgPnszCx+
	no0Scg/lPU2QeUwdwYDVWINTaDU2oRHergdKTN4V8DPEeDDEKpCdR8M7M+icytTBAdGbZAg7qiR
	Nigcuu2ujfQM4Au15GlTZ7LuD1nc=
X-Google-Smtp-Source: AGHT+IGvNTG0pQdAEJXa0r+l3xuPRP51cQc5MvnBhifGmCSoxEELMNC4gvY2X45M+c3yB2dLC39yQM2WlDMqjonStJI=
X-Received: by 2002:a05:6102:304d:b0:47f:17e7:ead3 with SMTP id
 ada2fe7eead31-48077de5466mr15483575137.12.1715802577005; Wed, 15 May 2024
 12:49:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240515082414.316080594@linuxfoundation.org>
In-Reply-To: <20240515082414.316080594@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 15 May 2024 12:49:26 -0700
Message-ID: <CAOMdWS+1-Yj+5uYB469K63VU_9-Pi3O2do2S753udPQm8vhOEg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/168] 5.15.159-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.159 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.159-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
