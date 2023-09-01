Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9248D5662
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 09:18:56 +0000 (UTC)
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-2bb9a063f26so30978351fa.2
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 02:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693559934; x=1694164734; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6+njEKjcTP+ez0Q2gzhNZpFi7MIABKKwCebuyo0ubII=;
        b=LlXofFADVHtuEhbitG328Ilw9eQghct2SVPax5naE+5tdauAb5aPwY/w48flfS1Nzs
         C47rqPPxtbGc84pp6zWfHf0moymEMc6UbgoDJi4KGpQRqV2kL4Z8TjYeHbL23S+v2D1O
         RSF/Za3sps46dMkkaXWH79ewq6v2Utex2K7E0MFR2e4htfDmdZDmrLpftr0xJMe26CJF
         ZA/HU0ribfXVqPAyxxQPYvwgNXZT82pJTm9xoJfuiYSBKqaXuWj/iYu5p463j8m0O6Bd
         YWIXAQHTqFILmFxtvjiQDWFRmUuseZeZVkIXWtJCOF705uU/ASpkEPwczsazF6mtp/qa
         3MXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693559934; x=1694164734;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+njEKjcTP+ez0Q2gzhNZpFi7MIABKKwCebuyo0ubII=;
        b=YoIcfGg1YEnvPSPlUSaIjeesGRm4CHEjA7xVPuY952fUsg7kKsU34dc/uoNtzo0LzO
         whEtRpFv2DcAXP7suXbNDJ8sZcgFHKopHY80GaLIh5bZgoAP6J0A6o17hjVPgziAUKxV
         GV43dEftcK9zZwIcSRjdcquQPnYyb+se8IszVUkUkyE8Yj7Pt6IkoFsXIcYXjRnFMNo3
         Y5ILs6mFDJopFhdIbVRvO+PBTNu5nDJdRzQIQZfW5nxo548k+YRj+IcyfsZSzPdF9YjA
         6oN0Nash9dO1p0pEWhnzQycQFNLcctWrfKE/+ZTOrsmsIPtm6hWfqLiIhg5M9lJYA/gi
         sjNA==
X-Gm-Message-State: AOJu0Yxdq8DwziHFfTlFqyniGcb0Hw7f9AyHMTpb+BPebfhM+3wMK6Gg
	58tN/uxcen6hRSyiyIu8Afc=
X-Google-Smtp-Source: AGHT+IEuuUVNlcvvZD9+UdKgZYWHNdlT09FhxxgTeD7XtEa6nwx5c8AdfbirneV7j47yNV+2pin8DQ==
X-Received: by 2002:a2e:a0c3:0:b0:2b5:bc27:d6eb with SMTP id f3-20020a2ea0c3000000b002b5bc27d6ebmr1131010ljm.8.1693559933940;
        Fri, 01 Sep 2023 02:18:53 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id y11-20020a1c4b0b000000b003fe2b081661sm7368206wma.30.2023.09.01.02.18.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Sep 2023 02:18:53 -0700 (PDT)
Date: Fri, 1 Sep 2023 10:18:51 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 4.19 0/2] 4.19.294-rc2 review
Message-ID: <ZPGse1U/KfXLI+q3@debian>
References: <20230831172214.759342877@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230831172214.759342877@linuxfoundation.org>

Hi Greg,

On Thu, Aug 31, 2023 at 07:30:20PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.294 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 17:22:08 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.4.1 20230829):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/4879


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
