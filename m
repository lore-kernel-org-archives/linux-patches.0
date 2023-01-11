Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC1B5256E
	for <patches@lists.linux.dev>; Wed, 11 Jan 2023 13:02:06 +0000 (UTC)
Received: by mail-wr1-f44.google.com with SMTP id k8so448194wrc.9
        for <patches@lists.linux.dev>; Wed, 11 Jan 2023 05:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pqLXNc7RAugZUpob9cm6wuqqrL/nJ70ZfGAMn/EOoRU=;
        b=jWKM+LIMDWA3ZNABfM0jkH79WXGM5ex+Yxt+pWrtsms6QzD3Zu4XK2SZGuYFLr79Wu
         lSSVUgy78X3xvQ1kDZYqsdphDMFrjIB+pdXWK8j/t4Ox0Vy4IKAd0cdPk3NDmSuS/xPr
         IhSgVOGr188/v+wcrtnOIWJ/48nFb1hnIvLfTaruklUNq5QkrQzzmpRWTqzXBBQKnLaQ
         yJJgkUCSQcmlIgPf469+EuEomKEP9NdlrPEhPAwLv9lPJYj3QLBP0Ku10xrEkh0DKZzJ
         xR4egh9T5CpyRlKyKuR9sl9BTUsiypc6UOtS5irHHnz8iD+1rnmkj9+Uc5oT8t69gedO
         LSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pqLXNc7RAugZUpob9cm6wuqqrL/nJ70ZfGAMn/EOoRU=;
        b=5epc/skrkjWiM36cklAZP4fne997kNf3cUO82AAGKofkYpKIvd2OQCCFjamkVy2rJj
         PBKqVXU3gvOlX/tH96RyUffh/8Q3cTkbDCTIqQpnL3YoR0oEQoUhiD/w7MAUE9p9j/fh
         CjPURedRJ5Taf5Au1zb/zEy91CgvwEUOrRzSy/y4XFkb8RRIvgHlmdLhIj+0Fomy207S
         Sr5E2WhcPO1AH3KrehA6fxg+mfKdgRGSfyKxV9E7IRxmK2K8ah4ynt2wLvQK5LYtFfsx
         2jJdpt8dQHtDX5T3Tbgd0JWXf0hXPUJSi8Pj3/nmI5g4PbKOTOcJcr/K/dssircT7V8A
         RyBQ==
X-Gm-Message-State: AFqh2kpxav2dFi+mWLVmJVxblL/G8PHbW9nWVyjAPszWnabb53neg0yt
	w1K1imYT8U1mUB9zFwf5P2c=
X-Google-Smtp-Source: AMrXdXtMfWw/+HTr5Jegwc181mbmydBXmrWNAXj7eP79GT4Gn2OPcw2S2rWA3O8Do7z2BdGFUOm48Q==
X-Received: by 2002:a05:6000:5c9:b0:2b0:bc05:b463 with SMTP id bh9-20020a05600005c900b002b0bc05b463mr18143511wrb.7.1673442125180;
        Wed, 11 Jan 2023 05:02:05 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id i5-20020a5d55c5000000b002a6f329203esm13875406wrw.61.2023.01.11.05.02.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:02:04 -0800 (PST)
Date: Wed, 11 Jan 2023 13:02:03 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/290] 5.15.87-rc1 review
Message-ID: <Y76zS/EtFvJhDlQG@debian>
References: <20230110180031.620810905@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>

Hi Greg,

On Tue, Jan 10, 2023 at 07:01:32PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.87 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2607
[2]. https://openqa.qa.codethink.co.uk/tests/2612
[3]. https://openqa.qa.codethink.co.uk/tests/2615

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
