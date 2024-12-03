Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3CE41E1C34
	for <patches@lists.linux.dev>; Tue,  3 Dec 2024 22:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733265415; cv=none; b=n/V4awnTm1mctevIZpBWWVEPhF7CgbdcZZBBGU+2R3KD9FVPHnXI4PcWS00+mqTzRNKnC0zgRabHVeB4JxDe+QpyRnuim+/O37xni8lLTmyQo31DVEc0+lEpNZCRMRrC6J+Erxxcx7Gzr/DeJzwW11NMfNagfm48NN4BxdsAap4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733265415; c=relaxed/simple;
	bh=qOI/ig1QDv+Wtqaxl61xm8chjhmXcLx8lqKwGKoDZDk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ad3uwYmV1dprUk+zENC8jX0BiGTWEVI/67RcMm/S6MP/7mQwonfhgkT3iLs5g1WkBd/68/SvLg8WlqWGB2k6Qgp8oG3AMAQIsSdpFUCnmbE2J/9y9pWayBa5c4n7UARVdNCeVKtIj9i6CyrhRCIFqOApIMufreKNrwmKbnIvF3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SPRu48bZ; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SPRu48bZ"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-215513ea198so2216815ad.1
        for <patches@lists.linux.dev>; Tue, 03 Dec 2024 14:36:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733265413; x=1733870213; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c0MGb16YH2aWkzNnPP+Ws/sefGovgAngp5l3l7ZM9e8=;
        b=SPRu48bZzapZC3Q+3umABb0TwD5WenjnxrOfu7EADpLCcwpI3G0VDZsOrV0zyH57q2
         ZdS2I3IVDgWYFOpGhasCtXAph04pnYHRlsgjHBjXOLYVdl8gWSJSQ2iZcntj3McOq/k8
         VPQ0RGpHHncqUkMYJb8pWkiGlizUDXD0Nf8lKFKRppIP/byjoBdn9CZwvMoRz0BVt/RP
         /lOJqlwnLLscCfTmuUpsgqVMsWhvGe4/+TGzQAlka2l7R3i3vWWem/CSPjycJ0aDbtrS
         oDZz2zJdzT0wQ7mne/3Vbqj4IijWeujyuV495n5xKwomui0ToABPXrvtMDohQZGhyB4T
         kU3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733265413; x=1733870213;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c0MGb16YH2aWkzNnPP+Ws/sefGovgAngp5l3l7ZM9e8=;
        b=C9aA33A6LhOVTCm9BpdcSbNZSw4ScsX6p2/1SXT1QG6UaZqZvHauQ8ZiWIH9Lx6JS8
         zOQHbU4Z7iCVMac+W6h7gBi4oXideL1xv/cgrRT+KXhgDdyZmQxztF9ztJA7Bg/Y0F8t
         7RrDFNDg+b7t45HLWlyBwTXhpiPw9PesEc/SNTMq6AhnGR06YJvUSSPEa2X1aGh1HZG0
         XdtgR2ivkMN1UOBqcVc/BNf5OxNEEsgFgTTh8J4zO54XsFPdgQGd9pXQvQj0IhZCJXzB
         xbQjCUl3mbmsspKqF52Jyn7bD36Mz1RGWeMoEgRUk+Ukzbb8XkXLoa0+cGRjSKIhbjzj
         teSw==
X-Gm-Message-State: AOJu0Yz6bxY2VCSJX0fCvEGObz6JHkUjMqc0i+OLbNm7a7IwbTeaJDPw
	7McIE57SQwEkZqZEMNa/kn3rqi3Pj/8HOrOHhhwdSzimVK8Zr6l6
X-Gm-Gg: ASbGncvjm0CK2fTN6E02y71AXPAgAmjUgOj1PyaArJWQhTwsJ3ldtY/XqYouO238y9h
	QQ8MofNGIYdQvZs3UjQaiVgSiy630jqOpDa76DD8hKrBHhMuQkrVkDcPhB8DY2R/0yWArNXh4cJ
	E+7Yj+0u8z/NtqktNTVVVAUE5T8Lb3chjgMSaHq3ykYK4qlJ60hh6kTPGjDfcC6tciE/N+KcklJ
	BuWDqkJbOEfVYNPtxOu1vePmfPL1h8u184q5bwrCjWiAp0kasmbe9ykesqQlLUNFMo8B7lsHZhC
	tA==
X-Google-Smtp-Source: AGHT+IHG8yy/5ZNzwUCkxKjCQQfRjePsw3KTiv6MjhBgxNc20eGp6xaX9Myomz22N9ui8afV0b1Keg==
X-Received: by 2002:a17:902:db10:b0:215:65c2:f3f2 with SMTP id d9443c01a7336-21565c2f650mr243763255ad.6.1733265413165;
        Tue, 03 Dec 2024 14:36:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21589aa5478sm45813675ad.59.2024.12.03.14.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Dec 2024 14:36:52 -0800 (PST)
Message-ID: <5eeb1f9c-2b9f-49f1-9861-051478a8630d@gmail.com>
Date: Tue, 3 Dec 2024 14:36:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/826] 6.12.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241203144743.428732212@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.2 release.
> There are 826 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:45:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same build issue as the one reported for perf on 6.11.11-rc1:

util/stat-display.c: In function 'uniquify_event_name':
util/stat-display.c:895:45: error: 'struct evsel' has no member named 
'alternate_hw_config'
   895 |         if (counter->pmu->is_core && 
counter->alternate_hw_config != PERF_COUNT_HW_MAX)
       |                                             ^~

caused by 629f9fa8142105b4cb07e9b4d4452dab0ca40914 ("perf stat: Uniquify 
event name improvements")
-- 
Florian
