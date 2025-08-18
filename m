Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E22F2773C1
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 17:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755539867; cv=none; b=DT7KH2R4Hv/GVDypyUpBWR8QVavkThMzMmIC+cOEDEXJ/ftsxmu41bCnAJK53eHMj3Q89ofLgLR0DRTTBUeZ62A2pYZ75+9SFhd29AD/YqDMkCd/r07nqC78jToAqZpA3w5oY2QdOm1P7y3QQoUgoYW/qsPhPLMzZNCH969DVOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755539867; c=relaxed/simple;
	bh=7reA1nrrhuVsRD/BNRdqB4StM9Zzk+kKYzf7IJRxOvM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lxa/E961RNwK8pYFEuz264261jW/c/BZkhCL/hj4ogdlWavhzKEisnIeguw+WQ+nW8wrPXYvdFBbHVUDRQ3OEt3n+drKMOdOsCp/BxF3CEOXsnPuXObCFeLTvnQEYjpVoKOQc+b2Y/EXFtW8dCeZ36cpW7vfOldhxIC9L4gxEsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UuBg0XH0; arc=none smtp.client-ip=209.85.222.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UuBg0XH0"
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-7e87050b077so646181885a.1
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 10:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755539865; x=1756144665; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=5dpAAc7F/8e7I8kDQez5QitfInVFnriBvKVZ+tJof7o=;
        b=UuBg0XH0VrDPvzG0VByx0IcQ2z6m0AjEVziUNR7Pja7Bjur9dPrZ7ghc6mbOXW18Cb
         JZkX1nvf1AgvPtBgeWu+0rTm6MF3QbOCeAJSqEC0GRw8LKKwLwEzYkWwKblmVcwDZIu5
         9z6Ak9cht7VWnzODwb2IsIgkmHly8Xhhy3no5ZfIsydRlaXf2/wUwJmRTlOnE5tXHVwV
         kX2W33h3290pLw7+BRAZnk2eRcCWGyQ++iPFE9NxHhHUGkHp7+WR7hMBMcrFAu108XcK
         Mbath8Hnxz/A8lordMfPxEaH2i7ibjsc4k7ucZzpueL/fLjmA5hl48dVo80y9k4YhjFV
         ln4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755539865; x=1756144665;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5dpAAc7F/8e7I8kDQez5QitfInVFnriBvKVZ+tJof7o=;
        b=MgGqbbzcI5y5N7izhQHb154Htcr4FxUq3SdhuSML3Zwf12Td+GVBmmFXdUyB9VAxKH
         ERsfljRQVWv+xyKp8SG4n106NfbgeE+rwVBJggjrW5vtdb4HdhrX5ClV3q7yIBWsIqRo
         /qKeBdw8mLSDWkcriIYxT+jQFn7yCmWs3/5W8QpWIEM8gIycVQ/dintKr5xPIe7dvMqe
         mxJhVF72aDO1bUwdkk8pqE7BcRiJQ6OFzsgunYneAX0TeLL5OnD7QBiNed9P8ONBMUfR
         sTuv3WdCy0sGH4OzFCq3fA0it52Y3zvX1ccsQYtwIs+8PErAMBQKdzCSqTsdqiBo3vRk
         TtWw==
X-Gm-Message-State: AOJu0YzkljFPyC7dIFIH7ZxAavVL1a2hML7sRMlXY6aWdHL0dqj/3Dzt
	ByE/I50l6/WYUYSSjdfXdMUzcEuZYyKDYXzpMwsoQ9HMdPSPsWDS+LTw
X-Gm-Gg: ASbGncs8h2EBls9InJ+AsvC0ICDLf/PpBzQiZ9MUR8L/CEYIMycAtPQUbgbqDQqeWRu
	7zAXKpeTGsyeLupTH1I1LqNeqAH6bQUnn0P4ALUctNnIxVzWeK6F955AHCepv8M8FyrUGZ4f47Q
	2jr8UwXU92pNJ+NXQNlmn7VBqEZDj3OGrSfDdLTZbU58MyW2W+uRC8Ah+cut9cFpccA8ZqYd7M3
	0j4Jb0AQ2KcSRXMZdGUKlO4MmahXxaQUXsNRVSuTLTLBw8lGZcJWJeRhwNWgza8x4BYNsfrGz1j
	jbsIXWnRCnDyEsWGYWdlfa22k3P7VEg+HMN1eE7hUC0iMQFQE4WhP5yhw4twkbYDhsULm2xYOJc
	Z5CrlmJkviA4ae48AMcIB/cXQ9BJkBks9yljfNoDjn2msO/0EpA==
X-Google-Smtp-Source: AGHT+IHYzzYhD1kG1DP3lCnGlBxWAQqboJMYhFCESN69WTGlbet6GMtTiUgPse6bErG/6aS9jEO+5w==
X-Received: by 2002:a05:622a:2485:b0:4b0:71e9:1f99 with SMTP id d75a77b69052e-4b12a74e55bmr121025781cf.30.1755539865088;
        Mon, 18 Aug 2025 10:57:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b11de44f76sm55428721cf.50.2025.08.18.10.57.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 10:57:44 -0700 (PDT)
Message-ID: <831e5459-a8f2-454f-8c2d-3d96c01c6c8e@gmail.com>
Date: Mon, 18 Aug 2025 10:57:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250818124505.781598737@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 05:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
