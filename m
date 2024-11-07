Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 832B5182BC
	for <patches@lists.linux.dev>; Thu,  7 Nov 2024 02:40:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730947241; cv=none; b=ohG9LGUKzj69+gWGlJxND/GmsLTXknUjG1CfSTfBIN9IrLAXl7HGQTvaurqeVdPARc68x0nmKM2w3NghJLFakbEtsZcjF/XJ2NGDVQgTEFD6sBNxkv+Zi/PVXrlnMZOpFOeQJ9Rw2nN+LQxSNZwM/0bIefbhmoONQXkW5j9jDMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730947241; c=relaxed/simple;
	bh=kcK7aHsP78LdSs6pNTwsnISUp0fBE7OUksiNXAiKvy0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tv3/L+trrWjIPr3qfYfp31PGvKrJ0NtkQhF6o9kg0X5EMOLWWOmXQHzMRD/T1wG0zn0hhokM+cbze1c0juf6FviTAiJRFhOAPsf2O/tQpMvONzTfPdE10QLKb258R2x+6t4+1yFaFXjLDuhFesv2BiOywOrMVOFE5P6YdUXJCtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8z4bUPZ; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8z4bUPZ"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a6bcbd23c9so2116455ab.3
        for <patches@lists.linux.dev>; Wed, 06 Nov 2024 18:40:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1730947238; x=1731552038; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jVII3fPsxOIMCI+j60vE9UfnhsNmai0dOhdTYQx2JDM=;
        b=D8z4bUPZrElnXbbqUQ+cyivrFEMGjf7pBZonmzt82vodcrof4UQlcsNGMfESzYtQy9
         mckEFMolld+hS4ALWQl37P+YqLmAxhyx8D7VapIkYXTVCze/g8scek81nAbvvmkXIfWe
         DxJDPMrzLqToJ6hIVprX7BFIQ/TDHFVVwXxl4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730947238; x=1731552038;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jVII3fPsxOIMCI+j60vE9UfnhsNmai0dOhdTYQx2JDM=;
        b=AkZQq/4sEV4hj9SBA3zVYPpUw/OIIxutttfiVGPSvVf16Y45SVCNLSJKg4sc5HKc/J
         72yl+PdbhtY09w2AggBxtEAz8wA3sWTHe4j7zHJ7fenpsgKIK5KA15CZz2alaV6XQx1+
         8cdNz5AQga1Dwq8UeLed4C1UNYSvIjSTZDkhwXM+2Cj41Gy04Mbn28JbBO3qhq81+5df
         pTKCYjWRZUsw/njaGTipXH1N7aM/ypdz3khJ5bek4B5/uUOVTjtaNzCsrUu3AmMAd6tv
         rZmQZuO+rTKebJ/ySI4TG0hvOQAyCZ7frPI1cawbRLsd9f0ooGKUkXjDjolXLRvriPfU
         VbnA==
X-Gm-Message-State: AOJu0YyEGsp8EawhG5GWqTN08P0g1kUehcEL1FVCT1PDnyzUGHV3ppek
	7IaejPBoyJDT+HhkCAsrEVcc37Me6QIvaOV3RA4AdxlLylejapBQ0vXBduzd8gg=
X-Google-Smtp-Source: AGHT+IHGZ27/oZkKkcigXB4g1bcfKe8ACte6HVgTPQgFpjO28C3gZ2EVTg6rGHjcnOSRHLoyT/kmyQ==
X-Received: by 2002:a05:6e02:1546:b0:3a6:b3bd:e92d with SMTP id e9e14a558f8ab-3a6eb1287fbmr3501735ab.12.1730947238633;
        Wed, 06 Nov 2024 18:40:38 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a6eaca8c29sm776035ab.18.2024.11.06.18.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Nov 2024 18:40:38 -0800 (PST)
Message-ID: <390c9e9a-0f07-4153-bd35-9155a74b7d8c@linuxfoundation.org>
Date: Wed, 6 Nov 2024 19:40:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241106120306.038154857@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/6/24 05:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
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
