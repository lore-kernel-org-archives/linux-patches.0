Received: from mail-il1-f193.google.com (mail-il1-f193.google.com [209.85.166.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68F8350D6A
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 19:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762890433; cv=none; b=jUB49CJpZS2Hao/t7MqpN9xwkLsO1/JQHHJPF/PUGhv2Tpbe6KKd28EZLfzgW+Ufm6oZMHZutzAS7pT0FXm9RRG++g+OvFUVvtW71W8QC1kyt2/dZ7aIF1HQLRBvjhO5uwEjA3tloTiTodZKpU17Kix5l4fowJKDOBtMEpTb774=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762890433; c=relaxed/simple;
	bh=ZrW+cL6/6u+Ohf+JzfSVkT6ZAGlURKmwD1lBTmPGJbo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJP/EfspYqIQnNXrCFAkfShauYoNydt/MofuMocxPQg8aLAo7JkQOVj4HR8QrI01EbiFogR4DJ2iNMKIVb7HRC0yzEZMpDVBvFWH/fj5Ro6rr+e29MfPFgiDu+WrqMD9wJUU4NDHkngIdeUCnKzbaJU5D4JctmtFRqRga8wXLgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=PKzKxb+D; arc=none smtp.client-ip=209.85.166.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="PKzKxb+D"
Received: by mail-il1-f193.google.com with SMTP id e9e14a558f8ab-43377ee4825so208075ab.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 11:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1762890431; x=1763495231; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZvmJ8eLa//4NsRGRjplCnKOxzOcbE/faHx1blTowx+I=;
        b=PKzKxb+DQ3cJZ6+xPpT/6BW2WkPcZh+SBnMekXN0WzW4LQeCd17imsofp/QB/pdSl/
         AqyxKdr3MyOEIvh0vfr236vwOGr5EKPHXO5YEHvv70GIK/r60n8c1rLkLw+bvo5jf4R2
         tQ8njPFXLDVGIUSI8OcbZnf2xRh4GUklU9bXv85+gR6gKnzxV2Cwl1eUJ1U5sKmuCX0E
         LbMS4KLaWy4Oqkd100NHP46qh4A/20Q32PMJe0jfjNtXvvnUNmM9BIxMjf/WRce//2yx
         L4o5hYWqRLhwOrlG9H3kD5au5G5h975uO4MoP2mP+WQXmgZX0MAOW/h7oyXID7Nvfh+S
         dpZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762890431; x=1763495231;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZvmJ8eLa//4NsRGRjplCnKOxzOcbE/faHx1blTowx+I=;
        b=rLO1LVxs4QUiGtNdV2UBLySlF2VVWm43vE23DZp4ekRO52KRCvE6qI5tm47FOfo7Th
         lyNMEdNQ1G7quXbjxx8e/Hp9NEt5l/P9dHWJCOGtdEl7UXDeJcCJ4yAiAkWFlQrJ6wD9
         rzz4IorzRESkpVKTyBpLfYsqOS3kiMwQAwcQrGl6gCFZQMiY4BAz2JWegzbNNb7N6Ao6
         dqse5GmAvkXsOSkPBszTOfU1KAKN9eq+GJCVp2pSSf6USuTzpOPLw+9PZ7EBwqRU7i1m
         /pz2JExASgwHFPjfjlX4GVqclVKO36xTESIiPpJLQTMyVkgneG6FHipO8T6fGs0Lnxga
         KSkA==
X-Gm-Message-State: AOJu0YzNak74deBdlCNzEOJgXeqwjU4vb8GKRMauAsicqka3kx4rIma9
	Eqd9JAg0B8wkMxVUX2MOpGRDs0zkrQPVKysv0vcnbnJaiq7jFjvDL7AUDDPDTXhGggE=
X-Gm-Gg: ASbGncsH6u2puqwvqUPiU1b5xuq9OEjHr4q2Rcb/w7tOqlSz+yh9Ucl/i+rZlq3T2Px
	WIUzrEON9PfBe4jvNujC/yHUSkSJeIoo6iRoXHnJTuona8JaV/ueaD3xyRjpxP3nxKCikaVgLYf
	WEYwWSeKorU82kS3LMBg9lgoxX8zYFcxAxShA+i1/W0Qw4UcLOP8VlLQK3+7N+KoI+CHhRWyo/n
	D7mgtjUEYxO9Ov8C29YFgEpfWtbPvhXZQTRsDEockNHns6z/nSRjGxGbwOlitIlemZKPb48Omra
	DIu0DKR2OveRaGqSOnZQ2qfPfIOBOPK0JFRZ+tSMNx7cnEZ9KkdGy7OdxOJRS+LPpga+z7h9hQU
	e4IEwgzMb7IACrfmK9NPVuHk6NsemWeTrslOmgAiO9DoXKwbIiNT7MvSByaAGpLsXl5qDOaOtk1
	hXisH+egSWTDbln5s=
X-Google-Smtp-Source: AGHT+IEFzUXrbqx24P+kXe5zMwKwFMHqOAgKW6mk9ecTAQgOVV1SJVteL9W3Xh6SnyVk+zsjwHpNnQ==
X-Received: by 2002:a05:6e02:304a:b0:433:551d:5f2c with SMTP id e9e14a558f8ab-43473db30f7mr5000705ab.29.1762890431000;
        Tue, 11 Nov 2025 11:47:11 -0800 (PST)
Received: from [192.168.5.95] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4347338d54esm2244295ab.22.2025.11.11.11.47.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 11:47:09 -0800 (PST)
Message-ID: <07d63659-72b1-43d0-9139-2a0b6d73edd4@sladewatkins.com>
Date: Tue, 11 Nov 2025 14:47:06 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/565] 6.12.58-rc1 review
To: Shuah Khan <skhan@linuxfoundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251111004526.816196597@linuxfoundation.org>
 <641427c7-0069-4bee-8e6a-53347654a926@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <641427c7-0069-4bee-8e6a-53347654a926@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/2025 1:00 PM, Shuah Khan wrote:
> I am seeing a build failure on my system - the following
> commit could be the reason.
> 
>>
>> Heiner Kallweit <hkallweit1@gmail.com>
>>      net: phy: fix phy_disable_eee
>>

Hey Shuah,

Just to save you some time, this patch was already dropped from 
6.12.58-rc2! :)

rc2: 
https://lore.kernel.org/stable/20251111012348.571643096@linuxfoundation.org/

> drivers/net/phy/phy_device.c: In function ‘phy_disable_eee’:
> drivers/net/phy/phy_device.c:3061:29: error: passing argument 1 of 
> ‘linkmode_fill’ makes pointer from integer without a cast [-Wint- 
> conversion]
>   3061 |         linkmode_fill(phydev->eee_broken_modes);
>        |                       ~~~~~~^~~~~~~~~~~~~~~~~~
>        |                             |
>        |                             u32 {aka unsigned int}
> 
> I will go build it without this and update you.
> 
> thanks,
> -- Shuah
> 

Best,
Slade
