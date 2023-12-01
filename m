Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62AB1163
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 00:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMh7kzX4"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-6d8103f3cc5so218214a34.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:08:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701389306; x=1701994106; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0TeSiz7oFzuM5XyCdaX+ONzU+lRac4jJbmIws69/sXE=;
        b=SMh7kzX4AYHZ7EfXRFZwMgH7c53XroePrEvBcYvVteNrYF4yGfKJ1ViSHF9H4RkYnF
         hNmyK+reFVsGIIAtodWCUk3FKs+d/F1eaSWuZpVk2EkgRhxDJvwWWR1URKjrNUggyKoR
         qMFdKFkEgTYthV9ufv9YA7NLO9CbBkByDnCD4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701389306; x=1701994106;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0TeSiz7oFzuM5XyCdaX+ONzU+lRac4jJbmIws69/sXE=;
        b=v4Sfzs/jWSEyCadQHAk3Wrd/46B1B5lVHxXx0sP0aC9fCqMFlKl5N2OOdiCklrnS8U
         UHeZGiZKED+ejugs5HXE+1Q8f1zZhptjgUQhlDfUQsJspvGHTcKwgxc0ZrImcA8eR5C/
         wKawFhsA8xPgAn0qjQHMs5dJa4SlOpDZ/9bryGhgrmlY4jkmPV22px+Jr3BQ0JEg2LqX
         KCutP+7Z7DLVpEeJacnWXE6nfBYMvCsneedeadI/u5fhRbROFoch5xRyZCVj/4OKZ/V+
         hPR8tUikB9F5z3oi+BUeHELahaBkJALjsKL+wAmPCHc1Cshz6M7yBPYMur6Au3+qaY1q
         qCJA==
X-Gm-Message-State: AOJu0YwiHg6TkAfDP0C25q3S/SYp15xj561xDiEm03/StktpaBMVOus1
	BtSpADobwZoFmZP5o1QQ6xHqLQ==
X-Google-Smtp-Source: AGHT+IEjoza6H96rpiRXI/yQlfJocoSpE8YdpEW/1Kp0jxbS6nBNtuQSHHnK1i96Tjnh8gSr6g/Urw==
X-Received: by 2002:a05:6830:4888:b0:6d8:114e:9c5d with SMTP id en8-20020a056830488800b006d8114e9c5dmr23275214otb.0.1701389306333;
        Thu, 30 Nov 2023 16:08:26 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e24-20020a0568301e5800b006cd09ba046fsm315807otj.61.2023.11.30.16.08.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 16:08:25 -0800 (PST)
Message-ID: <65a8c8d3-7557-4731-8909-a6445dd58806@linuxfoundation.org>
Date: Thu, 30 Nov 2023 17:08:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 09:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.4-rc1.gz
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
