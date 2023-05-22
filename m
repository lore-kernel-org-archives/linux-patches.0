Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 501BC174EB
	for <patches@lists.linux.dev>; Mon, 22 May 2023 21:48:18 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1ae5dc9eac4so41608835ad.1
        for <patches@lists.linux.dev>; Mon, 22 May 2023 14:48:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684792098; x=1687384098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xYFQfj7RH7xLCxdAm/GI182OJFS6kQaDL6l/UoivNeE=;
        b=Qp59Jo9HZfYsWyecShsx9f3oPfYSagf01XQTuN9w92J2JENJZf+Hg/N/UtiyfWioe+
         5TXqpkr9jUOtuYUBqMVV4+QH9mPv76mlpv+N+V3VwSWdi21Q6qub0XqC3i/TISeKungJ
         TQu5BNMs7p4tJWI+JGUA6KlGFV7ehhni1Io83UmU9BOsAAp8TRZrHgTioKoM7D+jphz0
         jDSroTqBCqoTTwgoVYNhEmoTUxySgyr1ggTo7SsfC8ro6Ia20AfZFxz92hfGe+aBDMzt
         YFY7bbdQ/8U7QirjSndhDaRs1JPa1ZBQBMP56646kjl534sZkawQiz3ut0v2jOAtSuZp
         lWvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684792098; x=1687384098;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xYFQfj7RH7xLCxdAm/GI182OJFS6kQaDL6l/UoivNeE=;
        b=GOSYtVdbRCQ3J4LnWP6O0MxK6qjzfLuvvXfI7qLjVv7drMVelhapIUdwOaeo81I7Ax
         PEfymJnAQ/10LMFjaRT/IoDpXM7UnM+x3RN00A42WKDGN0XshLYAQycXjtvJFIVTnAy8
         r6cStutxBiuV0ebf2zKeA1vVGwAI2F6djQBLB88H428OnJlW1v/mWDR68XMt+Cx6i4AC
         lW6Kw0K+Ps121XY41PSB9QNyjRE/bTeoj6BddK+k8vFVm0HVp75tUFpe0ghnVZKWOU+w
         thwLZYsf7VOV3lWnOA1Hi2e/h3N2SNZpf5oFucuzk3u7V9q2AAct5z7WbWfH0xLYFtHP
         Znag==
X-Gm-Message-State: AC+VfDywaycVxVQ7P1rJo+yzKFlPeqypyapOVhBIqrNSH9xefY5yPQ2R
	fp3lIzloEEnHuXMrmOT05nM=
X-Google-Smtp-Source: ACHHUZ4fT2O0Az+BgY0tofcct7VKUS0Zknla0EAujh6QSeRqhoYLuq1nUjTbtqPRcMEqzM24QqS/iw==
X-Received: by 2002:a17:902:a3cf:b0:1ab:675:3e31 with SMTP id q15-20020a170902a3cf00b001ab06753e31mr11317763plb.37.1684792097612;
        Mon, 22 May 2023 14:48:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k12-20020a170902694c00b001aaeaa27dd5sm2992336plt.252.2023.05.22.14.48.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 14:48:17 -0700 (PDT)
Message-ID: <b7494efa-304b-9de9-c8dd-2053106a9f02@gmail.com>
Date: Mon, 22 May 2023 14:48:14 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/364] 6.3.4-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230522190412.801391872@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/23 12:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.4 release.
> There are 364 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Same comment as with 6.1, we would need:

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=3522340199cc060b70f0094e3039bdb43c3f6ee1

to be backported to avoid:

[    0.001697] Early cacheinfo failed, ret = -22
-- 
Florian

