Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA3B1F0E36
	for <patches@lists.linux.dev>; Fri, 21 Feb 2025 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740163107; cv=none; b=EgD7NXIrFS7f4YQACYG4c2hbGCw1Sb7MpV1cEgTcMnRUcHt8Ui96DKNXMipzQ7Do7brj0oU7coLR1AbaCGF5Jlv72Tgur5TNBEp37HFQ4+4vBYuLLBcHyZ77ju1YstKp3gHJfX6jkT1rDSlwXd8Y0UlHqqOt4+9EsgD/ba18c8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740163107; c=relaxed/simple;
	bh=Q936AZExE99tb2q+MrHHJwRam8QYuQsfnHAxnBUlB+I=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=iEnupYrYc2wn3EF3c4S9jtu4VoSUcZfm9qAiCBQi7u9VA+duefJQ+c9tnn3ssXgNrFRvJ1a+wg5MlgUeCQ9QAMl0YwJJZmPs3483MPrEXcykwFmyUbW0Omikggo73qIvbPPCNOJ0H2/x2eGWxQ7Iocsf+tq3Xn5SYRO6ATLibx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JkOYeKA2; arc=none smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JkOYeKA2"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-2a01bcd0143so1992750fac.2
        for <patches@lists.linux.dev>; Fri, 21 Feb 2025 10:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1740163104; x=1740767904; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=hsGNbGLYi3imJsJL+9aifpnDeSIfnWypP/Kgm6qb5gU=;
        b=JkOYeKA2/mIqcCiH5cwhenF6KfQGpW3y0q+E9yGUrczelK5FsxyF3jja/Xv07/6AFH
         07l5VLWg7HvyCtfVpD2UggVtb3Y4x+olGYaaQs7RKs+42Z5GuHpv713LtZoT+vJr7bGk
         nQ6vXhKiGgtOMT9tCzaWaUNuixsn7Tf5FWT8sWbFRLFQg43MOevKk/DRV8NiR/Us28o6
         t8dwvXUP5fo9/xA7hWLo0TFOSIChdYJGK0Y0svDQSKIQa2FILIBjll+oqLnJ+N5RgzS5
         In69+nay8jSvMPMJWyRdBnSaiMH0PRtDD/i4uEmaFYHIdkeY8Trwk0AnPDEyoqtXZaI9
         raGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740163104; x=1740767904;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :references:cc:to:subject:from:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hsGNbGLYi3imJsJL+9aifpnDeSIfnWypP/Kgm6qb5gU=;
        b=JJdgcI5OiCmNL8Ku9zBJoN9hOQKZKxkiFeRKZ4StfW4CfZmQam4dDREH3vjIQFz6Ml
         585FIHkV6z2mC0gYljMCWOiBcc2ZzAaobgzmxVAfwlk6zQj9Sgm5C+3TrXivQvvN0Eh4
         pbC8QGWRtfSOHVKqjB05QnPjvJDwqhLdColbqW3PyqLTKSdtkpryvz5+SHPm5U/ex230
         DfFgq2qa0wtjhZ3O7hHkhV6+5ms1Hh4nCwJ4Jesp/1SzZAoztoO5jD7+RRCHxlg7iUGU
         zQI/k7rdTZ7QAIDjsApXnLCx2924XX2rkj3NdVpC1dQjkhIZqkHQZF2ENLU4QJELH1lC
         Et0Q==
X-Gm-Message-State: AOJu0YyTIR9/R41uE53SfE2vwUEYjHgoHYOTGSYl4QCxAexYJVGC4oTG
	5XlCYgZdFIWD2tSQCboD/U3dUqlarsk8VlKGU7ebv4VlI8KK5PcFvepeYQ==
X-Gm-Gg: ASbGncv1RFTFbDJzrWRgawv7OQ719yTt82uP4jzAd862vEOtsmv+1bHysqyklnuS/pX
	+Vi6j1EazMuFL8SrGgJmltxtL364CXx+bbJgPSSgvoCycKD2zxuF4sJMWeoeAYAdZx50MG8z696
	loicIhv4zagPRlcm4GdXPDTZGBwLQtPywkVGbHmZFyS73lW78arxbxWdNQDkBhuYdlRVhNoBwoO
	DVyXcs9ngalu+7F4fQFf40cCXVUp2G6SJovY/oAjiZPqXQOYTLgn1Pe+kUtrmcElQZOF9y52XXG
	ywmJvHrE4Llyem8CQ7qX5pAhRu2LcYn7uZLliXvgBTRdXO7oFUGLxA==
X-Google-Smtp-Source: AGHT+IGHalgkEU3Q8tpgYl9lid1QhnBNk/7/u+5TKgseeEXkfKvsLq1RqZXTz9yUGpUMJZ9We3jGfQ==
X-Received: by 2002:a05:6871:1c9:b0:29e:354e:5fdb with SMTP id 586e51a60fabf-2bd50fb898emr3242983fac.37.1740163104051;
        Fri, 21 Feb 2025 10:38:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2bd68843a69sm141957fac.26.2025.02.21.10.38.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Feb 2025 10:38:21 -0800 (PST)
Message-ID: <259638f6-061f-4259-8534-d5537f47d85b@gmail.com>
Date: Fri, 21 Feb 2025 10:38:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104500.178420129@linuxfoundation.org>
Content-Language: en-US
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
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/20/2025 2:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.4-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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


