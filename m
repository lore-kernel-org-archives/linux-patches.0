Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EAA72EB87A
	for <patches@lists.linux.dev>; Mon,  8 Sep 2025 22:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757370939; cv=none; b=hyx84BU9inMu3FLEor2jT8A+CEPQAfGlLhS59gwAxyAWqQ2IvpCfwI63oSc9VnEBzJK0VbEXSJA2sm3fECX4VjyPya4uuSFRitXBQ6umSx5PpWSdNXbQ9apCLmBueSutp5vJfRm9ZGk5KCtmfHcYjRNE8rCxeYm5tXzp15XQU3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757370939; c=relaxed/simple;
	bh=jokPdzy+QFXUQhnXK24Nqj86DGGIIehQPhNMfk587v0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k9Iui/TxsRPV2BJhF4paj8YIHGFmoMb6JW+TDxdHkw+Q8eg2eAVnxIjy3QDdRnXeyPon2XYxa9H4qvfQxV0ravlS9oEBo0oQUQv1wzRFm97atm5+E8wLZmQHaVIUxJd/pas9dvR2ej3n9S8uXYhWD9v3Rf50qkD8QOxpFdQhvGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kk8TmQHC; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kk8TmQHC"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3f664c47ac9so27608845ab.2
        for <patches@lists.linux.dev>; Mon, 08 Sep 2025 15:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1757370935; x=1757975735; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9bjV+b3hh2hO3TSHHe7wU0vMi5wwisl90Tr3zOtLYr0=;
        b=Kk8TmQHCEF77/hABk+UukkFp3PiKmQxnJ8Mb9NUV2w5s+uzU4URLQJrhbjv8Go+qZS
         KnVnGqUyUMBHgNqYWes8oo4Njw9pfHrXiTEE8kPrbHj6CtD0J2cXa/47fobgyQi0+OOM
         AAa8YXGByqil6ckcUZkbMb/VE7hf20/kmLy7w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757370935; x=1757975735;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9bjV+b3hh2hO3TSHHe7wU0vMi5wwisl90Tr3zOtLYr0=;
        b=dWQxfNwlBUjW4PjNRr76nYeRFKDvC+iy5c2zDbS60lYOZvHbpRTiyQ5SIVeAw2u2xf
         wdUOfaxZoGSW/KkEmfuf4hktvwqLPzODh2M/Ity7X8EkH6KSAtUlZVTFJYfUE7FFAWDm
         bTudEQ2EJOR7vLK+zVGgT+lbLeCKpVDU9F0CIVLwWa+2D1feglll12rTalPwHvf9zZwh
         1XYvr7RpnvUPQluYl+bVN7r7gVjkcgOX3lIiPI0lEmn/ZGhFqP+AP9iPiMNWI4Y7EPQS
         PKkfzi+pbkLO4mgrduDm50+uc2b1wPTBrCv4XYNkWaIUTl21RsyhDVswOesehe5yuLPV
         5Z/A==
X-Gm-Message-State: AOJu0Yxw2TyYJA6KvJ2qZq6IJmwDV5A7c+KR2l2WRedhMTd4qeUu2IAr
	tdHTR6oXYnvSP4GKdBV5/S6G7Ji58YXFeJt965QN27osDR7ysy7rf4FaAO3CiJlS7xI=
X-Gm-Gg: ASbGncvzH+nx2AXJgPHSSCiI+GfxXFb7zg+3KV40r7quXEC8L65Z2gXvYnlvyJzVA0U
	0/6tl4OXM14+ZNL75KnEo7HyY5R69bh/WrlqUrZzRpL9M7l55+L/im/JbQYrzbduFr3VchqqG/U
	mrg7JFVrVxF4+LZst5bi6rRfr8exKfeXchi/KDjgoapXIPUiGPeJSFSrCjSwdwmc2QGLvlNA1aZ
	UFpEQjlD8rZJwSDsn8sqx+ZvfB5sWi4nm4oHhbeG2XIgKtazuPNs4fUq0WPMPp4ugg9WpOcy7CK
	AT5cKqtOKD5x8JBirFfwJVgyqdphwMf2kTtVZxGgxH5UewS1AhWwMlPklWDKqCWSobVsGZ3JUxb
	T/BOZFiUi9SWVhWUy8IMG9VrYkRw8dSdi/zs=
X-Google-Smtp-Source: AGHT+IFkKB76IaSWWVxO1VqoPC1DAvppF9S5WYqdz/wBv8g28ZnA54hUe3zUoEpuXFiSeVDiy/Dncg==
X-Received: by 2002:a05:6e02:164f:b0:3f3:82da:29f2 with SMTP id e9e14a558f8ab-3fd877813e7mr117569685ab.24.1757370935586;
        Mon, 08 Sep 2025 15:35:35 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3f3de24e723sm112127645ab.7.2025.09.08.15.35.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Sep 2025 15:35:35 -0700 (PDT)
Message-ID: <76c82c3c-9d76-4f74-ad44-a6ecad0e6590@linuxfoundation.org>
Date: Mon, 8 Sep 2025 16:35:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/183] 6.16.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/7/25 13:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.6 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
