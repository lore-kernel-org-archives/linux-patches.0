Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7421156968
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 23:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736291801; cv=none; b=aUyUNb+Gqfg0CZPqWhx9z9XJnVgM9BW8LuuQi6wqjFR7OZWTDNN3w4DFNxcPe+lIUsmRhoBWy/Pu1mWT2TpReey+6KpgEVX/ECPD3YY1pIvOB3wAUWhJ2YHIY1tiRelmMXnn5utfRMNYrtTC357DdzBu0I5ZPaqqmOWMw9b4j5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736291801; c=relaxed/simple;
	bh=5f8+vCD+W2ZyJES1S39viCPirAwFDjPa61O7vco6+BU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KkLGoN8Wneyww2CaalVMu2yVlJVcwy3gUqgjQBOBpgI5pI4Q2MTwZoOp/Ha2B2SZkLMCCAfnPRzqpHSxUfFbTVsuCEMHRvO33ztTJjpximi8GVFlfhxy+5xNy7jWz0ei5tGHiFYnJyhQCWcOA8zpSokCl/1rd3xVLGBA1jVJo10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ei0xhXOV; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ei0xhXOV"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-844e10ef3cfso1298721939f.2
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 15:16:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736291799; x=1736896599; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8+KAvtq871rslFmjjmy4HmKCpmB8dEob7QiZmKyRRok=;
        b=ei0xhXOV2Mb6QDcpbjkZqSkV2Er2Hlx8iCcObMuenaXu0s/MOfBQl2/DtLR6S+jxcT
         HkWedFGlA4GMNOgMhU+aZM4jeRWtLU9Z0P6x89bj+IdQx/r+bNA7GksbNfAgowFxkwIQ
         qg+lm6ha7H11GbnYwmdugnSqkssa/L98Z3YWg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736291799; x=1736896599;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8+KAvtq871rslFmjjmy4HmKCpmB8dEob7QiZmKyRRok=;
        b=rk3tbDGrjiKMoHHoIwYusKfCyh1PsznpKn0q9SkLnMHTsHAWOpTfap6C50g/ibKruE
         FVFdJP5DSS06egtwkdWWTOQljHaGYdQes9tis0Ffpalrd5cjCVtfqRryq9mBWcowXosQ
         uMoXTcIWcZHQe1ek/GrVmqCpYI9ZHbwlhI3RsO9gYkrfgwRO6DF//YI5U0dVAbW4mxYn
         d7REvhnfb6crw4IuKco2DNqea6CKG+ZgUpRMMTvFdTwZPFy37HILMDHvkGdNxT+OmPyj
         xcrlAmZapREM9QyqLlgqj6N8nKtetTBzPY0Rg4xgVI8ARhqSGICzjEGaBndq+2hkR2wh
         7eyw==
X-Gm-Message-State: AOJu0YyZlmsoyxG2A6qP+McU9StHkWcoZHvSHKD6cFqz0FJkdSkeaWX+
	baBHLp7XdBpru8QJ39DetnE+aJQihJph/Q6uo9R8Di7fI/mddoREhiExGJfO1HM=
X-Gm-Gg: ASbGncu0UwmCa3zYN7fAfTzdltx3Y2o7Uo/4TwHy0YNJmhPURDB8VrIYt/ZMvQx9fJc
	VdQbexgSNNQ5jYeZT6VDnz+O5aXHve8bl5urzwC9ErsyNQ56ipwQO60VGHhW5lD5uiz1zRA8Nvi
	/Xj6XmeGmhIy5dwETC5opi4Qq9KBUmlCYvK/hAQk1tuuRaRpCovLmx5+xbO9hBFQGMAaOY7hgeX
	uOt9MVI2neG45Xefzl+WnA7CyrnNEDWM8OTCFQlCQKdgZfHw2T7AcEt6R9cRrKsXSTy
X-Google-Smtp-Source: AGHT+IG1ttLh8ZQ81EvLd+eMylyuVC0qCz7+yfpfhFhABQFPRbMTUht4w4ZZZP/8N3DZCdo4ccqCMA==
X-Received: by 2002:a05:6602:481c:b0:849:c82e:c084 with SMTP id ca18e2360f4ac-84ce0095ac1mr99998739f.6.1736291798927;
        Tue, 07 Jan 2025 15:16:38 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8498d8aae78sm968120639f.40.2025.01.07.15.16.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 15:16:38 -0800 (PST)
Message-ID: <4721d4fc-0a4f-4b81-a385-bd0b61912975@linuxfoundation.org>
Date: Tue, 7 Jan 2025 16:16:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 08:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
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
