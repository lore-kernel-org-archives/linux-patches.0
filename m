Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 334AA260375
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 18:52:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741719132; cv=none; b=LgK36T2g9rZRUY75/9aKv40DP521ilJ2+OUpbH3OUPmmIh9VS9DAKJgSDORA87i3OTEJyZ15MX+JckNCQu/9hPyV0j58Vn37RhYW93QxHfu6nE+zlzBcTUPXEq8/6thZe2N6WPPjLNqe3MOYa4XgDdwV5ozctjXP/j5fnUr5vtw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741719132; c=relaxed/simple;
	bh=pmh21KHHUJyITORe3G6MYTnt9mwiJEGrznvtH2hlXQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cvFwr6yr1XcCS9AM+HelgAO1EQLTS3x8FGJMojcLW9x9m3Wb8Hk2n2WjpxwAGIDK8S3gxOm1u0vKI69O4HE4i8R6k8iZDDUURAMKXL8Q0iKfAFuKsWh09TkFLjct7QoPeDHSw9cqq08cll81VzUkOJAXdwCI30lVsq3KCeKKpFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VU3ih5Fd; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VU3ih5Fd"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-72b0626c785so2297272a34.2
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 11:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741719130; x=1742323930; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Sq+W0mjXXkytCf2wQ234eWDtDS6+X3Z6W+0y68u9vgY=;
        b=VU3ih5FdvWiEfgmuHQyibVxCKo2HHfeRWcQet3Rl07gBqDG3P1R3/TN5JyEHbQj/yh
         pFfBKP0NEb62y0Sf3bBWbKY+ap3joK61se27yIaoNSwn5pGJcXRvfctWHYphczbLEvvx
         vMdl+YuacK8WtO14S5Lyz8BqJJq06uvJ8PxBIEPkyAMEK2Pq0ymn0WZeBOzRlGMTe8Hu
         YoZ31sNlS4ypjdGtW3zkbpdwObtWcqsqHKMrMg2wgQrAHwj39V5eGa/AG8TNtcaWJWE1
         m9p6BOoFYUQCyILCj3VgFAOKrFZOSvm9e44k3s4hY5UhptJcaPFe/2ljXYeaFpqlkHSb
         G9Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741719130; x=1742323930;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sq+W0mjXXkytCf2wQ234eWDtDS6+X3Z6W+0y68u9vgY=;
        b=PUFou0OhBupHLdWTyIMChTV/1bpF73D4YsunzSvhyqeQ8qQ2htBlOP7y5TuQ3H+EqB
         eGFtG1e5JkOlCEQpxh7CugSEzHIxLHohDf99fk5/X2EEwROQXlMGpoV9ZvuqSalKsaw9
         oHmesbn3OFDoFD9U+yQz+wioUdl9263ewi9S86jzWijkO3gAH+yzvD2xoae5iTgwQJ0C
         YlZ7qH31ouLZzupnlsDQZ+TlnsRYqBmKnThGJKkp5DU2kkqijuNT++AxRbnfzvX7l9sT
         S/maI8UnJGk5H1CmmYwXaC94vtHzVYwa1hygXJEMaPRNW79RtPOxqZoBo2go65WFHBZc
         JJYQ==
X-Gm-Message-State: AOJu0YyZ6HtGrWSpqdTHUcCtNcaFnpISkHm11xBKF7SmjLCAqnxhGRRL
	82Wjy7NU43X6jlM8Vf+wVAdbj1FCvSdZhS6W/LRFpTVf34VbbVwB
X-Gm-Gg: ASbGncttP+2gbR6VaWeGKt6La5EYs2UKAvFRQaqOS1UgfTU8DKHFnsEAWzBOPqddrn6
	IxRHERr6aR015dC3u7uWIQgK4amPZEBbQCmTkjwmaGKfRI5D5xDng4dtn6gah920fPTMeMNJabS
	Xcf9CZirMYDDZWIIexcpAWfqL+lx3dfERbElro/9VzJqrkZsENErVVE/Wr5d+rVaHINT8bT11bg
	+EwE+beSJJNz3ozjXGdPRXz0xrzCeUvStciZwNs/CAeVC4FGbiaVdIuxjLtnQIlwNgszAoPOEIt
	YkCU5P0bcRtxcTID70gFYOY584x+hVIEpH6MmK4tAuUi9ErazTFGC767sTm5XfKKxaqz2fCW
X-Google-Smtp-Source: AGHT+IHGo2cQ32wvmAWbFqPq3xOSCO1nxjOULnj+BI1Akbky84nYA6nCouocS8h1q3lZOLj0BYTO7Q==
X-Received: by 2002:a05:6830:730a:b0:727:4a6:5b31 with SMTP id 46e09a7af769-72a37c523ebmr9831669a34.22.1741719129751;
        Tue, 11 Mar 2025 11:52:09 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72a2db0c727sm2536220a34.36.2025.03.11.11.52.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 11:52:08 -0700 (PDT)
Message-ID: <acdbae48-2d7b-4eab-b53f-7bca6e30394e@gmail.com>
Date: Tue, 11 Mar 2025 11:52:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/462] 5.10.235-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311145758.343076290@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/11/25 07:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.235 release.
> There are 462 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Mar 2025 14:56:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.235-rc1.gz
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

Same thing as with the 5.4 kernel, "udp: gso: do not drop small packets 
when PMTU reduces" needs to use min_t() instead. Thanks!
-- 
Florian
