Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969A76FD0
	for <patches@lists.linux.dev>; Sat, 15 Jun 2024 02:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718417459; cv=none; b=EI3J4kEiA5DSLMsp0/ts5rUUu3b/rhp+OrWjdfdLISotuYyCCwdr3eINTJtkC04xV/GitGuPXy/mL1AklXFtiDBcSKDhJcJ9YSAw7bCorCydLrGEFwDf9x2Fec3U1dSiEma8iPgOP/33VjuU68nTr79W0ZU0ELa9ekyYM4ZCHn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718417459; c=relaxed/simple;
	bh=DXmInziqCWKjxJpwpBGulsCPWOKNAr5TIjnc5FqxXlg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K/rCPQe3VZwXg//J4nHZiczIasvfVzWUHLi6c1bfnb6po0tHukXfE5rydBoN6c41J5sBL0lbsMXCljluBTJ3MQdubbEq/JRfbhXfv408J9oufezN4d8WYK9ICCrYO8XsEWC6gScF4zaJWw40CeLCmrpzIdw/gtNsyga/VAXKA1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KaVRxT2y; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KaVRxT2y"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7eb721a19c9so12131139f.2
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 19:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1718417457; x=1719022257; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J3nS2v4qoTZtVNGX3X2MEYA2M4BO3FR1NxPvnOGys6s=;
        b=KaVRxT2y5X7If/X/4KDi9IfHq0k8xlZrZ3tUemKlz/yx9yLmlXU33l7L6ZVFaoCce/
         +vAvoHEbN3r/JlkrIYERLhj7FkfFrI6IvsQzxkuL7ZgAZUl7ivVuqwSLumazqWqcWHX5
         4PgP05+el50wz8NBuVKPmvJ9aSoW8Biua+lF8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718417457; x=1719022257;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J3nS2v4qoTZtVNGX3X2MEYA2M4BO3FR1NxPvnOGys6s=;
        b=lj+6I0/jxdmg+77LmOQN3607reGZ74YHVfb3e6Enogl6wf7EAm7ICqoidN7oLjLNmS
         63MOu0x+HRt7Rpms1cKaFeyc74/44xqvq30dSY4/OEWiHK7cebUDz8E9NOTqLvpaO64j
         6WWXyChhTy2v8nQwkonjp7B+YwirDIxp67BSyaKx+Gb0gZnbyNxn9UuV1ZlUF5FgT496
         t4OYxRZPG2tPJ8DIVN4/af1J338Nf/LBgi1L7G7pJ5FUV3ozTI5KqvUgIVFWEAHoMVPq
         py4z/Ge5KPFEN40pkyzM25Rdqr9c0q6Wo0HcYAwIr/DWYkThHFHwFB1m0GRwlLk6C/QS
         Ys3A==
X-Gm-Message-State: AOJu0YzSOqDutSVmpftdb59U5dM//9LonZ5kaI3uCSWDJhzn9vNXgGSg
	udAUFICcvDIiMrvxzC8F3vcEufsBIiqteIjQ5NBi9JbeI3ctmkgCSG1NhVMNwQI=
X-Google-Smtp-Source: AGHT+IEkZI+trr+spMpD5Uhm6wzSPYBWWnpmmtC5NW5c990CTvY6qKgFjfD2kSBCOb6xgmfk0p/i7Q==
X-Received: by 2002:a6b:6b16:0:b0:7eb:730b:f0c2 with SMTP id ca18e2360f4ac-7ebeaef9959mr402719139f.0.1718417456900;
        Fri, 14 Jun 2024 19:10:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b9569ef5f1sm1199962173.114.2024.06.14.19.10.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 19:10:56 -0700 (PDT)
Message-ID: <0aec1473-b16b-455f-a8f6-495c424d94ad@linuxfoundation.org>
Date: Fri, 14 Jun 2024 20:10:55 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/402] 5.15.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/13/24 05:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.161 release.
> There are 402 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.161-rc1.gz
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
