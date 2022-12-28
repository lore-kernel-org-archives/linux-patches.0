Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F9D1C10
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:08:38 +0000 (UTC)
Received: by mail-pg1-f172.google.com with SMTP id v3so11073834pgh.4
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 11:08:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LG1TKXfO3Ap1YVLnv1vLNUNgLF1B4SFHf63ToBDBDCg=;
        b=FNNpqbSgPvg8Ci3s8pZ/cj5NIEYbaKeAAwgKGJqFKYZyOm7nviLlkiR27j7/kHiv9/
         MuHJB+cBnFGTq7w139IlWJnRhv8C2KUlnGjFT+vzh/7HKB+W1J+kv544ucAy6VfbLFpu
         W6QtZAcnN0IKj1z01vbj27jp/80bOBXixHgJBJ6pT1WHjrVicdj7AS6l4AIFwdNxFx73
         oH3j6aMBeqic8o4P0PKi4LnxXJfbp198PDGGlSWomBxm6cxK6IBG5ugd47Fq7dv44h01
         ZQ75f7yL6ViuO7uK0KUT7guq5DKDPYI7W8Z/SkMd28MppgKVHYRyS51vPJmKT4IhmdUA
         Wxmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LG1TKXfO3Ap1YVLnv1vLNUNgLF1B4SFHf63ToBDBDCg=;
        b=lfVM2zIhXa+rngYz90UuKL0EdiL0MpRxdTGRDB4TvJyYH/IyEPbwNHzPhqnnshGlgD
         AzNCnswxj1Mln8f1u9fJA6Mt6oonTn/EdgBFLiD4y6fLTYn0FZxcXVKeoEAmu/2T07xB
         CIPofiufuQv2RK7GxGjFz9N1IfhHuJnrNcnUwimMTvparxQ4TsgBvxij1suanB3WcvX9
         AYI7KzufRAfrTbI+reSlwTzIBg3F3qUREtLAvmfJK/QLXiJjavhjawoC5PEsqe+Vi9uy
         F6Xx67oOIrEpSyLcNZTE4PUgRlRp6WXwn1qUyxDwIcuHXXmkJtkJdPzWspZxd2W95BWg
         KuxA==
X-Gm-Message-State: AFqh2kprulba59f5n0KOjrbawY3l2HGBDSZEceY/dDUS91bQV/t2DFjD
	iJVXWpQf3LVxdlTWKh+51qE=
X-Google-Smtp-Source: AMrXdXs3v3zXwsJDPj1hQvHoDsNZ8SJR/+bixjEBkFAtCi2TvZFCePhcLD/CddXDaxSe9zF7eKZ0HQ==
X-Received: by 2002:a05:6a00:1255:b0:576:b8e1:862b with SMTP id u21-20020a056a00125500b00576b8e1862bmr33307714pfi.14.1672254517424;
        Wed, 28 Dec 2022 11:08:37 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id j123-20020a625581000000b00574e84ed847sm10715726pfb.24.2022.12.28.11.08.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 11:08:36 -0800 (PST)
Message-ID: <e0b14de8-db62-b403-bd23-ee36f99073ae@gmail.com>
Date: Wed, 28 Dec 2022 11:08:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144256.536395940@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/28/2022 6:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
