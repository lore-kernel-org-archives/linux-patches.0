Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36CF720297E
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 20:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744232208; cv=none; b=oe4mvQCgxm+vTLevZDY2RW/JWKZf66RWXSoatW9wc30EVdMQ0H+zUIBR4s+T2vadFMLZJX4Z30naOITjW82APlzbGxZE70Zbz414ZQquiyYFEjZ01yzPNduPyDFIJ9M6HFiNadi//Jubud2Ng6vyKRFtzxRiinI9g0GFYp5t6mI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744232208; c=relaxed/simple;
	bh=Ka9I1gJSp0X0T+u/nhdNP1Ql3Cj7Gtryu0r8A3geZog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ekeYaj1vzeMuFBa5nSwc0ncWbnYYozgLf54PtpCakODiRkjenXGNxRF2/+PB8iZxCGGVNOrHeFXZuvfWF7cb68dxJUlAMlv0j+kia6NbpVPZsgU8rSsKlPYq7AOlPmY0cGTWz97LeCQc6oRQOGG6cG/5iug/ExGTeDLt6qApPHc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ah9BOYCn; arc=none smtp.client-ip=209.85.160.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ah9BOYCn"
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-2cc57330163so26550fac.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 13:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744232206; x=1744837006; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=St0u1FQ/HiS/87vKMqrXQMxMgUlG5KFQVCs/QGECYpQ=;
        b=ah9BOYCn7u83DMVc6y0t54r9aVnQvkUe0W0Jbkl2H0X1YzREUINQAiArBQORZt5UgV
         C8+6IMjYJwpXI3wxQgVKvvHFIG2u3xCFeAOXcfz78pYP+DtSxTeaOQZ6goYFp9crZ1nh
         9Z8qbBT2EntRXZyyMFh0DqH/RHM9oxSVVhKgxgIl0Al/LWUhJIY7qamvhG2wHdy6qtxQ
         CxqoJcU2dwWQTfqyFyo25xW50KqFWlMJIsOTp9C8sBJJIdKk/GH5bPmhCmq1LgZNLoUg
         capXKlvxUc3TRFqe/XQhlfFGfVDXzQaFiS8zkFyrq2ktbYPuD1rEBxdXI7KPSK0OOIHO
         VIHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744232206; x=1744837006;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=St0u1FQ/HiS/87vKMqrXQMxMgUlG5KFQVCs/QGECYpQ=;
        b=mJhW2iL+j9ImO9cwFL2dSTrK0AW32LLvpT2WpcGIak+kNMgNF+6jZAl1py+cmh/ikr
         Ja+1lHZQnI2fJ8A12WZYUZdFVZWsserBKKXdfg0R1SwjsdVeWPnA/UWwzXtCDFbQjx8w
         LXkb2lTVOc5r/Tzver1xhVfI01pemmnYJZ19oKvMMs4I9oC4A4HeWmzvYlMCx4xXqHyW
         kz/Sfl3OlYJL1eJN8h1sW66WOXliNDGreHjTGRWbi9WA2yND5yZcnC8g104d06A3WDek
         Hez1kRr24vtWIjI/DDsu3XPc2+r4Leya07oXmtQPDQfIJNn/J7iUkyniDBqLhpZ7p9Cv
         mpOQ==
X-Gm-Message-State: AOJu0YygW/6L0misd3Ah1tEQo+3fxC7mlsmjIMCcuhssahySC4RPCOYk
	6VvrpACEICMxgK0md1gL9HdcaneIv1KcZ4s21i7trSo+PpxIVpw0
X-Gm-Gg: ASbGncu0CwnbFm2uQ3Wa1VXtQmDpUFdkFKOyN4RefcGRrSxhN285RDHrn2iYtA9r1s2
	cqAwtQqXA7+19YzywSNIWOA7RR6lWuWdc/l3SnEUMSRzJ+BVGeeUM/h5TAHaVsNCk7lJmOw/3L4
	fPswwou2kl7XXKZv7y7ViwNfK1bzI5iAy4mvUClz/Y9AWIpZGmxO2ErjoJ3fgIDsTur7qDHc6Ab
	8Ver7XzIdWIjx3mgJAeqzykxWuwCWWnsQd+1olu/9pSjfsOt4iRk9LSWLS4sKqaYYHGku7BZx/r
	wyq+upremxAbGBnHWaBfenMe444uDqzdpbtN5kv9itkTYSqBNFjk7Gj0OQH621dxvf20
X-Google-Smtp-Source: AGHT+IHBEJxCYfyQDjJQItYWVDnh7HpluZP7fGhZMr8B63ZTI04kZBjK4HFOrDNUzYo17QWWUq5FBw==
X-Received: by 2002:a05:6871:71cc:b0:2b7:f8d9:d5f7 with SMTP id 586e51a60fabf-2d0b36d04ccmr115185fac.19.1744232206163;
        Wed, 09 Apr 2025 13:56:46 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2d096cd262asm380445fac.35.2025.04.09.13.56.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 13:56:45 -0700 (PDT)
Message-ID: <f170d500-8aad-4816-8bb9-b4433ab905fb@gmail.com>
Date: Wed, 9 Apr 2025 13:56:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/426] 6.12.23-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250409115859.721906906@linuxfoundation.org>
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
In-Reply-To: <20250409115859.721906906@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 05:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.23 release.
> There are 426 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.23-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
