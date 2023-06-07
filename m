Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586F33B418
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 23:55:56 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-75d461874f4so682085a.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 16:55:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686182155; x=1688774155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SYhFANAzyXu9CA9iibCEU+U1cngp0/OUke1pKcFWOtc=;
        b=heQ4IDcAnFQZvPRwgvKliopuoKlTnUvSTXrz7RNjydYPzgKZqCQUW+bwrPVWwSIVd6
         tpv/Kr5ROkPrkvhov3E/oYNeHtyBxZsxu2iRCokTHNHz9lRxnAbYS441rC/sttU6BTC6
         kemG8+mwqfqyYhrU0N0ofrXBFT+OTrau4MRoT5PZSs851LCA3RjjAgjHxLjB1GgVQgHv
         NYmCjr1UkDsCF4D1BvAO/Gl/6pvCV5MXWgVRGabPZeesFnS092eTwkxA2ihxX0dpoJUd
         oer0i377g+OurlGjGv/GvdMvY8QrTyXTJn+iyNgteJxVL9SOrucseeJibMCmwZdAUIwA
         /w/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686182155; x=1688774155;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SYhFANAzyXu9CA9iibCEU+U1cngp0/OUke1pKcFWOtc=;
        b=VjJjNEgR/GUq+tnXoZCuoSEFYa/o3POVsaFDNcQdWesQgaz205EaTJzrxaRgTjVr+8
         eSySKvZQiQk5GjoS0Cv1R/9QlaDvy/qRrrm0DOPSbjP4HRMFTiqPlEhNSV0RS0LYnFMW
         oLjm3H5xnGhqWlewd221v13FOl4SMf8jYUoLkNC3Mn47b/1bYX5/J06S3z6ToQbCl6+9
         fhUzwwg3tfBValCeI4iy0Uliwfc00rWXsWMRt8+l+wnXhgv7YmBcOZ7iga6yHsD7Y11O
         I97uWb7izxnGUBnuMS1sWuiEfLAgvIKZHu8xAryyQ3WV/xyq0iSO4vYa3AP7vdFgnvqa
         GtSg==
X-Gm-Message-State: AC+VfDz2YvYPdCQQyu+D8aUDFOhVM2MXCS7wIjDrcs7bZgnk9Po4BgmF
	BZNgsgmaFa7ndBMK+2PkJtI=
X-Google-Smtp-Source: ACHHUZ4qwuDixFk4U1d7Gyrg9n/EKGFw4ckTEhu/S2awuI5QH6bsKsHEGKy6w2y2KKEEgR+F6g2c7A==
X-Received: by 2002:a05:620a:8082:b0:75e:680f:857b with SMTP id ef2-20020a05620a808200b0075e680f857bmr3845741qkb.73.1686182155054;
        Wed, 07 Jun 2023 16:55:55 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u10-20020ae9c00a000000b007593bf6e345sm229163qkk.113.2023.06.07.16.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 16:55:54 -0700 (PDT)
Message-ID: <5d0364f2-8525-2d6d-ddc9-409c32b8147c@gmail.com>
Date: Wed, 7 Jun 2023 16:55:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/159] 5.15.116-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230607200903.652580797@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 13:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.116 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tseted on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

