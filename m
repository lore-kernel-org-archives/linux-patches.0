Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6E112E1FE
	for <patches@lists.linux.dev>; Fri, 24 May 2024 16:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716567974; cv=none; b=BsqBhpdMhXw5JV+HxzsS3ySr9jgsPYEsBmVBVFlkTKCELebJWTrTt6h5RZYk5n85ROXKkYkQLTl9AamaTmRT4rkv/qJIsRBzRqX3zVpWe97jGANt90DU7ooJ2dT9dB1j1Ff9Pio0EaS+v41881AE6xNZfiTfavb5JFjDZWFqHOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716567974; c=relaxed/simple;
	bh=NTY/Z9vtY53/yxL38hWX8wJpC/fbWUZ8djdpBxujX6o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XEXdciCVE5+bY7WuovkzCp71MXQBDne+eleNQEu3NNw35iwWvn2H4x1SL9CAt0SmwyRpI3JrQdvyFaVxNIpcbu7LRjqlX66GcCdgle5CCNEeyC2qORXdFt6DtC0BCZpMkw7Y+tKPHdDg/1GimnnNbDl/WhdXpbGu6xWKoCPD9to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg0LvxJo; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg0LvxJo"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7e8e2020002so4640439f.0
        for <patches@lists.linux.dev>; Fri, 24 May 2024 09:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716567971; x=1717172771; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Kwdb8YgsPUZNPJAKz/pu745pRsXy/bayXVNZ9hxFw1E=;
        b=Zg0LvxJo8mAHrQLtLltXgAfVvx08dfzTG4khA/jsesu1AJMjhYHZLvhBR0tkiu6PvN
         B0svqxAmKgCmAG1wbg3NgOal6JRCnyySyYGfm7Yl1Nc3p5AJg2bsm8HsFDEhTpnSb+MA
         0ODhlbnVRbMuncJbr1KfcOQHvsTHFntXuT7f4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716567971; x=1717172771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Kwdb8YgsPUZNPJAKz/pu745pRsXy/bayXVNZ9hxFw1E=;
        b=V6fI2mARKMA53UcGAlh0xM7vMn4iuwDg9hGrlD9WVNv9T7UYdQwhT2yy3Q/V5KiG73
         pcildFN8FXXDiGEdXP6pUf9kAyv266YdUgvbcDou/iNV5cP/Mx5Fw8joFMt5PRdd0AP+
         wZ09sJBvQoNcAhaxZ5Dcez3j+U//DGoUsMyge+YzKMnIadfvMBfb/N6cPOIF9NH0HLug
         AMkb8aMtYwCPEbGmI5B4qHBTNtQKG0OU289i7T/8PRLT2Bsr6+X2T8N1CAR0WssWZJKu
         H1zxrX/KwstzT8UG9rE+mSJO3hukvUxE665ydJ8rvXLKaZ9gdgLGKBnud9lm42cJQlA7
         IanQ==
X-Gm-Message-State: AOJu0YzUs5luQnuualsUxA6Jjlkjafv2uUJ2YChZyu+2NFGQ+xdA5LfL
	YFYqdk1ynsdDnLt8kgMmhRD5FpRmAaZovg28ArWDigYEnO7y/MF8rvI9V53W8yE=
X-Google-Smtp-Source: AGHT+IE89eceySKyxxGYhU1vsQz02+tAJU6zkx7ZB41UqW+BW6pwkqXmIYaexWDDo2VjVpg/htC1sQ==
X-Received: by 2002:a6b:fb09:0:b0:7de:b4dc:9b8f with SMTP id ca18e2360f4ac-7e8c607ad49mr320125639f.2.1716567971449;
        Fri, 24 May 2024 09:26:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03e94c6f2sm454828173.44.2024.05.24.09.26.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 09:26:11 -0700 (PDT)
Message-ID: <d27fddbb-bb75-4894-b164-ac9c77bc2061@linuxfoundation.org>
Date: Fri, 24 May 2024 10:26:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.277-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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


