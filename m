Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30AF28F7
	for <patches@lists.linux.dev>; Fri, 30 Dec 2022 17:23:39 +0000 (UTC)
Received: by mail-qt1-f180.google.com with SMTP id a16so17557298qtw.10
        for <patches@lists.linux.dev>; Fri, 30 Dec 2022 09:23:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9+/ml9NCLv5dDeSsbxvtQfApDnRRwzcuKMMn9TJ/VkA=;
        b=EzlVxJMwa8DGFD84dwRkZi0wFjJOLxUtCyb1ZmHRCVmxaoRDMXHvUR4GPON95dV1Rk
         svZWhK8ROFoTH8/JG06d6ej2uAKbh50zfMNOZHkIwixgPxBnTP9Il11UyNaUFl4+oZ+D
         pptoTsvHpiLlsvm28MIdoVRJWyETioDkepShdLrQOhDI/VvyhWl1Sh3cLbGbT65qvGD4
         j8Thbq9wY5Iq+C9OalLuBAYTcXffmsasz1IgCByZMGaCZdMRuw17YfF7I9gznk+DcpyI
         9fo8W+G34UkcLvoD2S71WNrttobVB9jjNxf3OH2cbJS4MBQhBlWYBOhniHXk9TwLIeUU
         qdeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9+/ml9NCLv5dDeSsbxvtQfApDnRRwzcuKMMn9TJ/VkA=;
        b=nA+y4sz7wEUEmmJUVZbmfbEHe/X2efE9iFHAN7dXZzxQSXE0BID1xhFbHGeDspdPHd
         kKl5C7ykWP0aJZdoOnGM4VyX+FFEA74AR6I9vIjJNIExp8bW73ifv9+EUNZFRJBS9GOv
         hsKNvkq1VN/9KFk7+L4VJL7L4VvLq0TBTba5cMhqDVjMnMpdYCBWIruKF53p2L4jws8o
         v0BvtIZxnyywO0Wl43rXVnMZ5YD4swxCBLnPRHlcPhkniLxHzAesWtUWpxVc2aMfxFSA
         amSPh5ooLM+uqk8BOMzAKPi6odqrCaYd7Y2tCtaie+FWWErjP9mTm55lYlbGdHjw90ve
         W+2w==
X-Gm-Message-State: AFqh2krRTlEoNq8UJmGly0xbqCdpNj/nPPqr10XpGOTCLIKaUrSq0BIx
	aUFAzdM4wgg0ysKAXBEcCiA=
X-Google-Smtp-Source: AMrXdXtyW7V+Bam3ECPKRKkNIhL5uzFNhXHjvI7hvi5I1zr6GBJfTKw8wfVeqzy3ofhsBWFy291k7A==
X-Received: by 2002:ac8:7395:0:b0:3a7:ed31:a618 with SMTP id t21-20020ac87395000000b003a7ed31a618mr44552430qtp.7.1672421018595;
        Fri, 30 Dec 2022 09:23:38 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id fb25-20020a05622a481900b003a5430ee366sm11995695qtb.60.2022.12.30.09.23.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Dec 2022 09:23:37 -0800 (PST)
Message-ID: <1655572b-dee1-9e85-050c-6fb9a743a869@gmail.com>
Date: Fri, 30 Dec 2022 09:23:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 5.15 000/731] 5.15.86-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221230094021.575121238@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221230094021.575121238@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/30/2022 1:49 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.86 release.
> There are 731 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc2.gz
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
