Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 079C724F21
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 17:50:38 +0000 (UTC)
Received: by mail-qt1-f171.google.com with SMTP id cg5so3051286qtb.12
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CRZEan3NfgrT4VK7068yRQxbI/GUnjcqKXl3lAB0/ok=;
        b=mlGALt0BHtpUKDMrYFh2gtKO+blRh5meqUilXOBvg8laYEGDab4y87YHGZO5JD8MpJ
         SjHmn8gJ26KYJ2Ri9NtYaTwag3QkYZ2ZfymLTUApepX2dTMoQK2ALlOGYg1jsTe0aQjf
         GIQv4wPH+HCAOVmoNPfHEh9GVoLC7Wei1fH0wEumyfU+30osWUXCFQ3lvyczkABsgxpp
         6JsPg36Pm9CLp0Bskv9qeHQ6JsS1g3jblsc6kTE7ctujhRfE0dENIyMCjuwS0jAf2aOE
         A5WFDEilUzRGSJGNq02E4JsRKvRWt5tKwJ9XZGl/ZvpHGc0SEfo3GI35NZbjFvONNg3V
         gGoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CRZEan3NfgrT4VK7068yRQxbI/GUnjcqKXl3lAB0/ok=;
        b=ntuPIDzuWGHBr92EAojbE1GTEXLmh+VAHTgtXgbMTJnaMSjPrTZ8W4+AKWz8TGpgeM
         DiFN5cUDkvn+iOsGBuwMf+6vGVpN7QZkY3rYTrfNuc8rbREUAoKnLOf293CiGKNpN1HR
         JuLe8MSWDwyipjzz8OViXvA9/z7u2UfHqS87TX0NEaDDcB5iY35OeKotkYPA2CfcEMz/
         sICjSfbX8wCFCEGJscf9ptncwPM471WISyKlxn2l4AfAAIYzE+YZweownPUcjue3qNXv
         1ZK+OrB2e6Uf03XlTXlSumHc0fdAmUSJZDVDwDFZx0dMYBWIo4fjDb0y4qoprbDymXjz
         AKGg==
X-Gm-Message-State: ACrzQf3D0sGcgN9c95Th8RQF1TCTfrOfXLEuGfkTAINlXfGf9ZsmLucN
	1xYWhUWbR/G1KporZfMPnqA=
X-Google-Smtp-Source: AMsMyM6XEL91aH2CWjdS98WCCWDzMHmTULvcNfPORFbx5ZuPrvgFRDsfOlPMYIPzEHTQW5jf2npRKg==
X-Received: by 2002:a05:622a:1793:b0:39c:f3cd:e725 with SMTP id s19-20020a05622a179300b0039cf3cde725mr21314518qtk.333.1667411437861;
        Wed, 02 Nov 2022 10:50:37 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id l1-20020a05620a28c100b006bbc09af9f5sm9011239qkp.101.2022.11.02.10.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 10:50:37 -0700 (PDT)
Message-ID: <b5eeb462-f5c9-37a7-f2f3-f90a7c89a632@gmail.com>
Date: Wed, 2 Nov 2022 10:50:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.4 00/64] 5.4.223-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022051.821538553@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022051.821538553@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/22 19:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.223 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.223-rc1.gz
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

