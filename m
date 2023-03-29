Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5B3D7B
	for <patches@lists.linux.dev>; Wed, 29 Mar 2023 01:09:37 +0000 (UTC)
Received: by mail-pj1-f52.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so14539840pjt.5
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 18:09:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680052177; x=1682644177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rrHmZ9KeqMwcEfZQAmDICbY5pMTadE3RCEsUwj0C8ZA=;
        b=Ga4K5TN2AUAffev3UvwTLNSZGK9/7ioRyZBBW9AAV1hKFgfajBHEi5HXeoHsplaZTf
         /yoUJ4/R22maWQYyOFRkRQPpGBLj0P0SR9NLK94t6z3Gm2NXXyD2mfB32s8KaSCKv2JD
         jY0nLg3jNVrpSIluaI34tVrE7HuMnApxJwQF9Gt37T/traPGUqAjuz6M6QsNZpH4QmUm
         r61IjQQqNkYnbF1QVX8AnSq06tWrU7qS8hUCyR/EE2akfk/dqzl8daZd3hCKVTDDeEu2
         mT8bx+5TO1MZ2wqWfngLWK0fQFj8BKaoCwFNjd1tBwxZ7tUW1KldztcSgXCcbTniA0FQ
         vvtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680052177; x=1682644177;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rrHmZ9KeqMwcEfZQAmDICbY5pMTadE3RCEsUwj0C8ZA=;
        b=WqrwzqS8lUMaOGyeVWjPnqv2UjNR/MCxd3lKeXzw/wI3GJcqhqfkQQwmGiaQ9guRAj
         6Du635tOWokbZ0iiHkc6Syut6pbbwwiAO6YHZqofCKVjbMd8bJpQ0dorhhOAoKjgL4+D
         02Xp4QguhyuVsWPBlSAvGrVqBlbaKCz7dBwx+iN4N76QSwWh1ldiUCLCM8ySfF8gJXYJ
         7zqr/mKMhfOLVSXRcq9AV5HpejT+X7TkERZ7p4WKDf0Z/68PafROFARj7bMtlEf1hrhS
         IZ2UGzJJ/cpv5uXEdFE649RRf4qG+ypPJWUta8ykzVpawYzdegBCjrjBmNoWDl/ZzxVa
         eWog==
X-Gm-Message-State: AAQBX9fRszifYdgF8Bs4hzjPXXTfBHJeN5kkx/ApFVOO4an2gSP+OioL
	Lkg6F+6trbNUHVbgNGdpKyU=
X-Google-Smtp-Source: AKy350ZyapWAKd4r51e2CPtGHPVUH757kF8rYkoC9VCVAVxJc5UcTeTcotvbAo4plSqSZwSserLk5w==
X-Received: by 2002:a17:903:11d2:b0:1a1:bff4:4a06 with SMTP id q18-20020a17090311d200b001a1bff44a06mr22531010plh.24.1680052176887;
        Tue, 28 Mar 2023 18:09:36 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d2-20020a170902b70200b0019e31e5f7f9sm21762127pls.71.2023.03.28.18.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 18:09:36 -0700 (PDT)
Message-ID: <9f9c61d0-ee89-fcd7-3df5-dd0264651960@gmail.com>
Date: Tue, 28 Mar 2023 18:09:34 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230328142602.660084725@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/28/2023 7:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
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
