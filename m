Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 906B51FB0
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:30:23 +0000 (UTC)
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-334d0f0d537so3963265ab.0
        for <patches@lists.linux.dev>; Mon, 15 May 2023 18:30:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684200622; x=1686792622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UVHnUIJWgu5B9c3GLUqRjUfbsWVf3ceFNu26vMPD94I=;
        b=U7IUelUOQMiqu6XmHrkSmtLo1ts+0gK2GWfpo43p0rgqXFxoR96alZvuiF86gN0EKl
         cbSzE5SCdA5fZp+99/nTyC7DsFhK6NSo0lRNx3zJMfElZdvIc+r/TwhP42InAi9Kg0FV
         Gmd6v/a7MLjbcLKcex3k+tWarkBlKR2EPU5Kc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684200622; x=1686792622;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UVHnUIJWgu5B9c3GLUqRjUfbsWVf3ceFNu26vMPD94I=;
        b=NXCbb3K0tt3WmACAQmspa6dbGUTNYw/5/nyYUWTgx4QayiIMx6PiDWQ82GkFL07fYi
         aoFRNqgyjdqpfrBropDZABoGnOvoSO5qceoEDIbh2pS2Zjj6oXM6LXAYdSFRRpqTjCSE
         eeW9+jB4nFbIl2wzFlilInViB92Pa9vl5SSLOEY6/l8uKc9ADuxFmm4bskHz9T532cYm
         bf/HvtleIplHQFBXejK/yjgjf32XdM2aUyZ77qMo/ts8Lm/e/+IzQ1JgH/n6zvKzvGsr
         HLZ3nPTAYUIPSXN4xTS+flECs9pkaJSiIpux0BfRoHtx+2yeUrHWonmHOMqK39TTw5Mf
         IG6g==
X-Gm-Message-State: AC+VfDwr2dStznCtCqSGdTz9Uc8Vj7P8omaiRXZEva6ZExEtS3mVc9mZ
	irjX9L4Lsmj0+oE/TFDKEhFu0Q==
X-Google-Smtp-Source: ACHHUZ4CpY87zIekDbcb4isU2iclMy4ONult/VJKgANjWIil2QvPH58pR928VEqWdN+QYp4EHtGQag==
X-Received: by 2002:a6b:3117:0:b0:76c:7342:dde6 with SMTP id j23-20020a6b3117000000b0076c7342dde6mr765163ioa.0.1684200622564;
        Mon, 15 May 2023 18:30:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id m20-20020a026d14000000b00418b836f89bsm628708jac.63.2023.05.15.18.30.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 18:30:22 -0700 (PDT)
Message-ID: <6219ed8b-af51-4fbd-c8cc-0aa88c26fa7a@linuxfoundation.org>
Date: Mon, 15 May 2023 19:30:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.10 000/381] 5.10.180-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/23 10:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.180 release.
> There are 381 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.180-rc1.gz
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
