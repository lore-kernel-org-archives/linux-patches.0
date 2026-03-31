Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741D64657C6
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 21:48:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774993694; cv=none; b=gIaHTTfER1dtNlwRZhkNNq2+Yu2MVfQhAZxN4Db8TycqIPTMd2iYIhr+6s+muvcuRFxya3qeeHB+wJsvjzsHn6kJyCwy1qDWhXDFbNUipNXXmDkCKvpGBJsK7Jg4tSIrbcZQcwYuk9nlddu799pDbFB0JdYtPHPnDdHxEYnp0p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774993694; c=relaxed/simple;
	bh=ZsOzdEAYegoinv4QWqmu4YkGfGvIVGK7ma0jEC5c6/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IIP2VCdmW10I5EWHcvzvSQuHS8a1m/eXCUW+3HRogB/ShbaPyRdTbj0+CicAl4SC0Zrx6ES4E8niCt4ljpvE71EUF2+6HLI1/6+Bl9U0QYRoA0QTf0ANtwmzEvSzmTVCVdx607NsFMSivhC03kBodi533JAHxlLjMx5WUmxqEwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=E9BEITyl; arc=none smtp.client-ip=74.125.82.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E9BEITyl"
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-2c15849aa2cso6617576eec.0
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 14:48:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774993693; x=1775598493; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z9XZFrjbE2TprMrLGChRtQlyHiVKoGQiGftbWSi5t+k=;
        b=E9BEITyl6ufsXHxgDwCd+fJ7vOeGfkPmhShUd9pEPtp2gmSNQNhA6VqUsGg9rll1eQ
         1PoBT3Z3Ti8h59XpqPSE1z3SwHnYxBCeqAXJfZMn3fCMJ2JO7T/LtspHiGCRHtcrSa0b
         Khcbwe7zLMgoZN0Zu6V4YG6a79JRU+mJfwsit/8YT7SuFlLDkIqDfnOrO6ynSbXjDf/B
         NeRH2joRffTZr2+M+r5MthQu4pXLerUs39OnZwLI3f3EjmI5uV8muKfxhRKWe1jiWVfa
         9TfffOJBqgUAp6q1IfK1cNBInFqqGMtoSeGH86kDSELEOjux134j+feor4Cxdyqd4gkT
         6gWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774993693; x=1775598493;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Z9XZFrjbE2TprMrLGChRtQlyHiVKoGQiGftbWSi5t+k=;
        b=g0ypMaVqUjIFNfWHAHpscFhLsd0+DdvRre1vABfECSXuml10GqB19Sdhi8xbR08PXS
         efgPCZnXoS8eVo4BogEdO3QpDzyGDlPocORNPBywTHZsPtWDeBf/7Ot57fbiESqw44Y4
         GwfexLrmuRoOOwKuTvnFX76wfhC5wyGnXtJRr0Etgm4JLmIDNc+gTDuegT/t/t9Hyb5E
         A3kBrXgPMWX/vB4Cwpc5IG8n4pTeR0+1ODeTNA6ZkX4WiYxuejo1TjLkQgttFQpYUa2e
         jA/vJAvId9qPE1iDcnU2COiJsUNCFWJdTZbzHvwKxYu4GCK5Eg99B3Ul9ZW25CZQN0+U
         0phw==
X-Gm-Message-State: AOJu0YzU6gOb68Hexhdeu2w745JrPCVTOtRRvsj6cbIdkmSkKJyId3Pu
	m/HkVVdjqrFHz417f3GZ0YHeXZy4WqvOyEy40a6Pnfmbg5T542va2aLW
X-Gm-Gg: ATEYQzw/OevRG2jw3ihqBkZUF5OY/Z5N0GS479DcZm/T5zo672goQyrF0nUPDrgQJ1R
	218jJvzeoPb9RqL2sRYE0z7V4C7pGIL/uGbFVUkOB9ANhYInsOf03QWtjj+BoEgK9kUyG4zDCCU
	CowH1L/TQ+KucklZLXXpoKvQBS196jj3cNGZggop4CNxfQGU6iJrD1h6+9zXW9agIXoZjJCPorv
	ceKs2Ikr/h3n/jqmlezeahRqPBTYGHbJIAVf6D0RarEhmb46FFm17EZvn13NZH1LHBWeg5Bi1Bv
	nReNsFpmwxSmKLO2IvYFEO8OxyNeaimZtdpH5jCefZWxABVyBohdKxLewlBtT9nGWR/o5dcgV42
	vZHBaOqIkxfEt6rR1PqX2z39qo91THFcXupk6hi7vVNEijPmjU+i5ayv2cEZd6+pVOEH1pMGJQm
	pYyDVtQqZqeiS2TmDRPUTxYWiqpJzR/LjPWnzqbLtmgu6Sk99Usw==
X-Received: by 2002:a05:693c:3118:b0:2c1:60c8:e0ba with SMTP id 5a478bee46e88-2c93138bdd2mr661459eec.15.1774993692362;
        Tue, 31 Mar 2026 14:48:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2c3c10361e7sm11365139eec.0.2026.03.31.14.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 14:48:11 -0700 (PDT)
Message-ID: <8c3357b3-56be-4f31-bddc-8c6cf76c8683@gmail.com>
Date: Tue, 31 Mar 2026 14:48:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/175] 6.6.131-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260331161729.779738837@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/31/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.131 release.
> There are 175 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2026 16:16:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.131-rc1.gz
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
