Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40B5F7F
	for <patches@lists.linux.dev>; Thu, 16 Mar 2023 00:01:54 +0000 (UTC)
Received: by mail-io1-f52.google.com with SMTP id f14so73568iow.5
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 17:01:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924913; x=1681516913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dakV7OvXKZeanAvpbbYmcrxTn/kj7HJQ+TrMFJcLTAo=;
        b=EMpk7PFeUuQgaKqFTJz1ZEWW8aqgEuX14pjy1NyeN7N2H5fU0AfAEEe+RWXvKRoBrv
         1draL4jbeUAiwR4deHZl6sOe1QNxqc5OmcnkM2kRdiKidU6DbiRVxQrE4oP659hLEkUR
         1uiooJWvUV6pxFd8N0p8sMHQiYts0ICxxo5oA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924913; x=1681516913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dakV7OvXKZeanAvpbbYmcrxTn/kj7HJQ+TrMFJcLTAo=;
        b=q0QSbEu0QdkY1yTRBOba4TSMvuroDHaz5fkH4L/VdtZ4pozi3uezpGor8VCQLvUEdn
         LaHaJ3HWaof9X7vktGcmU1iwAcBLUzelpL94NXBIvh+EmxPZ8Oa57v0n0/cJ2wFTguqC
         gBwgfuR/n5W7aesw8TMZuHS2QxjwLDAgF55bnmrUdmiOp33B8Y4PIL5FFWydVDpKswM+
         0spS0I7jNUWDsRmSt5h3nOcfTBhaCyYbPYU0djhAqfyAHLavJ6QZNFUCDM1sHO8z/+eR
         RZqEg0FVRxVgZ/aUclF1V1cpWBP2ou3S5yzgAGwkbzNCC5Jx+ZXlMbq+IXfJ2bFnFsPV
         XLlg==
X-Gm-Message-State: AO0yUKW1pIWgaqhoR+9+DFnm0tRwSS8u31KQPuc1+5krwlF/gn0MRZTd
	GL92iqg8NS//zSy4+/9+fAWM4A==
X-Google-Smtp-Source: AK7set+89kt1gXLpBnZ7BzlENiScErzcQtGQv/MbT407oj7oBcEUkqJgz9N2JPNoZ/O1CfyAK0Utgw==
X-Received: by 2002:a5e:a70d:0:b0:752:dcbc:9f12 with SMTP id b13-20020a5ea70d000000b00752dcbc9f12mr697211iod.2.1678924913279;
        Wed, 15 Mar 2023 17:01:53 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638063500b003fdb5b32bd0sm2077924jar.101.2023.03.15.17.01.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 17:01:53 -0700 (PDT)
Message-ID: <4a547162-7fa1-fda1-5867-1f5a2a2a9597@linuxfoundation.org>
Date: Wed, 15 Mar 2023 18:01:52 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115726.103942885@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
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

