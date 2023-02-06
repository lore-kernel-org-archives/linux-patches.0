Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226F2F2F
	for <patches@lists.linux.dev>; Mon,  6 Feb 2023 18:52:39 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id v17so14007716qto.3
        for <patches@lists.linux.dev>; Mon, 06 Feb 2023 10:52:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C2BVvWwJDpl1vnxID9lKGhlHkyXd2wpAzBHIvBEypFI=;
        b=NU5yP0net479efL90aEMdAry1GtUGTtcnIM+V5VWpf3OnvalwRYyiB3WTq3O+2sa0L
         XAfGImxrig945/HunVQx7wMltHs65iFwGt45xht0BtLReW7lLZOozULK6AxNtabIXQJW
         tCa08cEvtGwLfzBL5KHo9FpbW8JNWeWag913WGGyvmSL3gml4uwXx0MBBv57JoT02gu2
         6jon78fvEzFm1AztyVKoljbyDXq/RGhYkcjR/Fq5YBdQTuIoNHwhX7P+6GHgkdPJZ95L
         4SuKl5Sz4J4iQy0dRNy8ZCrG80xIfTBnjI+zLfwCdpNzlW79QdmOwnaw0TiYoIGRWINp
         H3pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C2BVvWwJDpl1vnxID9lKGhlHkyXd2wpAzBHIvBEypFI=;
        b=e33qKOXAX4lLjNzMYsFhZMKr8oIdpWPibqFLPGujUZYrhAReulxFWK9df4lW6l86tB
         +hFC4IFHnmgFTDQhorL4FP02HfMTpE/CV9aO3XRMkp01szha9NvjqNdirK7zxAgvVAHN
         U1UQd+IwIyaVKxyeVTVOqQsIYUGA9NN36+p9HiGaM86ElVM/0uLgZr6Puw6VOaov4+b1
         eSiT8cGtMel/7ql6+1LcIPZnIw1nNAQjyMmXXEUCpFAVrouy3k611Gk9X8wjdY55WvIx
         IyZ+/Xn66aSCILGI88xMrgxB8DPlPwoha4agpwTqhUvNnJyHNYlO/+jbf12m2QHNnppg
         M1XQ==
X-Gm-Message-State: AO0yUKW4Z/mzmqTqZEYN4GgwD/4lEgkzX9Z8J6tcT2QjBxx0LMdRDTln
	j42zokd7q04TfplTEBaLvFI=
X-Google-Smtp-Source: AK7set+NwTyimLUxjlb0jM54xus9V5kklM8Yuwc3DdZL7VVI0c9IYWu9x8AuDMdOH4fl4MNWe0mA2A==
X-Received: by 2002:ac8:5dcf:0:b0:3b9:b1eb:ad38 with SMTP id e15-20020ac85dcf000000b003b9b1ebad38mr516760qtx.50.1675709558533;
        Mon, 06 Feb 2023 10:52:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ed4-20020a05620a490400b007195af894e7sm7841310qkb.76.2023.02.06.10.52.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Feb 2023 10:52:37 -0800 (PST)
Message-ID: <d79aa5f7-23d6-342c-83ec-3badaf111096@gmail.com>
Date: Mon, 6 Feb 2023 10:52:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/134] 5.4.231-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230204143608.813973353@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230204143608.813973353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/23 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.231 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 06 Feb 2023 14:35:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.231-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

