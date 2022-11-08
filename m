Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 355DC8BFA
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 19:02:58 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id s20so9673484qkg.5
        for <patches@lists.linux.dev>; Tue, 08 Nov 2022 11:02:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3KG5HTwbUWnHIh1/xSLWqezCx1gVcj4ogrO0fVWY3+c=;
        b=YNGhzolnYHsjbIqKphzgb1s6nsxsgBM112eytFZL3/uZxCD8uc0kBgp0raeP0ueDJS
         HP4uZC+H99k6T1HILl0955Su4Lb9c8ZhhiLwNQons+o4JNcdER384aVrzWFhQX4W/kMA
         Ao1DJS4iD1YLhemCCJfi9M8w2gOuFymxiJeeNaZmjlIDD3cxUIWMHAxi3XBNAgfDc/ud
         aj4KSH0kC1wEfKrG6YC5EohJSdldUl84t+RbjE6DOQmiMMuWcerxk6bANlaFlitjZ83Y
         klTrwOKpyVzdE3zaTbHmwlIZ4O4eZghZ+MWc2Rb4BwZ2EbT9Wr+6w9gc9hNzshpmKz/d
         TOZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3KG5HTwbUWnHIh1/xSLWqezCx1gVcj4ogrO0fVWY3+c=;
        b=5D0SV2dy2k7MSFe3yxZqsaw6N7vKLEJu4xpuoS9aBA93uNB8CDp6kp5DD19AX6l9Sl
         D9PerfCSkbDJbxy9P6m8c+gmF2v1b96KLwsCUBrefadpwIkywDE7Myf7ikYybeXbXtJp
         RTuk6yF6JdBvyxMlmY1JprsbbvuMCRFDwuBVmfDv1v0N1IX8gIXp6gACM80CIkTHN3TO
         IHBqUEh8tJhePWZrVOYJ59nBY2lgQRRUARNZUFHtKrPVh4p2C+ifmoRMH7SXJADqBEiY
         DCZnoDumu9KpsS6cLRljL+OyeoW4+HqK3kryjmmnDTereagy5pPOaEzTvdA9kZLWdN95
         xDnA==
X-Gm-Message-State: ACrzQf3b9+nmxk6c3nG9N5SwL8xFp0razkgkXXq2EJWz/pBTbU0ZIDKH
	oi6j62zziY5B9UNShHkxBwk=
X-Google-Smtp-Source: AMsMyM7xP7cI78ex/eFm+5CJnRn70C4IZ1TJd562+dkXO/hXZs7nFClObcKZvjQfCHRISzXWQ54mAg==
X-Received: by 2002:a05:620a:132e:b0:6fa:5082:f870 with SMTP id p14-20020a05620a132e00b006fa5082f870mr28354616qkj.391.1667934177028;
        Tue, 08 Nov 2022 11:02:57 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h4-20020ac846c4000000b00398a7c860c2sm8572295qto.4.2022.11.08.11.02.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Nov 2022 11:02:56 -0800 (PST)
Message-ID: <33c89360-8f7d-469e-c365-c9c739b7b033@gmail.com>
Date: Tue, 8 Nov 2022 11:02:39 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/74] 5.4.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221108133333.659601604@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221108133333.659601604@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 11/8/2022 5:38 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.224 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.224-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

