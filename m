Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3910393DFC
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 18:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762884017; cv=none; b=rpBamoP1BYDwZw9enCfi0JCNR9iQoEZoWfe00WPyObI6WDWJXO0HBiPXyfebdZykS923c/8LKIaKDhqUfE36VOsy/vRmx1QVjhkTMCEukiGawymWWOua6z8M/J+h43NKcI/vQyQqFvGpRs5wq8ApY6BlHHafaYe9/xn8GwOFgJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762884017; c=relaxed/simple;
	bh=8BGgfEn97snW7daOKRguJgMVYYh52RpW/KfSxw5SYYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PZs4EMwOiBbU0ZhaQ6dlbA0l2qy3C+xUq8+YB2Yz+XEYvfRwdfa6LJBiIMBkP+1UGMfigTyKEbNSb5dHGNTwCUZI5iQGlAME3O6Xno0ZvmEbENcn2dA7CYV3gTluWSrUrteOr72XTlWSv/odffRtPM9t68Q1UD6dqi/99Lx+bMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBE4sKK7; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBE4sKK7"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-433217b58d9so18174525ab.1
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 10:00:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1762884013; x=1763488813; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zu4EHUDGvoxogQX+S3l1H2cM4F4fAMlTZfbToOtiANE=;
        b=TBE4sKK74JM2145Oz/RqjxiDSHdshWOUFvthA+1AaJhvemXbjJNCGNarpmNyjQdnru
         lUmi/FFqRCyJWwjXXWL/IR2tnbNNo5r7C6g7cXHsZ3KV9LLgEPk4Hd7jRpL31fGja3r+
         jq+wiZaw8dxh2Yb4Bxtz7RSczwfCEliV8J//g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762884013; x=1763488813;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zu4EHUDGvoxogQX+S3l1H2cM4F4fAMlTZfbToOtiANE=;
        b=BGP8Mjq9dii9msH4nu0pwiT+SNg9pq87G1+5M/cTWKSmyX/pWVmJslhSArFIVo8XXs
         5WoAhxnyR4C+UIUb+lbxOlUsO5hrhmq+YNCO4g7+EFinuMcIZHGBkbLHlhAi/4YtSwn+
         1oYnNhjOCJq9V3WjrPqN/cH45BYplP4yy2ml6dvLeUwTqr/MyPNvIZXSomNXR2Rz3NLp
         wkKkrU3JM01zAd4mDPA5fViAjICpULi9CtF81mGeQKrjZD98Aq7KLjI7iimGg/mvWeQ0
         Xdcrw6D01trrSAjl+8zEdr3uuhXMd+uHoO0ijvr0WYi+2JactmexBZmXLNKTbQA/p4AE
         71gQ==
X-Gm-Message-State: AOJu0Yzu3z1VhagdijvJo1rfi540Dq984/JleDWIw29Kudd2s/P83aPY
	cRFRkRMzuo/sDeLxLkYI+50e3vB3x5sH8k6KNFgJT3cXiT/tDDisyIgQAFDYqtksOMs=
X-Gm-Gg: ASbGncsB+6bA14LKPcNJ4IhGCZ+c3jJx4Kqvw9FD7E2OYvzRhC1CaeqDobzR+DedKHP
	avsPXn4yczdbsJoVPV9BgwZ2wrikmRdS/FRF9VjacF/TLxAWxgKD9o97++r6RGdPDdcF/kJSB7A
	e3rYQkmEygcY8nmAQZWfGh5BAz5iVDqYLQwIO5zyF7oYU20OW9cWciTEekGxVIS5nIGRUub5q/b
	wR41HmOHqMzOhRDYS9Yeubnc9wmrZdMXkqKdWfn0QAu2aJ9ykVSJe2C1H0NbJuVVaUv2tYXQIEQ
	Rt6bHhP7OpEQqky4ngtvLoEX0afLZNNqW69jhry2giExbezEXaCSy7s3BToENMsYMz8t2oEO8f1
	GluinreyjV8FhvalktmbG5UUWLCfB9sm+sVQuXlbYRpJ5qbMJb/qi45T7bahQKuVDyELDqI66Y0
	US26HK6j+Wbo0D
X-Google-Smtp-Source: AGHT+IEQMr3Vpgo000GhycQVvJrz9u/ak9auHMJZ5/xjFusfwrcdqUjlULnvSbDKynTKwDNhnUux7Q==
X-Received: by 2002:a05:6e02:1fc3:b0:431:d7da:ee29 with SMTP id e9e14a558f8ab-43367e79e87mr145738845ab.28.1762884012698;
        Tue, 11 Nov 2025 10:00:12 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b7ab11690fsm116564173.47.2025.11.11.10.00.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 10:00:12 -0800 (PST)
Message-ID: <641427c7-0069-4bee-8e6a-53347654a926@linuxfoundation.org>
Date: Tue, 11 Nov 2025 11:00:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/565] 6.12.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/10/25 17:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 00:43:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

I am seeing a build failure on my system - the following
commit could be the reason.

> 
> Heiner Kallweit <hkallweit1@gmail.com>
>      net: phy: fix phy_disable_eee
> 
drivers/net/phy/phy_device.c: In function ‘phy_disable_eee’:
drivers/net/phy/phy_device.c:3061:29: error: passing argument 1 of ‘linkmode_fill’ makes pointer from integer without a cast [-Wint-conversion]
  3061 |         linkmode_fill(phydev->eee_broken_modes);
       |                       ~~~~~~^~~~~~~~~~~~~~~~~~
       |                             |
       |                             u32 {aka unsigned int}

I will go build it without this and update you.

thanks,
-- Shuah

