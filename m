Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308D3C941
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 18:00:25 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id ei23so155135qtb.2
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 11:00:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681927224; x=1684519224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lN15mI3Cv09qV6UOUeaICwKgmo1oUV8ffmv3hGFot/o=;
        b=ASVs8v2lab3prOG+mAph/fJrQ4OUgsvLf91EXLMJS4ZXl5GNoWGkUYU3uydH6poUfh
         IU5NiQ0Zs4tULBOqPPHWYqbHDDR1V5bkVAufY9L6/+KQpDiPtyAyZDKYa/HQvhWVtu5o
         c9/uMAF0TDs80j/KzdFP9gE9e4fy2Mn2VFr688mWwkofNaicTAr1QtaHwaJXMI1LT1Us
         wXMoNuPAs6CAIdKWksRWXWVU72o6AGZf75j4vKGQ5tVCr2eL3GJGwklaVpm8N1ogNvVr
         X5mRTUhDnC8LyWDai0Y9xF8qQzdTkDaGWLo3/UXWzRB46sE+YkU0N5iaaFrjJiW0SZkR
         y6Qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681927224; x=1684519224;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lN15mI3Cv09qV6UOUeaICwKgmo1oUV8ffmv3hGFot/o=;
        b=HH0I8IMyeJvYBTsLP0Tc5u/u92QEsbWlkoCz5w5IvQhELIOveHH478xhZz+Y/FePI0
         PLbAZOhygLWsFPQnuzndMEx82bmnVzLRbuVNOtdaw7JzRIZsnzMpdliXzk6MwrG2XEOt
         Qyy5Qnmht+Pg0OKcl6WfNyjEr6NHQBFE54glnRIUcfcJ89C6WfxH6qfAMarFG0+rVAJa
         vURF9m4YinSlLEivo71IMVOavBZy7l09l/ozst8AjxLjHh59UB6IkNJWZRXe9kf6/mhq
         AuukoeLx+iYOXGt1roelIvw2MwA3xUlZEd+bZa4HRYO/GnvHoSvRebIOMrM5WTuMng1V
         r6tw==
X-Gm-Message-State: AAQBX9dYljZPuNWw2cbqfoFOaBFJqYXXWBdB+5jpkvmnfuzjkhz3NH9+
	Ew25Ub9aYHyYkw4ZT8MIfik=
X-Google-Smtp-Source: AKy350YjYV1Ywb4vJYyHzNg3Ly09+OuNQLwtsiR3jNBm4GylYgI7vUhrnytxYXEnj2ZExqekBB9bDw==
X-Received: by 2002:a05:622a:14a:b0:3e3:88e0:88c3 with SMTP id v10-20020a05622a014a00b003e388e088c3mr8619755qtw.26.1681927223919;
        Wed, 19 Apr 2023 11:00:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id h17-20020ac87451000000b003ef239e3d5csm2625351qtr.17.2023.04.19.11.00.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:00:23 -0700 (PDT)
Message-ID: <05f88554-e705-db87-8c12-7e74aefaa44c@gmail.com>
Date: Wed, 19 Apr 2023 11:00:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.10 000/120] 5.10.178-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419072207.996418578@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419072207.996418578@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/23 00:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.178 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 07:21:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

