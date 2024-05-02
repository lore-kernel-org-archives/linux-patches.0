Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E34417571
	for <patches@lists.linux.dev>; Thu,  2 May 2024 02:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714615865; cv=none; b=EsQAxMYxv/RCyClHSCHTGi7tCHafL7ZVEb5McHArWhSEMZ/q/SKNrt5/cop+gWjEFmc/JlQCKibiYNQQGPyi7EYHqwic44jLgCYVcIpVoLPoaNM5jtYrjvJP4YSZAePZw5hIEu6fRPd4iLRIE+k1LlyWTSg0lBboH2KorFYKJCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714615865; c=relaxed/simple;
	bh=iRqFjcp2JS4wJru6lJM4cL35QVmiTQNsqCV46bY/XCs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NTlkhRSdcRggqCnFt9tW7uGBe+L4r4xscD30+mdZF9X64wDFFl0TOZUGT8d+rb+w5fYNZJtmEKQfG2PSIgIInt5v/kRkbQKM9iZdabMjGd9UVB1nuRVhrDOndVajJMTn5YUAcV6tfXdqdYumzyeCzd0MrEVw6RAtNdxAlR4pJIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A3gNQbNU; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A3gNQbNU"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7dee034225eso20886639f.2
        for <patches@lists.linux.dev>; Wed, 01 May 2024 19:11:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714615862; x=1715220662; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ux36Du+V3TKAlinHlEmK9kfOgnPDluyCdGYd1Ayjxyk=;
        b=A3gNQbNUsm3sQkXc3iqO+aEnbsIzbJF45q6H9vHeZ+L19k44y/8LBhjVQ2Q6oC3+gI
         qfmG//NLscS3gfDRkyC/gEzoo4CgLyKLnZ82WzWhYLd1PgZxtDqTh+FGdiv+GxS0HRdt
         D8sTDUZFvzpyhOTm8oYZDWtaqXJr/GPVnWNe0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714615862; x=1715220662;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ux36Du+V3TKAlinHlEmK9kfOgnPDluyCdGYd1Ayjxyk=;
        b=fwZ/ghUtKlnUljnIbGN2QYaJjLEnMbuuvMlcboPAB/65ItNeob0BG6KKcj/X48SmSP
         mVyTEdaFK6/qGrIZNQNt0GPOFR2wglHoEcN1joa97tnA9oSYx8VR/duHLt93DcLwBvVr
         BwmAQ+lbBVMXL6iJYjO/EkMDgl1nWYDGQkhq4ztyqlvXUGldL1Vat0ybikKUguUuOsn4
         w+gUx8UtVN/IjWHv1J392GGK7rzGkX9BLAdpZc1GftFKZRkynkQ60jiW3ExA+KZ+1Sw6
         Hb9VbNiXaRcyQ86ryjcg2WnDewSHfuE9W6O0K4cV44qUJ5K4zGots1dW0+t90w9vl9di
         nlbg==
X-Gm-Message-State: AOJu0YwS0bIn7j0kafCwo63xE/DJ8BobgwTtus+hyhRkdpa6sMtDQnZu
	wDsK584UgDB6jATxO4inVSQOg11RoLs65HFvUJdqFXPB5Kza4xFCKhkJieUV2Lc=
X-Google-Smtp-Source: AGHT+IFk7Iv7uzyxXIfPDJ7VEbUGp3sjzrH395PU9dimMM9OWz98WD5XY4sa+Y76BZDYtMhmCFUdQg==
X-Received: by 2002:a05:6e02:1fe5:b0:36c:5572:f69d with SMTP id dt5-20020a056e021fe500b0036c5572f69dmr5487322ilb.1.1714615862413;
        Wed, 01 May 2024 19:11:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id s12-20020a056e02216c00b0036c5d1d1cf3sm923789ilv.87.2024.05.01.19.11.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 19:11:01 -0700 (PDT)
Message-ID: <fc4fff68-3012-4c90-beea-3d28dd1d7d61@linuxfoundation.org>
Date: Wed, 1 May 2024 20:11:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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
