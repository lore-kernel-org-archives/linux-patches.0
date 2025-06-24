Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B9C52D8DBE
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 16:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750782626; cv=none; b=pCmjR5biIuaHfnlKRQa6lFBYcvA2nhLVXffOE7MciVN/juJkuh5w3CMSLLfAs/sQpKC3jJAymSZSpwGW6Mgb88HJ2gEjuDK1xWqFVGYm084P+JbQu6B6rtoyZEjjvC3mSfdc1/SZ3SiR6yFfjuMCL5rIXQZhEIp/5zmbzn7qm10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750782626; c=relaxed/simple;
	bh=gKMPTkfUjmeGkeTinayig8vCmkghRWoA+dn4/KL/Vok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XQWtrDHzG3PfJ1GLVfCF1qf4UVLpqofCDLX3I0Hh3RaJUuy+DKRXE+eCZplOHAvrFw9nfHQv2Kpcd9QdIpa3343zxWF4S7JFCvL6+TQB1sSll46kQyC7r2xcFWRRQ3GqTjm/bm3zoucCZy/YZ9waLavw0MM50dUzf1+ZkdQctXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P2bthMpi; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P2bthMpi"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b3182c6d03bso930370a12.0
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 09:30:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750782624; x=1751387424; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=4bZoTWO4+wQAYyr+HiGHwhWvZDtBUnYSBhmhbwbqVjs=;
        b=P2bthMpiJIatdY/crgecV60tCe3qNWroxbhB2giILzshVNNVzBqBPAiShZqjtWiaEN
         wC9bunfS89J5ddinewnUuwyft1mLSqks/mqzJrSCxfGBBol9qjQKFiPAMqtudJ0v0pTs
         P/Mb5FLNtOEAD+sr8cxfrPV8BURPxIurPqnCW3YbpJAt7HvLSzn8i3Qo7C7uHm6YlX83
         h0T8nrnebfFXKwx+TLXdpGLt2sj8ILBJBYLRoscV2+Gg7HUz0aL48tpEZ6qOF6HQblFW
         fkjBgJO5Celf8VfYdZ0pEv8BYyASSpx8/wdQG7NjePdquyP0ITOHiAK2LLBECKU6VM+4
         W5FQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750782624; x=1751387424;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4bZoTWO4+wQAYyr+HiGHwhWvZDtBUnYSBhmhbwbqVjs=;
        b=lqylnWKhthQNOzN7eYfEDOm47YuwnrPmU3lSMrSzz9OoiqCaChQgT5/f0oxAAZSvgm
         1qtwDFrCEx4JsLfwYLDqipFa6RzN5qH6V1AlDd5AtxHx4lp5XbI2K97jZmu9bLNCx6bT
         bRz7Ncae7In+Ny5zfqyZp1b7kTPIGGPuDnOCbi4qHULA7E5r3eVjw9qy8ql8ITZaKlg2
         YJga0XeKftlblSy18EogH8hgG4VVUlx3eEHqAlFx2O+tRLJrvdGvAZiFq8Pfbj6L31oE
         SOqVfOmtRik8AcrpUkC7j2N1tibePT88OWzWl4Ebjhu/IHBABnABCRmVHw37TbE7QIPq
         GODg==
X-Gm-Message-State: AOJu0YzmOymGrr9e5MlOgGqbegHS53YoFeDjS0eHGV56C9qHVOCVsvmq
	jbj/6pvwwx5L6VViK2jckUT+Cte2bXck4v8yFxBQOVmUmGqb/U9UAEUy
X-Gm-Gg: ASbGncvzXlJ51oNg9XMQob1L3uT68zzYNLXWJg5DkrTZKNpPkD8+Dy6Ik3lilyyUAJy
	V/7E+LvVgxKAfzeTegc40/PJIc3KzYkUKc36HucYz8VT4A5Is+Z7FxR0puAHKGFR5S8DWTbKnrZ
	H9NEVGWs92NxX9qVOGuHvGKK0W9gJoNmF34piPPJVeF+hCyX27meWUnF5kmtDElHDtOZ1XwNgWE
	pEP2F76WUiBPpeAo24sxrZb2/92+NtWz5+tQSlmU0M0/p3cl6hAi0TvIo953yMAzb9b6szM0/zV
	HVNHMNHPTofkgihmCqOWcivm4eoVFYhXkoebFAV3nplXLG+h8ekqKYIgKkYtd6wPzPkG64hrihX
	51jywzqANa4wmPg==
X-Google-Smtp-Source: AGHT+IGV4rhwef4pWVroOvbIiHwEv415Wg/T+kR2AvIAoW1BXJeB7C1wZ2s1GH5m4uQsTs3wYzKGxQ==
X-Received: by 2002:a05:6a00:80f:b0:748:e585:3c42 with SMTP id d2e1a72fcca58-7490d629119mr22030600b3a.15.1750782624343;
        Tue, 24 Jun 2025 09:30:24 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-749c88721b9sm2228592b3a.150.2025.06.24.09.30.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 09:30:23 -0700 (PDT)
Message-ID: <8e98218b-543c-4484-b937-d62a64a9a17e@gmail.com>
Date: Tue, 24 Jun 2025 09:30:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/352] 5.10.239-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121412.352317604@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250624121412.352317604@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.239 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.239-rc2.gz
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
-- 
Florian
