Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E2720EE
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 16:53:18 +0000 (UTC)
Received: by mail-pj1-f43.google.com with SMTP id c3so13114000pjg.1
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 09:53:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681318398; x=1683910398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=svKE2Vd+mVEPF5FMwXkomHu4DRBlZ0ZAxPOWlhr/OIU=;
        b=gk0Le4iV1SfVvzyHk2McZLdrmZlTcuC70+BAG9tJx3Dl99K1N6BOKdKc9hYwRtYaaT
         yuzXMA3xTNfiTHo/6qTW6m5sliFiNSmwYUQtvybF7Q3D8G8Fhf4w09u1K5+/JHmTCD4T
         aDIIyMy/52dsz77dK9zryhdSAXiKR5/oV3fMHuKnB8RFKY5+6z6zFmnuDD59mYY98u+5
         AazhxT7lbTpkwxQXHxaYeYU/u2hkz8lJyTv14NdqxNLUtMRu773n0qrd/6ZjbAs4r+og
         krCn+Cic71gMPA8gmu6H0ARI7JRM1mpSDNG6XyUVa5+ebU2mUexMvzhzFoTlngQeuOKk
         LuJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681318398; x=1683910398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=svKE2Vd+mVEPF5FMwXkomHu4DRBlZ0ZAxPOWlhr/OIU=;
        b=AC4qJB4i4aD4FyyNWUxILULoqADcXgOdXHXq5s/EQVLlRboIvoMYgjac/pwNiP2fMa
         NpHYHZ+HhxzzRpGdwMVN6LHxc+kNBpnQfPBs0ZbFyDG1ZIsaLR0OI/p3E2jHPrdORwKM
         z0KeiCRbpdjAT9s0EUtb8xr06tLeN9rZJKmf57sWZGofOJ9lcMZcmSEbxRgn0TOZ8txh
         4A7yftJvub3i28lXCoVVvcgsEN4CRg2L1UfcAju+QHl8TSH4j49jrmwp+3G+wmKoQxG3
         8npuT/jwKwnf8o6ngJmf26E4akjra/cBPFwPKx+iR3OlURsCE7ntvBG9D/o/10r52g8l
         5FiQ==
X-Gm-Message-State: AAQBX9d62QxykOkR7WWBil8YcMfp7KL3HX9MUfNA2dhvkZfSyH5bMqTX
	D2HcCZHK1RBffrwippfoqtE=
X-Google-Smtp-Source: AKy350YAciQEkRZtVRmlMlv0UthOqCVxofwPzJcsir6JhllD5+o7/Sa5Sg3UPbTrGGwL7kFNOlJIvQ==
X-Received: by 2002:a17:902:d2cb:b0:1a2:37fc:b591 with SMTP id n11-20020a170902d2cb00b001a237fcb591mr9883195plc.69.1681318398402;
        Wed, 12 Apr 2023 09:53:18 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iz15-20020a170902ef8f00b001a1dc2be791sm6718454plb.259.2023.04.12.09.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 09:53:17 -0700 (PDT)
Message-ID: <5d683cd2-c989-c3e5-b55f-cd31aa78c7c8@gmail.com>
Date: Wed, 12 Apr 2023 09:53:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 00/93] 5.15.107-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230412082823.045155996@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/23 01:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.107 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.107-rc1.gz
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

