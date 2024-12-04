Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59C20C473
	for <patches@lists.linux.dev>; Wed,  4 Dec 2024 16:55:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733331323; cv=none; b=oE1D40PhfIvq7BtDtP61G1aVnE0CLrlbw/SCr3C3blL7Kqj9bM20gKq7gLxiatsIg0sixRa60JdjFA+oMo1zQ3sOOyheYBsp/6YXWVZ/RB9/a81e2RfWSsZg8J+iU1Kz9Te4NmPxOtTyY/AxUjUPDJeOExW1hSMc9UHV33KqrB0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733331323; c=relaxed/simple;
	bh=50xntMHu6DoF5HbqKeUR5WTuI4girmXp5E2jTq+5v/0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jFdL7BGrvtSOZ4Q8BjGPEvD5ngdvXYAtXcQXWzTGqAGflzccQcAhlQooIJx8twJidCWvei2y9MNvknokq8WQzVbrH2mtsN8N3ZKOQ0CipesODHGG0bLGFG7gvBgDPsrDhJbLgTWe9JEUiIzqaz10vGCZnUl7QeYpVXB6PZ330is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=an488T33; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="an488T33"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-8418f849466so235998739f.1
        for <patches@lists.linux.dev>; Wed, 04 Dec 2024 08:55:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1733331321; x=1733936121; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X9rvImidU/UNWdG1VLr1J9XNVi7IRCZUz2k0Jnz9nrQ=;
        b=an488T33ZgzPI21z4oTxWFzSqOKNlIWio3cXgjIkO98riTwfVgSyJg3UYsO6Lqe3wq
         cO6+g4vqqB5AZIXcZRqeDy0aL7hXy+VTitKEDb7TgeaxQe7nG1okGxCPi4x9eWfo7ypl
         jkoiIFbr4l2P1yAT6xF3cM5k2Ggc6yvEWQfYc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733331321; x=1733936121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9rvImidU/UNWdG1VLr1J9XNVi7IRCZUz2k0Jnz9nrQ=;
        b=p+J3/sU6ITWPFBFvyLXUy2Mj10pNHGVeA7An7kAOuoHCUzpt5rnm6iLtzq+V9yOWl2
         1XF8jdWNvgrI7W7X2KOC7IIJAiQ7gFAUUY2NVqMLr9+lrUQg5j1EQnHnRDZlh+zWKnzM
         AGqVwT6hfdzXauPxgl9OuTccJGFRVOMrQ4YxkuQCJ+buqu9FvTvBIbGfSOFvMDI3q/3h
         +4qcM7HUdeCooMEm/CuueqYSDpR77uJg7b4CTLBT6zG6+8zLwzYbEubU/PHt6cQMaCwD
         2WGkm2sMAznKqAoOq2BIFs73AlpaCdXZd5SWqh18OJKyAFUF9bZ4t6UrUBCvM+iTdqJj
         zfNw==
X-Gm-Message-State: AOJu0YxlJv0XsUzk54jK6dLdMwyw7ZyGrEx/b1UZgpZ9rUfLNIAX3CNl
	fnc+2v/Acaa2Cldq0FsplTcsiyW+KJos+zyNsqoTsHivAvwkLg9EWPGB6BWKAE0=
X-Gm-Gg: ASbGncudguI4fvRn+GQ944Ih6k7VFFNhUYV94LMPKIqrQ01C607yyXYYxrP4RFAaXQx
	ek1hXyZu0Qfi53XPaKCEv8GZUXKvA/nw+rGddFVxKqC5n0U0a/zynFAlQQ0z0n1LZNQlNvAGjub
	GSEEncV72kCMjNIC6MZQIg4OenuvGMHUAR+6NE5yXamBBamPLN9vaCxzLb3b6NnlDYbH2gdeLmu
	qgzlo6cuWd8crs25SOclde3JOLhlUrbeNJVL1sqPX9AKzRDei2j8JnPOh2iMg==
X-Google-Smtp-Source: AGHT+IH1/7Y0wwlKffNss3OdZLCieQ6uhiHOEWOAMvcbuYpAzMo+3UlejFx+5ubYj78zQviYx9B+Wg==
X-Received: by 2002:a05:6602:2c8f:b0:841:a9d3:3b30 with SMTP id ca18e2360f4ac-8445b53e299mr913854939f.1.1733331320966;
        Wed, 04 Dec 2024 08:55:20 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-84405f97db8sm322266239f.34.2024.12.04.08.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Dec 2024 08:55:20 -0800 (PST)
Message-ID: <0218c67a-20c1-44b4-bacc-d392d8163d96@linuxfoundation.org>
Date: Wed, 4 Dec 2024 09:55:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 000/817] 6.11.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/24 07:32, Greg Kroah-Hartman wrote:
> -----------
> Note, this is will probably be the last 6.11.y kernel to be released.
> Please move to the 6.12.y branch at this time.
> -----------
> 
> This is the start of the stable review cycle for the 6.11.11 release.
> There are 817 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 05 Dec 2024 14:36:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
