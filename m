Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F5B1F8AE4
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 18:52:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734461525; cv=none; b=axBpOxYg6hQmtatwD6nEFNmMNttve+L81yCUFZhY1v+XKZn/9+iRt+4ZgY+LN7gfn1SFCbLO2EzXLPaVYm6hkfzpHQY9eHyS0tXlV86p/4D5FCUUDchMAirkEPX4hHuPFvSlTj7KlwbwTXJalwQ2DveDQC+ZgbmAcc16DH1MRxk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734461525; c=relaxed/simple;
	bh=p6//4IiVidrIQuHKI5FobqI2mWPJitMp7g5TD9ChUPg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mNENKyh/OoBXRhCizldBW5yDCdAwFAV+3b4acQhrx0pTpQoNcNgPYWwV40iFFTS5B3boKhY/pHXsCqqiF9zw04k8+mdOLB3csBAMV4hWxHokbdhmyoVzp3149hOjaJPNDOJRL092dNUgeRnryqT0dDHkIWR1ipPal6p1CZjlK30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kGb60fNw; arc=none smtp.client-ip=209.85.210.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kGb60fNw"
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-725dbdf380aso4565189b3a.3
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 10:52:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734461524; x=1735066324; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=0smcS/bmntempFPtm1Qz4whs9w6FDLxVkMsEkznK8n4=;
        b=kGb60fNwvQPjcem6OSowptnsrKurcENSULvQxF0N9FY6vZFeqCZyt2Bj0kzCU4FamF
         EoqbN3OICv1OIFueR+mYsHQVlcdBEcBo5ShX3wSZYEfufVTduDFVyFPB5f5XQRZys5w4
         anAAjMNVg1InuX0bRnnoyamHrfcZcZ9ehYDDlINfFAqf/PLWiU5Hr8WQxKykl57IkCcD
         eOqydRBjwVtKf8G+kT8IeoDdcIZgshnoecXB7lXpL5WPces2L42XxN3/PkAyBeFNwcE6
         gnS+qGekFhKYWzlcrGZNfvSZJKjsO48mTzzTgSua5Cb7rWyhJh/cUnjgF5d5g10MnZ7m
         yp1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734461524; x=1735066324;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0smcS/bmntempFPtm1Qz4whs9w6FDLxVkMsEkznK8n4=;
        b=HjAFSk/XkMZ8aPz1Oz81KAgveSBe4oscDtWc8vB5/zgMoU9BeX9SGR/ir+wOjJfnHF
         a2ecSZemsb287oANjDXXQpLZEnpDeHhpG+YzGUzxQ/QDZCIBc1QbXjprIUofjd7V18mg
         epVx348n2HhLTtePClKG8N6TtpHnBl+Hp44s9Zv3XI+eScsy0hhF/20H1bn0XH+7pKrK
         Vco/rNKzFc3ScEfXLZvxFNCFClGa9adJqPlDwpe3/tyjsi16gO3TcHK/kWHax9+6DkrS
         1Y38Q9e39wC28b/3kWVXZNbhqeMkbAqMr4tlB3wPvN6zsM97dbxVx684Y8/cxNug3Ntl
         64Hg==
X-Gm-Message-State: AOJu0Yx5ehKyAVT0e5YKOmTyyCj1uX0Kc1tL3g0J9KFeOX21XdKzRPmG
	sTz51tLrsXXZdeBQX1/yPm6twInZ1zhm3uTl8gyd1RPUwIVH1IdO
X-Gm-Gg: ASbGnctPUImuQjfGKWpFQchJLXLFpWWOq7Z9Bot9pvgwtUSfuUm8SnheiwfO5JewRl5
	BiXV4+OflefPXzt6VbXXp4sYwbInSKDoS/tQfSs3JziK8BYIRY5x5ZtBWFtLjEJBHf9XFurH6dO
	AMKvTvzIfpcs3Knm0vtWBhOfA9qesa/FivWgWEEGuLfOFqryGPf3Hpnxbt+bK25FWeI3IUzh4NQ
	M83MLgTTYoUHkLZYq34nyfVV0jf2DBKUxUkg8b51rbgYVaP0o0Py5mrjpo1/3ZhKtNzfSiPi3We
	DZ7RuH6S
X-Google-Smtp-Source: AGHT+IFxxbYG/VcjpNLRsAsn3SGeseRhCh21P/ItvQIwtDkvlTPd/4Xg4r/a+nDZRm2AfZACzaMMeA==
X-Received: by 2002:a05:6a21:329a:b0:1e1:bdae:e058 with SMTP id adf61e73a8af0-1e5b48a2d61mr128988637.37.1734461523764;
        Tue, 17 Dec 2024 10:52:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72918ac5258sm7284782b3a.20.2024.12.17.10.51.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 10:52:02 -0800 (PST)
Message-ID: <554c84eb-05b1-4336-8c14-501ddbf9c2a0@gmail.com>
Date: Tue, 17 Dec 2024 10:51:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/43] 5.10.232-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170520.459491270@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:06, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.232 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.232-rc1.gz
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
