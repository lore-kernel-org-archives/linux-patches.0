Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A06715AC
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 23:18:52 +0000 (UTC)
Received: by mail-qv1-f45.google.com with SMTP id e13so14088728qvd.8
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 16:18:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681859932; x=1684451932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=w3zvg+atLra7PZe1SLabd0g82WwIT4a1nvs0QUOBbfg=;
        b=sVLt6GlYrdqqdcqzfTWR/NcVm4xx3mlkyoegItvNyGvjHXLSgvBKEvVGfboy3D7od9
         f7dZTV5UAb++eOI+fytvSoKgEKf/XVXd6YmL6UFj8nd2CHz6yWrg+VB2wsg3Tl11uiu0
         q7OYcKRpS3KbwD0k9ugOBC3wkvgQNnSY56qTR43Emm2aAyGptpcaQ5Ndv4ZDDMWNv6nq
         7oa41GR09307Q+polj8Ozmq9zmNyGuTu4+eHKBt33Y0xA+8DDmxVT1aHb06HVVhiMM1I
         dkx+iNPw1mupjMAzgmjKbSQo+1AuAuo5w6Y82ncgauCOs6wVU6WdO+tDOcvNb4lxr2sf
         jOLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681859932; x=1684451932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w3zvg+atLra7PZe1SLabd0g82WwIT4a1nvs0QUOBbfg=;
        b=XeEi0qhDZzCedYCahnkzGMjBAvkYNxMNOULgmiWHIgN64LNLtCl0XZJ+WtxnqqTFGF
         08tfI+do0qXVJAfELb/U0atn/yuUpm/qK0ZxpkZudlRVbd3JM0rFCn/vwo3OReLhhQO7
         FT096lZ9H8+qcaBO458ISKQClIcyOGIg6nFqmtJvnaqpEAQ0YpzTh9hqJ7jizCOGLRYu
         FASMQIOt6CKOXMXSgto9lqeR9wALob2rLbeBPU1dH6AEOK2/XRaWRxr/SD9ERztzC2hs
         Yx2sp57t75RcDp4Xgethepc7/WlAT8YgyLVerUd7zI3/DGSFmMBivHOTjrpYeL6mjz4t
         HDXQ==
X-Gm-Message-State: AAQBX9eme3DgvpPyKfRaz0XH6wBovkG3pN3hZ5slsBxk/bGsVnX4GTCo
	gt2lwce4DZTx1b/AbCONWaI=
X-Google-Smtp-Source: AKy350Yhw0Os57cUu2nkFOrZkPW9+WJGjA5D8gIYm+Bk0FRhUJUvZDtAGbbtXXlT754Bjg4yp1g43Q==
X-Received: by 2002:a05:6214:e8a:b0:5ea:654e:4d3f with SMTP id hf10-20020a0562140e8a00b005ea654e4d3fmr24396109qvb.5.1681859931856;
        Tue, 18 Apr 2023 16:18:51 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id ny15-20020a056214398f00b005ef8ade339fsm1072902qvb.125.2023.04.18.16.18.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 16:18:51 -0700 (PDT)
Message-ID: <bca3097b-f200-c7d8-28ac-575cc60a6f6c@gmail.com>
Date: Tue, 18 Apr 2023 16:18:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230418120313.725598495@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/18/2023 5:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
