Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E831A7E
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 22:25:52 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-34e1757fe8fso3818635ab.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:25:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695075951; x=1695680751; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9Rr0MlffztlGN+Dy0ATYiwBj5tqmkbKs8WVMjmYmCLY=;
        b=C42w7WjKHTMinaP9pfgQ45cQwRQInprcfnSMDOks9pZw7vhWnQC5L/URd03LI/Q4vP
         JUay/FOfsCzy0PxOUZybPK1J/TW+pRBQaO0Dc7zh9qN4b55hNe/pqE+uEW/fJJhi0znM
         CPjeVQS2HVjHh+T/h5t+yxu98FKYsf7MkNY60=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695075951; x=1695680751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9Rr0MlffztlGN+Dy0ATYiwBj5tqmkbKs8WVMjmYmCLY=;
        b=vLpNWm2vGnY5haW7hZL2flsEhG2I2+GDjIWQDjofb2o397zNmmyv+dPn4lVjCYBVOv
         EbM77/5GQm8r4C/el5qNny3oawKdjwwdDasOfT3i0vHv1Pc7Z4PUNQiw64bVtCKOh8yB
         q7OFfCYCifUg6jm7NA6L16q8YPKBIZ0u1XpdrjnTuLqQVUxHWdLj32TP9jFhwNE648Ma
         8SDbUerKpkxGdG9rLTj7n9K/MYx6h7tdqQcUjMlicfhxDS5PEYY5ir8Eyj26DXM5j6cI
         AS9fdcA2FMg4XTo/iv13uA066Avn8wL6rIGOFk7QaokUV00+3kshtQQWKiV2TQMPvjD6
         /Bdw==
X-Gm-Message-State: AOJu0Yzp02D4Bcz16IcqZ6STpJ93ikbbboocaXhly9LK4KD3+Qz9F1s3
	GHOJ3Rz0oJ0sg5CcPfJ2A6AK6w==
X-Google-Smtp-Source: AGHT+IF/bvEbcnzsPqYzgQ7yplNPSXCWWJUy/HB/NbpKfspYUsNnNefYLIsPMNmvxfGdrHvek4g8kw==
X-Received: by 2002:a92:d20d:0:b0:34f:b824:5844 with SMTP id y13-20020a92d20d000000b0034fb8245844mr10310495ily.3.1695075951328;
        Mon, 18 Sep 2023 15:25:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y19-20020a056e02129300b0034fbea17e75sm2619936ilq.20.2023.09.18.15.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 15:25:50 -0700 (PDT)
Message-ID: <7c78ba71-fae7-e640-4ecf-78e2ef5ec129@linuxfoundation.org>
Date: Mon, 18 Sep 2023 16:25:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.195 release.
> There are 406 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
