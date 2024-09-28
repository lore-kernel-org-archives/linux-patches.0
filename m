Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FF61474D8
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 17:15:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727543704; cv=none; b=a/vp01BaERacvV0bEUvGfhjRjgxOaRQGN9r6h8WSMTlhNa2BXQulLTKM4m5vg4SjPZx9/uMmFYG2r6vbU8hZ77HGfaXKm4S2tZ5jmC3UzvlxwTK8KNyf8AbDnLvZK4adoONPLVTjZ/r0pxPCHNxPe7l+awiL9sY90lYtQjZJFIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727543704; c=relaxed/simple;
	bh=Pu1ra73KdXyUjtcpFItrE1RBN62ZbzDM6xOG1WA02fA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cO3nuOJcvoIDL8f6Ja4rCeDuS7jf10neWPT2V0iHrXYoOaOGzvF3JEGxO9UCDhDkmWKPDN7Q13lY8AZjY22jqL+71U9/lrXkRx7CFPh4a5pSLAvqKWsW3xlC3Q0xI3jhKFDcLzNP2ITMn8Jkzwrvard8NR+R/Hx0UW2ZXjAFfbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DaQKwbpv; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DaQKwbpv"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a274ef3bdeso12109315ab.2
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 10:15:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727543702; x=1728148502; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JxGPjaFWUVuygqvE5pSQf6l07eOds48beRCBcUthdV0=;
        b=DaQKwbpv31xBiSxpRJCtb+Ub6mNsXJN3/v3vFmbkuFAAovZgTkPrvGbDS/x/E3uK+C
         yD7pnesMysLxWvelGUqhUtgMTJM7nU0V1xEg9W0+LKgqMt6G99ZGuJGugNlPv5MIwZeq
         ablX2tcjUjsQdlj2Hsl4Mn6Kd2ahqlEvPT1p8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727543702; x=1728148502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JxGPjaFWUVuygqvE5pSQf6l07eOds48beRCBcUthdV0=;
        b=fTLJ64U0PY9fekszmJaq2lOZ/fTAO9JnUi7QfM3YX+JvsmpzDQu9gRHALlp+f2IN3T
         FoszpiGCPbOlcAWPh1syCtZhRepJavxgPZV8tOHfWL1FldcbIwknzWogbUrHpxrPrWlf
         6/4y3ryzrD3SLnqfi+0Gb9ops4uVLVjFYBLRTVWkRG9dmULggN7Oc2/CBFdoqjQ6CIfj
         O38UazltM6fB+oBVtZg5QitmAT5ENVWm2aI/lbYbicUaOO8d2+/LXRKly/H6qR3+BZ5M
         85q5IGZygCmRtz6JMhNglva0/MlZU4jqq4R97ZjHJ3vCSIF1EWlpO9dgFA7pfxFpK9Px
         HoPg==
X-Gm-Message-State: AOJu0Yw8ppV5/HdA4qbKhDn1afMV1hIMhDcpDOZTPfftbtdNO/EC+5vD
	WUA9JWpEIpgKp0XEelN9hjcTlR9X8gQavbp2kL4Yt6DY9R4FaKy+2uEXBrVDNIY=
X-Google-Smtp-Source: AGHT+IENEVcL0X5iIGC/9WTT4qo+F5n851jEdlV2hj5sxqNpjLyeGAHMYcoxghnlDVw8QhJIX+ePIg==
X-Received: by 2002:a05:6e02:1fcd:b0:39d:1ca5:3904 with SMTP id e9e14a558f8ab-3a34517f9bbmr51119825ab.14.1727543702425;
        Sat, 28 Sep 2024 10:15:02 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d8888d9b33sm1178093173.141.2024.09.28.10.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 10:15:01 -0700 (PDT)
Message-ID: <2189dd09-25f3-4b3a-a799-44626765643d@linuxfoundation.org>
Date: Sat, 28 Sep 2024 11:15:00 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.11 00/12] 6.11.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/27/24 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.11.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.11.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.11.y
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
