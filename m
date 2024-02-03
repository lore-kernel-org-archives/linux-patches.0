Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAF064D5A7
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 07:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706944162; cv=none; b=O2JgR8amEyp4ezxYIH6q+MBTEayJgdqB6UTl7vWApYNXgxZKErFyLhglieJXcNxK6Oqo1/I5YLqUC8uIlnSkfSvbfE40PJtWwNvpDAUEMjho3Nsur1vMdCEOP5LAPs2yHRxedmmOnTeW7pAkIBV3R6ClVBkXrQon4yjWvKRczQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706944162; c=relaxed/simple;
	bh=s6NSZRW2mLYJfT3I+Oz81FmHjo1C+jKFUvpbebXCPOY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EeF627reSGZxdM0xMh6NO218BBh1vWS11xKD6iyc5Z70fACKRS76lWrdQLWuzsSEAqS9edIB0FRo4iZEd5ubh3dw28X+6HqvrDkotmqjNQGtMlrR0QFhn+mSmvzbjJ+mjUe1bhEYe1OKjU14BVfyiSIioO7c78JphoAxw4qTvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J137yclf; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J137yclf"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-59505514213so876513eaf.0
        for <patches@lists.linux.dev>; Fri, 02 Feb 2024 23:09:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706944159; x=1707548959; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Qkdp+nCetJUmL046juddo444UhmObUTMOHHVwoJU0Hk=;
        b=J137yclfWc1twXdj4uADUWjbNRLT4DnGCf/ObayESHCc23Ah5LHCPduB7tcQkY3bxJ
         ZHAEKuYL11PohoRp2pElxIxVgZ5XwmXkqTBix451fJklA2PfZIosVRywUHh8NTvLXEaK
         MLnw4EnViZfUngGs+Ln2aEyYiyDkeVMilTpzNK1R8alsIq8OL1Oq8p/B20gVcUvHNBgn
         9ue1ILo75nIRdn3hMySv8ypklysg7EDdtAwwtRSKIGgdQu1sUGqrqNugdg5Q+nnbeazx
         AwFET87gPyEBp9qBbTvKRiCB671m2a1oXe7JCuF8TnUCeW7Hiwxaa9FzhnvXTjkqN0YL
         8mig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706944159; x=1707548959;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Qkdp+nCetJUmL046juddo444UhmObUTMOHHVwoJU0Hk=;
        b=hBodbK0cyPvbw7aVfcNkVK+eiTL33G/G0FKO2GvqKJzkD6Hz6ty4skyKqvkchnnmFN
         iL0RVg5d24XsxwD/HWnZoeSkRrr+U4gmilJctv1RXGOawIccskPLaVnHWWX1KhekIWRC
         SKsjjFAi3NZ8+fGr62ospfv4P2gIOIiadbkMKI8azT2ObLbdAuC1IYVygBRQ+Qsuobc6
         zuwSmww6HAKZWfvCRMegCcL+cvX1tK24hEzWZ/Bh6gfC7fl0kZQqOzjdlrysGULMfrb1
         Hztvs3DCvmi6xZYXfWI275L/km2EQkeI4Onkojzuk7yaleFpnQN4XRaLDjZVHqUY54nG
         6q0g==
X-Gm-Message-State: AOJu0YyMPCinE9oVp5lDkXjmy2IHfgh2LGrwnZc/wopPUBua5e4FaNg9
	vLp/WrinuU5Glw8k8a95sHmzNwtpbq+yZnr9hPhbJVhoLkcgJrqHGRv6BJSXxxc=
X-Google-Smtp-Source: AGHT+IHrglBEaG8gB/KfduLxZpmV5e2jMRLRkv1itsHxKAdKWVyR0wlfovKnERQhHDyuqDzU/nD4dg==
X-Received: by 2002:a05:6820:b97:b0:59a:50fc:153 with SMTP id eg23-20020a0568200b9700b0059a50fc0153mr353183oob.0.1706944159019;
        Fri, 02 Feb 2024 23:09:19 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCUwZ4oq7OS9LVvjulXn2cTG9B8kfCQqQuLjJGXAJdW/mbxyQYySlfxfcbzEO0oQGMGAmCJcQMdHjGki0/xu7vgpXBwSUc2rMuWH2q9t8dWc9OR5xUMn3MjvyU3y3EFSZrplg1wyL0fLSfN7pYR6S2vLTs4MY+AOjz4uhb1Pc3tbGXZ9VIgHm9aTyHYCq2rLm6d5bhLsa1r5Ozebk6Dx+Ap8vq3VAJ9Y2hk7pdQb6VKcKN0e0qPIImjG2H9+mZHZg86gzLspt9QNdPvhsmpwu7pEcNvw7QYzEIPK6TYtNlKgrNoSzIxRDiLIKo6MTWhXNRNWBaIDCmQLJLVN51x2QYCuEdiJUeb8BvSzOfI40oTSfbwpx6pZlY0lZpTzwxqG3zwRoXP26k478/mR+td+ZEKd5dxVDZLBiH1c3HBW2YGOu7ZACadUJARSedqWuzSK2yb4W18uMiUFUxpZRskxp9Qjig1SC3WtQoCOOXnH4X5Ko3JCMrE8QsLpgKzxTqVM0t66UZZijOr8GrayHdjsvPEDfRfmbD+PINwHDmbuiDHhRmWeMlP0O6OxiLgfv3FCgZ94e4h8fbvu1IxRwpvvrj9Sk3JvJ2RRg4Iz0gA+UyCNT+t9RG2uBwdjxA==
Received: from [192.168.17.16] ([138.84.62.70])
        by smtp.gmail.com with ESMTPSA id e20-20020a4ada14000000b0059a853309f3sm724095oou.46.2024.02.02.23.09.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 23:09:18 -0800 (PST)
Message-ID: <4344da38-13b2-44db-8a2b-fd65ef5501c1@linaro.org>
Date: Sat, 3 Feb 2024 01:09:15 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/322] 6.6.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 mathias.nyman@linux.intel.com, dmitry.baryshkov@linaro.org
References: <20240203035359.041730947@linuxfoundation.org>
From: =?UTF-8?Q?Daniel_D=C3=ADaz?= <daniel.diaz@linaro.org>
In-Reply-To: <20240203035359.041730947@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hello!

On 02/02/24 10:01 p. m., Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 03:51:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same problems as reported on 6.7 and 6.1.

Build error/warning ("variable 'slot_id' is uninitialized", as seen on 6.7 and 6.1) can be found on this branch too, with Clang 17 and Clang nightly on Arm64, Arm32, i386, x86, MIPS, RISC-V.

Build error due to pmicintc is present on this branch too.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


Greetings!

Daniel Díaz
daniel.diaz@linaro.org

