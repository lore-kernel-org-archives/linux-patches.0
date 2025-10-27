Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 605233074AC
	for <patches@lists.linux.dev>; Mon, 27 Oct 2025 21:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761601235; cv=none; b=LVvKY9Oa6f414mvvuXMCRT+m1elvLcq634qW2PbzYMDZtTwNQC1wn4vHk2wqNpbT+8YVjkSP4aCpjUMyyfjnqX9OiSQTHIBAkOmoy2MbzCDRsqwZFMmFizHDVMjoIzOyoluYvpltEDDyFqbpXJ4qluwBXXu8mI5JKfT9FLyR6Wo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761601235; c=relaxed/simple;
	bh=p7tIlPXsYZ5Avel+J+izx/jHKu3N4qM4abUQEluRedc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uda4k+BffMMdNXikmQ2nRTry2NnssuM/JKmpeH5W5aB5vF7r5cwbY0QEjZNdwGTICm2YEUIQtmm6TOIgZgmGAqcJZoVKkP5IKGUdLVoiBzn2y2u0iEkSLP3oU3ndDUuPU7uXCi2rqQTmXCmYv7EHVcH3K9MAStLAegVJLGxyp6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FiOWOGMs; arc=none smtp.client-ip=209.85.160.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FiOWOGMs"
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4e896e91368so59111811cf.0
        for <patches@lists.linux.dev>; Mon, 27 Oct 2025 14:40:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761601232; x=1762206032; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=omu87Ze+GCEablLZ5Y1kVHweKQ9CM76WnBDADZ59AOg=;
        b=FiOWOGMsoAlnMkFxqSEIWJ3xEyDMxbr4yS+KYB72bzblGtaD+r0IveKBy3Q7hfovn6
         n2vmphsnkMl/b3LUjkqtcIcU0H3FCEiAxeB0Go6w26i0Jprq56PL0HBTZys/ESRI/s8m
         F/zx2yXw2LXSXLx2xiXyLZtVKjVr0FbltFtnCAEKNT5lbr+zX4LpUrTIUv7DDk+QdXjN
         c440EPU7I9X0tcSN7v+l34EpIxoC+/FxioSA3RAdxINdSDRWpyURQwBYMQOGQJxAICjU
         eVWro1b+9xEkQyEr5uyVyM/3wf+wsMkrGMi1H2K9HRJ3J5vxfkUi7Nb0EF5Aa9PhZVW8
         d3cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761601232; x=1762206032;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=omu87Ze+GCEablLZ5Y1kVHweKQ9CM76WnBDADZ59AOg=;
        b=MVQxxJgcVcwLjMrBXKEFpfUxy9AfcJry7veuc1S7lDMRhD4CeTNKoPR1U6wgfGXNvs
         fWwo/01DgFau5Jww9OWPXVoqbIXoUt2fDoGBZlET5RF+cjxzpki6vK0kQ980ETKD/NOG
         x9toyh8Y2rdmPtv/10Hso0gxMPRZtRmogrQrYEBRrNQEq12HBGtUHDK5/N4BJk9JB0R4
         1WAV9vX3IZOyHYbS7hAsQiKnXsZVSgK/nYXhL6v4gpB754IeI0XhAiJXrhyxMqNICL+n
         eT0qNIRVgAFprjPuler1Bv6UP/Nktgb5SECHx2KQf2HHiQRvj+u+hMqFeH6snVHpT7DU
         lwoA==
X-Gm-Message-State: AOJu0Yw/OclcKUCsg81gxNVoc72UDusbBcXNXmMq3P+QWcdLUGgZAvSC
	9miYBPiyTTfi+QskccAAtslSfVdJPCDeIW8o+HmhTC3xH++y1fsIy/TF
X-Gm-Gg: ASbGncsh6c4YIUMMqDoxI0eVnhUhi9FF/n8+zTGHO1lVowECnRlAe8XPNCERKPeMJX4
	nRNZMl6ojtpOVXEAzdgQHDlKmgH0Sb+hrdDXdcjXmq0j/cK5/qCqCMPYo1Ah16xpj2/EH6sR6h0
	ypslFXUgnjkC5NsUklDrRP3bHktSN4AkiO87lznkHeWmi8L/M6ZMRmLGcGRV+8BrLq/ZD3nY49b
	hr4Wtrj+fzTtgGuDRh0CrKoLzmT79OAT7KY58nGI8G5cOdhRQUOseaPa6/R/O5eFN+Y9Q8XxQen
	cXUkb+rd2P+vu1qrbQhpkRJKwUVi839IdCoU5wVtNCaAyKlAQU3IJ6ovk1rFfQcHVTUUDlERl56
	f2vI/0S+zVK5TC66W0SmsQvOfgKCNziHHSdvTbs+PEUIPgWxYKG//je8Rn77m2pckas0VhNwYGy
	RZawhtPT08tbgWBnywdYg7Do+MvS05lgFKZT5FAg==
X-Google-Smtp-Source: AGHT+IHRMBR5sjtlPhpv5oFEsUc8g9V/hwydBp726BZW0B6O5IgDfBJOEDvIgpDlBg09ewyz074CIQ==
X-Received: by 2002:ac8:5d08:0:b0:4eb:d83e:2e71 with SMTP id d75a77b69052e-4ed074bc1afmr21527911cf.18.1761601232179;
        Mon, 27 Oct 2025 14:40:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-89f247fce0bsm679653685a.13.2025.10.27.14.40.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Oct 2025 14:40:31 -0700 (PDT)
Message-ID: <47ffcfe3-f9b8-457f-a336-bba4b7977a44@gmail.com>
Date: Mon, 27 Oct 2025 14:40:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/117] 6.12.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251027183453.919157109@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251027183453.919157109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/27/25 11:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.56 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.56-rc1.gz
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
