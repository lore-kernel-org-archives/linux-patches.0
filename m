Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98B52199
	for <patches@lists.linux.dev>; Tue, 16 May 2023 01:20:02 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3357ea1681fso3211595ab.1
        for <patches@lists.linux.dev>; Mon, 15 May 2023 18:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1684200001; x=1686792001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hFE/2LbHG4DAhyFpHPKPmd13xVP1nkgSLEJ3rUtktCg=;
        b=bdI1VytjzUt/gQfiQzbVmZLPoX1eWLjUutL3gQi/rgEoo8VJ8qqUe3jfaLAwJvC1J3
         91ER7PUZKEKIMatJF4IM8m1OlIL/dviM8nz84pS8D23gnhCLd/j6/IIzQFk7icNWPCbo
         HG3SIPedH7azN4s7i+OO643lA3UPl2qM9e+fU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684200001; x=1686792001;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hFE/2LbHG4DAhyFpHPKPmd13xVP1nkgSLEJ3rUtktCg=;
        b=LWIGTcteD7uUfnlSOlpyZq+4eDZhTNonmuxCAKtfDMWGRSPM1T/vvf3Y6Vklz5/kUL
         YyM94TtaKgd62cIhczVi2givHj6D8xaijRxcB/AV8oZvnfJDjyZ/RlrP+ViWy8oobOkI
         HgvIyXGXaUJPAW6LdM0HW7aUXI8d4KUtjEDtSgL49JTsqIOB4CcahFRi+yFMJLLivjOK
         lpTakK5y2VffSmIqjBLNSP/qSPx9rtu485R21Fn6uN0mT+qbN0hTHDZXx85exz0cM4Gc
         p/JwNKthvBdaGXli3TIdX9akwgAISjaqLcCT0iGt4TroUP8SQiuKtcxT1ChES+EcIxnb
         5Iyg==
X-Gm-Message-State: AC+VfDzO7Zkw3MFXe7tAHwdGSCDDBvqRpuymQyS2EQmL8IyoskKAd4j1
	pJM99I1TooyMq3O8rh6NA2ZVmQ==
X-Google-Smtp-Source: ACHHUZ5cmh0U8jqt1uM7uoN0KTmKVr51aoJ6tgzIORk2q+odfyB3vQgcuTchpMmkZoOg0vVKpE/p/g==
X-Received: by 2002:a05:6e02:178a:b0:325:f635:26c5 with SMTP id y10-20020a056e02178a00b00325f63526c5mr760449ilu.3.1684200001468;
        Mon, 15 May 2023 18:20:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i24-20020a02c618000000b0040fc3b34d57sm7144781jan.56.2023.05.15.18.20.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 18:20:00 -0700 (PDT)
Message-ID: <938d888e-4507-33c8-8a8e-52a92e671843@linuxfoundation.org>
Date: Mon, 15 May 2023 19:19:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.3 000/246] 6.3.3-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230515161722.610123835@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230515161722.610123835@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/23 10:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.3 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 17 May 2023 16:16:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

