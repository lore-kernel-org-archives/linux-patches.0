Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3445E1F582E
	for <patches@lists.linux.dev>; Thu,  8 May 2025 19:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746733885; cv=none; b=GwQRUvKzcF6Vea72yOuDRdrpgsdncfZxTMLanuGqFUSy4fnyJ2uAPpp1NrKK5cQJUT7PpyEan7pMlIlEeYXIcAzxsLALH3TImNGExpsaebaL8vr+jx+lcJTGMUobKtm7NTKdJ+tJ0udaCIBu3goRqZDM+/D71fVO4cqwfZMlc/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746733885; c=relaxed/simple;
	bh=NxSLgtwGa5Pvm3sSaGJSWkuVJbuhdtpWSuSUnu/IKFo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PeAuf8KPgP6D720HEbivt7spXe2s47ScLX2WyiwdKGWhTTMco7FyoVvTExg010DLnZgroezWal4l6id24VJPZWNcwc1DEqJHrWJfX8RG5ggS/Y0cBBaV1VQGTnCUh7U5lwuFy4LKQAIFMwORofFs/JOfoyihJ0BfINahnrFbUTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=icMQsb23; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="icMQsb23"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-736e52948ebso1718006b3a.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 12:51:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746733883; x=1747338683; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BxFtwmyoa5Fo1/6tSGbyqsFnT+GrzfrM2vUs8B7e09U=;
        b=icMQsb23qYwgikpLoUnoG+vxBxCLQuZbQcTPGF2UqK9EkvTt90d5MW7hFKBNf+k5f9
         c7mabv1H63h4FnETIlr074LaAJuOeACQ+71m8w9JK0nKomgsr6uZJuzgZtaMusdCtdMk
         11PFhC337zjuvAgfGw9rJlfeSod5DLKtodKrhRrKhDxK5mTyRUiSRCb2XvlU0k96YXrX
         wSezpqidAhGtJcm8LD8IRtOGOKPlhzaASmi6eJrSEIviUgX5hKoUMHyn8bYdfJyHL5AA
         ET3I86Nd4/tXoARZoEUp6Zwb2wSHHVNUvJAwhHga/7SiYugz4akZ06q170Q8TmBtj/Cy
         ABNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746733883; x=1747338683;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BxFtwmyoa5Fo1/6tSGbyqsFnT+GrzfrM2vUs8B7e09U=;
        b=ve6AVxPBpkf5upE8RzjMnvgdUuoqkJuSe5oT2jEjPQksbtWJq5mTRnSkLChuI3Awio
         DYyuyvb7+M2WE/QM5LWElnquAKqnNesMMHZCTIJ5HWAFmG7E8KN/IgnOxTmvrdKCxiH+
         9AIoxunrNz4+Ibgs9yecqcu+lgoxiX0ztzmhsX0eidjf6X3pd0D7653+qugTtjkTQ8Q6
         ibljxzORT1QSNsELVo4kYW78FFd43p7Q8GJW7Q95oWB14dgSLsMlB8rg30Hv4DWBKMWe
         hAsJ1G9bOSppppbZkgaR99z27x7z8Xhb50n4jIBrIyMeQCJFWWk+I6QZOCOZxtEQMRZ6
         9q/g==
X-Gm-Message-State: AOJu0YwwVI9rZTsy5oQp7XDceidnXZh4wS2+gld6fCYJcA1Lo/LJgzyI
	ETmZd+vOpFKys8CAPQZICgFQEaxevhsZvB12wu5KJ6Hp33smSegs
X-Gm-Gg: ASbGncvH5kgJNhjsO7GFs9nFVgR3ZnSGpSw/znwJyHBBNe5TxiXm6HJLgKmGRw/0Z6G
	IoUI9v4NIMBm1QetQxEOgxtl4kyN9F80lnfDzaajZCmB/trRAQH5M85VVR6uso3KmkCsXAdngvZ
	LZRV73TBGbgn6eLQiT2AHJn680W5dgbXs1+x83Ol5vSep0Xb9FiRbUPTVI4RmKMY6AvUKFQeNE/
	IolV199STDJu4Tp28/7OvH2As75maVhKCHsGs5EPBARg6RSApPrKu/4ouVQO7HyuY7NP4y/oC0w
	5JuEg1Eey4yyg6opgYYcbhdpBizgEYIzzACL0J9NkiGurJCnkX82hX+Xixqj+IFGdLSqFuRuZ3c
	TVAcs
X-Google-Smtp-Source: AGHT+IGMfZ8xzshY932iVGkJXt00AIUnjSibA64iPqAaIAFBbci7gB43Nlq621rK0qJj+ODf6GJ3ww==
X-Received: by 2002:a05:6a00:f0b:b0:737:6fdf:bb69 with SMTP id d2e1a72fcca58-7423be92b53mr753548b3a.13.1746733883325;
        Thu, 08 May 2025 12:51:23 -0700 (PDT)
Received: from [192.168.1.177] (46.37.67.37.rev.sfr.net. [37.67.37.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7423773c796sm430081b3a.69.2025.05.08.12.51.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 12:51:22 -0700 (PDT)
Message-ID: <7098bb22-76d2-4097-918c-7120a4998b92@gmail.com>
Date: Thu, 8 May 2025 21:51:18 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250508112559.173535641@linuxfoundation.org>
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
In-Reply-To: <20250508112559.173535641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/8/2025 1:30 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 May 2025 11:25:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

