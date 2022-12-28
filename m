Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D07AF1C10
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 19:20:39 +0000 (UTC)
Received: by mail-pl1-f171.google.com with SMTP id d9so111558pll.9
        for <patches@lists.linux.dev>; Wed, 28 Dec 2022 11:20:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tPjEE4IkK/UqjlAXGEr5RHGSebOudNwdgJr4Z1YJtDs=;
        b=BPLoHCGT9oR6K/S0wfK4If03CeIE2KDLqyKX2iD57fGcEVsdDolJ4T6xPijESN1w6F
         Le404VMstLLy8N6RY/50t6rSTDiSxkuSyFwzdRkwZtDqMsWRsKHW078V6+CPkbKHSUrh
         WCOxDpOUvaK8MH00+0FchO5EgtQep2UN/97AU8la8vmb5qvMMCfM3cspIqAHhFIspK1N
         jyLk164cBaq10KwtUDoMXx+iaXLWfbg7UiKIEEt5vklZPgpEGmGbKU4c4wWNuQCdDWJw
         Gx/nkCDicobEl6F7ldu/4alxnCtqJhh/bpaOqxI1+d1EBDRqlChLCcrQ/6OjPJGaWKMU
         w9cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tPjEE4IkK/UqjlAXGEr5RHGSebOudNwdgJr4Z1YJtDs=;
        b=uXHFFitNcFfodcOrOKEk3sRMvGCSDP+RNZeHnHZiXlSfndl2Kc6HSfIgeWYeFxLVaR
         XIRB7TDMwcRi3oWyStguKpoDsDD+WnnIk+QrOZqfGd4pqAb6tVugJF+dgrTdZRADtA8N
         xJIRI1RSnLbMFStBzomAiKwSdxJpGDeciLf1D8GikdI3sOs0y3rYyNA9vsgVQVOYaHol
         yi1q5+V4uzma5JCuHlgPnk42y6wYoJdwiyKosqYOkksd3X9axpZwtlvjjZCjWTCg7TGs
         zO+unHrPCd+mIeMtQveCpvD2vRhz46NXUmILculLBIaSWliUAIJ+Tp2Q6yWwG4qB5X5l
         hllw==
X-Gm-Message-State: AFqh2krDCnf9mu08Uo38jmHrmrN6nkHSWhOv/QbIIl3qDTA+lNUwsY2V
	nnXO8W9K4+o987mFPPty/bg=
X-Google-Smtp-Source: AMrXdXs73Z915rrEYq+qN4900ZX9X0NvlilJQSCosBGNPXUv6N3aCT5lZ0I/vIASJo1BncDFX3g/rA==
X-Received: by 2002:a05:6a20:3c8f:b0:ad:97cc:e948 with SMTP id b15-20020a056a203c8f00b000ad97cce948mr40352953pzj.45.1672255239202;
        Wed, 28 Dec 2022 11:20:39 -0800 (PST)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id f4-20020a170902684400b00189f69c1aa0sm11363584pln.270.2022.12.28.11.20.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Dec 2022 11:20:38 -0800 (PST)
Message-ID: <c85bf51e-803f-98f4-8d3f-f85daf28e553@gmail.com>
Date: Wed, 28 Dec 2022 11:20:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH 6.0 0000/1073] 6.0.16-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221228144328.162723588@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/28/2022 6:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.16 release.
> There are 1073 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Dec 2022 14:41:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.16-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
