Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A916733D6E9
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 20:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762893687; cv=none; b=eUiN/qy5d96GSQc/5XABGLE9lEhKM3LcPrK3iG+SjoxppNcc0YFYf1oJuO3FNbP75AitJHyFZic/ewu+Z7lMI2VMPPrkJ4hUKEwtPZymGg6x1DwKEsSHZlwDZmatEeeDlL/3J81qPfFP8KiHUeIDvEsDK75iYU1Xc3RAwyA307s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762893687; c=relaxed/simple;
	bh=YEr04aoMcmyecPDZJfLTTNm/R81XpSd91kOBrbpoX5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DhNj83eadkAl4II0ezDwJSwHG6+y6wg+IGIKzP9iA2ZghRGSu4Uszu+t6WB5OLYTKuEdWzzmSYS81CNv4wSB7a55y/M7lc0EUUxQbM3+mWoVeD//rmbSv9rNsEs3o+gLy+ZXDd5K1gS5WRQbDNEyO3z5/tqktS5rXhtlwRM/4dU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D/5Yexv7; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D/5Yexv7"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-4331d3eea61so820125ab.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 12:41:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1762893685; x=1763498485; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5r/++3mVCJ9xD+Mh5hsq3AQxsTxN+uDvyJmdcqTQc8I=;
        b=D/5Yexv75iv2yh8EgCWCXLqqhu4I+xl5ATtoYlHAxCFycTant/wD46ttPjVq+SDJ2v
         dCo9j/ElJmwPLv4mzT0imUlUjY/guFVV3E5o3BZC7Hnq3Rn3FhfTKen6mtUypYEgXvuK
         560IwfQOQYq/DL5U7RcGUccbgEEDUsYdUetn0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762893685; x=1763498485;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5r/++3mVCJ9xD+Mh5hsq3AQxsTxN+uDvyJmdcqTQc8I=;
        b=pKGEWlPtdHayiWjjnAmesbkdOuMDKwr68dlG5WpPRlIUe7uRAWGTjslu3A32cVupJJ
         laRNw9gKMho7J7/hZRyMN3YBtBSVE1fSXqo3r0q6qNVImgLjxCFtU9lazz7X9xxLPBKr
         Zots/egPSG11b+I0sSh+xtkHBXna7+n6/i2ivkuTRkpy8b96O8jKyl6GbUHVax95UJ9p
         3ZwlKIBCHOkWKxGJ+cbjia+8VRO2bNmpv/ZolOJ9GvqFioDP3rIdDH+ZxznXNIATVOo5
         hNBb6vem+4n72RFFv757QKJtSuvItQevI1osJcUVVbUN4RkUa8A+6dZcEhnjtLAMAlwR
         0+jg==
X-Gm-Message-State: AOJu0YyIcazAAt7mNHUR77aII4QVM8ozO5gRQavE1VJCMjvlrcXl7B7A
	U9d8OJR0N4Xe8thC1+22kWkP39Z3ZfW9k02zRJbw/JXkB9/aqPjj3XGhPkhCWbbpKLk=
X-Gm-Gg: ASbGnctvr+yWD/j0OnCIW6n9/PVeJr3UbetEmWytZ0/2rZoHYKYyOnhLvl+4y0ONbW9
	mJTu9mKcUIVlLnNyJgH7C2J7EJN/LHzFoc8TOMwkzvCvWmoLlErMpBYQ21pn0c7i2nxEuy1XE5O
	fwjpMTV0TJUTTN1+diA9nqNL5tLM0TvSA6PBXMg3mKYxBTzevzZNtPVfcXsf3uosEA03R668ItO
	P8Zli26hZQNSdb6csOpaOMBL0arI0W8Hk9PqoS6fJH1pjQTFQfE8po5E3hFPaRFxQNcEmBCBFS5
	asznqnkoCGpitjTMBtBGjiAY/nJJVHaHZd4LOoOfnt0r3/fysE5C6oLCJVB2cmpfYnKggQxzsof
	E2R3wcdPp21Sj7GfAfgcGSzRtoSfYYZfVrK7r9Ea7wIgL8itl9SWHHUG0KegAzaXXxYYuZYPTEe
	Tlrw4w29FQpoRKNz/foY/BZgw=
X-Google-Smtp-Source: AGHT+IHc85hYIBG9ds9G2pphrlClRxY7dfT0RUGyDwgFy2LVDtnEan/ZgMhySlr1XPzoCUV2ctuLfA==
X-Received: by 2002:a05:6e02:174e:b0:433:5e33:d424 with SMTP id e9e14a558f8ab-43473cff5demr8186165ab.2.1762893684483;
        Tue, 11 Nov 2025 12:41:24 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-4347338d4d7sm2687265ab.20.2025.11.11.12.41.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 12:41:24 -0800 (PST)
Message-ID: <b7cc8106-6383-4035-bf9a-f3abcf0b7da3@linuxfoundation.org>
Date: Tue, 11 Nov 2025 13:41:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/565] 6.12.58-rc1 review
To: Slade Watkins <sr@sladewatkins.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
 <641427c7-0069-4bee-8e6a-53347654a926@linuxfoundation.org>
 <07d63659-72b1-43d0-9139-2a0b6d73edd4@sladewatkins.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <07d63659-72b1-43d0-9139-2a0b6d73edd4@sladewatkins.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/11/25 12:47, Slade Watkins wrote:
> On 11/11/2025 1:00 PM, Shuah Khan wrote:
>> I am seeing a build failure on my system - the following
>> commit could be the reason.
>>
>>>
>>> Heiner Kallweit <hkallweit1@gmail.com>
>>>      net: phy: fix phy_disable_eee
>>>
> 
> Hey Shuah,
> 
> Just to save you some time, this patch was already dropped from 6.12.58-rc2! :)
> 
> rc2: https://lore.kernel.org/stable/20251111012348.571643096@linuxfoundation.org/
> 

Thanks. I noticed that right after sending the email. I am building
rc2 now.

thanks,
-- Shuah
