Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F67B1AB6CB
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 22:32:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980349; cv=none; b=moi6HwklnzsxmJYQ1zNX6bybgFSSyJZZwMO6KEF1XYDwLap79lbdDqpjW3KLq8QfS4C6W9lAGONVJaQorx1GyTO2J4eSHy78eoL/xc3RotXLA3oJiI1QXRM5S2a1gB1ekTr96l9UPID0DMjPFkxV7ZDEIa1O1PX1jzSUIjTOaPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980349; c=relaxed/simple;
	bh=BvESpttXPM+cPnUnYHzUkfijK1/cxJZNs2ANKE3voUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PFpEiTJPERgib2VNI9msHyGgV+BI0UhQ7w7Ct00M/opdv/SxAvbNWdH4jKAnrIzOUVrgTEaUN4V6FQkW3oZ1TyvzdkKpxlO4TCkYg8uW0leeu2YNi82VVyhwhOvZWHUJRCW1UTnnzNRFs6JECSWoHWP5+pEM+wXhyRouAuBM3NE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K6n4sRWa; arc=none smtp.client-ip=209.85.166.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K6n4sRWa"
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3ce7c4115e8so5219365ab.1
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736980346; x=1737585146; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xOb20PSjdeGT0anWqDB+dqo18daPgjdBpR3vyxUVTEI=;
        b=K6n4sRWa4qIraQRfxJ9fD0wF3ghjhHqVNqeJUIrZWOnqH9AH2l8IEAKUd7jXv4Srpo
         KjW1jmDcXpyErir6bx7CyCMYlz+Rox6v3ZwoUlbTWcumYn3hSa4hFxmt2OfwLxwcuV7q
         NwWRy28KrKsNlO5ANRWpRfDmrNvCCYGdmlRrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736980346; x=1737585146;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xOb20PSjdeGT0anWqDB+dqo18daPgjdBpR3vyxUVTEI=;
        b=iswBuN5FDITatlzWROhlF/hYaWC4WpNZLpul2uCKMc2EsSBRSlnRRvxK/zklPRr2kg
         GeoN1fh+TYFxEAFbOYash8hBYplXWpTzFSiXAi6Mb4auvLOJo0fhJ+sfPT5P3vvdp5MT
         dmSC9vSfPFWi8tSkHBa4H3lA8FvjxDcgGvq5OyiLvrA1QpYuE3Zvb/v+jIRun7RtIP4n
         Kt638D7ezdSvmUjCqB4o5O6MiyMv35tPTdoCR8EpcGx+jDF28sZr/ReOW1m5HICH7hDK
         YPWYHSxC3ZPhzv4tpTVJLGi+1KkpM0ObiKoJmSR/iJOf2F7FVJ5FQbo6RsTJ2e6Jsrzg
         7aAg==
X-Gm-Message-State: AOJu0YzJc1cbI3yvB6PlDfsXeKUgmaCJKv6ca3789yVaNqvwMzydGVq2
	gOR/+i8oPQzJsl/ZsYdKXJWcGqSS43g+YcKS8pKynPk9cR/ny3JJfstMhk7Es7I=
X-Gm-Gg: ASbGncuKB6EDnkycBULUH7oEqkB5Qp9UoVrq67Pv4R/WNd9JGVE1bhT8FsP/qF09wXZ
	OyZwmauuB6dcjrYKzHCzYV/FsJQLkTal8jdwGfOX8vrNL2N7YvdnLH/LmclPcwLnsxPK3+NlNg5
	zvTa+yOkw+d0SQnIClyAcpzJOlDL5c4PqElV9fBgW7A7zzWfFro+ApMc5an86dXyzPSQFg2Bopn
	fk7s3W/EUICsNRHH8Qohmp9HtvGoNZw/mJ1X9eflyw9fQoIyiehuv4m8fzV1Kvw8LI=
X-Google-Smtp-Source: AGHT+IFl92Ibs2oFy7a4C6tHXHj8T2cGTjuNJBVfgfJ74/qMBNF9tXTpjVxba6p9FhV9k7u3EJ8CQA==
X-Received: by 2002:a05:6e02:16cb:b0:3ce:3657:7407 with SMTP id e9e14a558f8ab-3ce84a8d3c7mr39407335ab.11.1736980346689;
        Wed, 15 Jan 2025 14:32:26 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b718a4dsm4284662173.100.2025.01.15.14.32.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 14:32:26 -0800 (PST)
Message-ID: <e66d86b1-ff1d-41d6-bebb-d64c4f435094@linuxfoundation.org>
Date: Wed, 15 Jan 2025 15:32:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 03:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
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
