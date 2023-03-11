Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222107B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 18:02:14 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id y15-20020a17090aa40f00b00237ad8ee3a0so8011943pjp.2
        for <patches@lists.linux.dev>; Sat, 11 Mar 2023 10:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678557733;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sEp3Uao+18suIe2B4esuVKp1Lfv3V9UcEhPWB7SNWIY=;
        b=J4xWgp8aqQa8ujZWXlVHi1TZKwYIPszE7Rf08eD1K/KOE1fOIz8XlOecLtJjKbkJgy
         IPJi6JnI2JE/HeCl2OPDR4ixptuvdC9ZFb9w4vYYeSmFkBMzrjX7ZjMp3nXBeBmlKxRJ
         l3DKWmkLp+jJP/Hqfr/WQBfR9FGG9xJR/S8h0vjIGu1bZwYx2gfYitBiOnlmQKnPxPil
         uvzVs8P6Y3MMRF6FtA7OSBmQLxsxR3a5S3OF8eL0BkXGP+DzSlEUvB6o1vl5ov4V78xX
         ZP45U+5MJRmbTKzb6cNmSiGQ51H/qLq0de9mKcqijC20ytTg/Sa8xmsKdd3UbG5Hdpt9
         ijxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678557733;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sEp3Uao+18suIe2B4esuVKp1Lfv3V9UcEhPWB7SNWIY=;
        b=Gb45DiBqCkq5gM8gk51QiHettC39UY/6DVsF2TJbjeTc/X23bWbgQFbLSfsFcQJ3Sp
         e31Kk5xnnjxbSH6K9vzRw7LyG3KgqjVNl9x2VjNqbYrDiqnf3/tXuZihH0kPYRM4yUSL
         jVxnzW8FHmema1tjNWkAjW7VBx0rRUvfodYrIKUnl6G/KYhdvF7ALnhwBkamyu9kwioH
         vRNFl5DuHLo/1LvNryKAsYNx1iZSVqcj3nWV/2KuB5lURExtafZ8kuqQcwpGtteO9sP+
         wYbGdJVh/uJs4b+oP8Y49STPesHg7DYAP6yc6CeS9PglYweJ8yQEiOkVLSFiuHgkM+CY
         +gaw==
X-Gm-Message-State: AO0yUKUs2Ul5FzUvKpMLkB4Zv3dItZf1+hnm2pFQq4T33BPNJ2HrqxJ6
	NzIOG/H47F8HnmlI9KLflFU=
X-Google-Smtp-Source: AK7set/sQt5TqWkuMbCi/8OWDahL2G4jm31zfGbllabOeTkQ8Pruijdv+DSUPSdyuStcfiKYFFdiMg==
X-Received: by 2002:a17:90b:4b0a:b0:237:f925:f63 with SMTP id lx10-20020a17090b4b0a00b00237f9250f63mr30319565pjb.13.1678557733514;
        Sat, 11 Mar 2023 10:02:13 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u33-20020a631421000000b004e28be19d1csm1801091pgl.32.2023.03.11.10.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:02:12 -0800 (PST)
Message-ID: <8bdeef04-c636-59e9-020c-6cb12d0af9bb@gmail.com>
Date: Sat, 11 Mar 2023 10:02:11 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230310133717.050159289@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 05:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

