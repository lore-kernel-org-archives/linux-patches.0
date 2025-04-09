Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C3F127EC99
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:54:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224880; cv=none; b=KZHR/AZ9WDCwwx2qmqkuJzZS4weA5LHkvvsN3DMKn1YrTH/7Y7WBL8XmNBlRDXXAh8S46Zp7R0j223fOgyQiL3pbaNmCYI8/1rs52jTH4K73edTBdSrCzFTX6bCp8piIjs32PruHWZWZroJKck4GPM1c2xW9WAc2CrbpKKVLZWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224880; c=relaxed/simple;
	bh=BItrTn2IJIH0MdLppMsWlQgxElkb3NvoIdETrPiCE0I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Jkln/eptFT6PnpQI7+w/I8BdLC9wOmPWcfUP7PH/YPst9cVoK2bj0Wec0UCKSq3CwzNznP20GkL/Lcp3K34aPOiU5751K2O8NRc8lWwMayhRnXN3K5dppqw3toPHtTxk+BWGuOf0kHneT61SpGc2YpNdy1+Yu8sTc0ydOIdC4YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cfuEvlAY; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cfuEvlAY"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-85e15dc801aso3930239f.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224877; x=1744829677; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c7HCUg9+RtKDsPTNL/2WrP5NNIONueuTQQ7XmSzDe9Y=;
        b=cfuEvlAYh1UYiRKo9jTOIqGTrGN63D2l88cI01MbM2BZB4rhZOh2nGiIgPUFHGs4ZG
         KxZ0C5zkyqfBxt8oMfQ1WKS3BFBhxk0m89MtKAdPvcSdXPjgOTRUgBU0GmEVyIskrwWC
         qgwyhremay4gqel6sJhhPVHLXxV04bWHLAUpQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224877; x=1744829677;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=c7HCUg9+RtKDsPTNL/2WrP5NNIONueuTQQ7XmSzDe9Y=;
        b=FbHb5OYFgWfXGRb5dYeo5gQTMlNra6wwAC1yOKppjepFffz5DuA0Ae27996MsIf0tp
         RuWzG2zqRKo0UhWKXOoQt/E32c6e16gZrqvr5Zcd48ebSD4mw+NsjJFLv+YSxhbszMKa
         z7Zd7oi7aXAi6eYpG3vr2KpSJM6EDqO2wLuK2LZVml4jgqfkfepDn/YPxKz5DOlrYQMz
         7xDnWL/KO/J7ckJ0LmQ8Kt+YbtnPXpPMNXEGXtk2yHu9FXn+O2Z9CfYq+be8oz2wqv9C
         2hIzjW+UQC8zUGDgFzTyJZuPp3vOkI8P34poCO867brTQqD8eHzSZzOpQAfXpA33hjRf
         4TYg==
X-Gm-Message-State: AOJu0Yzy64zTlGzHgHmtU4dCGVHoWtlFx2Tra2l3SpHj7eqBQKixXTSB
	Ouw3pTdF8uMOUh5YptWaN1DCM2h2MEf7q9THiiyUjX7wET5fWgx4p0aig+N1JXun28Z5p0nKHGG
	V
X-Gm-Gg: ASbGncsFqHnXUx+Vu6oh3jIVvMy2cuzHF8dDk1EJy7+Z9OEk4Oumo7oO+iBngp/6tqZ
	q4B5O9OE2cLzZJ5BjRy3r21hBwX2E5Z34HbhVn6ySJqgs1/faBb6rSRKC2axLyOEzKP+c7Ab65U
	N6OEV7fhkCWCJNj3P8oDLK1jQa88ghSVhMz3lVNlXBUlCQlF7opMu0bePfnIDtF4heXSHALeffD
	T14m+e8At/AnsGsNdzHA6qGCLRu8501b5O/0AE/fGFZTSXopYbms9+9YDi4a9zt0pjCqbqNL1ab
	BAUM/dLEU6PONz+kYAuU0cDFe4VsEn01X6rAnFYzxWMpq2I3pzY=
X-Google-Smtp-Source: AGHT+IH5i6yQTBGbz82VtAMEMdTBDeDBWpGhiHzbBDbPeaa1aVN55DG89VDgZRcqxydWuF8KbdUa8A==
X-Received: by 2002:a05:6e02:1522:b0:3d4:6fb7:3a36 with SMTP id e9e14a558f8ab-3d7e478131cmr1913715ab.20.1744224877086;
        Wed, 09 Apr 2025 11:54:37 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f505e0271bsm369857173.96.2025.04.09.11.54.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:54:36 -0700 (PDT)
Message-ID: <51c911d6-a7bd-40e1-97b8-f73d94d2e9ce@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:54:35 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/154] 5.4.292-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250408104815.295196624@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250408104815.295196624@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/25 04:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.292 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.292-rc1.gz
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
