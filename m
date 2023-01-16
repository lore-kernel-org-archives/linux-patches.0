Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988498BF0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 23:55:15 +0000 (UTC)
Received: by mail-io1-f44.google.com with SMTP id j1so5960312iob.6
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:55:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4y0chPH8XRCcdBF2hAl+UEtCy8CCBFqYOr4KoVIAIlM=;
        b=SfBunpmYSH2pio7V7AGY4OLtI3BMU0OeuReqnd+dqSv+m52geBOxADryk6lrw5FkNw
         NO7cCvmWv6ZGPHf/dC6l6XWQLMTx8dUYM5htCknkmemQjYUvrj8FwaVDnXy2l5P4XN15
         tUOkltIZM7z6dkZAnDnfIukCSz4DqkcfBb534=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4y0chPH8XRCcdBF2hAl+UEtCy8CCBFqYOr4KoVIAIlM=;
        b=7MHr+FH42YfLpeoWaRJ66epC/8cYv+An8jU1m4wgwZ1LHpDuwYyjCJstmvmWYixaXA
         Ak97R10tDONWijGUITxV45VH0ypm6RFTxuKX4xpNs/u/Jp8ifX5JkzFgDtn0dQzqnbvV
         2EKTu1K8b+J+nXyTHuYkHHMVkVRgiUWQwgZ9GbPTE8SHuHuABJ+PpZhibTAuAZF0poLA
         afIamzZ/zMzR4Cg+MmuUjhZZd1IdaQRKrmIsf0KMLlRXudVmMLhS3ig3KrQsqWWI2q7G
         IQCb2puE7yYuYhWdDl2TOHHjHgOGUyGubIaBEl6jXNcMPJ759mQ/tBgx6cuYDKhlWlJv
         mWTw==
X-Gm-Message-State: AFqh2koicyuqwGIPjXRnqH5zmgyDW8nN3cs1qb4a/WQUOyJDl40pucUR
	Igt+jtpHo0hRjTuVf3UhfiYoAw==
X-Google-Smtp-Source: AMrXdXvyf1g9nsw7GmasQKuYuXvwJox6F7ZgL4FEMbeEbn8Lzozn5Goy89GXORdAto72Z6xYabIrHQ==
X-Received: by 2002:a6b:e90e:0:b0:704:bbb2:f9f9 with SMTP id u14-20020a6be90e000000b00704bbb2f9f9mr115998iof.1.1673913314577;
        Mon, 16 Jan 2023 15:55:14 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o192-20020a0222c9000000b0039e92d559a3sm6516285jao.166.2023.01.16.15.55.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:55:13 -0800 (PST)
Message-ID: <1a01061b-4ccd-0e2a-9e0c-b2ff03fb0f6f@linuxfoundation.org>
Date: Mon, 16 Jan 2023 16:55:12 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/23 08:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
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
