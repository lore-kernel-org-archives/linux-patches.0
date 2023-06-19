Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27A80C2DC
	for <patches@lists.linux.dev>; Mon, 19 Jun 2023 11:43:01 +0000 (UTC)
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6300510605bso16774076d6.0
        for <patches@lists.linux.dev>; Mon, 19 Jun 2023 04:43:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687174981; x=1689766981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xTBAhkNEAfivnk42N/MFkAxpYvk7m//AEyhvZcmNRzo=;
        b=NiVr6xLhrXpongF3PI3mhC9/bYP7HlHDnCovgkQMEFWnC+lwDITWQwgkyl0MMjxTF9
         6Gb2uFiZHFYs0KKl5xftXF+/Sp9t/5ZBh5P/5l+5blmAYfnEXEO7gCXdFX/5mHxPCjEo
         h63Qr/cqxDOUjujxReqsDGOkkSWxv3aO5TVTeqL5ammZle5hDlUt4B+lhhA8/0h+mhAe
         G0BNTN2OIbtf3iJuCLsVAxVOfQcGirdMIgwc41SxNivJPjw7vW9/lBBNlotjYbIhS421
         7Eh+NLKFjnTIMrvaeNbSf3YUR5xnkhltHnh9Q0NLjlTG1hKxJ/VhA28Krr+4KsHNUMnY
         xD3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687174981; x=1689766981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xTBAhkNEAfivnk42N/MFkAxpYvk7m//AEyhvZcmNRzo=;
        b=SceoxdPH8kxz+IYoJloCMj1AAm2wBHmu/ak/MMGJkREQqovlj40bMIq4t+eoul62Km
         E25OZ7oFFvDhM/BfHg0s34titHghU+8YrtnWPx0kG5/6Z8yG3Awewc2px9L3sMhOdAJC
         lIvo8DL8CED2HJwmEa0ag/U0+U1bk+fo8S4scjhHxY3AihddDnhRnryng/IripUHh/nE
         rgNZFB6wSq+OQWaKA7oybmn3+RgcfLKcs/yo5H0+UFUiutL03ALf8RFPxUU5igDvb4bq
         KHOzP4tZnNhOT6zR77kd7WEN9jYLfhlqYKo+r39iIfocX+mWirk1pKwaoGSwxTheATnC
         IRsA==
X-Gm-Message-State: AC+VfDypdE9LVYU3oMtzQ+p+2aE9cvZH7JMjVqa/NcgfoIFEFUBMZSN9
	REawZpyqYb2QZpm7K/uE4EaaZOfQMjtP4T2x
X-Google-Smtp-Source: ACHHUZ5lU7mEdDjnTyUD7XRJituWNTi2xBw5Vavk0uAHv8cfxcQUL1c/ybCv7UiWS386WA/GlL6KdA==
X-Received: by 2002:a05:6214:21a3:b0:5ef:5138:1e5d with SMTP id t3-20020a05621421a300b005ef51381e5dmr11365499qvc.49.1687174980696;
        Mon, 19 Jun 2023 04:43:00 -0700 (PDT)
Received: from [10.178.67.29] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id oj2-20020a056214440200b005ef442226bbsm10390842qvb.8.2023.06.19.04.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jun 2023 04:42:59 -0700 (PDT)
Message-ID: <cf3cbd12-f108-685d-38db-9a4a448acd1b@gmail.com>
Date: Mon, 19 Jun 2023 12:42:57 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH 5.4 00/64] 5.4.248-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230619102132.808972458@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230619102132.808972458@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/19/2023 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.248 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.248-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
