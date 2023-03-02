Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9AA5381
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 11:35:35 +0000 (UTC)
Received: by mail-wm1-f42.google.com with SMTP id j19-20020a05600c191300b003eb3e1eb0caso1498865wmq.1
        for <patches@lists.linux.dev>; Thu, 02 Mar 2023 03:35:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pFP4w9yXQRwkuHy+AS0IYRfVLFJDnB9DWr4aqzGFuFI=;
        b=nLUd9e7sjiOgddgiUGeMV90O35ulPhUfP/V/F9D9WRpEQHZWa6c/AhCLzvvzDW0GDE
         1FGsX4k59/SHzk3B1Y2wb++Pljn5Iakar2uHRhGkLyb78J2AyzwesLmFz985o254RnIF
         Uc0CX12kdKFr76dZse38HzPoch+O24rffJJ84evSaO2IkLo3xWqlxigq1YXrNuj5mNYi
         BlQZBaZJgH9ojaO898T9XcdnNYcb6zFX6aCnPD/UmRr7yqUkmbN3ga4js1j4qjqR31qP
         3qHMe6uUo4do72aiumAEmiSfSiIb14iM69s5ice3i3ACH0GlufHAyyymVKNT59z1LUSA
         KOhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pFP4w9yXQRwkuHy+AS0IYRfVLFJDnB9DWr4aqzGFuFI=;
        b=5VMY1wjxZx6qzqLFVuYe1Y5p/tLbyR+dAp5bGrYnXZaqL/11BXoOX7BBvx1EIRFhxR
         mUjd8W+BVmkMFaSHIMXJgwd35uGRW7yS5Wmd2PnR1NAZeb4hvCJCKVMAckwsx+4Nlc6L
         g99v41jaSnab5ZOygmvjWYUekbJct29CTscoL0mFw4KVEsKew77j1p744MR0bZRxGEYw
         BTq/5XoV4SmHqnTNUR5PPyRQaTRy/UJJFaMqFJHuAsbfKdNSLLd8s5Hx/o2JQ31Xcsdv
         2xPiT5I9xmoLxSOg6ToNLmqnavqK9FTr+Sjt8H+tLC1K01mxL3jfCJh/CbpeiU4ZGNWP
         /DLQ==
X-Gm-Message-State: AO0yUKXrOphgVfGk1QZIEEMVFZSRJaEGqZcVE1jpfNJSznZSuOXE4nN0
	uJd8/HS9YDzdmf7XKmIrMBA=
X-Google-Smtp-Source: AK7set/00cHFsu+tJ6BN+vsST01MHRYZnj94o5Qp9+xbBG33vZtqB8skwAWVnzxCjE2KEUBF5NEONw==
X-Received: by 2002:a05:600c:90a:b0:3eb:2b88:5af1 with SMTP id m10-20020a05600c090a00b003eb2b885af1mr7464514wmp.18.1677756933651;
        Thu, 02 Mar 2023 03:35:33 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id f12-20020adfe90c000000b002c3f9404c45sm15007009wrm.7.2023.03.02.03.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:35:33 -0800 (PST)
Date: Thu, 2 Mar 2023 11:35:31 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/22] 5.15.97-rc1 review
Message-ID: <ZACKAw4rA6CzXg/e@debian>
References: <20230301180652.658125575@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180652.658125575@linuxfoundation.org>

Hi Greg,

On Wed, Mar 01, 2023 at 07:08:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.97 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20230210):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2974
[2]. https://openqa.qa.codethink.co.uk/tests/2980
[3]. https://openqa.qa.codethink.co.uk/tests/2982

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
