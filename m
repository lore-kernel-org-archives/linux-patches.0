Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BDFC278172
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224760; cv=none; b=LtGW2Dafi2slJDEmCwkAZfZJzqBdMRVoQq9iWHi1akGHqZvJaf3Sn1kW7k7sFfoLKURWqMjM31o3/jaGwtTVPXgOfoD8obUjLZQsPI6HC2o9eA1rDCZtBbvsCygCiMJCrODrOCIbuNRKcJp5/6TV8PufK1TE6t52BfvN2iwwWk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224760; c=relaxed/simple;
	bh=pLt7GiueBlfEk7bEqYSj6/150Oe2cspFuNbigDQxZMk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PXAHYp3XG0j4qgJFcWD7xb7d2IJm6svokwjt+5aO/99GiM/df05Vu9IJniG51wUac7aQsXtE8sEAdlh6VaW9YpdVcX0Qo/1GTTsW8OVygpQBaxujt2AyaEpbBiqEHSt5AtLTs32K9ipUfvLlW4whsIwpQ7ReKUEUr+lt9IX5VEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dCfEO3Dy; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dCfEO3Dy"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-72c3b863b8eso10680a34.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:52:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224757; x=1744829557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=08HrC4TNhMaF2kgAGKOzCB9x+b2Lv0SOP0JhsgwzY5s=;
        b=dCfEO3DyCLNyRLR+IAf2AJJYUO9oBeVrDce6lbRWlpWho3VRQaimLYrPOnK8/6P3eA
         5wZJliyz+Zc9LYdGDzIrLuGPNGumxEnGOJGPaF8I034hRan/pH+AcNjbEMAoR5vlGg1O
         SGmgw82tufAXlS4omXAuDgge90iT37HkXaIJA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224757; x=1744829557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=08HrC4TNhMaF2kgAGKOzCB9x+b2Lv0SOP0JhsgwzY5s=;
        b=EEatlfubTS+6UU+yAbb1T1wpJzvq5cso/W5Xn4e9SDwXBdKhlvQ7skL60XkSryKmPv
         MQbfBQLhYtEfZGZV+ygo3CzQ8aQ//Kel+TOK1ow35YCXeiW0ebvNJ5SBZkXD4lCtN6UX
         x5MKtG+bnneZNaHAriHXYUGJg3kg2sgH8uVHapKOjZkMqISaSHzR4Id65nY1RDJsv8i2
         d6cFsMychD252JMH9U3scNWJsmE//c7V4z/6Kj3KPLjxGFn2RYwghRgFUEctdUvLJsPc
         CLxsByIMIdBeJQIkzhHoPfxmYWvPi9/Jued144wvVWzt73VWbfRKp95uF2G7jisKvvtk
         Dngg==
X-Gm-Message-State: AOJu0Yw1Cqk4cbOLiVck3I9zkwAllFRc+JlET4jRitVbliw3mmB1PWAg
	21GCD6E4EWWxGvJMxdWRFtx4V/n3QW/Vp3k7vNquTdYHxMqGfYidCT+mX3UDLUQ=
X-Gm-Gg: ASbGncvqPW5Xg15e2ovRMiQBg05g8HyH8Uycqc+gEMsz4lX0xnGjqeVxQKCvDKIjSXd
	EOGFLMV3E60dV15Kkvpi1rx7VSQ1gn1drEtRg66g/BOcYI6CnU1sZ0vcdiEsE3KhpJkTos236+W
	wFkCAKkSKw3uUJXADMBgSWAfWMwVrNEai0DN5FrRpjqFqBYj8y3WmmLSxCnfL6oUeZkzTgTVHkB
	FMFwhFBIOuEVrjvVt5p0zMtZHj0QWn/Q5sGnHWvVveJAuenLx9B3iJzza6P67T1DchZ8ixBiwO4
	qj8+Tja+IaB2vnKIihYRJIepvcUZ5VHKK22VqPyQ9RiDJyVsRNc=
X-Google-Smtp-Source: AGHT+IFE4WLk96sOEuDaUbLNglaG8LWOuDvoLplefjWi18rbkgHxYdcBhfLP+c4HletU/vfeakO66Q==
X-Received: by 2002:a05:6830:6304:b0:72b:9fb2:2abd with SMTP id 46e09a7af769-72e7bb2c8a0mr19492a34.20.1744224757172;
        Wed, 09 Apr 2025 11:52:37 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-72e73d8d90bsm280459a34.34.2025.04.09.11.52.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:52:36 -0700 (PDT)
Message-ID: <52fb54ef-4f30-4585-b5ff-6e52310ac43e@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:52:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/205] 6.1.134-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250409115832.610030955@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250409115832.610030955@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 205 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.134-rc2.gz
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
