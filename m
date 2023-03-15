Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DDC6111
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 19:07:39 +0000 (UTC)
Received: by mail-qt1-f173.google.com with SMTP id t9so1230839qtx.8
        for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:07:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678907258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wZ0/zvOMdFiNo5uPOMOj+D7ZIX4bpE2IJFKlYivIZk0=;
        b=Ct7Q0t12NaUwy+6LgJEcxRSgnz0UJT51Vbym5LRMAXXrj0ByrUwbZPBpGQitY4Lmmr
         noLg/gXxspqX42LQM39zoZh9R/lzLps2cKcu8gK055aQe7vGo3fDC+q1BOdw3xHcTtj/
         d+5kLqqqTpVopV9Alv62scMm3WjUdw9XLG/Sv8M1ZNufyHtvUM+xHi6DDp/g7GibddPg
         ZbJMRl2Jnl6zZKcaKerZdD0TywJjIhWeZod+/M962ycZnB3fhNTdV4CgEHO7FyrZzRHj
         xtH8VHv1ZVLzTpJzksqWhUdy/n3Jz8bPe58qz2TvzaegzG0J83aZ2/fEN7YDpZ3DTdoT
         SsQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678907258;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wZ0/zvOMdFiNo5uPOMOj+D7ZIX4bpE2IJFKlYivIZk0=;
        b=NOPG4ajE3I3NAZ/YImYOd6bC4cjJk0gr1d7MfCSAZpYOj0ZJs5wu/aVn2t0i8mlIqt
         lX3axvfaHWcAcEwSCwrOh0AfbnZpozds0Hqu+obyoozHMcVJfw+8ONTueOdxpdFjzF8F
         +sq/spgNlGZFSovVRboSq8aWwhi9RPY4/LpEf1Z6fLRs6heVWq5n7uMWTdUcT9vO/7Qe
         urf96Hw6+z+dLZJKmxN6mApnIqspLxuayCjVhCJcGe6qK5oyghRmbkaDqM0PaOa6/hC5
         r433VWC/5Sg3ayy4i8hOd3GeAmXUT4G1s3t2PN67byhbCkVaomhlvapS6gRH0b+on+Bj
         X50g==
X-Gm-Message-State: AO0yUKUwyZUnYPBAJ1XEJuP0Ehe+qrCSM5L3XA9JTUND20kgOikEskts
	IZrsYTipRUOrK3MGJjCRniU=
X-Google-Smtp-Source: AK7set8QJkutBm83311/qDFwLT9le+gtecQs+6Z/VnXQHJ6QunJlnDoWxtDKDLfrXOb1ByrbcI4+IQ==
X-Received: by 2002:a05:622a:1:b0:3b9:bf7f:66ff with SMTP id x1-20020a05622a000100b003b9bf7f66ffmr1223839qtw.67.1678907258344;
        Wed, 15 Mar 2023 12:07:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id cp4-20020a05622a420400b003bfb0ea8094sm4103899qtb.83.2023.03.15.12.07.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 12:07:37 -0700 (PDT)
Message-ID: <2ff0d13e-ed75-6b89-1aad-6e45f7a6a00c@gmail.com>
Date: Wed, 15 Mar 2023 12:07:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 00/68] 5.4.237-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230315115726.103942885@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230315115726.103942885@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/15/23 05:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Mar 2023 11:57:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.237-rc1.gz
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

