Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 156CE1A256E
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 17:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748970676; cv=none; b=Y8rKEsegcq64VYWQiv9F6A7IcWmYmAve3kEm8IkwD2dSHAQunedQCQO3Lt6MVlcbuh2qkwtfGRxaG3Bq+ciNIG7HczBT552ERR1MzU1nnrj3gcvGrgp7x+CoG4UIPT4dLLCluxdKNwQfrNrvWYLDW/P4vgoedfLc+IdQdtpRlW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748970676; c=relaxed/simple;
	bh=aQQBhohjQIsXAAA8OWEgSE8iiPBsicB0x/KzfQnnE5w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Prk3+XigjcLgHFKNyE8tKkRPchvsLwjEA+YM+Co63unibURwfmbzpyQxHNBzp6Q0X2c/x816T+/1S1QglJcqsFo3pRAk3yGx6jOewtplo/YDS/rBin229WOi8k3TBAi6tUUagCeRazbZfzrGRGiLGF7V3cZc2Qfxdj2jUmX2V0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SDsxiYF1; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SDsxiYF1"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-60eefb805a4so559380eaf.2
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 10:11:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1748970670; x=1749575470; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ge/FLJ6X+Z+KwzpsNzy53QG41bQPIW8972QpUYS6LZE=;
        b=SDsxiYF1wM54reuahiVu39lIKak0irClbsaYkx66Hz3lyHwb0ZKzcF1J7xb6mNU81a
         DSpv0QqQoYAt9YtTKigqFQrc26JJzjanQ7kpA9UPy+iIp4ly2T0zhGp6/uTRr4R29AP5
         FxNbiV9/IYWfiNYGwSZnZacx/XNvBywiQqGaA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748970670; x=1749575470;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ge/FLJ6X+Z+KwzpsNzy53QG41bQPIW8972QpUYS6LZE=;
        b=iXtPUPZrpJO1Y9CNQIoE9OmgoBbGzu22bnG57f4rtd1TKGMhrVREgmTcXL+daNUGar
         KM4nNzGq8ZzWPhlwnI5kLzL3hRb5H4FWCeRiNv37IUIPOWZXvMzbC8N+EJAEo0BWEwCe
         B+tCNxa2hlUjNsxkX4GZHDLon2qr6IduJ2sAnc5d2O6ou9Ta3dpDwhKMozjurgcOrKAI
         Bt3C/0UEDX8ToUdOHKYP/YQUDgrq6eNroZxmg3TCbApzqagsrl8S/eBoKRWWso9p0Gk9
         diqji5cbK4vu+SLE4amII4rDjfXpmb3xILij3IT8/HjWLbJeJ5hE8zT6rcWABwA9UK4M
         O//A==
X-Gm-Message-State: AOJu0YwqNgG5c1fJGIggDU+eZrvavekm1PJPB0Ga4VnjNQFlvKCJUIp8
	0LSS8aSJ3/lw2S4aIHXTWlF9RUGuUDbLyBxu72TqgNVvBAm2CnMTXGQ1qVqW5M9HcVZ+0u4e5wg
	zqcMf
X-Gm-Gg: ASbGnctlksVnsJt+6hFCZhLh3U/2Y16iRVO2iDSWqnyH9BYduFsPmumKdwxgekKSbVv
	axRPdqG+1myRKnEIxNxJOugmvpp3G3rOE+XETMzyVMeGKy0zMMLQTxEbGwFv2W9WFk1H56E5JDp
	tWlBLdWEoCn8tBmDxojMZuzpyBXvqZlVI6hgLWot8DhEJPNNzSRsRN1bflrHcrLcHy6dM6ARAgH
	pVRVK9kMEL5h69SHCqh5sTw+7iOJp9hdtmVHaGUbODj69XeiRzrdHoa734NTuMZzcEuvENo7hPV
	Yr5tXiQD3+1uw2tD/UYekL6rOf7BEUda3w1WSQHOL0YoUozaGkKMcPuClY6j5w==
X-Google-Smtp-Source: AGHT+IHan2FSKbS0x4O5vzploOaIxfhJ7Es6upmUdxSGvzf3ySgMu6gpZ24LXAKPXHs/2zci6fpapg==
X-Received: by 2002:a05:6e02:4416:20b0:3dc:8b29:30bc with SMTP id e9e14a558f8ab-3dd9cc15926mr127450175ab.21.1748970658903;
        Tue, 03 Jun 2025 10:10:58 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3dd9353d994sm27175185ab.18.2025.06.03.10.10.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jun 2025 10:10:58 -0700 (PDT)
Message-ID: <bfa7e3c8-b497-4b06-b7de-db6f97ade6bb@linuxfoundation.org>
Date: Tue, 3 Jun 2025 11:10:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250602134238.271281478@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/2/25 07:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.32-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
