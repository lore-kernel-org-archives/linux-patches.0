Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F208280331
	for <patches@lists.linux.dev>; Mon, 10 Aug 2026 22:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786400473; cv=none; b=rnNIZnQiEePbILbWgue3N+FwYbXA3AgS73Iwey/Gjs62ZwG5p9xXexsx3CHA2jYBVrNmgmPL7pvm6r9DSbuXstkiM3z/2VpM14BMUuIsxJNNJ7gzJXtpqkz68EF0n6K0gd/bfubDx+ZaANa+Miod767GNmwO0qbFj4PSb82xC6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786400473; c=relaxed/simple;
	bh=YxMtMKdJRVqLnvTqrwryqwIm4gyNBPQBUx5K/GDgWWI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FRfYsHd8t8byPPZsz9EOnwvh8eGrZxvdxRbA3h1tm38t5RQiNeLSmkvm+AAFP6C5CzHHeZMsq7KtNg18lsS2si3XUgJe3RYAHQDtOKB6YPcdD1Lb1wrdbN06roiCQSRJ6Dmc61BChw9pOVOdCp1yuLWCwz88P6B/M67bk0AFXnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1a3Zmpk; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1a3Zmpk"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso186408a12.1
        for <patches@lists.linux.dev>; Mon, 10 Aug 2026 15:21:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786400471; x=1787005271; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EhH8yHW1aCCAUDKyGcbi0td9RK/+xzXgFbOGp2XJPSY=;
        b=R1a3ZmpkShtoOJ68tCHfuUb/XpoEPa9sTNunw3KeO9ARaUR/fM2JofWU4+dBPplPtQ
         MsVIbaQWjYEDB2kC2IDmI9pMJVQDcuuY8J9AusB79q2nRW+nIK/0/F++UK64AEDqT6jF
         EkhAIRBF9KHK1Y9YsCNjoSrlmb14j4nOFiVesaW6OoeuR+pawFj+qrJLWwwFxZG1If8v
         QLEM2oMeBBqjaOhb42/OU+H8v7nIjcggfUOf6g/3ew6puJStiOEGI2NomOW+N2szTK/l
         gLmXaXZMze0j7Wp4zY6c+kIXiR+KQsifK9m2OyTcLlTuyTjXfJbb/nAHzNuF8lZgPpBT
         zsxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786400471; x=1787005271;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EhH8yHW1aCCAUDKyGcbi0td9RK/+xzXgFbOGp2XJPSY=;
        b=tRGfELxNX5J0y1uLT7bu6oKLNziP1ISjXwk/Hkmd9Eu8nMnN/ti0n7YN5ynEWtdph0
         Vs53z+9ISZMg8JHtG3Hew8SWDnUAG0l4d7ZuwUhr0XHXEIkoPDJYMlPoaZOC93JyOQgH
         +9gqA29xCYHLB4EbWYnM+Q/BOMdZ8Tzwc5ac0/ybk9pRUOQ/8q5sesXsGV+VbZqzkHjJ
         2fHIoYKGoPS8dcaw5YjjidtrdpKz4xRGl5h0EtlQyNHK+jSNi6HQwmIeVpMzxhLzU07w
         gH2UEbLQSlGS8OF+GUvFGE52BdP1KeIz/ws0kWe1gl+e/1yJePhyegJL4CvhC6pKX13X
         ru8A==
X-Gm-Message-State: AOJu0Yyy+K8N/wCtKL/44h9Zm1x7DplDq3y+GR9yr2YGX8SmYiCv+84S
	Dk7AvUf3LUUWMWYEy64axP33O0Po3CRtyWuuN3nRCutlShuDzPFm0fPn
X-Gm-Gg: AR+sD12OYHmacVhI2aVsnYMuvWFNcLNv5E+GKMQ0zqVbmXVfiNGWK8np4h54VeQDgvF
	J4zQj1JQ4WGAcgjKxBU8XxVtg/3p3i0BaoyfMQLnmKq9MR58bpzvQOuU5B6bXmT6Cd1R+O0t4CU
	y0qgaB145q0xZwYklohFtzOdY4FrI9uvThQO4HRNDFE2G3kMKbZvbeEoF7PjZArPr0H4KgQfvGa
	pkUUoMAldkmE/Ym8kBm/oEph4tIMO1d7QLriUMvz/Tku09jLZpn1CPgtQCsTRpzYTbEPY6WeRkB
	CNN9IkUwVSuE7vIRG7z97MV32SuVY8VwqJeI07RgW4ftoESk42BipU03M/aqlkvcM+uaNWsILdX
	1C1gQoKcMixe+NSr5+WiuxJfyWQD/tCRESRDLsb+lkExhE+CEMp/aIQFgbgo7Hu0hU3WPw9Dmic
	uToOm9smJmIucz3eK/pAF2n8uKp0JGtJuOMEInnQQMl4/D85pkP8gENaYE0//QrJ345iAEygUpQ
	LV/4iz8lEfgARY=
X-Received: by 2002:a05:6a20:cfa2:b0:3c4:397a:69b8 with SMTP id adf61e73a8af0-3cb85e6c93amr61041573637.21.1786400471483;
        Mon, 10 Aug 2026 15:21:11 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14101a60867sm38773947c88.9.2026.08.10.15.21.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 15:21:10 -0700 (PDT)
Message-ID: <012b8d8e-3add-4694-9a30-57475e1a52b1@gmail.com>
Date: Mon, 10 Aug 2026 15:21:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260807143415.358597922@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 07:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
