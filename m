Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8F5AD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:32:25 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id i4so4835900ils.1
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:32:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v+G2MTwAb5c58IsGIh6nnFDVKJAUHbH8B79n2LboROs=;
        b=AAJ1dD8S3VP0jBzZV6iOx1rkPvP+p4HFWCv3Bnm5HuunxwlhFTA5AlPOAyju/NQySC
         jXUR6YlNj2i5TGKuDkYpqRnKo9fHR3TIic1jNudpjJS0/vloxG9O5QH+3DJf2DE4Bl5e
         mq/5xGpEp675jDW5hf/hHrjtIQI31gqVloal0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v+G2MTwAb5c58IsGIh6nnFDVKJAUHbH8B79n2LboROs=;
        b=UeCEFNMSAG28PTSbxwvOtpmeE8wTBrSFnwViFV9mWdsh2Qw6tdbq8Tg4ofw2zDNECd
         aIEd6j72OMBkms/XDV3U2EFEq+kVMzMSYCk+VXWP+LQLhPJlUPkJupF8XjjEk4hV5SDt
         6jKPV9LXmoT10VLdkM0p2ZKSc1YhuX1AnmB4BUCiDaInPvsM/UWU2U2azpBAWcw9CvzS
         H/fMF0eZ1fRDpZCMSs2SsAi6Egy4OAhUeQbtmcxbnfdJTycKlDDoPRi18j6XgnJizzk7
         E9+64AwMNT1Ou92vDZD8BPfDIYNmbYK8vezI6cgOgxuIK6C6i0+GAxTOpy5pzFqkHZKH
         kFdw==
X-Gm-Message-State: AO0yUKUv4Eil6WI6qPgT6FvEZwWwdhvcZIpdZHqTbFtxnQ+RFaMtpe0N
	c8xDir5onZtBMYF3Tj0rZHG4UA==
X-Google-Smtp-Source: AK7set/yx0QA26JOwJPCRq2sSPXrVUEmIqbLL3ZCyuaJfwyvd0stgO6BHyYRqcK7MmqBN5aw0TJCAA==
X-Received: by 2002:a05:6e02:174f:b0:315:e673:e7d6 with SMTP id y15-20020a056e02174f00b00315e673e7d6mr9554380ill.0.1677195144552;
        Thu, 23 Feb 2023 15:32:24 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k9-20020a02c649000000b003e43da36e1fsm1719151jan.12.2023.02.23.15.32.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:32:23 -0800 (PST)
Message-ID: <e37ed568-cfa5-9928-9b3c-91125801d00a@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:32:23 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 00/47] 6.1.14-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141545.280864003@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141545.280864003@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.14 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.14-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
