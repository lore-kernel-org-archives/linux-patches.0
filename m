Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23D8837B015
	for <patches@lists.linux.dev>; Wed, 13 May 2026 22:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778710786; cv=none; b=pJJXpTc7vf2Ab4jTTDGl5EpqwVBXdAhBscJPkkaiptjvOEarniHqQ8BSjCcoOHYN2J8ckyDO6NtyaTcXp/kgQWYkO4Qs3HsoREtrmY/s0H2MHv9E5l8nuSy+qZDeqJSvrat+FoODTWtryJ7tlJkL2YEby8sFSGDZKKLe6Xw1tow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778710786; c=relaxed/simple;
	bh=cxTxPuiEpchvxoE6s7FBoPyKjzZaCBOY4cXbh/fZYUc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JE2sZCXH2OmDU7N1QEhH3O5Jg6k6CiMRV8W/PN6Ew/vOKmcJ4X/hlvRJr7eupf/T70RumjEsLJ1O9IKgaWiESg9N4lH4cd/zzMJW8yjKL0wqyHcs+PMYjwVXkdSE72A7zzgurqpg88r4xkCjqt/nN4SsdrxxmQsArVu69KaBXCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NDmNpOIo; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NDmNpOIo"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8eea23d01f7so993744985a.0
        for <patches@lists.linux.dev>; Wed, 13 May 2026 15:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778710781; x=1779315581; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YgwA9bz7u/SZRuejSIAFTZG+KPn1vJm2yiXaNhSWDjg=;
        b=NDmNpOIoOwfaCyg6WbM/ug4fQdKsPkSE8bqgaaFgnVq+UfETqN087hm7qkSmrTQu1E
         Eem5GQAuiNYE5edHX8UfjvwHh5R4chK3ovZ0li3JLvrx0CQlRXBkBAoMfe4eJyYqxnWY
         HiOw1kh2YPhrrB0u1WC8b2Z3XPbaZPWCUYQr3HgwdlaZ3AdaLxGFbEYst5OKnb/jAS5e
         1GyI0fHnpgiH9k92HKrpQFPIAGGvgSh920gUUPUFKnQxVb/shO5zUuSKY3hpJfIrBQDv
         w6wKkSFAe3m99DkZ/dCiS9nZhjsCPCiT/zVKpJLljOos9Cbw3nwa5lQrEpzRbHSXvgR2
         asmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778710781; x=1779315581;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YgwA9bz7u/SZRuejSIAFTZG+KPn1vJm2yiXaNhSWDjg=;
        b=k36d/OtybYgxJ8yXfsjsOInl4/Vg+dJAiiQinLH8Di5uq+fPDhmuvjmjykDd3QZCAY
         9BCwW+xktrWpTi1083kRlnmZzc5ZtE5NSf0XLsouyShWkk7LWFlAUOZ3P9D2bvtT747Z
         /OrFEQI4BSlzvYLQNIgDLX2uTEbBj+cVuSlJWgNCmD20/Tpcxgeoye2tW9SgNBMSA0zk
         OncqXUmt1mmpbooahJRZD2KB5Oojap7FbMk4F1zkYOMhgC1YD4hiOVg4U9RsE1oCpyaE
         dUQshA+PiiyI6+PrzHyEIhxk/3m3qTHl3iFqI6nxZtPi5AO1Bbk7K5f3/hWWxJCXDfOC
         u8qg==
X-Gm-Message-State: AOJu0YyUIqIIUEc5IMV/GbfjKBmeh4y/JwLnf2cj0wbcvjgr1TsqOR3+
	PoHuvpjLtogi0SkmBQqKo/6fKhH2ddztIRJiK1O0Q+Ol+/GgC6ATG3Bf
X-Gm-Gg: Acq92OEWf+xxdraoSZrFgGxBrbw60/P0XTGN+nd+R1LrXobhwMUyGMB0gtqPY7PjHtZ
	VVFffQ2OaXJFjFmw8rK7P3WWSvi8oU+Qh0Ri3rrFToM4NZj7CshhwruxU9JEv6Z9Zpkphjmx+OJ
	Qgw8t81bXxOcaAhU8GJ/AhlfTRyFfGXArF1+Sm0lvur6iGYlEZRMLVfFW/2STCAIVAi/e3gW121
	MSkdgA5q8RWhOXuCFowLbDTOnOhbywtEM1QziOjdrnsjCfbyXIbpqsNxmtewkVYqWKXQCWeSRRN
	/PqK2IHU+sRysEpTVHSD2HtiKFP6xA7Ia6pWrGVAMePLGVr63LU+L70JcwwecTgwNAw84rfqbUj
	0Ga89dhTcLvmhO48GzrMxYS7wZrCGYEdo7WZrvyuyJeRyDhd37eNHKFjoybYWVRpTMqa2ypiPqn
	kqNnejAD9TS33JVSeTJ0KNEsHcVs5c1ZVfhYq0csTGXRz1eRGM7dXzCyU4Sv7o
X-Received: by 2002:a05:622a:5c85:b0:50b:3788:ab59 with SMTP id d75a77b69052e-5162f4b00dfmr75902121cf.22.1778710781154;
        Wed, 13 May 2026 15:19:41 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-516456b6cf7sm1499921cf.8.2026.05.13.15.19.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 May 2026 15:19:40 -0700 (PDT)
Message-ID: <2ec12f83-9d43-4c07-928d-a300dd0f48f7@gmail.com>
Date: Wed, 13 May 2026 15:19:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/305] 7.0.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260513153754.934923793@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260513153754.934923793@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.7 release.
> There are 305 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 15 May 2026 15:37:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.7-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
