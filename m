Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028BA53E05
	for <patches@lists.linux.dev>; Mon, 29 Jan 2024 23:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706570104; cv=none; b=OTiRcYeeQDHq7Tizy9x09phKtm+mGOy3QbdHtQ5y4eINkALpvFyYQ+WGjscAFMf8Ty21s3JTuGdyZc0uNlFDN08RmIUrqU8nvvGS8BJ+cYEi68vU/31HnqNUKlvQQlK9oEJwjECvOHjktuQ4bPxOB7JcQ/z76i308rx5JzDmDtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706570104; c=relaxed/simple;
	bh=ehbO0HFf0uL/p+JVVry66GgwWQcsluKxO5QnGZu2pHM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ey6q2si9SCJaA94mmnCwfE15xilzTYwt2A/MJUzsksa+MssgtOeIE1p2o2TjV4aHs+im5Pra0kRzCkOD4vfaa1u6Bq8sAOl+/x9X749hvFOIIcz+msD5XKICxxZV1q3Pz9CPPTQLVd+4ZmTQcMfP0lc177Y5kvIbL5xDLZWvX20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zy0ufgH3; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zy0ufgH3"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7bf3283c18dso45590639f.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 15:15:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1706570102; x=1707174902; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HlEg0VBx55ozwcl3uKk0QdR1gxYWE04fuZIKqnVt1W8=;
        b=Zy0ufgH3U2dib4KrFKgID+LULYegYCPYJqgyX1sCh98q70gcO5YziAYHr93XjnVkCM
         RLfBsZpSgffYW5be0rH7Y09ItyHRUIiyMErquBtZ7IT8E1ckT+nUCCJp6OvRlqjzRapO
         XNiIx72EjH/y11pUYA7T5QqD1XTzePvlZZa78=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706570102; x=1707174902;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=HlEg0VBx55ozwcl3uKk0QdR1gxYWE04fuZIKqnVt1W8=;
        b=jL+n1dkVNLoOgNvFJ9K6mggTsO6Bgw19ZE3tWOnVXZ8j8RmiZ1Va3HtI7L7kedkt5I
         PxVyjVqIVhdAzKftx2VCq1IgGLP7BKnfhCQBEz6dGP1j1jdRRnEB9CNuB2NefPkJjs/t
         p/tW48cTCg7UT0+7VFZTCsnTQJIJLPG+uIqutx0NS9VDuQNUA5xaDFYLHu4uD8fsXXyL
         OrIp1BioiUbbMJ7UlwjkQ14Jdu7V0tyPu/V1nxHSly/6IqJgkyXG5vs2qTDFCnIU/cCb
         5+W7e+hOz+puVKRey/7GAeZWsnNgRmjjbmOWXe8ei0Tim868H55lgHMMxkUSY/UjykKX
         kaCg==
X-Gm-Message-State: AOJu0YwCVCbz8h5eywWIhi5VAUDKr5EddfsbeLeQn+9UJjmLD06If0Xg
	m+6gauVma2iZ1e65q8CIGN2cflqcmCzA8gFuiKAZ7KT/YcZ92xf2EQBs5zDD3WCh3BHQ1B+Mvgh
	O
X-Google-Smtp-Source: AGHT+IHTwdmWs+k8W9kmfFqN0grLMB9mP0tEqiQOdwQiuLcTv+h5u+9+wvYtVGHtchOhzbsPR56BhQ==
X-Received: by 2002:a5e:870b:0:b0:7bf:b18e:fccc with SMTP id y11-20020a5e870b000000b007bfb18efcccmr8110539ioj.1.1706570102071;
        Mon, 29 Jan 2024 15:15:02 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id g19-20020a02c553000000b0046edf6bffedsm1988701jaj.85.2024.01.29.15.15.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 29 Jan 2024 15:15:01 -0800 (PST)
Message-ID: <88a1bc55-710f-4d64-b51b-90787a4090f5@linuxfoundation.org>
Date: Mon, 29 Jan 2024 16:15:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/331] 6.6.15-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/24 10:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.15 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 31 Jan 2024 16:59:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

