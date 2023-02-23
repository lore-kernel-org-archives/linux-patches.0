Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F13382F2A
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 17:42:44 +0000 (UTC)
Received: by mail-pj1-f51.google.com with SMTP id cp7-20020a17090afb8700b0023756229427so81921pjb.1
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 09:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YUQnTxCw0HRxUaX138YoYVUi4ja1Ry/gLGuor7Mye68=;
        b=mlDZ/lbQiBqIVVlqw25sMUcTj9Je6SbGrXb7urUz8nf7RxL2CQmWlJNYxr4t1Tw4FX
         6XZSMT7C4b29T4smnW1QaKZi8Htrij9UNHtmgrjbUjOSCbW8arnUA3eCZAX1J1ZbK10w
         R214O65KuiZwBSmSkhDKa25vUNEXERu115XdIU3srWU37pJW1/0vNlUSHwZKEJzOw7AH
         vbgbmNJHw/bfnAlLGyiZU6JHoC9uBF/E1K76ZXrCmNMI1TaqenddTagol24bqRt4ePZz
         a8RXHUSiBuJ8PlcWNanwFhutdWo33V9ODbOHDrxd53wFLXsh10mp5hBdDt/AyUUiXPZh
         RhFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YUQnTxCw0HRxUaX138YoYVUi4ja1Ry/gLGuor7Mye68=;
        b=hgCESHG3CksMjU00hbT/2a6ybmVbHoqmbbRLHDSaHlE4ZmeZDlEmlHH1pXX8cOIVBy
         Jq0nztYE+ftF4pLVHKHTgby4hrlUdkR2R49aIgNUdW+KNMhWHQ/9uUxbEkLxl3vnwPii
         Ji1h3frl8axrA8eWgDf51OvJLhn1C3XtuVkOwo+LT7D0/tpabHhbRqV5FyUZM0tZIEU2
         3+1hJ7+zFfrq6dhbgYfY8dHe1+2s5IfatOff0ASBo1bAQ9M09S85/LLGdFsr/RTSEIyL
         TMRHfsoXDlGnfdYOUUlZVEWnQadeyd6YMOwcHrutDXbyZTHyNUol/fwrs1HvaJA14932
         zTLQ==
X-Gm-Message-State: AO0yUKVtiSGVPo2YICIyDM7DwsAGol7ba2t7fQ12tp7lKkWLRt2p7UY5
	Tu5+DM67MLwrC+0CjXPK0fA=
X-Google-Smtp-Source: AK7set9NeiIltv+d6Vr8lPtbiRtFk0vymU/QzZJd14XxNmFpFzI0KAJkBY6t/JiW9w+bJUXoRlcr/g==
X-Received: by 2002:a05:6a20:9383:b0:b0:c30:1de with SMTP id x3-20020a056a20938300b000b00c3001demr3706303pzh.61.1677174164269;
        Thu, 23 Feb 2023 09:42:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k13-20020a636f0d000000b004fbb48e3e5csm6682556pgc.77.2023.02.23.09.42.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 09:42:43 -0800 (PST)
Message-ID: <31f37158-13f5-a0c4-c477-b6202d48f429@gmail.com>
Date: Thu, 23 Feb 2023 09:42:41 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141540.701637224@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.170-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

