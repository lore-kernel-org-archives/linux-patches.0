Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF849883A
	for <patches@lists.linux.dev>; Wed, 23 Aug 2023 08:54:49 +0000 (UTC)
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-3ff1c397405so3393775e9.3
        for <patches@lists.linux.dev>; Wed, 23 Aug 2023 01:54:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692780888; x=1693385688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BswGZjQLEAdts40JO7B/IE0p4jIiLic8b6XiJmbSSU8=;
        b=fSDE82jP59sJAPSRXKdVYg+WN0BbOPfp5i6NmlFjJHRaIR2z8gNl1IglMyTOPoxE27
         Vt+0l+NBoMOv86vUwP/7EoYCQms98lAL1tRcuBiQ4QTYcnx9dVMaZjCaWj+14ZshJNbH
         uucTDRizEa5zYS8htbqqor/8rJZwTyGU32tZ9NPQtgdODGCfleKYL2HtVC9fzFYtgnl0
         9iqGKmAmP6/tqCb9O/E+Y11GziSbDd2FraZgxDYPlXsyWgGj2CSX1mcWZy5HYOvfLDPH
         +vVrkcLFEKn8Wx9HDs8jJKVZ3pHarNx1ufz6NqtIzsltmt4m4wZTXEAtwvx43opoHh6e
         wY2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692780888; x=1693385688;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BswGZjQLEAdts40JO7B/IE0p4jIiLic8b6XiJmbSSU8=;
        b=dcU8eiX+/88kBzMALkr+3mSLrSZR6YynQd/8aTl5VbNmukcEvsQdaTEBBz/zb/lqi4
         a/3SXXjldNvefvqyzt/VFFgARJiZ0o++d1TkzH+lk/YQfxTTWv+eE3PI2ipxDRR4aJI2
         /UifeB8DYuKiFf05KDZOQZV1B1Xsv4IXRlzTzto1PwAtvKT+UDPPYAR8sCC3MfN2vfSy
         QFztys3GuMYtiPfAQgMeayCuXtLoVwMQujDrSkbOkoHoPURF0gzEpIJHoREUZhNgfdnj
         S1gD4PRMiYyarVq+aSGZkdkagx7Cqa5zK0m1y+ehFGlR1Q03XcQafxqRvjIdzodNGCiu
         w64g==
X-Gm-Message-State: AOJu0YyAwdCVlBTuPEWuJvu1ttd6sczBR88DTQE9XO2O1jJO6AkcNIBE
	CPbt1fSRnUur6DMQxwITP9E=
X-Google-Smtp-Source: AGHT+IHQjqP4ss6RAjHKdp48XvlaiwLE59zsm0ttZMacwSKYnoz7zPhcE40z1lNftwIMZWc/LGZyUg==
X-Received: by 2002:adf:facd:0:b0:314:3ad6:2327 with SMTP id a13-20020adffacd000000b003143ad62327mr8096342wrs.12.1692780887797;
        Wed, 23 Aug 2023 01:54:47 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id t10-20020a5d49ca000000b0031ad2f9269dsm18179338wrs.40.2023.08.23.01.54.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Aug 2023 01:54:47 -0700 (PDT)
Date: Wed, 23 Aug 2023 09:54:45 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
Message-ID: <ZOXJVamgYV1Mb+7S@debian>
References: <20230821194122.695845670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>

Hi Greg,

On Mon, Aug 21, 2023 at 09:39:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.3.1 20230625):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. Warning on boot, already reported by others.
x86_64: Booted on qemu. Warning on boot, already reported by others. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/4765
[2]. https://openqa.qa.codethink.co.uk/tests/4773
[3]. https://openqa.qa.codethink.co.uk/tests/4772

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
