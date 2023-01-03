Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3E48F57
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 19:02:41 +0000 (UTC)
Received: by mail-qt1-f178.google.com with SMTP id bp44so22662863qtb.0
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 11:02:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jYj4/tXIF69QmtbzP1BhKc/PoGdv6mttUVghO9XmKxQ=;
        b=NbuvwgnhOsNh8UNKt3cOld5dXyeR7DZQaKzpwcqXmyfxhDapDGUWrz/khEqHRmu3R2
         HTOk1nyri59cXhqeN99/ZsXhuZTb9Oi8yinf9ES6AlFvrz385uBCOQ+ZIRLcZ4cxS6Hj
         nORyRUcPeSWD03jxYHeXx5Nbfd5aqpEE84OQJNwjGkc9ilr+JlZE3osSrcKvyM7vJLI0
         MmgZCkSYfs192Odxj4fS9LZXilqHd+QsRa88owC5HgCqFgUx4qjhZxxAf2a6/5h2sO4K
         LWiFzfG9Ps6HltEpEG93r6ogE9Zq00guB9sg6RVDMpHn+D6Z7xuIpiTtrjGJ613CLli0
         NswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jYj4/tXIF69QmtbzP1BhKc/PoGdv6mttUVghO9XmKxQ=;
        b=hJNumR97l8HpEUgVEeOli/8BWQplbFm/ibBXAOfhMu+i9GqMSyLUbf28oonTz3JU9b
         2ACA4zCMqMYLhNeUsAuaLB4xXDCsBTFA01hvyydQJ4hpIv0gwjmqFmjH/1eCiqrMYUIo
         mLk/G+e7Zc37YWxvTnbaIo46ltV1LkyVaj5uOxZyOXGL/eeDaoNdppznWwiSMXsrjyn9
         P8PivOAtJjh31pgqYyODNAFrVQQJLtuuqx0pukuIpRjapOPK2eT+gD4bN7t0OE8jJuJ7
         rA6AW/wXW1SglbIIpP6m5tHU6bsTWmqtDgiZhCoE+BpHG3DihWIeWnS7zeIKeiZbNbAK
         b1rg==
X-Gm-Message-State: AFqh2kqEQn2EBGiUS2ASC2f4p4jnrqbSw82QYn8ma50pVn8oXGfD2mCI
	O4A7UOEPbKNncbDJzU5s6Uo=
X-Google-Smtp-Source: AMrXdXtAjY59Dp9u9hXRm6Xx81M9kMnNiElJEcoeoBh2hHj5KV6VYfwGYyXMbmto+glaJqc7ymtAKA==
X-Received: by 2002:ac8:5495:0:b0:3a8:3d8:4e68 with SMTP id h21-20020ac85495000000b003a803d84e68mr63525918qtq.55.1672772559947;
        Tue, 03 Jan 2023 11:02:39 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q12-20020ac8450c000000b00397b1c60780sm19246359qtn.61.2023.01.03.11.02.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Jan 2023 11:02:39 -0800 (PST)
Message-ID: <5d8a44f2-511a-c5df-0246-8b1ff953a0e9@gmail.com>
Date: Tue, 3 Jan 2023 11:02:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230102110552.061937047@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/2/23 03:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

