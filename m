Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D66F2DC798
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 22:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777069487; cv=none; b=nz6lQlwqUJTKkYacgumjI/1TPwTBwK3Bj2ldI8jNGTUfr7T0qvCzdETpZNWwjCfn+kvO53v8LWceumk8iDw4FpsgHHnMXLlmbrdJsbuBAjjZN+iJUw6tjlPITjp09Uz+orU+uskc+2j/5yzpuMFt4upo+b+1th2vPIj4ksqmnmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777069487; c=relaxed/simple;
	bh=QRTQt8IYZ1PoJoyPRwAMIdnKbh+/mDsCpuzGqRWl3J8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blBZGJP3gZppxCLieH7Ig64UyczWIxybT68r5DBBC7PqaW9S+ReUXSHe9dJF+2ajDC4yvKeFnaE0Dg3ERomVESPHOTFkY3vezSeXcyrG24gYoPRcn7st/TKCoIxFb7YBGxag/SA3FsxmdUKYGrZbK1CduiTPZdOevYUxyLWBdcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N7AIAalj; arc=none smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N7AIAalj"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-42fbf95cca8so2855935fac.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 15:24:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1777069484; x=1777674284; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7hoOTgbH8m6VDooPa7iPwA0AOawKhYjioyD8Abk/9cQ=;
        b=N7AIAaljd1LNv3tdsJLKy7mSArzS/y+Z63yY/xEt6IJEDh30ZRLfpi09SLfb0IePkr
         rOCNO3iJ7K5TWK8kgs7xK+opf5xCfihjmCgtcMUKq0O8P514mAtM/h77kx7mRcMTBFH2
         RBamN+oZ2v9e9uHpVvlsfEilVuQr5raq7Gv2k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777069484; x=1777674284;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7hoOTgbH8m6VDooPa7iPwA0AOawKhYjioyD8Abk/9cQ=;
        b=KgBkoLcvIESZvQ2/CkPIch/a/KSfWR/HSf62h3CUYYSw3tWaWf6+3yR8EWDjv7CDTW
         SMbvrw7GeidhMlKH5fkgRsYlsCvjOlLFOh1AWKAdSD2dLfFK4bE5C4jAx/zcu1lzmsEU
         xvGtNCQv6SbA8ekV0RcD3dO/gfVZcdXbq5JBOWsw1EV25HNlhU96654Zr1mMux/AwIBd
         36/Og2f81NCcH3Ozqm7dnlLBeoCRQjaz5OkuvDVEDJcb+MV3gp5BVOHEygPNybqmhLom
         qfjTTqRfErABlswtuMDEG0kS9hGhLD2vLQlNoIo6DWJWp5kYd6SDtuR987+EfEOxfNyO
         ehUQ==
X-Gm-Message-State: AOJu0YxMPuO0/PJBcpKFvTZhIIjui90SVLUsZHKE2TyU0ZwkM+Lf+L+f
	tceJ5izHTha+e8+z+j/naGIDr8zGm45avIIJYdDXwSk4YS0k3Wa2ouPq8Ok5D/DzJug=
X-Gm-Gg: AeBDieuQONRWFYuOXkQQ4HwZspgAaAZyu+SvbETqZX8d6uy8imuF5tV8xP0Vv8te8Zs
	3R+ibwV1OY+zwUItXvWMWTbL3Hcj+rX5RbhHEf/krhyDjpBwfumZhXAmeMJPoKjxZw1k556YqA1
	xcsAE7eyeIZ2Tv2hiEi1s8fX0LJqwrCAZKQv27jSegNnjsYvMJFguktbv5mwP5MOUiSchsTB+ct
	BQHMdS9tROvFP2gswdjERQ2cI6KhOeNKdFWBZbql5l+qBAVa0nRtYFTlQKh6TWWtR3+c0gxZ5uT
	vV+o+j+2OZu7A1lT9P7AB7O8Vzr8FHEMP5pnq4aMj6PIp2/IZja/H9jSQD9j8hNT8Q0E5RrBE9G
	AprmosxjRl3MCWrS9sGBjjqMEObg+nAjM2y6yWUM6eHvFFrmYHwFePk1fhtCPZlN9h+gIMLe6Tc
	+yqYspPdo+aMVK7MjfdMaLTvWlvatkCK6QfUNZW4B72w==
X-Received: by 2002:a05:6870:d0c2:b0:42c:2c15:376c with SMTP id 586e51a60fabf-42c2c4307a2mr12056818fac.4.1777069483982;
        Fri, 24 Apr 2026 15:24:43 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-42c054997absm15591799fac.3.2026.04.24.15.24.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 15:24:43 -0700 (PDT)
Message-ID: <c939e98c-8913-490a-86a6-318942f6fe91@linuxfoundation.org>
Date: Fri, 24 Apr 2026 16:24:41 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 00/55] 6.18.25-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260424132430.006424517@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260424132430.006424517@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.25 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.25-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
