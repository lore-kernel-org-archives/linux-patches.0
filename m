Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0325A15572C
	for <patches@lists.linux.dev>; Wed, 15 May 2024 15:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715785738; cv=none; b=kpgfjx+mBYkuKXb6T1ROtKu55CTC5o91k7WgcBa9wE+ja/1PyNFdIDl0pKDmjXtjONcvBNOloqIm9lh7FRwPfQOWCrh54O6J572El99V+yFTqduXi521oxgeoZzFCvx7ySDLST+vctOdJD3vN5OJjUQXa3dZWO3Wf5ErlWuZTVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715785738; c=relaxed/simple;
	bh=qNAQ/s9LlzreCAmAb2oxC6fUH9eKBTNvC1uNwC5sLXI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DxqyPTHk4momfApArPzyHd7j3Jd88Hbn6dd3+O/mPCjd9SjVnYeMfRrR99Z7msYx7jr/iT+jVKxB00y0Ld7TFKHyINKAVSnFyGh07JZVx+Mpsp7VWrhf8miPzeZf7FO7pNNipfVAOEsncA4mtQGK9q7DmU/eeAIh9a61D59AApM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V9ooZPtv; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V9ooZPtv"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-36c86ad15caso317395ab.2
        for <patches@lists.linux.dev>; Wed, 15 May 2024 08:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1715785736; x=1716390536; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DSqN4wQpwk4yqsoWhaj7lKmacqnY0+0Y5JLQgrtZQTw=;
        b=V9ooZPtvbOEgtPN6NTrhMt5POU+UUdGLyweqUfy7YQiSBwF5c5RZXrtu3H/nkV+Mui
         VwsZCvGZE5WO2AfrTD7g70oOJsEcgI3aF2cqMIbkXhWVhOM3W8uVfMOrOJb/hiObT63t
         V1U6VNlCvO1idG08GaZieZJMJVd1VthX54VOk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715785736; x=1716390536;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DSqN4wQpwk4yqsoWhaj7lKmacqnY0+0Y5JLQgrtZQTw=;
        b=ivTXE3VERX/0CkRrD9xmv8MGWGRP84y+ICINqHtDhGyFbQj5lmJCxXDk1hdXvyQySS
         FqEgi3JyRhTd5qWxkQCM77/vbvloSZplWbIi2QVYtcj+j8Ag9w/GIM0JBm3Bmmm60o5V
         iovou9sT+/5ngKA1whMfopw+MFeZmaePOuxjclJrhI3MOcwXMrk0SSf44RN7Bw7Rd+c+
         9JiqZvj4b/fa6K22fyM1t+q6um2Kvkkhq7SaaaOeohg28hUwsn1npLVk54RsFR/tO9dh
         pkNe2ai1CGHMGROSdrpOLpN1kZ8PLhg39BBMcR/LQJSw8LUOmBv9wS/Lrfjh9m4ynni8
         4/gg==
X-Gm-Message-State: AOJu0YwD5+wl+EetF7VxYyHKiX6lS23Bk7j8U/TWRkI1MrLKiw4SZyH2
	K7n/ZiwY5UzaO70ftlTYcRazsVlV9oVuGTXuS/hExK3ULNEzq8d/AEeGFi67U0g=
X-Google-Smtp-Source: AGHT+IE/TJsiKBWLJTlooCuqIiZxdPbkyGL4Rv6ykctpuLdFe8Bh1zg+5HLkDYmp6zvnD13qcOfSQw==
X-Received: by 2002:a5d:8c8e:0:b0:7de:f48e:36c3 with SMTP id ca18e2360f4ac-7e1b500fbb0mr1695553439f.0.1715785736133;
        Wed, 15 May 2024 08:08:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-489376fc67csm3631174173.175.2024.05.15.08.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 08:08:55 -0700 (PDT)
Message-ID: <77d93d15-c9cb-46fa-8299-3e990be2e4e2@linuxfoundation.org>
Date: Wed, 15 May 2024 09:08:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/84] 5.4.276-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/14/24 04:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.276 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 May 2024 10:09:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.276-rc1.gz
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

