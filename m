Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 807DC27FD4A
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 16:02:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759334582; cv=none; b=ZINT8ti7KQBva8dde/vey2Od92nlUGb0RjH/1API+OB8QMZbT81lgQUUXmzyMFGfAGVP2mWE6Te7WgmLyAF9pUCXVY+jCks/SUIhWE+LQIHHWP64Azze8/9qMd8BfnhF+oBAf2JHge+MH5HDkzR0P8UQ6o0xthh3GeYcAobYhCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759334582; c=relaxed/simple;
	bh=TN08qxdXNdkLvHt7/wPIeKRCTg39xHBh9iRLNP8f/0A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a/DJQdCTQ5stRsaEzkxPYnKnwF6zuBd7g/+n18QVNdp3RXiA31Xkh0D5rYm8RY1JL13rVJOi755YYGv7CQMzMHDPr0lKQ+dF85rkOjFYZsNVhctWSGhwWip0O2H9fzivrYGACR1zDIOng01/SlQwFRNnqWCpasMRARKUWy8ASVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=COquHvY/; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="COquHvY/"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-9194a0241aaso212955339f.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 09:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1759334578; x=1759939378; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mR7FRFOp6wmlPMEQNaFmkailzNE5Cfn80QOSCcb0KCo=;
        b=COquHvY/O8DEFa1PfrYrx+m5EnFMaq7LxjgY8tkxtbXaYstHQ5ilzRV1ehVnIIlzaV
         Rmxu8EnZucLK+x12vt7XkmyRg8t3ulcv34uku/b2yJGAvcpSJgpDDXcYHcieVC7K6owc
         5M9DjSNLq5RF9gAgPQXrZyH/E2PAq30hDFKh4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759334578; x=1759939378;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mR7FRFOp6wmlPMEQNaFmkailzNE5Cfn80QOSCcb0KCo=;
        b=ixTBfAe5VrTZpStVAzot6JgLOxrxDRBjTzZiqWaj6UzAiB6ehgccNlHxB7JmCn7YUw
         Al8J91DQwb/ZEIpHK1avnzTujo1A1C3U1JHZeJpucLtVrDSgorRjgsKqNn6qGrwae7s2
         NJeP+ETYl3KsY+Zk9jJ0GUdglUQhfa9n8Zvs+7/BHbVR1KD2kZ6iwabIPEYVqKvKCGKh
         DzXJKcPO9eGYjhMkKbBnw4hkMmhb1la3aFksovMb/zpkurUFpNZV2bZa/nDIxk/aOyvs
         GwvYbu2/tRlMUJnRibnNIh4uDwBVJgpEETGrQl5SRvbf/T9neqbn0t1YkS8YvDLgXz2A
         /DqQ==
X-Gm-Message-State: AOJu0YxTQpubpcZ1xLP7UH3/EtpYvwUGBXmxcjMa6v+UEWOuldKOCHiZ
	NXPYJPdddzYnp2nMkFngkUMPjc6iJIMtH5avjf90nl31W1dnY+YX6laav4ff8WR8wAE=
X-Gm-Gg: ASbGncviyIG0IE3vAcoh2psVI3piJ+jp46MJEI1Svtj91X5qwidNnIvd82zVVMY9ZyC
	1DyKg3RiL+o7J6ipHfK8W23OZ4EI8/aWP1Nq5VKr5nfsY/1AjWM1wookd/C5pafd5r+tn4iW03q
	P9xAYRe162MdZfzf8PyY5qkm1mL9a+6f4JdylY6Ko1KqnsuJf+ibtDCxbqNBEMNwmW8Bk4D3V4q
	uFAoiTOYY0KO8Xhia08tJbrU4FEyspVZh9N4DML3GiIJu2M0NJRqNs0un2suk0K5sSvKuX1DIfF
	pIXHads4VUyKLTnaEVpCzf6QHV5Ba7trHtqaUM5iPzRhvqTLeL+xYRvBzs7Ex8rGAXq5FkBipKS
	xmeRK7iiF12ClIhtLYsq8PY3yZUrTaxh9lbqxujVMojU3mlLHne+oh+azLpU=
X-Google-Smtp-Source: AGHT+IHgdySDqIv8Jt6z7mJDygOJ39o7HwA2I1QtCXMXZ8x1/OJj6ga6XsCXSQpUzQE8TPPwtX9h9A==
X-Received: by 2002:a05:6602:26c7:b0:92a:4e19:197d with SMTP id ca18e2360f4ac-937a70f0ef2mr638019939f.4.1759334575525;
        Wed, 01 Oct 2025 09:02:55 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5764f341b2esm2373807173.0.2025.10.01.09.02.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Oct 2025 09:02:54 -0700 (PDT)
Message-ID: <111e47e1-b03f-4d24-a234-0d64c2792447@linuxfoundation.org>
Date: Wed, 1 Oct 2025 10:02:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 08:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
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
