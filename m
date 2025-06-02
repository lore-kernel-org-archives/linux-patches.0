Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF4718FDD5
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 16:49:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748882952; cv=none; b=GCSpoGEItMD6QmuQjiLlyG2I2n2Hz0o5I7peFK77IgckdUZyPkO8upsEThz5kDQ+5oCBHHlgf+BVotvB0LYrkrpxl06acwazM1LMnGQ4Kq50O/0cpoXVutLCArhNg678LNA6h5gfUcRqbrPaAhp3tcV7629hwvWTsrdbs01DHNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748882952; c=relaxed/simple;
	bh=c0gEGMhBwwH3EsG3J6mtSe3TBHd4NML2arG+mH1i/Eo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PA6eyPaFH5MtbaLlR9HsVBzXkLBTKqlFcf56zinjumjFcm36fw+zR9HHUdY46LD1H+8CgbUrqJMhurWiyZwKuaA7x3c78u+xVVre1B5GSpVLIjMf6F4/+J/zpWr3xHQ+nGVgO42WmgA8KwJ7RdTee+bnJJivFlqPpJaMR+wNPOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZZXqCxeP; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZZXqCxeP"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-234ade5a819so41175805ad.1
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 09:49:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748882950; x=1749487750; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=HknikpJA2FcmTw342+lb8lkp3yYgT8HLedmbOD4V3nk=;
        b=ZZXqCxeP2t72sklZm3ms85hzYKxPhofquEorf6bQ7GEojBEk4p70t/IcFSFT7MjHGw
         14lAtYYuOcjFXhbSCF3lZyjg9/xZTGS6Jf1gIXfT5eBP2M8S65qAxsPRwU3vJ7drdeGs
         wSai7Apt+jD3DA/ZBxvrdw2em4Q0KBUulBtcdPv0MQodafkVGozCpNKSvyOkyvp7kNJ+
         0pNLk+uvhGOBfaVrGL/Z2x4qmwdzq6WbZJRSHi1se1L1jJrA6vGHQugc8avpjTIdt19D
         IoKcAyjs+/hKwxSxGxRWOCiZvl2Xsi+UMZ9Z//KF85pzgkyuiOYaKXsdN2xhNDvomDsP
         csXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748882950; x=1749487750;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HknikpJA2FcmTw342+lb8lkp3yYgT8HLedmbOD4V3nk=;
        b=WNUldPCIX/I1xfOc8WMBf7IhNz+n02nDaMNDivp+h3/0HgizYUmr42FetrdZG6oSND
         rV+K9ZSphuYIYqntF5pBaISCSZ64ezHhCQPWSgTyOc6Ev+AHiewdzRh3MkZdQnYX5MGd
         YA3AtbC8fDiAI2UjBJDDdPwEvKxXqaDuwaPal9caH3K+yefu++oLf1YS9SB/1/HUXNi8
         4eeVmoPVFH1yM9w+SpWQChdYMgvdHebVc7BlLdgJmRKcQpWJfWCG8eVV1nbCEXyOLrb6
         /ZXpm7FIoNGXAh/O4PAYIhBSIC80uBHK/g5HZjgLy9p7LpTbCITBITo313Ti9BG16Zi2
         UIZQ==
X-Gm-Message-State: AOJu0Yw0HI2QRXZdH2hStvql7J9CkVFNwM1dYx6VR4QBXP7FdjhunG1Z
	ZZG+JcClbh6jqBVbYijL1MxaptUoGtecysMna8yRy2sBGtsNQEm+QuAo
X-Gm-Gg: ASbGnctx9/lzS54ca7BWlxAxy8sJzTlqB1laPRFenrkUXVV2zYdAn3oGmfFWCbfu0+b
	ffFTaDkYAFT1j1hVCOk6hKTxI/FNkcFCmhGFRGE880zfowJ7rSQbSUtI4KKHQ1JKUgf5wQiBj7g
	zyYvnYQv1byrfWp8VB8hXbAIwRK783LVM4FMcVzdCJq4Kq3O7tZghsGGPJRqlGrMZG1/e8WZNB6
	fDTA29saZPajKoP2UsClXyUdk6ddyiFAEXGt+2JGI1xrKyyWJPh2LyWKtohOQYBHrhJE+mlsMzj
	YSiLF9e3M4nV0ZdbcPZV7n3KOZUlhAE+RS+2KxZQwf2vlgzLPisnZ4sBC6lAWKv2IJaqot4Bke1
	aUEc=
