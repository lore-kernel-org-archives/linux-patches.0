Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D233C4A3E
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 00:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760747154; cv=none; b=qqcZk80FHFl9nG2YzZO41h3klTj9vd2fEZiXED+lygfCPhrmBOdNtA18YAaKjhMZCy4uEYKuWeHgc0SxDQH/9xcnPUGp+2PGHgIOJGvFqahvLqxDRfjhYZbLWghwSmqOqFijZP816N1wEnsc6y4anpr4nYpRC5JOMR8uHBTnDOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760747154; c=relaxed/simple;
	bh=wYDlpw74Z3cyAlrGrGpo5UDCI9NbA92k8W5CCOz2vbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YPJI1JWaF9gpHhdmcgkbzsS0f4AoZ27v5XQCQkTf0LK1qTV23eew1WKlu5Hl0llenWWsvt4sxrNRkw+b8Wl2fZ0f5tJFW8332Ha3cg/ceH8Di+Ni2+EAUY7orCMeQ6g23URk+YMXrUtt1GwEZXefwUSvAIZ/2eAwxtailbbX1WQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DygXehP0; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DygXehP0"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-430cd27de3eso3430425ab.1
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 17:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1760747152; x=1761351952; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ii45rQqKjwtGH5Psho54TOQP3QBwhKcT/rt69FEd2QU=;
        b=DygXehP05iCb+lXrXbyxc+ySZtzNrOa/oWDPNJsDjLSlYWozJY0kPC5QuU9d7LSBrY
         3YqebUIQqGi9nKT1V0KnuBk/WDMbmnbe8tJ0qAAGx/JyUwaiwxUZJYnOyzy7XBk/O0iz
         eaE8JZIP663s+L+JtxZj9hf4Ov8zxIKudTjYE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760747152; x=1761351952;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ii45rQqKjwtGH5Psho54TOQP3QBwhKcT/rt69FEd2QU=;
        b=dxfzOW8q7YDRLk18xhWo2ySGvqSCV2dZDof3XyNpFBcZXLGId7vw+IyV8qP97nFwzr
         tBumEK2bV5QJu4L81ahjomH8GbrmWAw7Pmx3JYd2OjwhyIIyuMZqp7V4miwJ/aiIvy0o
         0538NAFGDzsMFHs7dOohJDbCBNB1muzq5CCyPN7C+4RhBRKIM5c4YPc1xoOIJQ5PZU0T
         mR6F7tIA4F0gBa3vAqzyMHAk6pCWmFFukh2TNdNrOLS6P1iVRdOtBGe/XGS0U0XlMMbM
         6uqXd0HOl8WlFq/T2CnoiidJ6pOIPea4EIjyy0nmmSftO41OvmOEyxwue1J2Ze9edkb2
         lMtg==
X-Gm-Message-State: AOJu0Yy16mOJGgeQFdHkNA/7tF3kqo4K1o1q4r7Xl5DbGHz978b47UgT
	aQbDDHQ5pGMBhgn9txCpXnUZYTsBpzmyH44OUKH92wnrkIzmYCilzYCOTJagzeZjqzM=
X-Gm-Gg: ASbGncvHmYKx+nj8r+WPPfhyBZMWLKM0lInctJKGjCkTqzd+DDyKQg6hWS/EIdMg6SE
	BZ9m2smsonukjaB4dLZe0mJyG72fyyHgZOxU8r20h+PWYNEtLZLOjaCWy6gdnQKtGFmoM+tcfVf
	NgIrcwaAWlr0KMKNK+hexUYn9TVwvbZiDoPrPs9vCZeRA4bgMWq2CoMUTWd3VOU+TT0L1zz2iR2
	zn1XtVT0mnvZvEWzXgDb2Y54xKjcrtoPOOMUDpECc2/y/EphY/o4dcJbOT0z6PYTNC6ZJwTHqPe
	cD10YFN6iX0yDZ12hti1zZ/vZ8cPIA4GO744RjGY0TaIbvn/B99IzlygD+qqBSCrhs+N15fYOnj
	LLnE0Em+bFDU+9/h9wxcFhYY3wbO8uKvBJA6JjWSbpa6i4WGiqaewQzEukBfDA4xF0DgIICpaOO
	4Mre0zUeKrK28WLcCQEKVaqiU=
X-Google-Smtp-Source: AGHT+IGo2Se2kxunEF/SZg2Y4xCxWJXIASoIB5WJpf6wAy+KaI73tMOnfXy92b899FQW/8z6rJQpuA==
X-Received: by 2002:a05:6e02:156c:b0:430:af13:accc with SMTP id e9e14a558f8ab-430c5208df1mr78329755ab.7.1760747151996;
        Fri, 17 Oct 2025 17:25:51 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5a8a95fed66sm413846173.1.2025.10.17.17.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 17:25:51 -0700 (PDT)
Message-ID: <3c6f1571-8e24-4d03-aaee-5852fc9fd943@linuxfoundation.org>
Date: Fri, 17 Oct 2025 18:25:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20251017145134.710337454@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 08:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.113 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.113-rc1.gz
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
