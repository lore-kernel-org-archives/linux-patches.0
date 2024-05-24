Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8022012E1FE
	for <patches@lists.linux.dev>; Fri, 24 May 2024 16:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716568002; cv=none; b=O9i8EtGxwAuQBo65ayW9DdhI9aPoGhWRO2cvsh4GPsh/8oPholvHvSdcn3nG7reT/5UUdoq4MaNgpp/iKPQoFFcFQUnYOLj20FQmSsYBrl+fjh5H8ZjRpKTJhjzLmR8Xo7ASGfo39Yx3iavlG05lc8FpYiE6sFzojKQmgCRU3Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716568002; c=relaxed/simple;
	bh=uy3Bu+RWC2BwlJbf2rF1oLCzsBktn97cLQW+3/UQOvU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WQJMDoEnDqPy+h8TA2u5Xs1QWg+Hy74OT8Jl/ivc2+61ny8OgnyhfaZzASk1vTU6cQ6+p31dzWr+ru3NbkJ1rd7HJ+Gc+VAbbpiLo0ab7T2ZzlvgLXxwDqeVCMqTduhxfy7q2BHoLYGZuGsVJdsEc2/wYoaSggDfIRexSmmKJ6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RKBSapJ7; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RKBSapJ7"
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-36da87c973cso3679565ab.0
        for <patches@lists.linux.dev>; Fri, 24 May 2024 09:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716568000; x=1717172800; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lsPe10u6HqBDcmGD9Z1JKcdv2q+3cFzOGeNoz7xgfPM=;
        b=RKBSapJ79PPvXaO1/tEfX7FgGRGzTDZFhwKbA0iA/jhwxouOfFHB5ct6hjSruFnlVr
         ske9ne/xAMJYvcPVqqtjU/1nGc03iWNs9UWt+F3i8jWGWuxW/mEQ/Y1nmAily5vbdcY1
         d7Kab6s+5Kok2n8wdyV2CUennlwlmyi9hwdwk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716568000; x=1717172800;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lsPe10u6HqBDcmGD9Z1JKcdv2q+3cFzOGeNoz7xgfPM=;
        b=L8oUch+eldO6kRMebD3yzLRZ81KkC5+SjBt2sBUu2qQuXWE0sIkI9DXeNOU6YV3MWP
         5/RMyfA11O+ShHGz5tQzd5BIziXDnXDomz9uhX69vn1ovUaMIMGScQcPqKBS/rxml50W
         20XWnKurZGtWPI/gpgoonf6hid3if88T4Q33qU+g3EO5+Lg9zOlhYahTc/GqLYulyJHT
         Hzvw2iU6xJlZJmPZkgX+EY1DfWk2uRzbKCpXeoH81BHEM2dAWiEBHrR+zay+k2eV9AiO
         CDoEunlZbZiiPWMNFxSNQLlEbtSGdIMYrenumDk/7vcLF1xWsFxDbca8mdAV/yrU3ZHt
         KQcQ==
X-Gm-Message-State: AOJu0Yw/OXf2fsbzfB3PW41/XWeQYAPT/YJfhpWJMGEAm0wnySjOsvZn
	7bm7VjDFSQ56AhMUP35ZN8s9JIDuZ+YFZiXqqxz8V1cfwGqsQ/dD9tlNMmh/lnI=
X-Google-Smtp-Source: AGHT+IFZbhef8P56pBniXYHEspKkB2ti3g9EoFPYnn4FxykwHwL2OKJqu0yxdgGOlJl/tpiHmBHLdQ==
X-Received: by 2002:a5d:8783:0:b0:7e1:d865:e700 with SMTP id ca18e2360f4ac-7e8c65599d7mr325855239f.2.1716568000560;
        Fri, 24 May 2024 09:26:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03ebbf1bfsm438640173.89.2024.05.24.09.26.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 09:26:40 -0700 (PDT)
Message-ID: <af4aefec-c893-4356-a50b-5f67a3913740@linuxfoundation.org>
Date: Fri, 24 May 2024 10:26:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/18] 4.19.315-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130325.727602650@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130325.727602650@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.315 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.315-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
