Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3B42524F
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:15:35 +0000 (UTC)
Received: by mail-wm1-f47.google.com with SMTP id p16so8942871wmq.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 03:15:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0boVBTb7DoukQXQ50pLX7toWXVRfMvz+YuIAjUtNoB8=;
        b=VLJfQenKlJfF3VXqkE09W2mCmFGkwLCx1N1vROMbo7C2ZvELdPXIarWD3nwghVAGLs
         n4joDG1O99tGVZMvbtqf8ApkG2GjLd3KVz8M1N98Zb9U05YbAq9Z0L1UT4km0/yqSge1
         n9gXvMzk9v7uwuwlL7w7HUBDUAM4IN+6859GuwhPPDCrmOKEwk5ymulH1w/fiAJA5jrP
         iFiMlbSDwONs8Hg1L50hO/7TgRxSPsWE1LzuhdGcJQZ3pPuzR1GJvWkCfoCd5IUmqIH0
         jLvQNpihkQHxjHFNUKG4bjxwcE73pujC7RPrXPmJPmcBy0p4hcTa64mK8jymrBc8WABf
         o0HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0boVBTb7DoukQXQ50pLX7toWXVRfMvz+YuIAjUtNoB8=;
        b=7VOiwnmws95A4srK92e8/zBwlUiPoGF8jxqJDoOMpELpKCI6khGVDfqxxW8ZOzYSI9
         4y7Rs7WaBqSCG4iE8eztSQGaRvbOrj7KhxYqO3MsP7VQpbSu62eX7PPrGN4bTTE4GGj5
         SdhviuSNjWrPPCt0NE39KHsIojlPc9jzbX06p7tf3Qu7PlIXxBd+rUewHiNSjadcNoux
         1MjbrIGui/X85ZKjh8hlmNlQnxhgl44y/dPKbspGp+E5uv4ssEPJEQR+7hqrf8rRhtdc
         RxUfSM8jRXoIf7L59Niq+mPAEUI3AlfxI/I/p1Fm2CPH4fzmPYvjYz7pWaCw+C6Vk22H
         0JjA==
X-Gm-Message-State: AO0yUKUaKXgieUk8Y5Yqpk0fEBJie3kCsSVWiUz5Sdt2pBwwzoHRefEm
	WDW7ia4VtT9BU4DnB+KFCms=
X-Google-Smtp-Source: AK7set+3MyW1HIv+ADZHInPpjeEvm3w6Qnr1mDb8hUJY1kEvctlJGkCw/bAP3Ngy8hihKYZe2FEkAQ==
X-Received: by 2002:a05:600c:998:b0:3dc:5b88:e6dd with SMTP id w24-20020a05600c099800b003dc5b88e6ddmr12199715wmp.10.1677237333987;
        Fri, 24 Feb 2023 03:15:33 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id w2-20020a5d6802000000b002c55efa9cbesm12903925wru.39.2023.02.24.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Feb 2023 03:15:33 -0800 (PST)
Date: Fri, 24 Feb 2023 11:15:32 +0000
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
Message-ID: <Y/icVIHZ3SGogB1q@debian>
References: <20230223141539.591151658@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>

Hi Greg,

On Thu, Feb 23, 2023 at 03:16:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2929


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
