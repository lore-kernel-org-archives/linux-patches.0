Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0771B1B909
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 15:52:14 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1b034ca1195so11382185ad.2
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 08:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685721134; x=1688313134;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RQGRyMSZUt/6c6PELzSK9Ea1CB49w5/1U7+T+0QRn98=;
        b=DdXScspeUAbL65cM76ZTFa6R5bJhg2L8MMGxOh7ZpaUvt7jM0Pg2SC1z7WucpdwY6q
         PoeKLJ0rs4JNrEFwXFBtM+90jWWlNQdY9HR3wg3OD4EUCCktaI6cHHfsAOxl38Vd/wjn
         DBfLflVmH61VOgTY2frkSSiBC7lLH6WgvMtBwFKs42KwJ5pOuqLx9BSalDWPALwpv8wl
         5ERgY10SPuKBmCJyUsHr7/H5XoEC2AJ5WvHLF/PG4h3+P+G+m+q2eR7FwtFu0otpIpl9
         OH+xRkl53BwhIiC+g9SfekbC016jPXJ02CalseTsdWvIby5nPRnrV4dqmDc5u6XCQz20
         Uo6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685721134; x=1688313134;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RQGRyMSZUt/6c6PELzSK9Ea1CB49w5/1U7+T+0QRn98=;
        b=I8AEyE3CAJBFyW/Yow4JrZSnB5dWjoyMFxneu0mXC8CUIHwos1yIWk//DirQeHo5U0
         xT0EJ58kua/r5kfNAtIukUtYO//f+QcMAbS2lNdsiE51dgK1ANbea1at1Is8WAbJXQD6
         A3v+16uGz77XjsVIDJlQJdH9fQnBz/73NSCztf+oyT6P530kNDe3UU8ghYHKQrVMeUhc
         v0/9Ql16aeQmmt1Pcwo30N0ImCd3MZGrVh9kyOfwDuYDK5oJFhHLIZP+IV0MvnE4ygJm
         uPPBvI6n1S/3gt8PdW8DnU9YMq3k/Bb33D0tI1GekU62KLzuoVz16sT1SqkwlUrjSpZu
         9oPQ==
X-Gm-Message-State: AC+VfDxEe933a41G3YulGfB1hNG7ShuntLIRBmVr3At/RfDiIaPgc4Vs
	vS67SacsXv7Ku2c1G1+Z/pQ=
X-Google-Smtp-Source: ACHHUZ7p6RW3biIByHhy5Y+CQ4NRQY2owtw81j+RLN78oHosjmV7mITRtuSKxQ9TN9mxJBwB8+sFAw==
X-Received: by 2002:a17:902:f691:b0:1ad:b5b4:e424 with SMTP id l17-20020a170902f69100b001adb5b4e424mr340204plg.38.1685721134044;
        Fri, 02 Jun 2023 08:52:14 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id r19-20020a170902be1300b001ab12ccc2a7sm1533390pls.98.2023.06.02.08.52.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jun 2023 08:52:13 -0700 (PDT)
Message-ID: <3dd4d2d9-e95b-55b7-6b19-33267a648485@gmail.com>
Date: Fri, 2 Jun 2023 08:52:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230601143327.479886832@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/1/2023 7:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 Jun 2023 14:33:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.32-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested: 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
