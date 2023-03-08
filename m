Received: from mail-pg1-f178.google.com (mail-pg1-f178.google.com [209.85.215.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89D348BF3
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 19:03:33 +0000 (UTC)
Received: by mail-pg1-f178.google.com with SMTP id z10so10229631pgr.8
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 11:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678302213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bpVeJlxzr9a+pZzvYi0QKS84eR0eQKkGn5sJ0lCFKf4=;
        b=CgPAjPUgs6c57H71wf5NngCtu8lwZ5XxSFP7kG/knf3c1DKG/8MWb4cSbBXRAVmQXp
         99BRyQI5z5lIy+zElFWvjpIQGKQe8YY5XZFwYAftvJ9dVfEtS4IP/av8pXU2VtQNq5qn
         FXxo/VKx0LdXRsXQMGsr8K8DfZixTgvg9RyJQVfRERvfiZVotCnzXLp9dVXUIEZUljtI
         nA+IT5F+IeiKea0V+/IQLcjc/bkfHs5ORNi3cL3Bs+hYtFSqC/z/5GY2T0VmeKd71zRZ
         8LzEFwlejzXdAtvyCWMy2X6EwyMGEJlOo+dx6PDwj4tbiVTwEzre+L43Nqxt3GiMHOOF
         bRVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678302213;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bpVeJlxzr9a+pZzvYi0QKS84eR0eQKkGn5sJ0lCFKf4=;
        b=PS5gWfDy0HNKTUTL20rBSr1MiBbyd7tBHPRVtm9rI27fH7Ba3W5CbzDKzms4htIp16
         Kly5CIoXoOQ7CAioHeZU0SKTCSzkpinXlk4xGx1e6dMscGa28l4bQ5V1XJm7mmAId2xM
         V/xd0JVucMUqeSouFA4Xh/PNxPnqVe6uTxtqa+oku5pv8D3vc514rmGSo/U2+MY/n91I
         JIzt8bDtBuXy29EXEC5po5wQvE32RwelfkBCBP/MKdyCffVSSI8R6CtXduDjYauensus
         wVXENOi/js6ibxiafpClaqVAa47Q1e2MK5ByVBrYjNRGkTlQfhCWhtD0OIsyZYg5+W/R
         kkHg==
X-Gm-Message-State: AO0yUKWeGsO6TxVmFYHxwcaP/VkFpme6iSHkg5lW+19VRouVPPhh03wU
	3+Do6Ekg/S13+vAQqgQFZgo=
X-Google-Smtp-Source: AK7set/U0j1v/yI0bLmQYxFkDRAOdx2IIZqC3tp4CvTeNaOmgIpC8hFw2x1qAFDp5q7dRZH5JWYszg==
X-Received: by 2002:aa7:9a50:0:b0:61d:e10f:4e70 with SMTP id x16-20020aa79a50000000b0061de10f4e70mr2118523pfj.0.1678302212713;
        Wed, 08 Mar 2023 11:03:32 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id j14-20020a62e90e000000b005a8de0f4c76sm10045378pfh.17.2023.03.08.11.03.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:03:31 -0800 (PST)
Message-ID: <fa38ef6e-034f-7232-1f06-dccd565aa7cd@gmail.com>
Date: Wed, 8 Mar 2023 11:03:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/570] 5.15.99-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091759.112425121@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091759.112425121@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.99 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.99-rc2.gz
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

