Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AA84AD26
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 22:25:46 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id qi12-20020a17090b274c00b002341621377cso847426pjb.2
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 14:25:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rjj3snMpxZB2TRf050gHgvkyriwKTyczDaG6fgrNL/c=;
        b=bVHd1RSNG5SuUmtpJ0EPODD/jURN/Khhs6pYxikjWpkwxBOHWujluJ3ZskB8bygbth
         PFr8gRn3hbG8JoisOn9r9ZHFF9t/54QDTEx7unR3E1r1EGa3htXMarBzmcFnVOLLsRrj
         obIZzkeeFH+3fPnjii1089Y1an1l4bTFiVDVQgYM6mWuRG+nJOxAPafuqD/Zrz1I1who
         e4VEL9ir7Qh/oPwZSOrCkz7yImlNa9xTACmKshxGeRg3CsEJWb6Rz55ZgnrewjlC5YaK
         LSv1VgnhkB8qwBu4zXqhk7tF7slEE9YSxu5w2f+H2Ia5mwIcSAx5SR6AMRoJ/j3Q959H
         61lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rjj3snMpxZB2TRf050gHgvkyriwKTyczDaG6fgrNL/c=;
        b=DVdn8UOvVkjvgDYLmLwdoUKfPVnHMFB4sUOZjr4iABBvo1dqM+b69xBsRuNUeUlAwZ
         XtUL0p/cJaxx3Wdw/qVzubmuPr/DQpx27SEGa1ahiah2knu9F4W1/FnFjoYHBM4il17+
         rJb8DUcdiALmA7fZgd32KmbDgjDmP5muTR4Z0psW0LrvOxWDqN6NZ0lVYx+x2zDVe9qe
         AH6cCMfHIn9m7WfCtFOFukZd3oMkEuRuiIZoRdK8sXY7TQ6nVSRDhhnYfTfCevqqj+/D
         iFuSb7FcP8vPktmcY7VdDqMUFQxqZGHI0uOGEo3lLTCtH0K4OWBFoGn26Oi0usuVFUG6
         y2tw==
X-Gm-Message-State: AO0yUKVYIMH8h5oy4KN89sVUjSOD/0Eb21TT/0J121Kq/mhzArR5gYyR
	oFeKFdeF2ki9MQUZAB0rXdU=
X-Google-Smtp-Source: AK7set/pU1PTFiTw6yudCDS+Er13fStt9pnicY4aT3l0MFg815gT5EYNWEtUXWxCPRcjymPiOnT/YQ==
X-Received: by 2002:a17:90a:199:b0:234:b23:ead3 with SMTP id 25-20020a17090a019900b002340b23ead3mr14228561pjc.3.1677191145493;
        Thu, 23 Feb 2023 14:25:45 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ji10-20020a170903324a00b00198f256a192sm7862497plb.171.2023.02.23.14.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 14:25:44 -0800 (PST)
Message-ID: <b24ddcf2-0f9d-f96a-7a6a-8bdbc0904600@gmail.com>
Date: Thu, 23 Feb 2023 14:25:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141539.893173089@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

