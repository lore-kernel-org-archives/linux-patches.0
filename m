Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51A0192B62
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 21:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731791794; cv=none; b=f1Mw+dfvn3t4t71ZjeNQEkqRvgdkI1qYVrUNsV/22iNRHn4nz38cEcy0NuEwON8Ai/lRRNDGTh1gp9FTKxU5jx3ItdXMhmr+RViuALEC1H/W6eqEDBjQd9pRzxEFktRcSIzJXkoce/kD8d8N1wi44ZlxT8XuBMfceNYWQ7qzz8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731791794; c=relaxed/simple;
	bh=7PMrz2Zm2mvfKq4nmNSmKHiyobn8/8ri+IZxkljJbyw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XdJiWUhBOhCj29leDudgqokSe+vjic/8fBpd7OFUWrafiY5YOqIYSf6+YxxMvi1wi56A+fieXJd7Rtz56fchWg/XP5O4L6IdUp1+FEa0i9XtH8cBYlNu3mKWrbzls6r2f4Pa+BmosN4HsaCyP+n5ES+zMDn2q1IEHhv3mhfuYm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a7xfB/aW; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a7xfB/aW"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-83a9ca86049so94461639f.0
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 13:16:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1731791792; x=1732396592; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ThohtjZ3n9Q8TJFQ3v76IV9uxQamdVqCdT9v1KevZbM=;
        b=a7xfB/aWnQA1t4hTK3Az4UmqcTjozMVUW5ZJvWcJUx+4qBySUI7VqoJXioROscgW18
         JlTQIqWLeC68rkrVfpfQVmtFOUnlkEY5Zi6p5rNg5pttuApGe4OE6rh3VZFKHAOTZXEz
         hgNLQK0OJMz6QiRqe4zVdgusbF7TyX2x3X/38=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731791792; x=1732396592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ThohtjZ3n9Q8TJFQ3v76IV9uxQamdVqCdT9v1KevZbM=;
        b=Y93zRFxFqvnP1MdDgfCyy7Guk/jU3DW4cfkVjcjqiApm+2S64B00WtxcLEJh/0LO7T
         Whjjke5PhcMeiCLLn5t/jIH4fWHlnhu2HroZnAMaKJNIrS8LxR4gLBK56aOo50ZRkjze
         +/gMKQJ4uL5iYDd47z00Rg+bTgwL6SRmYElRmZLLqecSLX7oLOmNsKGdWM0DO2a0hg+T
         D4mYP/cUbcmrGBjJMVOuHcD5ZBvKEKkQukVgd6ZMQaDV3YGyVHIqD/1qUudmaoOkVsWK
         f7jm4SbauHsi2XPRCKesEEFIWlkwaK2zGYkelXJLqt4+syG8xHVQPUhNa5Yt7EwfXQb5
         h8Vg==
X-Gm-Message-State: AOJu0Yz0WfH8HQrfvk/CA7Q31nf0S570xVpgXtFkwB7tZV71MXglPTcw
	b7pr9sBHT6MNkiiDOzaTKcyvOB62LC4vR7jhdIp63CRaicP4ONdMy0KKrDL4khA=
X-Google-Smtp-Source: AGHT+IELWGMLxig5RgGYIn+TwWmLLm0INc8xcQs14z602A4podqiHLfXde+yVDHHN+PzMatqyRdC6Q==
X-Received: by 2002:a05:6602:6c08:b0:82d:9b0:ecb7 with SMTP id ca18e2360f4ac-83e6c299f59mr878007339f.3.1731791790626;
        Sat, 16 Nov 2024 13:16:30 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e06d6eacebsm1260708173.25.2024.11.16.13.16.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 16 Nov 2024 13:16:30 -0800 (PST)
Message-ID: <e143fb80-e6d4-43bd-84f0-14a1bac08df3@linuxfoundation.org>
Date: Sat, 16 Nov 2024 14:16:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/67] 5.4.286-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241115120451.517948500@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241115120451.517948500@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/24 05:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.286 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 Nov 2024 12:04:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.286-rc2.gz
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
