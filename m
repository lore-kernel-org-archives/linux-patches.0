Received: from mail-qk1-f176.google.com (mail-qk1-f176.google.com [209.85.222.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4AD52236E8
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 21:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787000836; cv=none; b=bhvMUw3Ed/u9qZ+Uhj/SLr6G/up8dfz3VWqaNMtiypLT1sJCBhX42pnmgmBGYpYLx/BwLIHi7M/SZcaGlBqSG/oa1UOG64ytAwRWZx/7MaFmlA9c7dYDRx5BfPqINVWNKx7L3oC5DOqUHQtAelhdhnli55rEABG65nfOxGlPaSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787000836; c=relaxed/simple;
	bh=LfKFQ60MGbt3oQUU4UeDzk9gNNM573Bv+YOc2QstpIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J/dMAAml/0KG7j7MUTQppiCk4b1QYKdCJplvQL1dkxiKL6ldmjavrPT+LLq6haIKLoDaL4hUTu4KD7fTGd3w3ffgOBI2AVTaflw2DsybqkMw7zdpXzUuZQag0vyBKbxlok9F3cMrmlC3g34Vc9v90vjqvxIBYE4Rvg4TnGSVg6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VtzcJaVM; arc=none smtp.client-ip=209.85.222.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VtzcJaVM"
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e50a650a0so220936585a.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 14:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787000833; x=1787605633; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ys/YTvaoT9w4FLM9XG0rthYcw3gybAoEJJ0PsMkecBs=;
        b=VtzcJaVM5YN6gfjeammV+fSFlG0cvTGxgzjJtjAKyIrPfz0DnBles4myubFEnX6+AS
         6jL+lWFmLmhzqmMR5AyQLKJLxZlC0zCiTvuJUSfftc3T39YvnNJ8OvmPlHPEMLyxvQD5
         NaFtuJ7wyhVJsWceqFXPAtyeSztl8JMg29Cxmj6ULLPeZTG6Dxzyk5ew5taOwH0zmPpW
         la7tSc3IxUlUnKarlFGmOy3SQBK5PbU0jwpBhAQlP+9GBaK7dhP8qr73OGDnPAYp9G3K
         HvCIt8u9c1UBYc0RpOvjQQrY0LrslKz0drxhNplRAJA7A/hjiJD3NEfgOi6fh0jsaZkb
         IqcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787000833; x=1787605633;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ys/YTvaoT9w4FLM9XG0rthYcw3gybAoEJJ0PsMkecBs=;
        b=Waa9xMAbz9jdelbIDUFS1cva78LSgl1nxpB/OfWr70FJ5L5iP7mFJcHa5GHUbOjX7n
         KPfLwiTgIagV1vORCMjwEyjoyf5jxbUfyeKHIIjsL/dN6KSUP5J2WxbRY8jWrEguDqxT
         Fo/KHY4DHSr1WTPGZwYvwJ8eYI057jO2W0Z8Px99/tVGAzWKgCk0/3E4yZKPz+YMr5r+
         XAPtG1+gPkV0w56Zj+Rapn6lDBu3CTdGvUE7j0FXElP6w73dTOMg8eG+AzwhyKhP3PaC
         65I3sV6Cou/gNGKrU5cXg1FV+HWRFIiY8PmZzRTImgGmy7foEYuRl1vrhsprgSsdVzNf
         3W9w==
X-Gm-Message-State: AOJu0YyIPbOIMuanUVTaB2r+pjcHyl5cZIXuIqzY1lTvwXQ98ntTT26r
	Gzmntihhc/UPluMLJwRIBWd9NqEwXT9XK4LKoDVC7Djhxr30MCHaEu9Y
X-Gm-Gg: AR+sD11HxAdTpPFFqhHzbHZUmtzH5EYMOwFI754etPwBee/c/aetY1Xc27gcrcnsKBI
	D4qLn77744g/OY+cqC3bX8QBCri7KBvQn889rDMAH7UBxlgXlEI4EhoccUBnoHIH3SqD8LioUYh
	aRmkC3msqnwbIJNZ5aOTNTX6OmunMIUc5vVgF/5JhgTTHdTHkuhaSxUcUttbmefF+4XlC9ORl0U
	9Xq4egVP0YB/Yu7TfNcwrLkFp5nkxuOhBo3hJmoYDRH1SPkbpqrcrE76kzrBqST1rTcYG77RmvG
	yKUTd1pLKS172pvg/ZO1i4884zZ1XWEuKunTkCkV/2IU8D1MMC5Jv8iANGApHN8mtV+TUTAAo0Z
	HaMSGBrRMhZ1gYQ2SGmUppMO23gEOCT002Xmbh7a+jc24Fm/M27E7Rp3tqHF0c0DAEvDaW66H1n
	hhPtVLY/qGzQbl1xZszqbH7ynjXOCF31AzMzmOR+o2EHVEY6JAJ37ryQQAoCf975e9yQg4XA2Ox
	VgJQMBHShzrd1U=
X-Received: by 2002:a05:620a:7086:b0:936:af34:ea68 with SMTP id af79cd13be357-93704bd0e9fmr362373085a.22.1787000833554;
        Mon, 17 Aug 2026 14:07:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033cf5fbsm135628885a.22.2026.08.17.14.07.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 14:07:12 -0700 (PDT)
Message-ID: <82c7d4de-6358-4265-a250-32351cec0f3d@gmail.com>
Date: Mon, 17 Aug 2026 14:07:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132534.666299318@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
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
