Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9447513DBAA
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 23:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720047658; cv=none; b=HiYvuox7IljY5NApy1T0B1fWbw3mlGZck2KOw/AWM/kFEua7ENAkCGYtVBzf+hiQ+CPLY1jEOofEGrrVvrryHe1vM8vVkFuwwSrwL9ANTgPT67pYl/Mmjm3fPm5E/oo/JkbEwFKf9IZiqnO1P9iKY7GCFJvZ0NuDu6YzvxrDUe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720047658; c=relaxed/simple;
	bh=VHyv/MRVW+WTFhYaGnV3MOif7DUzQliFa8DPM52lXxo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s2ymV38LC9+iUmKM8vEwr4mpjzlsoPqbh7hkBgJ5+M0p+ikupf2AdMEv0XWtri6wTEjhfXzyFkSWZmfqB0TTOsQoNPUkt9Tk/9UoVA8GxECDhye55BQiKxkYwb1F3mjqpQDbQQttivxZHbyYl7di0C3W8GBJUI3SPV/NTcZ5UH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xxwc1rKj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xxwc1rKj"
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3745eb24ffaso34005ab.1
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 16:00:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1720047655; x=1720652455; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gaNGuPgmfmqVDw17Fg7WUhOBboXfNjYBg+GGHoJDUOQ=;
        b=Xxwc1rKjFdmzncgmxbNhNWqFINd/a+MnCITihpDab3iAxfcB3MuL+uBUAsooHQKKF7
         gpTLxdSfMAMKil8z/N0lH86L1RKhP4aILoh69rrGa9GDRZ0IR/NY0XiyNfcy4jEF8nml
         egoh3FMoVUTh+yzG8WgJ8N1xlIMwWZ+UtltC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720047655; x=1720652455;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gaNGuPgmfmqVDw17Fg7WUhOBboXfNjYBg+GGHoJDUOQ=;
        b=gOSWZpCOKeRlMYCfF/VMF422NzOveCBTMZCM6m+0dYPXB+NGaUAe04MEDS1ViD78jE
         UB3pZYt06aHzCt1ga3qVe/EI332/Omg/as/Dqn+aCUWshA7ykC1B6pNyYW/TLaKNqTlc
         RNo7UrtuQ1wLxAnrMToQWdlh2B0VDmppOeOC3LiA6VRUF5Q0FguW4Qd8lqWy08Lolj+6
         RHPY0uWGsSoWkdJ7K0hw/OG848+UhyQJADIjQM8hIRFIEVyugxUysKwQBRPGpFCABWwz
         pwKniF/9i8nh1TTyYmc+1/PaKpUi9JqRdWu1+ICwtJKTEpwDZgB/jwWawzAuwYP/SKZV
         Nlxg==
X-Gm-Message-State: AOJu0YwYD8wVUspkxr68d1tPI8PVcM1KWC7A0x9b8WGNV0sl+t2/fJTO
	91EiFsvnT15cqT1XjFLQYRHemQiiZnP0ZRTxSk4WRR7CIq4y0XTHC/4Mtnrs2cU=
X-Google-Smtp-Source: AGHT+IHz9n+Gt9WGxmI6Wh1bYRd6WGaEgA2QfMUYbKqtbN5k5a+OnZFmL04YQ3gW4hYStFJwJ/L5KQ==
X-Received: by 2002:a05:6602:634e:b0:7f6:52a7:69aa with SMTP id ca18e2360f4ac-7f66dee2ea1mr7367839f.1.1720047654608;
        Wed, 03 Jul 2024 16:00:54 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4bb73dd7bacsm3616714173.65.2024.07.03.16.00.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jul 2024 16:00:54 -0700 (PDT)
Message-ID: <b7b4bf0d-35e8-41c1-ae0a-e91483e465a2@linuxfoundation.org>
Date: Wed, 3 Jul 2024 17:00:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240703102913.093882413@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/24 04:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
