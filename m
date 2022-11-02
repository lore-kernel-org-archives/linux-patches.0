Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F0E1EA01
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 17:32:56 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id v8so5736635qkg.12
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 10:32:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FXMb+WcYYZ9NnCxtbHWk8b6TS9iaJh2KE60qKBsQx6w=;
        b=ct2U5Jbus+Ria5ps2zBqX9RWweblUVX37T/d0bhI7AYzL+TaTCTsEL+1fFNC2nKxxO
         t0olxK2/nMdFpqIFYT8odtNgLTZBJptdSpHWzYNT5AGnu2Xx0sTf30cxQ3jE9iNnNQuh
         0YVb2QzVDpbUucWVRK4X43l3HsnLqILfWJpJWx6LKTB+aWZkcMGBTIEa5ztQJx6VI/o+
         ynXG01nOtirFCjfDsrHkD+aJO4NXZ/AS4TYCugBGz0itc65RstUzliajt+yGS7IzI095
         2iwcwwy+r8anMveBmQGGezQfVWnfFUik3CX/ZYcsRGDDHQot4Oxg/gzpy7HtBbuuOPak
         MWSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FXMb+WcYYZ9NnCxtbHWk8b6TS9iaJh2KE60qKBsQx6w=;
        b=5erzBSQbep3CuAF/r+VMzI8CCM9pt8fywUVAGuX6tzksU1hLSUVdAhPjmMO5wQxYcY
         oV5TkYx/5CvFVpTemd8Htq5IAeIdeVbBOPrLcfGLjMjc1g9Lvux4IUjYRWnbDPIV8WJ6
         gEMpzZhwVRgfju5l6T79TGPBUPrYZL/VAiKZA7HchJsPREeRU6AbqqBHv/g4UtP5td7b
         RVsNNrvBn1hkXzUszRykvGAdcOavAY9MARy+nVvZ9TlUwrRqgpz9BjpSyMO2paajiwL7
         Fv4jX+6QmJI6/NEBUhk7f3/rTCboh2hAkRs0z3C4M8jjS5sUrTrZHoR6pAj+ZTyOXf9U
         uB4g==
X-Gm-Message-State: ACrzQf3ncI6rwz1rjAen8bcMkyGaOosgRRRjfsnYzgc39io6cnt77PbS
	G+PpLz5Qiuj5nQ2/QFmKKc0=
X-Google-Smtp-Source: AMsMyM6Dbm3DV2KSjP3RBtJVa5jLgfcEfXKTCHifpX/HxQFHPy6DziE0ULHNXCCbblBsONga/twqwg==
X-Received: by 2002:a37:48c:0:b0:6f8:70d5:9a41 with SMTP id 134-20020a37048c000000b006f870d59a41mr18185879qke.676.1667410375061;
        Wed, 02 Nov 2022 10:32:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k17-20020a05620a415100b006ee7e223bb8sm9285918qko.39.2022.11.02.10.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:32:54 -0700 (PDT)
Message-ID: <ac1cacd7-d9a2-baed-5e4e-01abb70958bb@gmail.com>
Date: Wed, 2 Nov 2022 10:32:49 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.9 00/44] 4.9.332-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022049.017479464@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/22 19:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.332 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.332-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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

