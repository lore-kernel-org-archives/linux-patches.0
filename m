Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8512713D278
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 21:39:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718919545; cv=none; b=eUKVMFm56F4XFkwslYD++qFUVVJJ+4oJXdfeXltqmP8wiAnan7p/Pvm3S229gIYtrLHlDCXugtx2V5Z+aUoiB12C9F3z2N9+0+3ufIgxp6zMnCWQH/zIBhI8N2Fh/Qd9FnnBtZnHRsqvx+5sTBWE0eq8F0tiTDOUT7dHGb0NJ+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718919545; c=relaxed/simple;
	bh=4eUDbUYwi0pZS4XXlB9XJEj7hUZz/ZHaKyzWK04Nkvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y9+ippe7g1Y6kG1XGv/2mDSjx5kbaOwyans95OmLk+TPSmqiGYMgMwzkcNWX6g2nXaFNoIU4+LwynrYKJlcC2jsTaNwCmYc10gvU0mXtOR71BS9ilxpp7/ANoR/q3XKpAaTNIa/nRx/DVMjQmM/me8RIxzCct0w1GXODuZvPHOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YONFMDaf; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YONFMDaf"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7eb41831704so5828439f.1
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 14:39:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718919543; x=1719524343; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqHqvsSXJkneKAj++iJItugXBOlFHRP56AEPjUJ8ns4=;
        b=YONFMDafTZPxeJ/3NpOYC+1MKGon7xDOZx/Jaa6wYIHWDeW/GNBWAjzi3xYkSf6Je/
         wSp4eom+8LiRPrSl/O+In2ESuaz3yTieZBlUD7+OyU05911hYYGrmxN5D7WYf3UsFqaX
         pQ1kRyyPGv+kIgtKcPasu7T6z82ocz1e98/KE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718919543; x=1719524343;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mqHqvsSXJkneKAj++iJItugXBOlFHRP56AEPjUJ8ns4=;
        b=YG6JqYfhzwkI9NmFpkJddcpJIregikls8VcRGCWptsckW9F5SxnNodxjn/T4nw+4+U
         kuYusaMWqkTN10kSZPJzKrx7GgSLHe5pSqbKl8Mt5pUx2IuwtNsFsJRePYbatIPjYh9p
         pUH0MVcoNTR75oXnyq6+3BU4CBDbFfL6rOsfrdGf26RH+yZoPwPFVqrXFQA6JB0UcKL5
         X/cqZ1//+7zU+Al5OrN0j8Pk6VirT/J26DoVD9uhgbG7IXZRPkTDBfBuD/p+qXSqF8qj
         OW/1+QgbIiA89lFazjzWCxFbEUfHhQfx6L0jrQnxnOh+iX003hgGMuItmxAsRVPpJX/L
         JVOQ==
X-Gm-Message-State: AOJu0YyjqzGbiPKdc1bZryNCV2WvRrcV2o69TRlpjLpDJ/yD8AfsAaRs
	iAaAHxRAxYZjiDPNY0moj7EVYOJGiG+Wu6jiEKJzF4BfgX0T58r/aNimVe0ocns=
X-Google-Smtp-Source: AGHT+IG/MKrOHHu7bE0kz3/5P963pbzGNqZC6AtUsEQh8fvGhgnXsQm99vnIjQE3jJmQk8fO52HZGw==
X-Received: by 2002:a05:6602:3b84:b0:7eb:73f1:1357 with SMTP id ca18e2360f4ac-7f13eb9a591mr706580139f.0.1718919542734;
        Thu, 20 Jun 2024 14:39:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-7f391ff194dsm3069739f.23.2024.06.20.14.39.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Jun 2024 14:39:02 -0700 (PDT)
Message-ID: <7475d8c8-318a-4f8c-b4a7-c2a0be59d304@linuxfoundation.org>
Date: Thu, 20 Jun 2024 15:39:01 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240619125556.491243678@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/24 06:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
