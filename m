Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68334219C8A
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731453743; cv=none; b=IZ1xxVtc4OAW1gp/WfrKVWYwGHD4r9YePSoWEzfisYyM005CFfrxpKkqiFFUYrMAXULJQahzadvrLYGnwleWn+nU9VTojFOpb2OO2/jv55UXRCylFwk4WZ3GOwy96Ux7l+MuPAIGD/4hgjY80dSPFSyad7GOJdEfwg9J/ntmc0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731453743; c=relaxed/simple;
	bh=NwNK1UsOIIOnZPELwasBAkKZRpPZYiIrk9YgjeocQgE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u4BZJbPKQKbCsSErSXnS33Bu9AfRQvSD1JR5/pwIXrxZ/5h3LZ1gFKuqQHSCtuWBHzFD5ly8LPiRoyOOqCYxG+16HsKDnhXRnw49iM+O31zhpZx5LO2Uz243MzEHuLJeyBSlUU8b5D2mzoPl2414tEw/LiTlMilgC089kfLVkb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFiWypYI; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFiWypYI"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-83aae6aba1aso223034739f.2
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 15:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731453740; x=1732058540; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q3i82h1dy+1mDKQLcjx5GEyyInNzWC0fLINk9aH6mkU=;
        b=IFiWypYI1Dx/S53IR+EgRLE0iuTln51FIH6UvhBEPwDzrjZSuBQthLy68U9nQkhkDv
         KU9/pZJDlTI/J04mENHhcdZNlJjE5Tc/KHzPuKnfvuMfEuZ6Ok7BoIyFTZtteFFrxK5s
         jvTJot/YSlmiLYxLS7Anlg9FlZ0/+q26pQ+HM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731453740; x=1732058540;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q3i82h1dy+1mDKQLcjx5GEyyInNzWC0fLINk9aH6mkU=;
        b=f4rlde5B8niaPiO6Hy1MbgVLBgH9R23F+2U+ytH9WoL8NZlSJ3bKpZKEo0eiM1JuO+
         U3t6i8UAa+6HKiXl7+39EEXHE3PSHZZSLmCqCNScrgi9GT07ANUMreusn1CXLOlPBy7I
         4Zt1NDxs/IveiVZa5soJX9uICoslt0TvrViLLJ0UbaP3pfCu39tb07oLIY0yn/ehoick
         piLAj7tYMhk8ZPSy0TNI6lZVIrosxytufanOQJlXOPmVCevdH6bZ3VzYSQrT64P9d14d
         RzG/UF1ih72flTtS7KOzeHksgwO3xAvpiEaD33tDGSw19plf9Amo+T5Nc4AkgaeauOYw
         y5DQ==
X-Gm-Message-State: AOJu0YxNpWXcALRLepX45f4FoCuP6Z8F7A+Ct5UsDL9SDbl91Cnhtd4p
	69kE1DyxgqAZNFd+gvjhB5fuTX1bvkUmvc9mfjQ5i3lMIx6JMTnZzqnY4OSJc08=
X-Google-Smtp-Source: AGHT+IGzLKzOi3wnDvz2whiZjf4QgSZRq9izE8vIf+zuB7DErCoKskY2TnTwp9Uo6MfHt5B8jPVf2Q==
X-Received: by 2002:a05:6e02:1849:b0:3a3:b527:e809 with SMTP id e9e14a558f8ab-3a6f1a256c6mr212414795ab.14.1731453740488;
        Tue, 12 Nov 2024 15:22:20 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6f989b2c7sm24784755ab.79.2024.11.12.15.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Nov 2024 15:22:20 -0800 (PST)
Message-ID: <0372fd67-2f79-4b80-97de-e149bfc533ae@linuxfoundation.org>
Date: Tue, 12 Nov 2024 16:22:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.172-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241112101839.777512218@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241112101839.777512218@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/12/24 03:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.172 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Nov 2024 10:18:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.172-rc1.gz
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
