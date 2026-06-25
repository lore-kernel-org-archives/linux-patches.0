Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CBC4260580
	for <patches@lists.linux.dev>; Thu, 25 Jun 2026 23:56:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782431764; cv=none; b=Q5oD6kERRWfdsZTnY5+/ZQJqS2XiGtiqxfW/HN07dzTWouELYFs1mrO9z5yldLTbdJx2qr3N80Um031BObXPoR7jUfA+s8FMJFSpB2hKFFsgvDcP+KsDvG8dohjqqMLRz87Q6cLEyL1FDQUqvOUy8ADJ7GE2aKpX9ou/ViDA8kY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782431764; c=relaxed/simple;
	bh=v4qQOSfEsJBEAiTB8bNtCsmlBCLgcXgtDRs+K1rY+Gk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f9AK6rvFMDbvKnbz1u0nXDEx24LLMHa1v0YsBE9S7gryc8+bLX2K/UGNYLFtvBiEmErWS7ycrw+cowVsAOx0NrgqLSF/ACA1IVLQrracYS318Jk1mV9w3CW+ANP8cWJjy3+Jx2FcvX7h+KGxCOJGSvDdL+8C+lcnT4+KfOald4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mfv3k+o1; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mfv3k+o1"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7e93c3f1717so163539a34.2
        for <patches@lists.linux.dev>; Thu, 25 Jun 2026 16:56:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1782431761; x=1783036561; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=se3VN4EIvD6SLhtE53lIkfV7dyEZn4T4JlYolPRuK7Q=;
        b=Mfv3k+o1EkGhA/6XigIUE6E2jeuyPGes/rcFasVeEUqGieQMZU5SqXDhGqIc8gl9CK
         +iuX9Yl3JlC5MBFz1Zrf2wULgB/BOw+UhfPTtbvscxw42NLzA1jNN9fpFIRSy12iVP9N
         gKHMZfl0+dDIr0rttxb8J9I5yvn5K1oG/FA8Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782431761; x=1783036561;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=se3VN4EIvD6SLhtE53lIkfV7dyEZn4T4JlYolPRuK7Q=;
        b=L+NROeDMrY+HS1pqO9JoZobZYX56auG8o/sW80CZQBBgPOib8W2Azd6hkoHiK2Cu5T
         VIkmhNwnVtOn5EvMo8UbJ0YwBMgD3oiqd6CIu01Dieam+kt6LPrzUX2kjQFwNuoBGC3f
         2QfGC53gJ++6ZLjqdKDeeGDxtaCtaBuxYdJ+CI+ZxX1Fl7QmryhEaADUGWe/+J9yR7OW
         9QyyvbdLpXzMfdD9zrNLqAIVuMb+qiZZoFiMNQ0IUKG5PN78dc8zan3pRBiQ8dNHui7N
         n5ZXOPnMMpl+2HzG8gq6DOwwoqHai1E9pLgCcjpfAJBoNcN/wT10Afiz8XYck9QmieRR
         QxHg==
X-Gm-Message-State: AOJu0YxGgUMvgn0Qm77PZNZA0sg9gzcaD/loLNa4e/I4fSgj43Aiua6p
	2wL4yIlP1XTwOhJJKvcLhAPBK6Gfi3Q1HQqjsm21xb9VSDGbfWL9dg0npBe3R4Z6RHQ=
X-Gm-Gg: AfdE7cn9NlPu1lLNg7heSej6w0N4qpouYcVW7138PtAoSPp4Uz5VUWctHSedD/9H/Jc
	Ezo40wS6jVxj/DTIdJMYUB6N1GDnabxQJWrfu4Mo00o3VmaNR9vb4etN5P6TWxtjFiianO9Ylhg
	+04trp/3Ea9snpN1myuvaCnC4hqO2rZVlXnu4IOoqGjEX/YepqDockH4gTQfFebldmvz86sSaZ6
	KVWeJRKgFIxMwSV3sMar9fwLHCyR05FYR+LYZVTqMr33kMY+wkHk4at9Cx8PCeQe+cxeWgHhstr
	fm7jrPEoMy2GVIVWZE1ziYDcO2tuB72A3JN6v9Hosxx276lfYBpzS7UxVNnLTk4as3OhrAsCJUl
	N1cfDsITt7Ra54TKfqLIUmADT8ZQtCEOXnkqZ1Zq4aodLJtJzjQg4vq04flQI8eVXgXUyf/XUM6
	4mpWps1rzyVgVfBH5ExISZ+mFh4BkSxqE=
X-Received: by 2002:a05:6830:6383:b0:7dc:c4ae:a689 with SMTP id 46e09a7af769-7e99bf37bf5mr4066834a34.2.1782431760999;
        Thu, 25 Jun 2026 16:56:00 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9aa7bfd54sm378845a34.21.2026.06.25.16.55.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 16:56:00 -0700 (PDT)
Message-ID: <0d5a418d-4ee4-45a3-9ef2-79fe77afec2c@linuxfoundation.org>
Date: Thu, 25 Jun 2026 17:55:58 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 00/21] 7.1.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/25/26 07:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.2 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jun 2026 12:54:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
