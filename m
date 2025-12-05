Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82DCC2D3739
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 17:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764957388; cv=none; b=LF9Xnuh2FDCv8xGlaSYCXRPe1LirtKxQOQX6GbY/ZFQrhOv/h5h3suipMlBDe/jqmkmAAkLh9YAlIhK6k8vWONyc8QbD2AP3NOaxqyv5aYPmoyxVwh4D8MI7IPZzEqMzQbtVac9Yxk7hVxL+nEvzdaoTH/ajkS2NSWypI0vgQsU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764957388; c=relaxed/simple;
	bh=bmISz4wUHFCj2fNIPw8dlmlYdcyJ4m7YE6ev17DazPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QcEptuenhLeCyFjtvTOSwXi4e6FvegFMlnjO/7u3oNeD+s5CeB7xRU3THaAXKysn55OLk8WR8t05XqNHR84BScaSMpuO6nHuxMCFD8o1uWZo+UnFxeI830bmEZz6S35wX0BBEwY8wJNR7B/3+GvGIzDuXnbXsRuPYQfpjmo7gIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mC5mQvKG; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mC5mQvKG"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-42e2b80ab25so1140806f8f.1
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 09:56:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764957385; x=1765562185; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kEgKo/l9HOuNeryVXSYMwjnWbEw58DLyjo3pfWvSHQE=;
        b=mC5mQvKGqAGiZoyXBCklsvqtU9wxULbRO/TjDn4d4bZH2SyeGEVY9u0g90na6thY+4
         btX2arWFef2qUtXHQDN+0CFUAzz4GSjb57FpW7DEVWdR/2Du3CC6ZgcBxNXDoqLkGY62
         RbzplVIhD9OStSaFQ4KGXFWL72651BhYs9aShhjleBJJ0QBnAHr+PMqE9PvjZuhPTnxW
         m6ifobJE0OpizCMtEDq5XYkIJdNdT3DDRDnhRgFq1TbGKBqJWaJJ6AD88579a8T5nIc2
         3g96laPAzqj2CBA3OHQn2ay4io/Mv2zBSbO3hKm0VzTTUykq+6zgR3RUTyvlaXWmqhAF
         2OsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764957385; x=1765562185;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kEgKo/l9HOuNeryVXSYMwjnWbEw58DLyjo3pfWvSHQE=;
        b=ILid0TeahMdeBKf6qwQT8/du1F/YNJf9eDIgHhXxvpEzPJbkL6x4nUNqBebq850yFQ
         9s/IvZZC0oMLrdXL57d2r4eN5Col4tKl0rxetHAbAY9Hzotly62UKHkoDId6YqCtJGlv
         /u3g3uTILUumBQIxhoWdDhYXYyukpZx90Nl96W1OFP4Lo9wqzNf8XgHgVNTuM/4MySMY
         cEF7z7eMM5ARkipSehOVQzE6yH38x81Jybbk4JfBcpX6BdXjee7A7ghC1bLhmoSpy5sZ
         SX4m5Q1Te6UqRRn31hwXJu1i/ZJ3scRfy99WWBPjgeNZCPij7RHhyC4YE+C69hz6K6lk
         y2BQ==
X-Gm-Message-State: AOJu0Yw5p45bsQswxVWdcfMri6aHikR6QEtGjflAFuvo1u0wWagfSzyh
	ejPDphk1KqIXh/ue2c8feVxndmluwppexTDFnWrhSAikYQgyaO0b0Iqd
X-Gm-Gg: ASbGncu3IkkSLRu/MyBxjbPfm1wYS9nsKmik21cP5RIitqGtv9dp+j5meXc9Y/Vzqor
	ys7H35x9MeA/9NeOF0ubUReWpHsVmZrWC2i5RoFA4KLXqbN9r0tuvK1+AZd2AEtdtfObjL9yDrp
	sCm3pBJCHmj8RuzlWl/T4qQW1AzHOMDNYLk4Q7LoQMBpgvLDLEMsAamJFkSsEWOC9gQPbfwTKJ9
	FWah8cGe4/Quq3Z+ZKHP4BF7GbS7OfHU6VFORJMDHIIsvJr7qo/r6qhuoO7LS6cqXCK0l3l2rv8
	0MZ0ucg9WmWQxvDUUl1HYMskfMvaKPWx4cmNxtlXggwSweMlX6eW3KBjnIRMBv+tuu8ffMJBRk3
	Lr0zFTrMaIAkDeH6X0g1x5rMAxD9tBFpo3tZ/aX+vEE1cRUZCAu4lJRxgBJHds1IsWfztqQEnSO
	Ij09KqCheDUO3vwxhenP4G66Tgrj0YaCzWT7mDxSROtBimsbxW
X-Google-Smtp-Source: AGHT+IENm9zx8V7Tz0VXVGQhR9hdKMItPaS3QDNcTYQiQgg6kiMV16jXfg5TmA44Yga6DhrQU/Zk5w==
X-Received: by 2002:a05:6000:22c9:b0:42b:30d4:e3f0 with SMTP id ffacd0b85a97d-42f89f0e237mr49229f8f.22.1764957384592;
        Fri, 05 Dec 2025 09:56:24 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7d353be1sm9479087f8f.39.2025.12.05.09.56.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 09:56:22 -0800 (PST)
Message-ID: <198f8eb4-18a9-414b-bcec-fe44ea508e58@gmail.com>
Date: Fri, 5 Dec 2025 09:56:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/567] 6.1.159-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251204163841.693429967@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251204163841.693429967@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc2.gz
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