X-Google-Smtp-Source: AGHT+IHI1CdVRfDD9bf+nXVVrQOXSVtm+Yt+Yys2GsvFnPNTkgMLFR5+P/Cn+V3/3WtyF1CZOw0dEg==
X-Received: by 2002:a17:902:dac5:b0:234:a139:11e7 with SMTP id d9443c01a7336-2355f76c20amr137080885ad.35.1748882950526;
        Mon, 02 Jun 2025 09:49:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b2eceb96fe8sm5767803a12.59.2025.06.02.09.49.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 09:49:09 -0700 (PDT)
Message-ID: <4c608184-5a64-4814-a70a-d2395662d437@gmail.com>
Date: Mon, 2 Jun 2025 09:49:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134307.195171844@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 xsDiBEjPuBIRBACW9MxSJU9fvEOCTnRNqG/13rAGsj+vJqontvoDSNxRgmafP8d3nesnqPyR
 xGlkaOSDuu09rxuW+69Y2f1TzjFuGpBk4ysWOR85O2Nx8AJ6fYGCoeTbovrNlGT1M9obSFGQ
 X3IzRnWoqlfudjTO5TKoqkbOgpYqIo5n1QbEjCCwCwCg3DOH/4ug2AUUlcIT9/l3pGvoRJ0E
 AICDzi3l7pmC5IWn2n1mvP5247urtHFs/uusE827DDj3K8Upn2vYiOFMBhGsxAk6YKV6IP0d
 ZdWX6fqkJJlu9cSDvWtO1hXeHIfQIE/xcqvlRH783KrihLcsmnBqOiS6rJDO2x1eAgC8meAX
 SAgsrBhcgGl2Rl5gh/jkeA5ykwbxA/9u1eEuL70Qzt5APJmqVXR+kWvrqdBVPoUNy/tQ8mYc
 nzJJ63ng3tHhnwHXZOu8hL4nqwlYHRa9eeglXYhBqja4ZvIvCEqSmEukfivk+DlIgVoOAJbh
 qIWgvr3SIEuR6ayY3f5j0f2ejUMYlYYnKdiHXFlF9uXm1ELrb0YX4GMHz80nRmxvcmlhbiBG
 YWluZWxsaSA8Zi5mYWluZWxsaUBnbWFpbC5jb20+wmYEExECACYCGyMGCwkIBwMCBBUCCAME
 FgIDAQIeAQIXgAUCZ7gLLgUJMbXO7gAKCRBhV5kVtWN2DlsbAJ9zUK0VNvlLPOclJV3YM5HQ
 LkaemACgkF/tnkq2cL6CVpOk3NexhMLw2xzOw00ESM+4EhAQAL/o09boR9D3Vk1Tt7+gpYr3
 WQ6hgYVON905q2ndEoA2J0dQxJNRw3snabHDDzQBAcqOvdi7YidfBVdKi0wxHhSuRBfuOppu
 pdXkb7zxuPQuSveCLqqZWRQ+Cc2QgF7SBqgznbe6Ngout5qXY5Dcagk9LqFNGhJQzUGHAsIs
 hap1f0B1PoUyUNeEInV98D8Xd/edM3mhO9nRpUXRK9Bvt4iEZUXGuVtZLT52nK6Wv2EZ1TiT
 OiqZlf1P+vxYLBx9eKmabPdm3yjalhY8yr1S1vL0gSA/C6W1o/TowdieF1rWN/MYHlkpyj9c
 Rpc281gAO0AP3V1G00YzBEdYyi0gaJbCEQnq8Vz1vDXFxHzyhgGz7umBsVKmYwZgA8DrrB0M
 oaP35wuGR3RJcaG30AnJpEDkBYHznI2apxdcuTPOHZyEilIRrBGzDwGtAhldzlBoBwE3Z3MY
 31TOpACu1ZpNOMysZ6xiE35pWkwc0KYm4hJA5GFfmWSN6DniimW3pmdDIiw4Ifcx8b3mFrRO
 BbDIW13E51j9RjbO/nAaK9ndZ5LRO1B/8Fwat7bLzmsCiEXOJY7NNpIEpkoNoEUfCcZwmLrU
 +eOTPzaF6drw6ayewEi5yzPg3TAT6FV3oBsNg3xlwU0gPK3v6gYPX5w9+ovPZ1/qqNfOrbsE
 FRuiSVsZQ5s3AAMFD/9XjlnnVDh9GX/r/6hjmr4U9tEsM+VQXaVXqZuHKaSmojOLUCP/YVQo
 7IiYaNssCS4FCPe4yrL4FJJfJAsbeyDykMN7wAnBcOkbZ9BPJPNCbqU6dowLOiy8AuTYQ48m
 vIyQ4Ijnb6GTrtxIUDQeOBNuQC/gyyx3nbL/lVlHbxr4tb6YkhkO6shjXhQh7nQb33FjGO4P
 WU11Nr9i/qoV8QCo12MQEo244RRA6VMud06y/E449rWZFSTwGqb0FS0seTcYNvxt8PB2izX+
 HZA8SL54j479ubxhfuoTu5nXdtFYFj5Lj5x34LKPx7MpgAmj0H7SDhpFWF2FzcC1bjiW9mjW
 HaKaX23Awt97AqQZXegbfkJwX2Y53ufq8Np3e1542lh3/mpiGSilCsaTahEGrHK+lIusl6mz
 Joil+u3k01ofvJMK0ZdzGUZ/aPMZ16LofjFA+MNxWrZFrkYmiGdv+LG45zSlZyIvzSiG2lKy
 kuVag+IijCIom78P9jRtB1q1Q5lwZp2TLAJlz92DmFwBg1hyFzwDADjZ2nrDxKUiybXIgZp9
 aU2d++ptEGCVJOfEW4qpWCCLPbOT7XBr+g/4H3qWbs3j/cDDq7LuVYIe+wchy/iXEJaQVeTC
 y5arMQorqTFWlEOgRA8OP47L9knl9i4xuR0euV6DChDrguup2aJVU8JPBBgRAgAPAhsMBQJn
 uAtCBQkxtc7uAAoJEGFXmRW1Y3YOJHUAoLuIJDcJtl7ZksBQa+n2T7T5zXoZAJ9EnFa2JZh7
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 06:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.238 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

