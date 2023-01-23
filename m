Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D13B7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 20:01:53 +0000 (UTC)
Received: by mail-pl1-f175.google.com with SMTP id b17so12551888pld.7
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 12:01:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LSZUXEn2pln3/CCnZqJdWGRNu0XQyJw+TD8CxoELWNU=;
        b=GbAaHgmFXhyWDDxIOz0+D+RfOqP2Ok85UUj7wE9eA2EPsUBamv0VgHw/rw5q7SprBJ
         oPSjzl7bH1MSaVRZXWn/8PrphqaMcRXK2xgs28Q6V1JCky7Vqj0sFL46zQqRYDMCZMcq
         83FJkrpIExgrxq/DiGwuNHGgYuT/3EfcK0cCrAvg4BHPzBUo7MtsgKu7IFqft4EWlE//
         98F94YSNCH5fDowYwhe+M3VHyodK9RadX9mngaJQOYIEniOwhqURZ7x5yClVDBQYjkdM
         kywncC34+EBvStsHTzcArMM0qqFk4UM/L74+76z+21RwIQCwXIHS5NaLbUj+zPfOez5X
         P4SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LSZUXEn2pln3/CCnZqJdWGRNu0XQyJw+TD8CxoELWNU=;
        b=mv+fF5An1EXaybCWduPkVYRAMW+vmq/XyQmTyqrYxoXfUsn3xv53tn5Wr5ddqoa2Ow
         RWAooboXqkfHxOkRUv56255rnqJInVvFB+tALExebJVF9NGp67YHzmJTmhBiS94fOUCS
         g19eqLR0hMP80RrM+XSLkaMFqO1WzaJBFCEfB5XaKIYp/8r0PVDtA2iU5JW+AU2r+Qqs
         hHKwKqmgPF30io+nNtzEdxXo185vbLlGD9cUXiO0jBWf8k3P/UQUtKQltvaxgLf/+06A
         hXnsYh1WakX/4gDiBSQsI9wVkv7Lh+q0d6k0f9NTHDxmFGvFZUd4n8Vr3Pj4ctYkw9Vx
         Ioog==
X-Gm-Message-State: AFqh2kp+8IunzjW9C4knXXSjmVCHm/hWXC8L/cunbxMNbsAD2pKElIvL
	vDDdwNvfk7Eh8vTTh3FR6O0=
X-Google-Smtp-Source: AMrXdXtACcnlSumNzaxRxxHrSlnC/jTpG0PPQ4zhXVuDvzF/k8kTZwQB8KZZTBszN2O1sQB+xyYpWg==
X-Received: by 2002:a17:902:9343:b0:194:4a2b:d7e4 with SMTP id g3-20020a170902934300b001944a2bd7e4mr26601026plp.17.1674504113363;
        Mon, 23 Jan 2023 12:01:53 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id be2-20020a170902aa0200b001948809087dsm66804plb.281.2023.01.23.12.01.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:01:52 -0800 (PST)
Message-ID: <775529e0-1b21-82ba-acb1-1fee200eab12@gmail.com>
Date: Mon, 23 Jan 2023 12:01:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094918.977276664@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

