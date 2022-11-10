Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D15186E
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 10:50:54 +0000 (UTC)
Received: by mail-wr1-f42.google.com with SMTP id k8so1688237wrh.1
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 02:50:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EPZ1n8jGtqN7fSofdtx5HaESZFL2zLNxb+y38ml7+qg=;
        b=AzgRerKTxJ5i5yr/x6HptNqdQOnFUq8LAinGAEsUKx7LbdFu+WHM44/s+gjYROE9ZU
         e8sf581AQW60dEJvyq9kOgQQu04dMv6D4baMOpMFcyKiFpSEGo2Une016198GdDxea0d
         dC1oC+uixLPtTqn9BLyKc5aIRd6NiTZLhQelYoNc8smIyWQTOvPcL+asMmjKuUXseSSI
         REVxAeeoDlxtjhYVuc3SvUX3sRK+imEq/kMg8bsCzDaA9KSJtzw1X6FapDwhw3o41LgK
         YpBLEMosRUZprWjeqvWY/W5WhxKLDYgez3tT+PgGuHVGMU0OL4kocSneq4hlsdP14iRf
         onRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EPZ1n8jGtqN7fSofdtx5HaESZFL2zLNxb+y38ml7+qg=;
        b=PsUSxCd80+k+Fz5MblKHoDMzGi80TqRfaLn6rI4AEPzyOtsNKFeWf5fM/mXufeJscr
         YIdZrk3gL9sCLMUkFGUMH/nosM/qv9hjW0KiURAPCLTuZ5CfJUHrxA4TEwfrC/x3m75u
         wfPeoENFZhOW+GvckOBXlnDCrhRcHRQGmb0AR6CKiOkL6mUbQzOdzBz3MAqCaSrOTVVM
         8LSRQW5/HuH3cOsqU90Hmlh9I+0FZJXxHvM3aDkaaU2VlnDcMM1XdGaXI5xdvir1I+E4
         BD/GRYc4j+AvJ6uDiogYZYQoz2fZIb2J2XgnuvZ+4pu/Rl2w+7vG2jEJZPYmAbUCbxQr
         9KFA==
X-Gm-Message-State: ACrzQf127GqZ2jeg9HbFw62JM+jfR1jwsN2GvEYSTfi/16TdNDEByDDt
	yuAjmxIelfZ1h13uySLvWJE=
X-Google-Smtp-Source: AMsMyM78GqrPDUIMyGcHP56jkGP/O8l8M/tvgVpjiSsFKyKK9Yl8JXCzY/MNfIedbX7n0QLHsbPa5w==
X-Received: by 2002:adf:d1e6:0:b0:236:5ead:eac0 with SMTP id g6-20020adfd1e6000000b002365eadeac0mr40985279wrd.629.1668077453060;
        Thu, 10 Nov 2022 02:50:53 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id q189-20020a1c43c6000000b003cf483ee8e0sm4835398wma.24.2022.11.10.02.50.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:50:52 -0800 (PST)
Date: Thu, 10 Nov 2022 10:50:51 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Message-ID: <Y2zXi9WZsbpNntJv@debian>
References: <20221109082223.141145957@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>

Hi Greg,

On Wed, Nov 09, 2022 at 09:26:53AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2127
[2]. https://openqa.qa.codethink.co.uk/tests/2133


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
