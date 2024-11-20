Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11C741ABEA2
	for <patches@lists.linux.dev>; Wed, 20 Nov 2024 23:20:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732144844; cv=none; b=l5krS0GoArMB2lBFRglmK1HTV7GU7Bu9xmvExYc8xULjZjdF4UE+ysWCb87VS4kC5k8iMCpVoVl/VFj7/tB3ECBpiGpJ2q5SLMqefgpJfIKHfpwVCKrA1zlysn73WiRdNFT43WOJCkSMPXJpvXgIVrxSzolCl/yWvRqcF0mkVuc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732144844; c=relaxed/simple;
	bh=eupxP0WAfuiBRZTPQdKjbDaBL40xdQ9r/lQfnUunKPU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NIhdDOaH60d3lVPBoRGdGvjppqSFjL5sngPeK79b7HY+V3aTZkC3RxeAhPzn0DwW6OM2nha6PQ6I9aeWs6VPtfP5WRLkCq0EZheljcJrUPsoFEWBUCcdXmhgQ6heWqLhcNGNePISg3d2vYKh0McOZWJVZwdogvt1tU+85M17yGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GsCr+KYe; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GsCr+KYe"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-83aba237c03so10710139f.3
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 15:20:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1732144842; x=1732749642; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kI8LjRbHnrIYCWVFuTZVSrxkVpMakjiw/cyxut4YKfI=;
        b=GsCr+KYeVKDGfIlYvzdxXLTP9zdTJ60b/hid0IgNxOe9EZUDaBIQVT5I7Hc7j6Wmx6
         AZsrmkxFmRsdqXvNXY8VQ6WgKwO0JVZRl3M3J5pknuZNQ+jx2lIVHpBzORH1DsJwzS3a
         ohHKUczyTgcUirfz1R3xu9c+9YZxC/5YOStJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732144842; x=1732749642;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kI8LjRbHnrIYCWVFuTZVSrxkVpMakjiw/cyxut4YKfI=;
        b=B4bZoezUAVu/PQqlBe3IJET4nPyNWFR4bxBVI+kIPzE2k9pUwXadVchMVfI0Hhk/L5
         XC+rerUMqZWKQPG3TEXEsks9M3jJPGqx7UvPDx0Vbbc0EWO5UMh4F4UvyXzSFgk5BuT8
         l4PqbE8ZpcfB7cqZlmPtrKgy+z+BtcoairB+BVGoxcMC9VDyCVPr6gZkX+SCOQ/XkElG
         RrORm1fVQILQjIyrD9jwwzLD+2Qv8g/9JsyjINHEQLS6qJqlyeLZXi34JfHwYEs/AYvi
         hj0rGcS6mOZytZ3FfJmIkI4pLQEp1PkNDjvPjlfdvJCSA57WxMnVDD1YZu+oWei0/hdi
         TOHA==
X-Gm-Message-State: AOJu0Yz3Ymxd6Pcws7ncDnUOLnN//hzaCKh6fxHFn6t2tp96jJXTwygU
	oqjI4DutzEDc9HMBLE9+qhL8XkOv6kag/q3FgcfzzRQQOGKqgF5vb3CVd5f5qSY=
X-Google-Smtp-Source: AGHT+IEEiuGathMJnfCVnOnRROnN/kddhLVKZ8maKJ87UcKzpikjw9GywFlkWjEQ98DV5mVGfqUK2w==
X-Received: by 2002:a05:6602:2c03:b0:83a:ab63:20b with SMTP id ca18e2360f4ac-83eb5f88fd2mr584939039f.4.1732144842233;
        Wed, 20 Nov 2024 15:20:42 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d6ebe55sm3349642173.6.2024.11.20.15.20.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Nov 2024 15:20:41 -0800 (PST)
Message-ID: <3b2a3cfc-861b-48c2-834b-408532a230e3@linuxfoundation.org>
Date: Wed, 20 Nov 2024 16:20:40 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/20/24 05:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.63 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Nov 2024 12:56:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

