Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B317C20683
	for <patches@lists.linux.dev>; Tue, 30 May 2023 19:29:57 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-3f6c0d651adso54133891cf.2
        for <patches@lists.linux.dev>; Tue, 30 May 2023 12:29:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685474996; x=1688066996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NCGe5Caz3DEnl0P8+9VuWwQPUYNNo3nHDhzKR02eYIs=;
        b=hbjlXETznLK4qdRrUeGs/hgHvEYRZwB5YNehCAn/zWwHA3EXNt76XaBTDaJwcy8SLF
         HZePu/OBBxJGnqGWQ1ZoshQ8XvvM0OYAcOeQCpbaDBp4vEKgf0tnKActfBDuAcWdz9tm
         9MRaaGrnHchKUlaqMzzaVR2GW4bWQ3NEYK3O9I+5VKO2rpQ3tnZVrMw9erdPuEqZr/4r
         KFacdRhol0xZfgntrLGD10vgNvHW4+Z+9XD8ROqFpsT0w7xKetYkEG7qiXTRPHTfF6gW
         A2ovI+dcuZhjrXhp711C7WlnRmTY/jTHSTVDLfGkj3boW3aUP7Amvn6gfnv6aN1ufFzP
         nRKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685474996; x=1688066996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCGe5Caz3DEnl0P8+9VuWwQPUYNNo3nHDhzKR02eYIs=;
        b=P5O7iXVFeepACCfA20hoTLhQ2QyNiP5kWVLD/k7UmqxHt5C6vPeMBhDaszYKtNwCfZ
         6lA7OrtRSGz90tfXOQj10jubILt/dCVcjDWIJzoBDf78eDSboauKFDaFuLaGOwiSl+Rv
         CyzTym98wf5QlNpuTwWKYEat72QM1GEH+GYs5leI7nQp1DNi+HTXaqfOozf2keP1U7RR
         jEsUmaYk0FcJzQWKNxhDmKLC1KOdBnnhTcjh5LgeagSdU7CI6MfYYC2gecGrVTHcC+HR
         2P66Midnv4dxnr7HbD2XUjs/9j+Hz6azF+VDkdSopU/BluTUeJIwv1AALzlYXwXZVdc1
         3ncQ==
X-Gm-Message-State: AC+VfDwI7tcUE911oGO1tZKceqzKf1+xu/OGOv5xWmgAaVqOT2PTsvuh
	UFlOxRTBUqt5ha9sY5ib7Y8=
X-Google-Smtp-Source: ACHHUZ5Q42xzU7BmXAeJg92SVGPbv7pe1B1oigWtYF8kP83jXZMjLmnPfFNzBOQpMr63SuIdJV1llw==
X-Received: by 2002:ac8:7d45:0:b0:3f5:3f0f:3744 with SMTP id h5-20020ac87d45000000b003f53f0f3744mr4036598qtb.52.1685474996631;
        Tue, 30 May 2023 12:29:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id fg20-20020a05622a581400b003e39106bdb2sm4970070qtb.31.2023.05.30.12.29.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 May 2023 12:29:55 -0700 (PDT)
Message-ID: <deb58a23-1487-aebd-8fce-e0d6e39e723b@gmail.com>
Date: Tue, 30 May 2023 12:29:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230528190835.386670951@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/28/23 12:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.31-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

