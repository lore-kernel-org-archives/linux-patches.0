Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE62B12C47C
	for <patches@lists.linux.dev>; Fri, 24 May 2024 14:36:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716561393; cv=none; b=IMjOo/emeTru+KirNlhas+f2W7Kgy/wJimQzyaudBS0cAF7FJrfB6vyJtAOZzadGIrH0IlF1XiNzMpch8821maVp2T+1n5ksmsZhi0dtaRM8mULvgb/PUxaopkUset02CzxP57gWn9RDszLL3cWxodY8k0MeliD7hcgeXhIlxLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716561393; c=relaxed/simple;
	bh=OlcQUkE+10S+V+5BWXkOihQkB/FKpWJlk/l27hzFiPY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aVWZDVsypikbncqdaLpuePDS59baS/h24es1z5RDQZW88qR2BHEGolWwY5TpVPrhr08+u4fCPCNPOvZT8m8yFYQxpQzSYFJO36MUlcdEkBF8yMAOTt7iUI+LlGcLVamvHY+hUq5nx7uVemAJ6Y3f7EfIwMOYAMR+cQOKQii2SKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SOJZYpz2; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SOJZYpz2"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7e1b8606bfdso6836939f.3
        for <patches@lists.linux.dev>; Fri, 24 May 2024 07:36:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1716561391; x=1717166191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R0A+T+phTh7w520oILhLQP+E0qPbhhtr/8XZsPjsHfU=;
        b=SOJZYpz2JqIAkdyuknG3dPObVMVvlL29o5y/r+1WzDmSpYNG1wKG2NJiVE/aTsAEOB
         eEAtHfloMK95sd0gOEpcrqnqCv8RVR8Z07Dv+rfNP4ieNN5DL2a9VE4tiBXETG6l/z5n
         w3yVqvA4zw/hjTDvJ4y9F0acKgyGESvmacL2M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716561391; x=1717166191;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R0A+T+phTh7w520oILhLQP+E0qPbhhtr/8XZsPjsHfU=;
        b=eYB7HqJubPiI4W2+3Lfv6lw3V6NbDATOCNUZPOij7N4Lsy1BT1AT/uw6AVsc8NpUWs
         jtE+RnV1sZXClq7SghcLaV1bR573OtWwblW5hrD1XHqmo7onG3D78rHOO1Z+lTFtPbqy
         MyDR2envnu88A4kNQjLu8ZVBp1d5Wt6U9qxHUr9hnxJDLN+I9+KY1kKW0E73D0Hs+Ind
         1ALIvlpPrE/D9ZJgiygbS9gMuhy1t5/H/kGGMbcAfI+PfDBfLWFKHLsnhTg9QXBLt74a
         R3WZcYmN2IP6FYvB4PxUhbPEJvJadwuG6ebE5y8LG9oaob5BufIin9Zd5QF7FyR3oE4H
         RArQ==
X-Gm-Message-State: AOJu0YyZA8H+OW+Bo4BYa2jwzUy+i0mvGVDwNnORlZdtq/+uGOVTzU2b
	8N+Ecp99PUYZ86tJRI+wU47WMQuHuSMJ8qdsdHWdgx1cihYechgbI+87trOjrxs=
X-Google-Smtp-Source: AGHT+IGwYTkaXZ6CDxeoD4a8OBX6/giEkKXDWpEKMArNNfaIijvcv/Bg/n/W7nMYYT2ZvRHrGYAcrQ==
X-Received: by 2002:a05:6602:2bc5:b0:7e1:8bc8:8228 with SMTP id ca18e2360f4ac-7e8c14117f4mr274978339f.0.1716561391032;
        Fri, 24 May 2024 07:36:31 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4b03ebbf7a6sm386420173.91.2024.05.24.07.36.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 May 2024 07:36:30 -0700 (PDT)
Message-ID: <f1d167fd-dfd0-4400-a1a4-5b3f78b9a59f@linuxfoundation.org>
Date: Fri, 24 May 2024 08:36:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/23] 5.15.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240523130327.956341021@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240523130327.956341021@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.160 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