Similar build warning as reported for 5.4, due to the same commit:

commit b47e6abc7dc5772ecb45383d9956f9fcb7fdf33c
Author: Jeongjun Park <aha310510@gmail.com>
Date:   Tue Apr 22 20:30:25 2025 +0900

     tracing: Fix oob write in trace_seq_to_buffer()

     commit f5178c41bb43444a6008150fe6094497135d07cb upstream.

In file included from ./include/linux/kernel.h:15,
                  from ./include/asm-generic/bug.h:20,
                  from ./arch/arm/include/asm/bug.h:60,
                  from ./include/linux/bug.h:5,
                  from ./include/linux/mmdebug.h:5,
                  from ./include/linux/mm.h:9,
                  from ./include/linux/ring_buffer.h:5,
                  from kernel/trace/trace.c:15:
kernel/trace/trace.c: In function 'tracing_splice_read_pipe':
./include/linux/minmax.h:20:35: warning: comparison of distinct pointer 
types lacks a cast
    20 |         (!!(sizeof((typeof(x) *)1 == (typeof(y) *)1)))
       |                                   ^~
./include/linux/minmax.h:26:18: note: in expansion of macro '__typecheck'
    26 |                 (__typecheck(x, y) && __no_side_effects(x, y))
       |                  ^~~~~~~~~~~
./include/linux/minmax.h:36:31: note: in expansion of macro '__safe_cmp'
    36 |         __builtin_choose_expr(__safe_cmp(x, y), \
       |                               ^~~~~~~~~~
./include/linux/minmax.h:45:25: note: in expansion of macro '__careful_cmp'
    45 | #define min(x, y)       __careful_cmp(x, y, <)
       |                         ^~~~~~~~~~~~~
kernel/trace/trace.c:6688:43: note: in expansion of macro 'min'
  6688 | 
min((size_t)trace_seq_used(&iter->seq),
       |                                           ^~~

-- 
Florian
