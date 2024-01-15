Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64018E0D
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EqAXnj0W"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7cdb24b3ac3so1160815241.3
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 11:46:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705347967; x=1705952767; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JIbfkPiR6M/kmxy2zdTQeSRuTcxVNa/RonwKaeglhrM=;
        b=EqAXnj0WA2fBr+RmRPNRe3DGW754d+DKMn3X79NDcQsLeu7M4h7xG6ZW8V8QiYfeyx
         MtkBaPhaXVo7uqsVaG6CDw6qiJOQ6tx9QKZnE9W6jWa/DYhPUUKbiJ7Rz5a8P5QnywcW
         w+c4e3Eiu91bvVjyidyKsqrwbX0wvALRjAsefmCi7UXgvjwe4YpRbZhUdYbdy73Hpuq7
         Jc1imwUmTNwf6orUyseXEXHxzytTKVBfpwBRT9ZThfBu27TXxi0BdKZglKakqmCetkNB
         Dy82dt57nsx4wzWYfgc33GwM/e44PiQiVIqR36TAI4xgoRVwuPz3PXIyUneQKMHFm7V2
         6qCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705347967; x=1705952767;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JIbfkPiR6M/kmxy2zdTQeSRuTcxVNa/RonwKaeglhrM=;
        b=rzJqhqRa0fiNO0W/+GwXHJTP4CoA0y35rbmfjMcZuKH0rMCJcw3/nO00gpXlE0YqX8
         O7jFmzxd0Rg/TRnzDCAKQpK4vqJSsuViU8y7Mq/7J81EZU85JOrofOk6xsObWGq0t4Vi
         84pbUYHK5Gx/HQvT2PFUP0jMx+VgYy7CAK4+cSZir8br8Vobzw9vDOECLA6uF19ZNwji
         4FzhRz+yGpmS603liuL3eFqG3Ttv3+r5t3Fc+2pnWTz6n+pOolMw8/T6RHr1D3B6MQEU
         bkQzhJTzbahYhtyz8myT3wWHV7tuY7HUPkbQjkhqS7BhmhEh7g64bWP5+4E7FqOVMfo3
         uM/A==
X-Gm-Message-State: AOJu0YyMByMDjFbo8d04xbv9YxjZmKdwqiT7/mvfSxG8ZKKY3iyQa8rp
	Qamin2CoX3pSWn1UIjA09IKqymPXSY50hogEmro=
X-Google-Smtp-Source: AGHT+IHb/CMeHORAxtWRRGn6N6ab3r/Xv6z27ogqUBsIkqEjTTznz/OGBR8VGl4EHxuhi1bPGgPVvqr2Q7B/LJ6CMLY=
X-Received: by 2002:a67:c78b:0:b0:467:cb07:fd1 with SMTP id
 t11-20020a67c78b000000b00467cb070fd1mr2273871vsk.11.1705347967413; Mon, 15
 Jan 2024 11:46:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094204.275569789@linuxfoundation.org>
In-Reply-To: <20240113094204.275569789@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 15 Jan 2024 11:45:56 -0800
Message-ID: <CAOMdWSLBK0FsWn+4BmRxrE=FC=E212NcaA2jkhEekmP51iWThg@mail.gmail.com>
Subject: Re: [PATCH 6.6 0/1] 6.6.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.6.12 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.12-rc1.gz
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
