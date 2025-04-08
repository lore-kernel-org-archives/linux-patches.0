Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E8D74A21
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 23:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744153542; cv=none; b=KUqEI/zC/adYa6mATZHp1ZVah1lltJHNTKH0Xxuu6PGEJKWDcIIls9LZo8Mof8wrkGes4YmS+DUXxXYxsxIzF65prejrpZ8ktw4uLxRowmTksJ60ZCM2bYz+9vOaPIXq7pOgoluyJxCvP0o/Y88T9ObDRDQRffrhFqFWG2lQfWI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744153542; c=relaxed/simple;
	bh=LVaRNYh6WMVe5PCaDela1SyPvvoOx30n+RRZDnS3rNQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kxe1FXVUCXI+WLsJZD3dukCBYMlHePullV0xL9owOfAliU+njc/QyChb1ghoMew3ZYywqiiah4eu2ssACeFaWOuTMt0HYHkbU3B+3M3Hjqy7pSZQAYkZewv6mUt7oOVdmqHVQuFVsJRIq61X8ocZgOkHUM8CbD1WenCtNoAnItQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hDvTe0lG; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hDvTe0lG"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2264aefc45dso78499795ad.0
        for <patches@lists.linux.dev>; Tue, 08 Apr 2025 16:05:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1744153540; x=1744758340; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=KgDaWD7pBfobOcPiH9eCDq3XorE+3xfuNlgtuPHnMwo=;
        b=hDvTe0lG8ftxRSyh+jfEEih8h6t4eP1j/8dL+TQBTcuq5V6bHUF1Qfmql8z4t8via7
         5KF00ffUfDrfiNv5KxX6ryY4zp/2+lg2xTZ4Re7x5/8uXjfck1kmYM1K3xWCiJLaHR6Q
         FlbkkZ4jeZcmFbKCgdKp9WrXE3SXOfkA/GvojlSCz8Fe+GW3Dy1KE/9HYL3ba4FA79e2
         toqrytRGbiRKtK38aqL8T15hUmdREOkEE39meyUthEA2Z5VIw6+1H0T7IyI6fTZVm/lM
         lodMKe/VgnfDUE3qoJRZLAQlabLUNre+Mj8l4P1ADDaPUgzrm4zz1JclsPBAUvt8vbJu
         p9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744153540; x=1744758340;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KgDaWD7pBfobOcPiH9eCDq3XorE+3xfuNlgtuPHnMwo=;
        b=ht9VhAkX7cYhKTmDMNn0WCtFig4uDO4iBdkD4Rg/PYwxmlgsAq4NcjKCIONXhi197C
         rDwq92HBSJ4ylQRhs1SPNtf+DZ32ry9Z0Bgac3vFow1n42jBqxjTSK0L7roA/XedfYCT
         DrGNjrEgS5N2ZZVkgL4fupYrmJGG3q0/RS5lVrKM8FIY+YRa4JT+TA6H3m3qjNqrfabq
         fGB/fk8q5LifYUZxL5VwPwiH//ZMKKmule3zRnj3qeyNh9f8ZS0u3tckMRXl3Rx0GjuL
         IXilIGHU4ry+49BDQ7anb534lJdiLkLGncwk457536HIeQhqpTzrYZ3FunqBoLdBZDO0
         D61Q==
X-Gm-Message-State: AOJu0YywBIX9DYeZk/6diKgB1GknXz97stB+e4nxvQvSCb9VL9wTlRuJ
	Q5Llo4l8+GIBve5JBe8wrSRXIGIf/GmFjhDT8smEcDhR5Rr1CRRQ
X-Gm-Gg: ASbGncvmP0Kc6PCGJdEVxj+EY/iv6Xk+/aDQqFFjB8hR4V3HOORn01Fyrm5fIYYfH3a
	M41nyrHq64cIcVPNPeMAuTAjd6gdMXuJHUKdwayQVqbtboWbpkClHFVWuZ5WzyNgQ+8u+sWIPP4
	EsrVLqXdIG2NUrn0qWAqYaOd+IYXIP+bJCNq7lkpvzvUgCYAwZO1PEb8StLJFyNYWD1Jp1TeujJ
	Npu2CQDfO3PeANZsZrtaAIqXg+aJT2+GoZz7HfhC7xz1sggpIsA1kOTOQZ1pOKq6Mg7Z2bMbW/C
	Kvi1DbgpreiENMOODxpzfcFgrkpkPvXG5mvKaNYcsqXcdCAXjdKb3tsA0AAgkjvSFTWHc+Pt
X-Google-Smtp-Source: AGHT+IF+qqPKnrQM93G0gkP/m6WyZu8TD1szV6n/zNvLwqFHhzCeyrLFxiZpJKo+0FnB7aiPGghkkQ==
X-Received: by 2002:a17:902:fc85:b0:224:f12:3734 with SMTP id d9443c01a7336-22ac29b52bamr14842315ad.30.1744153540347;
        Tue, 08 Apr 2025 16:05:40 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2297865e491sm106573935ad.153.2025.04.08.16.05.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Apr 2025 16:05:39 -0700 (PDT)
Message-ID: <929581ef-cc54-4619-8f4d-0e0f3369a38c@gmail.com>
Date: Tue, 8 Apr 2025 16:05:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/728] 6.14.2-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408195232.204375459@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250408195232.204375459@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 12:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.2 release.
> There are 728 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 19:51:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.2-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

perf fails to build with:

util/hist.c: In function '__hists__add_entry':
util/hist.c:745:37: error: 'struct addr_location' has no member named 
'parallelism'
   745 |                 .parallelism    = al->parallelism,
       |                                     ^~
make[6]: *** 
[/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/build/Makefile.build:86: 
/local/users/fainelli/buildroot/output/arm64/build/linux-custom/tools/perf/util/hist.o] 
Error 1

-- 
Florian
