Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 332721AA66
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 17:00:32 +0000 (UTC)
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-686bc261111so46402b3a.3
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 10:00:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1690390831; x=1690995631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GRXFgTXwEMCksEqkmAG7j7rHI7ptzJ+wrSewIU7zYRk=;
        b=hVlx7E50I8QXnsT9P97cs1HAMPqrmoO1gfTpfHiwzixeU95QEBPAQR9waHDHdb/JuP
         Js2fzSxRvnWHK40CsqGrB5PXJMB/3SyNlAz7Opetpus1Yb6C2TZCfy8uSjhZGjqj1TeB
         LiH7WQti+8nlCnXTZL6yNBuOG9M9fVUzgxAYA+tvjA8aKGb4RMcPC/EldhW+kTX8phtc
         0V3JhDsRuCYZEFtCqTLMn+boDze2tqxr//rcD76Efn70YbyVFjHoxQDLlnqm1vLz68ke
         C2iPktyGdQouYoUOE42JfHOHnfnF4egggOmydQ7arfGts+6W3ZOLcsbedqEm2uzHHYM3
         gvWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690390831; x=1690995631;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GRXFgTXwEMCksEqkmAG7j7rHI7ptzJ+wrSewIU7zYRk=;
        b=kzP+puEpdvVtvOjw4hobklPuU6CC3HG8F0I/kUYXZu4TKnWsWmDmgCwlMMf5SYLviG
         xH51TEtk9rYv6jJBNIAoGPC0ZZcrQgwj2xNzNhSc687EuItDVtCc6cQ/WUd/0VtNivbe
         0rJOHggjWcFo4SjrJXBD7ma4j96hPZlHxqFzm/1EeO9cdvlmruIwWjh2eDUjjLV7yeM+
         bQWpm/My29zQnxHO5CfLXpE7jLY1blN4R3tBTq9CfPn8YFfwQ1oohKq96xzWM2JT9X9P
         01egYVGDBgJ0IH5pFAj12UBxB0z+gfj+agzax+9G+OwczT56a+ybWBgQubWe/BSa3YHN
         34pA==
X-Gm-Message-State: ABy/qLb6sL4EANt2Vn8AYXjCjQ3F1TLlYBT4DaFAf1zpe84Co+X3mU7E
	eC2zZoFx7SPexoryfsrK8Bl1EXL3CIzoZA==
X-Google-Smtp-Source: APBJJlHlmQt5qUdMqMWWQeb/Dn/+EsZmfh/FeLlUckZByDjyiPEVj4bCMi6MqUU2oiFNaRjmA0UfHg==
X-Received: by 2002:a17:90a:74cd:b0:263:9e9b:5586 with SMTP id p13-20020a17090a74cd00b002639e9b5586mr2123026pjl.44.1690390831295;
        Wed, 26 Jul 2023 10:00:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id b20-20020a17090aa59400b00268160c6bb8sm1478834pjq.31.2023.07.26.10.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Jul 2023 10:00:30 -0700 (PDT)
Message-ID: <4b2bdca4-278e-c6b2-0cba-31b5baed472a@gmail.com>
Date: Wed, 26 Jul 2023 10:00:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.4 000/310] 5.4.251-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230726045247.338066179@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230726045247.338066179@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/23 21:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.251 release.
> There are 310 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 28 Jul 2023 04:51:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.251-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

