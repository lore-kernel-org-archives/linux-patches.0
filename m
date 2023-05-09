Received: from mail-qk1-f169.google.com (mail-qk1-f169.google.com [209.85.222.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A622A1800B
	for <patches@lists.linux.dev>; Tue,  9 May 2023 16:49:39 +0000 (UTC)
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-757741ca000so299986385a.2
        for <patches@lists.linux.dev>; Tue, 09 May 2023 09:49:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683650978; x=1686242978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+v/X+OxvTsGwJMDiA5a3JO4hrqmYlFbvSipw3tCkW7k=;
        b=mi18ne7/zmw24M0PE5a/jix7FCxVRAPj2OWezMOLK435O6KTl91ufM7ecY/3An5FlG
         3eDIxoiYdu6nOfrJG1xvexSDGBBA8iftptyC0At0dA4g4TSRiM+tkA3sJL8/LCj+5u2H
         Bvl8EJoSWHQqjhd+Qtaly9hiW0mzpXzSC+Ff/OGOg6C6OOPVed4LlRAo/4/qB/c9FXM3
         qAAJNsx/YYbRNnn7PHjDliADKFOFEmo3AV9DioKrvGDQHhEqFe3NYV0/YaryXGzVXliQ
         7RKZFyJhAY3QPNhuyesiQtVX9bbyj1FqAqLttQffgFNCN5QhF4Ip9Qbx0BWt/7pTO0US
         besA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683650978; x=1686242978;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+v/X+OxvTsGwJMDiA5a3JO4hrqmYlFbvSipw3tCkW7k=;
        b=igWpbH87Yei5RXk/nC3HZFCRa+Nu7mCEkXASaoGcssiE3NHk92NWRReeWWfcc0bWw4
         S0/02+jy5GXtbAht0SyM0xuEcP4zkwORNsfeAHNT0vUmLEgJnW9d7kybtXHRn/Q0rhhL
         16+tkA28MLvzONdCbf7pHq785m478VUCM0CxG4LoNhp5Xfg97HeHFKjxLdgTj9rTz4xV
         KGY6jiAsHkH6T11LRIGzrp5U6x1CSbXxVrYnVqfswhOSYHIwVCyV6GRwmRrAPk/72rrq
         j6zPpcoNAP5yuj43CsbcTrmVUQ9lQWZxZ7Ckirv5jtKsafeKeiiD8KjyuTPB3qJbTaNE
         9dHA==
X-Gm-Message-State: AC+VfDzRQazuDdJXtpsKu/pXoojcJwo7jHBxpdkbKFJWkNRZ97U2YY67
	Q04VuUB7n2uyej3PDM+Rj00=
X-Google-Smtp-Source: ACHHUZ4KMC8JbEB3svxiOe6ARE2a/tn5H49VSw4ZqmLxsz8hib28t5obbwshSIBb3QlXSqLgXxD0Vg==
X-Received: by 2002:a05:6214:1243:b0:5c5:1a25:edf0 with SMTP id r3-20020a056214124300b005c51a25edf0mr21819667qvv.26.1683650978520;
        Tue, 09 May 2023 09:49:38 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u2-20020a0cdd02000000b005ef6128255bsm875900qvk.92.2023.05.09.09.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 May 2023 09:49:37 -0700 (PDT)
Message-ID: <1f7ec6f8-dc61-9ea0-a7c6-1a51d69d0610@gmail.com>
Date: Tue, 9 May 2023 09:49:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 5.15 000/370] 5.15.111-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230509030611.521807993@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230509030611.521807993@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/8/23 20:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 370 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 May 2023 03:05:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.111-rc2.gz
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

