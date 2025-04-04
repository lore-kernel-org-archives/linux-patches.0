Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 380BE1F3BB7
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 14:44:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743777864; cv=none; b=iVnJxdg6ElWLo5Xg9kIjgvpzORW01bnFhvKlgqOvY4yAPsdnGfJ9ZG4HJpjRT4Pwg6JQ4RqIQ4x2hBhxqugg0NTNgRllWu7SjATrixU5uCObh+KJiUqHVjHB5ejXXqjBDiV6kfQ3josj33YmJuNi79lcsP89BS6nttwrDd/ZFrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743777864; c=relaxed/simple;
	bh=E6utw/gDQf+fI4uGLBdnXPibG1fX3thq787NQIaKJ5E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lzymzss9eUdTZdfcVwV5OpCZcWOIVa6dri2TFVYk1qiH5QYZ3DKx9m9Mrd8hfhNM4ZwQ1x8xAdfJIn/VjviG/rrjmefNAPitCPZ/Ii0vWj9Y3Pcoj+4aVVHdpic3PiqaQqb+QX2yec8EQDySn9nL3mXJOz2aT7YS8/BkypEXd5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g7A8Yeow; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g7A8Yeow"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3d5e2606a1bso17295095ab.0
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1743777861; x=1744382661; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q7j6X65sUf/Y74e3CXgX1WG8fpjUk7SSrlyn4gxiEzw=;
        b=g7A8YeowXJZryLm1TON1UJjLKZS9tTJiiugqrVFLzpFyXsUzHy17tBsdPBqqmBVBjY
         JZjrXcwBG5LLicnUc9tLUzyHoyW6pZFpbMgju3oD9uZKBtG9q6w0hB0v51ovcydLEMF9
         tyijYwYhi10FRRXnb5Pvbn1gkIi7ddApsdQ5k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743777861; x=1744382661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q7j6X65sUf/Y74e3CXgX1WG8fpjUk7SSrlyn4gxiEzw=;
        b=of/tnAhCerLdO1n3cj+XjMMReKyG/u22Q2bjWTVoYK96WvAaPa29+1XDo98u9cn3Hp
         ZO7/lSPSMYMEPP/2fWs00o8Bzv2/K/Y+bdDyr7luhQlIcgp3e81bhK6af1j2AZ7WPDMm
         B1EOqy23xQviaAJM886qA7bGZRx3qNzxzN319htB49DTn+o1rRNiIUwFHW6xUanBlDv3
         gC7Mx/IsAzlWkxaf5bgQ10mJ8M1Fq5mckmta6/XZf3aq3f0YtUfnEyyNV/98sT9b1rud
         ZCHO29GRyu48Z2Wn3PzW697WyoDat+hvHqZOs1mPuX5bh1hFS5ivOpDpnZkzek7yaoED
         EmrQ==
X-Gm-Message-State: AOJu0YysecKkfG6MqS9DsNyJMPT20vX0pTnm9mx9vYeMxGf3BGSWm8Mm
	Z52X2xPWlPIxCLLqGsPJZfDcm1nF4rHK5Mt4wYFT/9FNcr17xv5LjQMQ8usw/Ac=
X-Gm-Gg: ASbGncuxnV4EJKvCoSy1RZb3EnpmEOi+ATgCwTJI3W8xJiV+27SKJO3tcJMAkwUhTv2
	u7rqtUtxxmYOlYtwduaGIay+xfAf6qGvOMhvPrqoGccd/k68eGja8VLZcUvrqBhpufSJOa3bY2J
	ccVFVd0gtLlh8IeR+zMu2m2pIFYOBVqxgRc0JwHRA4EbnEhxjkUWrz2fgl+vOCMc8vxho470EVP
	ryiwV/EdR6gC+gwvn2V23DvqAW2C0kGgbWKIfhpt18ngozf5XdAWfRpsEVPitw8uQxyUzQckrU9
	QeYezlT94ZzYE6rKEbU+Vg5JKLolX+WTaG9SxGljTCaQu9KYLaIcukM=
X-Google-Smtp-Source: AGHT+IEHkqDh9oJa2S3GGKDi+GP2V7X1hMJDHi7lwm71y2eKrCoA2PqIlJS9fMSkYj3RVmu94fwG0A==
X-Received: by 2002:a05:6e02:1d9b:b0:3ce:8ed9:ca94 with SMTP id e9e14a558f8ab-3d6e3f6573dmr40989205ab.14.1743777860986;
        Fri, 04 Apr 2025 07:44:20 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3d6de79f070sm8236735ab.12.2025.04.04.07.44.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 07:44:20 -0700 (PDT)
Message-ID: <3936bdd4-b776-49a5-b997-a7c6139c5f85@linuxfoundation.org>
Date: Fri, 4 Apr 2025 08:44:19 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 00/21] 6.14.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250403151621.130541515@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250403151621.130541515@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.1 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
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
