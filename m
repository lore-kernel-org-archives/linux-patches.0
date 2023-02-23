Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47F81AD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 21:54:14 +0000 (UTC)
Received: by mail-qv1-f42.google.com with SMTP id op8so12722512qvb.11
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 13:54:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mhDdt0fMRr1vot8arPkCNh+wXMPBtnxO+GXM3kSrfBE=;
        b=PISFKTE8TM6sQSy1pBwZQI3u/FYQ14vkOaC/RCP1BrAipVymVttA0bLTmJjirxfNrX
         5o8h95DpGXbCuVOFh5tziZ+NXPrX71dUMKRzGEkobDZBbA9JLfjoWXaNJJEO53RcxY7v
         fm6zQHfxKYLvHNA47/9eR4LRs89UcMrAGBfWZL1nqOAquJrumq3aL1Mg/glmVNG6zsJV
         kRNV+w2DSoJtKyUA6GTXqZ/HiAa2PMDNL1s5aKqF+1gfb/QOqKGXf2uoUttcXRYCgzEE
         LVglo9IJJFOWySdneEpSw6VWeLHI8zsZyC3ojV6mS4Jy5Ws827yvaxd4Wek9sJ+dZgKp
         Y6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mhDdt0fMRr1vot8arPkCNh+wXMPBtnxO+GXM3kSrfBE=;
        b=QmikZ7QrfTM6FsavqIQbKt6O7kXlNb/lxItdnaW0qufCRW2tp5oEuGue0eobm1PjQm
         8m44o8s9LTyCzg2gucTzXh6kiN3L9O+tM5JscP9G7U6vOYalNDO5OUv95Es7cuZifFGT
         t85HpfnJmJz/I9tcaPSdKppLOm4LiB/fEQxhs+ONl5Wl/LwL6qThtIUoxFj+lreNmVyg
         23/12MOW4OZSBkUMlJk00loD+yvm5B9gOR6yvz8GqRsFt0rIwdOnAXgC0YN4VjEZSV1J
         zx7aNQ6MNZjK1SaHDJY3yiWoF/H7w9kg+V3dEIL9LnSHO6yK/crIgsxwpQ12bHqx147G
         yM9w==
X-Gm-Message-State: AO0yUKXSKND7fHYgW/MhahNThVOGlCyoWeaLi6d95RBRtY/uAGEeoXVr
	MfNYzAbnUAJ7I1NgtBw/aig=
X-Google-Smtp-Source: AK7set+8DThh2Mijo2u7YMM3UZhA44f0vpc4gUZlHdvfSjAp1w1r64513HiUfo8NsrWaPkl3D+3lQA==
X-Received: by 2002:a05:6214:528b:b0:56e:982c:30 with SMTP id kj11-20020a056214528b00b0056e982c0030mr27247064qvb.16.1677189253033;
        Thu, 23 Feb 2023 13:54:13 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d191-20020a3768c8000000b0073b4d8cb4a5sm5489949qkc.60.2023.02.23.13.54.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 13:54:12 -0800 (PST)
Message-ID: <ceea2630-7c1e-6fde-cf2f-d4e36e292e59@gmail.com>
Date: Thu, 23 Feb 2023 13:54:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

with fixing the permissions of scripts/pahole-version.sh
-- 
Florian

