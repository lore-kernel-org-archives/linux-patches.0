Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC7B23D4
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 11:16:44 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id r9-20020a1c4409000000b003d02dd48c45so3356233wma.0
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 03:16:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=hhE3haZb45CNFULsHmxwy6vNCZW7lpy6GOVrdTfivPU=;
        b=a9W2owUCiWIJEl1zC8SQpHH6xMsKDPL6Zhomc9tVZyDc1RJPSLlEnSCj5e9zHhgxl+
         64x8vTJM9xRuDe9jbUmdmhR+1XeUwkJZMTgRt3PwC5lIv1AZqV0h7iGR9rzmstycsIXa
         B3aZZhkeK0K4qANLbOIoibhUS/WoOQLdXAv0nDHgkqrpstdpy9pkcG3zUj4NSQ41y/S2
         Y1HJ/+0Y1UJfp0wxxYcS9FQBxcIWu+1WdEDiDU3w9+AKZvUAqFrUZqaZjHqolTsrrlo2
         HSu0Lc54FOGorUS2iIpVEJbppZBeHxgZQKxqyjAuH/WbFwPdNpIDC1cnsNwIi4fWXXwY
         vhww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hhE3haZb45CNFULsHmxwy6vNCZW7lpy6GOVrdTfivPU=;
        b=GJ1DrwORoG56zxpfxeeOBFvW9WZuzTvq7AUSSRUS2Cg3FkJaNxGFE0FgV5l3g+jieP
         962xyE0rT9z0dEknJW5COXceXzKEyOQE66kKJwdFrC1+zFVmo/GBgF3uUkDE3JLNb+hL
         Eg9sL2AHWD+Vyy1vAs+yGgb0ul5uQmgJFYydkjLAUSmR2J2JRw/rNIeDmwdu3zFimQ7t
         iEc3X0R3Sn8NTrnUTKkKDQWaVIfzdjpbgH7JSTS3z6zUrke4cwGCIw/94pBwhgDO5fv/
         dfcmHelFaqUNHwpIRGiot1GAoQo7Ypipr376yRrs0EkHnkB1rjcmHgFfD7nILt0RPgdH
         fF5g==
X-Gm-Message-State: ANoB5pkIpABFFLDcwKkecffl8cSfpHjFXVDWBu51MGOpQGuy6319LZ8G
	9h5X8S0wN3cJFnN1iwzcr6z9zJVCVJY=
X-Google-Smtp-Source: AA0mqf4XBviurARzZqb6Yq7Pcs2grnbACeQWURwUcnvS+y6QDCrwTpM00ImOHe4vAL6jd5TymyL0pg==
X-Received: by 2002:a05:600c:4894:b0:3b4:91f1:da83 with SMTP id j20-20020a05600c489400b003b491f1da83mr12754098wmp.127.1669288603060;
        Thu, 24 Nov 2022 03:16:43 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id w16-20020a5d5450000000b00241db7deb57sm1057267wrv.114.2022.11.24.03.16.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Nov 2022 03:16:42 -0800 (PST)
Date: Thu, 24 Nov 2022 11:16:40 +0000
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
	rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/314] 6.0.10-rc1 review
Message-ID: <Y39SmCRcY7EUhkhA@debian>
References: <20221123084625.457073469@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>

Hi Greg,

On Wed, Nov 23, 2022 at 09:47:25AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.10 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 52 configs -> 1 failure
arm: 100 configs -> 2 failures
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> 1 failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
1. As reported by others arm mips and powerpc allmodconfig fails with:
drivers/rtc/rtc-cmos.c:1299:13: error: 'rtc_wake_setup' defined but not used [-Werror=unused-function]
 1299 | static void rtc_wake_setup(struct device *dev)
      |             ^~~~~~~~~~~~~~


2. arm imxrt_defconfig fails with:

In file included from ./include/linux/bpf-cgroup.h:5,
                 from security/device_cgroup.c:8:
./include/linux/bpf.h:2310:20: error: static declaration of 'bpf_prog_inc_misses_counter' follows non-static declaration
 2310 | static inline void bpf_prog_inc_misses_counter(struct bpf_prog *prog)
      |                    ^~~~~~~~~~~~~~~~~~~~~~~~~~~
./include/linux/bpf.h:1970:14: note: previous declaration of 'bpf_prog_inc_misses_counter' with type 'void(struct bpf_prog *)'
 1970 | void notrace bpf_prog_inc_misses_counter(struct bpf_prog *prog);
      |              ^~~~~~~~~~~~~~~~~~~~~~~~~~~

Caused by a1ba348f5325 ("bpf: Prevent bpf program recursion for raw tracepoint probes").

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/2210
[2]. https://openqa.qa.codethink.co.uk/tests/2214
[3]. https://openqa.qa.codethink.co.uk/tests/2216

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
