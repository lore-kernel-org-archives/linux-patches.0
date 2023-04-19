Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC89C941
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 18:21:29 +0000 (UTC)
Received: by mail-qv1-f51.google.com with SMTP id oo30so463221qvb.12
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 11:21:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681928488; x=1684520488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9JQ4YYXDHsdgydwwSkAz6HZEvZ1oP7JFBvoxDwJAvLY=;
        b=YKVGS+JSlMdc4XLuJlnixrMr1IveWypUVQwZ/1x19W+QvHciP8XMfIfR44MjzwRrXz
         zgHVkC1yIbmwdH9bugckqffWMIIowwshWYY95KMSlRZNFpIQ48Weri2SlRaFlr3LtyZw
         azJO7NTDtHzAFnK9KzB+U3fVHUQp00R8rK8/eN4FSx5tmNcDXuEGF0jHmiPp5nixo42C
         ANOMAA7IS1KQNZO0ktM2KiSBjEyiZvkAcmdevFqT0cPB2PS5etZZtlPG8lCOiumxLKzl
         G1Z4jTK8unTFlGcV+czLYDsnGXjvtQC1SFNIAWquio7CH5IaIXlKagT89nbUt7Yila9W
         Jrlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681928488; x=1684520488;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9JQ4YYXDHsdgydwwSkAz6HZEvZ1oP7JFBvoxDwJAvLY=;
        b=V+IUdOT3YSeb48mh3osfKQuaTroBMK6BRGbts9wAyq65QHjLPX0Gv7rxRkjVcqdyPo
         VL+fqiTbRyst24XtVi2ON9YP50lnc6CF3nXKoVL94m5yvOFLTULkkHWzedKwqXfmAGEX
         SeE4QaPHKprN6jnxqcfUjrGrCsPgwHnV40ITPIanHR4xEZ+2Ubq0PdrvT7g+PIxF4ID+
         3N47ZctPYi02xBK7/mrbBzda0ZBSk6qrTqpoajDQpTbcFNOgAe8pXedT3jxXsH2/spaU
         Mi/NACtsY08cjyWSRrJ02yzTnzd3gAPXyuDhEFxdydJndBOm8oFLosThE0/nma6LkFnj
         yXCQ==
X-Gm-Message-State: AAQBX9fE6ti53fVijf3udBTR2COBkC9zvnTdqtIiiZxBNIgUE/Swu2j2
	WFmJ4RDDnldorLIEWXr809s=
X-Google-Smtp-Source: AKy350a+dfIVVyli8FYMG1z89l9XMpH9g4QdD4/ZdUFCps1ZR6oAiKCc9JeOXuxK1TT0wvcWhGHZdQ==
X-Received: by 2002:a05:6214:2622:b0:572:6e81:ae89 with SMTP id gv2-20020a056214262200b005726e81ae89mr32408165qvb.40.1681928488047;
        Wed, 19 Apr 2023 11:21:28 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id c11-20020ac8110b000000b003e699f278dasm384193qtj.7.2023.04.19.11.21.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Apr 2023 11:21:27 -0700 (PDT)
Message-ID: <483c9166-5266-91a5-3cfb-bbca3a0a80f7@gmail.com>
Date: Wed, 19 Apr 2023 11:21:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 00/84] 5.15.108-rc4 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230419132034.475843587@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230419132034.475843587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/19/23 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 21 Apr 2023 13:20:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.108-rc4.gz
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

