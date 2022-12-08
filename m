Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C977F3
	for <patches@lists.linux.dev>; Thu,  8 Dec 2022 09:38:18 +0000 (UTC)
Received: by mail-wr1-f45.google.com with SMTP id q7so916893wrr.8
        for <patches@lists.linux.dev>; Thu, 08 Dec 2022 01:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VmylA4p6JIXEdV9jKTt9EugkkSk/Nd5xRV/APqKB6+8=;
        b=I317LVxJl1AebamM5xxtwNP8J74f11NmqL0K5P7Kh7v5poKbYendla8reZ6IZLEo1b
         csWcWwzVEhLaIKP0ERHUZxYFrMMw1NfTCeZOFTBEHQwZAni05tRpLw4nWdy0NuVio9lq
         /k6Be3DAEkC0m1U/AmpcLbRI7+HITe4MiCBGxQc2CBHaFjVrUvJA6hN6iN3JyktOQM93
         11CiPK+HprcnO+7Ky3BmrW/IizKU7NiBW6893iTEKW73LCVYcTBzh7tSVdNckV2XkxGY
         5ERzTamBMHYzAbhpwFqzt4C/tZatx3K0wbikqQGHcwFtoFL/iGaMeHvFH0KT0t9892hY
         s6Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VmylA4p6JIXEdV9jKTt9EugkkSk/Nd5xRV/APqKB6+8=;
        b=4d0cRLBPSDXhPwGA0keSH4K/AT63goWN1oni9nZEot2M6JUvb+Tpnlk/Z1co47SMUc
         6u8xU0IBd4dU2coRqD68eiNTRsX6I02TIuRD+9bAV4E7lFABgvpyCnmOYRf2e+Wua8LJ
         WE201/Rsv1urqrmCbz9YHAiG1tTMuBpPITJr5+Nr2X2rBv24Z1hT1r/pTAJyeNFU1tn9
         ado8tSD9Ovh1EClUZznJpr9YpCaqkZZbLgHQazDyidSCF+ogwr5nmCEBmKTF5RTmyvgJ
         0kHkLKGPQMXOtXOjgMhxM9AyI+5fSsohCpExJr6C6UHStp6WHNqwFvk89ld+7ReOmuEv
         R60g==
X-Gm-Message-State: ANoB5pm+TwfksAftLhDeyk5142rzfSg90MrXZOv98e291PY+3maFXQtd
	P4SOMnsr/k4hRvtXYs5oNZk=
X-Google-Smtp-Source: AA0mqf6s3vhO2x3ul3AAFBHxC7005Nl+5wqr8KZt+OdhO7g2RegrcqygugLliC9dvXmAcdMs1XFk0A==
X-Received: by 2002:a5d:4086:0:b0:242:509a:ad42 with SMTP id o6-20020a5d4086000000b00242509aad42mr1096900wrp.36.1670492296692;
        Thu, 08 Dec 2022 01:38:16 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id d5-20020a5d6445000000b002368f6b56desm25837594wrw.18.2022.12.08.01.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 01:38:16 -0800 (PST)
Date: Thu, 8 Dec 2022 09:38:14 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
Message-ID: <Y5Gwho1dzyxMdGyU@debian>
References: <20221206163439.841627689@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>

Hi Greg,

On Tue, Dec 06, 2022 at 05:39:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2320
[2]. https://openqa.qa.codethink.co.uk/tests/2300
[3]. https://openqa.qa.codethink.co.uk/tests/2324

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
