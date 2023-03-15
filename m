Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EC3193
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 22:43:00 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id cn6so7907663pjb.2
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 15:43:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678920180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eEp3d+FJRKvRxifPcXNAFdp5+kmGjxvebEQxyNRqGVA=;
        b=M3yCC97Geq9KE07fU9rp4QJKMGfWQcU8AM6+2xT/72tlldyXs/r4blB8gVCxXP6kCQ
         rO227if2lgIbA495wol0zjzwcWJXdGDxHOHJv2jUBXJtFYJGuvWYmEhTnEIIsT6Ok6IO
         40gMJ+/JgGDZyfaaLF3xXQGQ0pl05oZuOktuWAB0Fw2jbW+Ueh/hHcTHG0gLKsP2fBZt
         +AfoE2uXoMP2b5wFFhNrnl4MQr8JVShfR/WzR2z/61cOH+yNuV7qm2LGAokhxATGPMp5
         uIPs0d4CUTbbZU89uvKD21uGa84EURPmrZumBiEgFkht8n6Nnmg0Su4+sjK2bZssHSO+
         0j2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678920180;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eEp3d+FJRKvRxifPcXNAFdp5+kmGjxvebEQxyNRqGVA=;
        b=W/NGUDRkgwgxPH43aKBFnfwpNsnQh7/pmY2g63Na6eghz/6jnkGXU3A/+EoJABTQ8C
         Pnw9ONW3APgRsSpOTwzQA5GpbRPkr65Igk0ZFUtoFLTZZANSCjXvMV8HSRAZEfxx0gon
         Ykl5GRhHBcJuS/jAxfwFWNe3GnGLQ/UGYldeIGHO/+uYixRJ4OCxGeKOIcdsYNESOKQV
         9WsBdtcWIp1cGRsC99lMzbJprcRQKkrmYGCNQ8XSCGv/I1u1K3YLkqP3McXhNkJt8giC
         wnMU9Qhgmfkwsyv0xxwLzCXnOXxP2oqbrk9oEmYWufdS12jBwkpZwfNEmVAhXJtg7WNf
         09iw==
X-Gm-Message-State: AO0yUKWwAcTcKNk4Tm+QtHo8THcShF78qBqUrBNGG/OPTKTGX1e2qsOH
	myaKWtQSYopzVKGsKscbXQg=
X-Google-Smtp-Source: AK7set/gEmMAoI2d2RY7inGv65qx0qY2mC+u7Ow/Fl8KS4cd1P8vvS3G17KHSjRJaqONW96MuV5zrA==
X-Received: by 2002:a17:90b:1d87:b0:234:e5c2:b92c with SMTP id pf7-20020a17090b1d8700b00234e5c2b92cmr1518112pjb.15.1678920180153;
        Wed, 15 Mar 2023 15:43:00 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a13-20020a65640d000000b005026c125d47sm3864410pgv.21.2023.03.15.15.42.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 15:42:59 -0700 (PDT)
Message-ID: <13bc86c9-fffb-1d5d-9214-1b03de131bc4@gmail.com>
Date: Wed, 15 Mar 2023 15:42:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/141] 6.2.7-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115739.932786806@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.7 release.
> There are 141 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

