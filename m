Received: from mail-qv1-f50.google.com (mail-qv1-f50.google.com [209.85.219.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1795AD52
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 20:57:34 +0000 (UTC)
Received: by mail-qv1-f50.google.com with SMTP id i12so9178934qvs.2
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 12:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=X9T1XxacdA8ndnvUpLliuxpb8eQwtpX1tyf1SdPkzuc=;
        b=nvhM8oNBR/PWWGy0uSLopHV6OaM89T+GBlnrlad8bBhcH1uk1wOLodXVWXzRKGesRm
         52IXvnsGYnJTF/35BlOCurz9tFEnk5GsDk8zekIMQ0Rt2t0MI2vQacI73QTyuAD7avGt
         fyLsRrWHcFWIYih0Z+KqbfeoIGB/6k9RNyVDN3q12kzgrQGCL7S9Ej3XD417dRINYnIR
         CSuujm5GNQDRYSnxlbgaVaQcqf2Lw/1+cygPZEqZxl0JJRBOTG67JhWNTnDkuRIhVq+2
         Pe458RMZDpLu5MSqVj6IIXhFPcdYHdFK2w6gTmqA8nJ8moq/GFf1XplsiwQ8uZP7gjv7
         M1ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X9T1XxacdA8ndnvUpLliuxpb8eQwtpX1tyf1SdPkzuc=;
        b=gjg4VuzqF9bmqwLn8vXlr+Pq98zR54sMwhF2x4sya9jjYOa8aai0iQ8I0t2EDZ8Mbb
         /DxpzJiYAxs+/7xAMkJ5UKNcOYTMmxSqe6v/Yyi42slmvB7oDV2UIEjUmhc7qhWOandW
         gB1MfI6hdiF48cPcPym9g17Nx17fJE931Q7txchPm0BAkQq+3ueTP6pkJ06AGCgRDLi4
         Q21pd7pv/Ji3DrPj2NkCovQcxWD9umkgHnDYgy4dbsRAAb+nbZdogjNU2vUjtu5T+QVH
         t2MwXINR248EvvXeNOzw5GrLVMHohwzkZMMd+zc3tWYFZxc+aBJonctTtN5WU3Rf0E/O
         EIIw==
X-Gm-Message-State: AO0yUKU8Ttg8XKwVhfzGGdOH8NdRF2hLbq/bHsntht1U00hABnRonWxV
	fsvWnr17ffvYzpRdmKxATTY=
X-Google-Smtp-Source: AK7set+COE3Ki8x13mf7uSUyaVPrSP2/TE12cUHxsDwlLZ85G2gUP5pumFlHX1Rr518NciO2lIwgrQ==
X-Received: by 2002:a05:6214:4017:b0:56e:b33c:d990 with SMTP id kd23-20020a056214401700b0056eb33cd990mr585415qvb.24.1676321853859;
        Mon, 13 Feb 2023 12:57:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l67-20020a37bb46000000b0071d0f1d01easm10424569qkf.57.2023.02.13.12.57.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Feb 2023 12:57:33 -0800 (PST)
Message-ID: <a4b17949-a7a2-1ffc-12cc-eec4b2fbead3@gmail.com>
Date: Mon, 13 Feb 2023 12:57:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230213144742.219399167@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/13/23 06:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

