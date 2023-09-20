Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC0033CCE7
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 19:29:55 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-1c59c40b840so1189555ad.3
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1695238195; x=1695842995; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sUlxpDvphMvioljxEZkNm9H9LA+4RY/SFbC6XXedRTw=;
        b=LxeWOkqgz70w837eR++XRDwGi4VBZn48/J5O3md6aNYDZdIjESKoePY5H2UYeKl8gZ
         vw7juKWmHUidGswMI89ckubgPHcHORqB8B2I1z/oGo4gydm6SavrTqcyqMExqmY+FNDq
         JmKaZHKYeW8qOEVa5NIDylbTUmFCe1azsZQRB8OVfhiNAwSBy0I3o8th9My7l7DPgHNT
         ZzfgcTQYU6FnRe1eVr2F94kHQKcxPI9RkKhnKwmfDbXKwzscOmqaYySZpdMa5aM1n5Z+
         VILCNRYNZpkV4mPFmaKNCMz5b/WS6dIlwlJ1AQ4JJRk3MdWFmT+fPPwY6isQ2r0VOcdY
         y0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695238195; x=1695842995;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sUlxpDvphMvioljxEZkNm9H9LA+4RY/SFbC6XXedRTw=;
        b=SCSb2pLdNJ7xYcloKhDSBnOjh6fjF5PyRBG3T5yXKiBKi+rKBwQkGZkZnbU7jrHqmp
         4Gg9WpGo378G0xw1scb3SOJs5tDcs0B/P4b3uBArkDqVIN+zfJQ2Bn5njKRfg42N1/aE
         6vDYI/GWm3ETFdUvUFqp0MatbtGnCnCPN3BQMgrU2OWEiB7DbuHT6EmPKfWWaJbJUyli
         zhHhjQ6RD+IWQbw5VwqTWy4xBxRFDHah1G+JKLh8GhgfGYIkZCmRAEkw+fZryrLKUfQm
         qGhZW3Wsq+e5zxZL8KvP8z89Od5ZJ9VYcMwxjrHRlMAGokbwv1e58HhsWRLxmHSuLY8t
         GihQ==
X-Gm-Message-State: AOJu0YyIZSqqPT4PwaKGS9MZPUco+5u870Yv8hSEC+4NMvwh+QYF2NE3
	gCOacmYR4ilCsGQSrOZ8yag=
X-Google-Smtp-Source: AGHT+IFzCe9v4enWMqD8aJlN8WVdwg5w2F6MgrYVy9VIPVO0fjAfqUhk7kgjFnoWDx4oCn1gTQTlmA==
X-Received: by 2002:a17:903:120b:b0:1c3:1167:26e4 with SMTP id l11-20020a170903120b00b001c3116726e4mr3725633plh.60.1695238194996;
        Wed, 20 Sep 2023 12:29:54 -0700 (PDT)
Received: from [10.67.49.139] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id iw13-20020a170903044d00b001c582de968dsm4964589plb.72.2023.09.20.12.29.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 12:29:54 -0700 (PDT)
Message-ID: <d48fb8da-c170-0c79-9ffe-152bc07ce819@gmail.com>
Date: Wed, 20 Sep 2023 12:29:52 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230920112835.549467415@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 04:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

