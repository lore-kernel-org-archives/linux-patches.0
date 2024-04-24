Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52DCF161913
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 16:26:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713976020; cv=none; b=PWpAEIcx0iFOFFLzNQJaXjSfU4wQeozjFs5Q0dMmJtd9sUcmKYNsuD2MoPRhgqaUd0Tk9/IanthU7AbWMwqdqOhXz1e1tK5ZEzJncyXGNjsaQ9U3RB5gl2T+6BDE/mH4/0QPWm0FG1JnljrV1z7GuSh0rPS1W0U6zUmhrgwXfJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713976020; c=relaxed/simple;
	bh=MrekQsd6OaTvzphSNX4kb5YxwQEH0aINbyb83pngJpI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KYWBqx6zyRapqTMvd+3sEO1nWHjirX+/RrrqZwXqEor0Uck5bMLJXMvmqfu67XL7V/6S22z2RS/3QINyeQZpT8/uQHbn+B/4wzwQxzjNjNUp/VsiXaM9E2mQQM86YvVw6gyDCUz1Mz8i1CbcXIzU990E86H5KS7M44bef80sV80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D7/Q5OHq; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D7/Q5OHq"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-78f05341128so459683485a.0
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 09:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713976018; x=1714580818; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=re1VA/XQsH0motUnZZSRX7lW+nnZ1gYeiybIgvu9m1o=;
        b=D7/Q5OHqMQNQDHMUlaL8E1UFiZFeqrbS9wNLkpFwyu+AzIbFvEaZDT1E1IAvRIBkzH
         Dn9ENUrkKnaNL14CQphXYbF3YRHKYyR3N7CDFfgl+SGPKEbADPqY27FH39ghtgvtv20f
         TGi7cMmzp74V3ramXxBaNBZ1XBjISaYEjjsfktbRqrbcSgFDklEWPa/c7q2gyXQzS6OT
         BbM3UmyajW7dpcJMzvRUlu/PjrYzr9ZgCb8toh2HrFsvXBYYMo9p9O4cIzn6ESJ944CJ
         z7VeTZzqX1w7OvLyaHQNgvNJ+kSoFyF6XLHYwno3zpvFL7+X3tMnc/4lWwcJFxf9gfHK
         2tMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713976018; x=1714580818;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=re1VA/XQsH0motUnZZSRX7lW+nnZ1gYeiybIgvu9m1o=;
        b=IaF1o+pe6oFOWLav1DW6AQvVpO/eeD7+Wvgvy0/1CjlrYz/KGNcK5plqlOHzqcqgFp
         LrauVbpFGz2d/Vw6oWFhA+dS81pW10rtcIPnM8q0uNksUcpci/zCkSxwUZOA8G2PVVYo
         tmr2xGN/qyQNPsRAFcZUwsLngdNSWUte0/P3UuEB0lbfJqlbjZJ4CVVRq9xOC3IOkNNm
         E4+JpTfzXCg4rM74DozN82LFCIGZcd3KBHZzDdBl4qReR3IYv5D8Gp383gxXlILcsCra
         g93uMpQnV2U6Eva3n8ZrTbspoxRp4gWhSOqMqLX2brEiNdRjf8HqDD6xxIoF2Ey1ksLg
         cuQg==
X-Gm-Message-State: AOJu0YxUybEv+COJtwrg/xQwX6OA7U08QIKotwKFIP926Z3ktmDakgl0
	gncifmtuD2SNnJbUAIZSuIAG6Xn1PLAjgwkaGsE2ONpoSViGdUnd
X-Google-Smtp-Source: AGHT+IFM6NLmoPFoH6FJDBLabYzNV7CTdH+SzP4ipMiUJV0Fnx0XZAUUqt01+8Hm5ti+FGIm3K2t2A==
X-Received: by 2002:ae9:f714:0:b0:790:9792:ccf9 with SMTP id s20-20020ae9f714000000b007909792ccf9mr97187qkg.26.1713976018075;
        Wed, 24 Apr 2024 09:26:58 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y16-20020a37e310000000b0078d5fdc929fsm6230425qki.104.2024.04.24.09.26.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Apr 2024 09:26:57 -0700 (PDT)
Message-ID: <0886a749-c834-4f52-a25d-fc700dc26334@gmail.com>
Date: Wed, 24 Apr 2024 09:26:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/141] 6.1.88-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213853.356988651@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240423213853.356988651@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/23/24 14:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.88 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.88-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

