Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6403A46454
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 16:05:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TeQ/jjfd"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-35d7e22ccfeso3255935ab.0
        for <patches@lists.linux.dev>; Wed, 06 Dec 2023 08:05:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701878727; x=1702483527; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kfHqMdgf8sbyN9wDJxguz1/nkkr9jhupgPfkwuG+lCA=;
        b=TeQ/jjfd1pSpYFY62kSCgakd5wvAe6kZy9bHYkqHxYuiQEwUSZjy8lqgcn+phC59Bx
         YOVOkfTPU04tka7IAwY+pAZrvm5G87pUNFj/1RlaJoMUdaoYsuwIn8CBTmFqekZsrjIb
         JoH+Mq+o8pJyLJIM7Gcza2xVStgIghPyOe+q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701878727; x=1702483527;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kfHqMdgf8sbyN9wDJxguz1/nkkr9jhupgPfkwuG+lCA=;
        b=Ral3K4349R9GnLzrDX0rCbnh2T+06InDYuxsNfZ+SE3wZtz6aJpMfa8+xPDTjQ1DUN
         Y5xCA+r8FVWo7B89ww2//8ov3iQkKujERxf7vxs5btkQI4syIkjAnd62XiRs1u72s0Jf
         ++zctMMJp8lgxi7QTNP7nvQBgp89bQ3eMtR5X+PccLTgf94JcaLhDf5MMKmDh3B0do5B
         S+rPyorqhw3QX1aGc8FSAinHeoionaGMOtl5ZtA4xar2H0KlDlKlfzeLzWuNn6wt20Fe
         2V3Evq9XQMoM6nwRUVnMs3RtFkZcVSXa6BeA6oazdpxbwRZnYKUxObQeAmcJ3LPYUC7G
         1YYg==
X-Gm-Message-State: AOJu0Yx2HW3MwWOFVll5sLZ2BWpTFdJmYdnI6T+l+u6QxDaoGieNIixP
	Z+wgDamQeBv7YTW8DgX+3yn9Dg==
X-Google-Smtp-Source: AGHT+IFASU5mVUojmqPOHR421PqQSolVDnYHY3+2N0sJLwISiUfCDxIOYhj/aS9mI7+r2gxbxcKFsw==
X-Received: by 2002:a05:6e02:1d94:b0:35d:5779:4a5 with SMTP id h20-20020a056e021d9400b0035d577904a5mr2508931ila.0.1701878727344;
        Wed, 06 Dec 2023 08:05:27 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id c17-20020a92b751000000b0035b186a19f7sm60492ilm.23.2023.12.06.08.05.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Dec 2023 08:05:26 -0800 (PST)
Message-ID: <543a9e8b-275c-4ac8-b4d0-13a08d8433a9@linuxfoundation.org>
Date: Wed, 6 Dec 2023 09:05:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/90] 5.4.263-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205183241.636315882@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205183241.636315882@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/23 12:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 90 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 18:32:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.263-rc3.gz
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
