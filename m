Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CF1D27FB0E
	for <patches@lists.linux.dev>; Tue, 20 May 2025 18:48:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747766913; cv=none; b=RFr8X7stZKGAfzAxQkPai+/W6NMCG+v6g5+lJ6AnsW98q2XgvB688QJvq9G6kY4+izu2i2WsG6nnt6QsGinz9ZRCqMg3dViziZCYSTxycNoEe9C9K8zS3mUhz+dzkirp5neNIJDVxZTi1penOXShdzyiPzcUq7KxJgxx3oAItxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747766913; c=relaxed/simple;
	bh=eWhmDY+JzhMTlbfmEF/OGgFA8INkcIC+ByVMvWRgrZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ttGWtZZXMH0s7mGQILGdEe1eQsiiJVweYZUxsrBRE7rbhmW6ZZ8iGu2ktbcluOpf1AyfC3FrDC560e+kyus1Vb2ikc+9pal/wffKtYt5aps3MrDfC1gDByGjJsltmKUBWU2JSGrr4Zry7jlK06i3+Uz/FE0HgGiU+MLy1gOvbDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z3QdFXtc; arc=none smtp.client-ip=209.85.215.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z3QdFXtc"
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-879d2e419b9so5185716a12.2
        for <patches@lists.linux.dev>; Tue, 20 May 2025 11:48:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747766910; x=1748371710; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=exMlkAQN+jyrfEO32kiys6EMj6zlpuy/OgwNus9hUYc=;
        b=Z3QdFXtcUvGc4BPeu0p6aB2KbXMuj+zwQM2bHL/3kqEmGMFmhwAAVITMrMo3sz4+0o
         aE1+b1AqLrvtWzOxyIjy/JStfuNdMqImNjYCjODvtR7Mtt21R7NXNacUH+xCqnSrdT9Y
         3DnmoWAd3UlWPuC8HiySYUhneTGtbAd3OesoJ2qUHNRxzbpx0nXPbpt8z9iVdp58TSMl
         OsjTc88eLP0vRb+AGWXoqi5Ts5DjnneK663N7TCknrSWr8km7zkUTkRMxe5VumyEUsPj
         lpVB5hSaPd2snMKhCkDADq3f/MYj5XqfxB4oLWxtJCSUJYNN8LTt//tf1JinAHz8HQO8
         BGxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747766910; x=1748371710;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=exMlkAQN+jyrfEO32kiys6EMj6zlpuy/OgwNus9hUYc=;
        b=s+ufmiI5xJAMxNENJJh8FeZTF3NhqefM/Hp8ZEZnlZgrLhK4dXIL8C/pPtevzeLrOG
         5TtVchMvsD8lXLOeAAHeJ2l59YliCDo23eVd33odgtZdgR+uyYVlpw6jKExQi92uZCnR
         QKWCDXIgACLlArctiMkqYD8g7cfmekUvC+xQ/sRm/Ax+kLPTyuwdq29ZSFzzcQPuu1tN
         IhGiptzZd+Q7ZJxIG2UqYM8Lj9vsyI4ALCbfUA5mvQ4wB8OuTiFvzi0WM+N9WZAYNQ0A
         2jY2qzjjjOq/DLrvl7/eKTu07yZz7F0+qFyhUIpud13vmbgypoCQ2U5SPG+2fMqcABha
         IlbA==
X-Gm-Message-State: AOJu0Yw+ud6txipU6LvM6++mW0m9NjrNPkpXQ6V1pd3NZuF/q59zDzwv
	9ovP43krdXZR2ojV4nIXP8LlLL5lQd7yvPN4p4jYP+1INnBBWsmS7rPC
X-Gm-Gg: ASbGnct4MHbZ32xTPU3jdIn0y7DZ6FxwkYZDhWRyD3LLk2fNTXbD9Kpsfme259PQiWb
	DklbywKYGsVBFI954uec4/Wl7oAK8QGvkUEYJrC3gbXbUUFi5yUbVvuMbKzc5FBIqiO5y08FfZ9
	tXEtcVx3XOjlBhx0pKTYne/e8+RckQ4IJorXRImufUatJkKWx7iAr+ePmLhix7eOLXv6AMuAd5U
	r5sQto4atGDXoh1SrlTtJBeJjmTwBvrrl9/IuCmki/wD72ROeK3mU4rjFhURBBsLt4YWqATCgC8
	YXzftpvHlrvQXuLglwN4Q5U7HZuSBUGiNm42Ikhy3MuHgWyF1i5vrwzNY6YCPiJycT8EFfEhnHM
	B1o29wsLGBqcRIA==
X-Google-Smtp-Source: AGHT+IG6I1PUmZYO94K/10yCwbz28YB+rLraQhTmPlhL1JjGl7LdacLjtbaQ6Q2m2SjKi97glIc1sg==
X-Received: by 2002:a17:90a:c105:b0:305:2d68:8d39 with SMTP id 98e67ed59e1d1-30e7d5221efmr31915083a91.12.1747766910401;
        Tue, 20 May 2025 11:48:30 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30f365e5dc6sm2047020a91.40.2025.05.20.11.48.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 11:48:29 -0700 (PDT)
Message-ID: <419b017b-37f8-4f9b-b914-95ab4d76b334@gmail.com>
Date: Tue, 20 May 2025 11:48:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/143] 6.12.30-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125810.036375422@linuxfoundation.org>
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
In-Reply-To: <20250520125810.036375422@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.30 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.30-rc1.gz
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
