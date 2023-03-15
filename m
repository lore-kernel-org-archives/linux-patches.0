Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DCF193
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 23:55:23 +0000 (UTC)
Received: by mail-il1-f173.google.com with SMTP id l9so109387iln.1
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 16:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678924522; x=1681516522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJmb45xduCOTtiQomI20pSAQLMuMo+/lMZmF0lsBs1o=;
        b=KWnHapDjovKMGnS8P5pL7xeopb1wv/Fa0NavOmofiMDoOBXOqneZ9bohNYgthYrTza
         zqOcDj1SHw6YHC6pF+G8yK0gLt98rR53dv9PGhlgVB0Jqvd0na/6Jcq7LJmRL7005UXt
         oRaBjm5b6+7DpmWjwLLUcBEP1sngGJ47XUDcA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678924522; x=1681516522;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZJmb45xduCOTtiQomI20pSAQLMuMo+/lMZmF0lsBs1o=;
        b=79JxHEazSVhM/iE8Shhn7vpvOgJb0kNxU2Kt57PtgCKjyvWrysUlOAGIp1XVVCxGj2
         dhCPqtYeLOcRW9bwv/WUYS6t4nIPYStudop9jQjPo3y2Uq7cCfS40nWmOYrMiuemeleh
         uoScNfRmDhRARXxb2tNJHJOKIJHltC7z6vvrU+niGohQBtbMNXC8ppAcc1YkEsFsS/YC
         5zbCUY2jp3ul2YJeaXcGOUt2CvRRalINiHJXNl9KTe0XZLPZ/VRs1LpV/JE2tlcwjRLF
         BK0rtezq8o/2pmDHOTHDF1FOzguntF/rVTEkvcFgHmY2RatwXGZhugRPANuVs2LJr9pA
         i9pg==
X-Gm-Message-State: AO0yUKVhTAzYIvT1RsLCfsIVQETuJ8TJwNuXziA8NW7h28vsz/+AiKXI
	G9epfyHE2E91UwRSAINysaF4yw==
X-Google-Smtp-Source: AK7set8Lke23ypiPd9J8rwJOVhaTU9GcNKrdeRaFGQdJaYmF+wMwU1ptFuGdQSvcSVroJ/MZyWjgBw==
X-Received: by 2002:a92:c5d0:0:b0:319:5431:5d5b with SMTP id s16-20020a92c5d0000000b0031954315d5bmr558832ilt.1.1678924522458;
        Wed, 15 Mar 2023 16:55:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s28-20020a02cf3c000000b003c4f5f9f577sm2111326jar.25.2023.03.15.16.55.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 16:55:22 -0700 (PDT)
Message-ID: <4c7745f3-fe4d-7e76-ec64-6ba5df24610b@linuxfoundation.org>
Date: Wed, 15 Mar 2023 17:55:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 6.1 000/143] 6.1.20-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 06:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.20 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.20-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
