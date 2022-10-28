Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555E612286
	for <patches@lists.linux.dev>; Fri, 28 Oct 2022 19:44:43 +0000 (UTC)
Received: by mail-wr1-f49.google.com with SMTP id bk15so7854539wrb.13
        for <patches@lists.linux.dev>; Fri, 28 Oct 2022 12:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7GMIU8DmmkMh1/JCI17fB9sAKppQWftzASqvslzNmxs=;
        b=TbudKJU0ktV7bQwxoi778vjsYATy/4hGssDvljqaNhGBTy8jhVYKVOsjBjSw+P9ZJ/
         OV2Vf9scBOOIv6qhczVCmdAn5BgIw/yLtJi1lc9lYUogw6vt+wQnO3BrBgDxxoy6lwOz
         8Px1uAUxlPXKbUiou2zX03tbnNrT3IL+0sRsjCaFDZ1//XJd4sTBMMLWrjQqgT7qaNX5
         G6nTZW5ROCmS4xv9VnPV4zfddnNXDiHwGfH7eBdiL+sPwB/UlQ8huzKVwV46GKsRA0I2
         oYpDV+G1Gyv6UwCPB6k/A9X7UDi3m+rA1U0SEH67V8I0NbecJGj+xgu0BEzn9nhacTtj
         tK8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7GMIU8DmmkMh1/JCI17fB9sAKppQWftzASqvslzNmxs=;
        b=MzNTPr3ViLlZlUQjfr0A3mil45SyeeTu1TUsCBDNzO2Akw31rIQyjuXxx5COqOO2Rn
         +21AUf3eTqIkDqwGMRT9rg04sDCeNAM32dl1FRnLENdej6lkwK+FwdtUKCdbt5ZsxiS4
         MsxYh2DhAYiYKPB4GvNChe1O/hCZ6sStffnwQw94FFI/B3ydlORg8Ye+skb71G84TRad
         WbbriqSjTaYzLJwApS5JsvSdJ7V6kaEs+yzF5iSpkF9MLDM33PBj9a9uJUeRv08e4TYo
         m422gyswMGOMlay6Ew/WZVQkOEDICRoOxKuYIUxM00vscnuUsWgvc9ABtYZsUGO1Aa9i
         iaOQ==
X-Gm-Message-State: ACrzQf0ST8b7xHe86JtpwHOJFIwASDf9UYlqrjjOaJd81IJsHlBkipma
	3DVerB7mNmfevyqVMrc0O1w=
X-Google-Smtp-Source: AMsMyM4xwxMtFyBku5K6q8YJA6LuKtqBa45TUwXD8fwrGprU0cjlIRwlKki8EVlJVamMiDM132zGmg==
X-Received: by 2002:adf:df03:0:b0:236:78cb:b6e5 with SMTP id y3-20020adfdf03000000b0023678cbb6e5mr529994wrl.269.1666986281571;
        Fri, 28 Oct 2022 12:44:41 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id bp23-20020a5d5a97000000b00236740c6e6fsm4512361wrb.100.2022.10.28.12.44.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Oct 2022 12:44:41 -0700 (PDT)
Date: Fri, 28 Oct 2022 20:44:39 +0100
From: "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/73] 5.10.152-rc1 review
Message-ID: <Y1wxJ07McQVO8ABM@debian>
References: <20221028120232.344548477@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028120232.344548477@linuxfoundation.org>

Hi Greg,

On Fri, Oct 28, 2022 at 02:02:57PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.152 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Oct 2022 12:02:13 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/2057
[2]. https://openqa.qa.codethink.co.uk/tests/2060


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
