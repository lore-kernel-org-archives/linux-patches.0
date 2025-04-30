Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1543725E45B
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028560; cv=none; b=DQKbN9H9MgVaBVx7eZDO1Clz1E/Jo+PSHAY9Jck5xHzo+NYc2/suHO+RcNfG3xby0cvrNpGzjWOqNyzCwiO7/aPA5LnK6b6lBhOWoV0U+8e8vv5W5Z3imI2dCuGHsts+eJUY7KvLDjTKwvv7gyfcOJV0RsdLPROIIxOuXbIVp44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028560; c=relaxed/simple;
	bh=nvpbM6yPn80ejMIq2G5tOqowwPWvomfiV80DiRlQ3v0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kLLQ0rqmFMYlG2yB1DwoCxw+uAj6XkT4FcUZYF66qqHzh1iro9mnYGLTBxO7qNvUqR6d+reP6nNBjuxfgpFPZL5+rvd0i7N2oO/wW3E3eUg6aq0VrQ+6fHgCMYefH3Of6uIuCJtKbKek5OPeHJv6qIOOm/pbcpLv1ZIdQ8dVaBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UwJqMOyi; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UwJqMOyi"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3d93deba52fso23625ab.0
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028556; x=1746633356; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b8hsdaBH5p1DQoSnQ5Ty53GpeYiStgKXkL8MESJIMtU=;
        b=UwJqMOyiHkzVsM41N5Gh+up+VXrzT1i0LyBb3i2QlnUEuPZohiCO/TvuXuX/S5onI6
         7gp9HD6n7XECVHhkhlnjB4Tm8ZlZvPUiwHD1uXx5EqFRyXNYTsKx0EP5gJFHzLZsmbUd
         92gWNlDdiLohACjrkQJkmcR3vmVGuTIRcrxHA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028556; x=1746633356;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=b8hsdaBH5p1DQoSnQ5Ty53GpeYiStgKXkL8MESJIMtU=;
        b=uDPsRDPgmv8qRMROCVLL4ceAZKNTn26qcZLDqw3+YhsiVQ78BNi4HYsa+3+ldXv7WE
         WXjvTz8H35oZblm/tJ11pVyoCUwrhUQCdCs35CDIkRRTVpsWZUL9rK75PY++qaAEDAdS
         eV98k6oRtvyecqPU0SMcYr8TcpkrhBzMhjqIEU9fhbLOzp3P9PkkBoRFCWwaH8NkhZe5
         PnYLTuEXuxz9wpURbiYr/+STVXlJepIqG8eEX/iFyQXvqftcCPBdNXa+EE2d+sckR3wr
         mfZZfhVEmxU5w1XjJ5VvfFsbhqxdspyEkwmaBsrCfFfVGHI3wolGrgIvkEWUX0xcpUb5
         XxkQ==
X-Gm-Message-State: AOJu0YyWqIxcX5PcOIFxn3ieIBnprFU3ggMRXrFLCxgv3PhIydSRbLgl
	d65CSBct+jQDCtUCMxfBNCzMpxW69pwd80Ck0KAn+zk8teBSzST7J8WI0jv5I9I=
X-Gm-Gg: ASbGncvO+t0QY1RWWvoWSdUcrj+09wS4stVCJgCsLp8d1O6MrQqJeiWdWO+0aI3x+Ox
	RWoLn5go6tTNIYhOcTPKQ5jH85Rri9PQ2SoGS1UfGqkzjbrd7+1JA8d5fVbbhyR0qV60v7BkZce
	v7Dt4FE5bO6dyW+002GGMjGlQgM+LdkIBh6/TJMMwNs9U0ZECBEhzj2vVf5e1mdlPypHl+GiGi4
	Y31ERKmIwm02xLVyNQyHDfqQ/5zmtg698NvMa6wDodlkGh1BDUqzeZITht+grYJkgUF8uNh4hrw
	KDCadLG3nXRYOAhzaRP200moK79S3NmhD060qgD4gowXLPtIOas=
X-Google-Smtp-Source: AGHT+IHDd6IrZ/vYNCzEQn0266E0pxx26NMuGqdeEc0TxxwFoyQmZMAPG78d5AHhYanl4op4L0EMaQ==
X-Received: by 2002:a05:6e02:1f0e:b0:3d8:211c:9891 with SMTP id e9e14a558f8ab-3d967fa3bd8mr33031125ab.2.1746028556114;
        Wed, 30 Apr 2025 08:55:56 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f86314a291sm803211173.124.2025.04.30.08.55.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:55:55 -0700 (PDT)
Message-ID: <25a5c132-6686-429c-93ea-1a0944203af0@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:55:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/179] 5.4.293-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.293 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.293-rc1.gz
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
