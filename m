Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412E2F9E8
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 17:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751995206; cv=none; b=bwDAJTwxaBYb54bHzIbx7nRr81zhPKV477UhXztLFNXe0S9ovOSVUHSE8iQIYiIv/zpyBUcsSQ4mZqauIQ9NtI+y/dH7liFqqIT4pBLRFRdXQpgRCfFpioe/bzIChJakMTgFrS1S31vgttE33vY2RVRjMGgPCdkjSWhDeN01N/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751995206; c=relaxed/simple;
	bh=5HKDLUwL/LdlMoeCZ0mvFi6Ak2fk9HX39Njg+XBJbDY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i7gOwTsY+y0DnoCcrfBmfb0TvbzS0/W1UMO+FwG2y4vEHGmj70VGAyM3mLsgFfwj7rQqNrpWQo2faz72/Cv82fv4R+Ww05SGhTAHXM6ReI/sbHtdBFWbE2l3zCoiYM919x8EU7AdJcwKUvcEISoFYEKs8J7llGpV/adop0TXzAs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wsac1L9W; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wsac1L9W"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-7fd581c2bf4so4117808a12.3
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 10:20:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751995204; x=1752600004; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=9ONPi5RfC9AjSuKPoYYov/Aga4AW9k6qwLcUOFYQQdA=;
        b=Wsac1L9Wh5CjQcswLb99ntY/uxGHTI487hgrZod9iczWt9/jAk5ZUcHURxJX2Wywag
         xpBDb3XTeGKHy08/Ip/mnIFHwCkgV1jTk/K8F+FbbPGPoAx9QG8HP6fyc1Lms+IiBvJa
         r39ob4Be8R5lqgDBSm+a3mHO/UGbYOS5Nlq0GQjTq/9zYeZ6IjvrgRzdFhWaobV9F1EO
         VzFYoYdadL1kGr2EN6cEusCcchfaZv2sCyR68d9xzyXRF3M11dN+IrYfI+uAyde2V6kX
         z8ir1IVvCLc7lDpsXXE8aLyIgpFOWROnh5Vs1+k9XqyiNn6635tPNBINVnVtSRT7Jm44
         uUYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751995204; x=1752600004;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ONPi5RfC9AjSuKPoYYov/Aga4AW9k6qwLcUOFYQQdA=;
        b=M4noEO7s5bXzapHZq2Eavoss6UH35HiC4+9zshn2dpLRVmnaMkZK/BWFq4BiXi4imk
         ICWkN8ARacFihYVgmdNwcUL+eoQADc7ihwLj1IW1LIWi3JsIFLokyVR9D8S3wSpEUBFi
         iDV2qvV1eCnkHEwp9z0+7ij/MJf2YmNDszn6rpliDc2whWBTeJTAlnYu2A6bPStGf566
         QkfF5uY76oAfteGaeOcr8NSIpwkypUv5MCjeNgREkGKcOgeILH4KTiXWWHrlVgR8egOo
         omhK1mc67FoYVC7GybXLCXkYS/OmqGSkjUk32CHNfwQxlKX607kp0U9FVXHVs8wlFOUK
         bztw==
X-Gm-Message-State: AOJu0Yz1/XZPv/LdhvNoapVZe4X5N6BZxsIs1rQl1BGDYba71IB8/M8c
	UvAcZZ9l1BeDkGSV56TQDdLIWkKFpAUuPy9XNsTkwWnW5vGQq9SKdVZi
X-Gm-Gg: ASbGnctSbXy7CsNuL0YnSDUHDXc7cP5KAArHullUtiGClRre2nj/DzKpK84dlh6K00t
	LpuCPcsarQYM5vmOIi9a9yQ9bVWIRQ4IkW0/RUNtbCi3nsM5Gg5O+qEbV7jZgJrKNKqKWLqYwzN
	xGMR8lEZH5ANSh3jUTBWehzgc3nOh/HV5G2lBWafF1j7FNBVd0VN+QkovGX+roGycQs3HFzLOn9
	eb12X32k3BL1/PE/OmXjyuVMc353V/Wcm5e1qf2bzAn6EViS4Ggrp+lrfc8Pzi28ZmOomEIytZB
	n9gVa4j4VOlrG9/HsKuAU6rUDio7FjyINpygUArYs6vIo3s04pEApw4/u1sJggf2PQBqMEmV3qe
	M/D3IsyWIgGCfgDZRrnDQ+oNK
X-Google-Smtp-Source: AGHT+IF+yI8LROtj0p5DPStD22YvfLpioPplA4G0IH6B6dY/haS9t3i+nGdLM/G1uO1e+QYM/i4g9A==
X-Received: by 2002:a05:6a20:c6c1:b0:21f:563e:b7e8 with SMTP id adf61e73a8af0-22608fb3017mr28149530637.4.1751995204221;
        Tue, 08 Jul 2025 10:20:04 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74ce42a17bcsm12417556b3a.130.2025.07.08.10.20.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Jul 2025 10:20:03 -0700 (PDT)
Message-ID: <2438aa80-091d-4668-90e0-fb75f3e0b699@gmail.com>
Date: Tue, 8 Jul 2025 10:20:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/160] 5.15.187-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Kim Phillips <kim.phillips@amd.com>, "Borislav Petkov (AMD)" <bp@alien8.de>,
 Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708162231.503362020@linuxfoundation.org>
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
In-Reply-To: <20250708162231.503362020@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/8/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.187 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.187-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

The ARM 32-bit kernel fails to build with:

/local/users/fainelli/buildroot/output/arm/host/bin/arm-linux-ld: 
drivers/base/cpu.o: in function `.LANCHOR2':
cpu.c:(.data+0xbc): undefined reference to `cpu_show_tsa'
host-make[2]: *** [Makefile:1246: vmlinux] Error 1

This is caused by:

commit 5799df885785024821d09c334612c00992aa4c4b
Author: Borislav Petkov (AMD) <bp@alien8.de>
Date:   Wed Sep 11 10:53:08 2024 +0200

     x86/bugs: Add a Transient Scheduler Attacks mitigation

     Commit d8010d4ba43e9f790925375a7de100604a5e2dba upstream.

     Add the required features detection glue to bugs.c et all in order to
     support the TSA mitigation.

     Co-developed-by: Kim Phillips <kim.phillips@amd.com>
     Signed-off-by: Kim Phillips <kim.phillips@amd.com>
     Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
     Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

I don't see this in Linus' tree but it's not clear yet why that is not 
happening there.
-- 
Florian
