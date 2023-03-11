Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC4EEA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 01:59:51 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id d12so2780696ioe.10
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 17:59:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678499990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TmOK8Uz3KkGO3i5LKLy4ogbNt2yEolBlgdmXQA2p1DI=;
        b=Frg3LCd+nllIj2u9mw5A5CegEgBu3zY6KuOu4SYUCXb+OmWxiHrk2nN78PpQSRFmHB
         tpQ3zB0KCvy/7UM36UAzzVeHTSdchJJRLQ5t9vXHB7bpGWUSQPoheRu7iGeOsjWVPmt8
         k4O55Mn0/C7ebIi0omedT/r6LTHWSY1t56KHo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499990;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TmOK8Uz3KkGO3i5LKLy4ogbNt2yEolBlgdmXQA2p1DI=;
        b=BDzcce1PNr/R+XBc+AHTcXudbcAp/qXftPu3Fp2nGaFaQjk/WSjrzccN/qrhNziWQL
         73O9qPmcx9zn6CxSipObVm+rk1hsn+3fb48i0R68r6+arIaeojBU0l5+WET7glDWNn9x
         VkjRN8SLbzN3CABD68b+motkPh1LkHV3ws/VgDinfKdYzP0/8gRR9oyFiJKOuhw2Hxtg
         w4zOOGPk9aXtaUUCIqPkaxgoIpsLoGxa/FyiDEx3mCrECWT5dLwsAAIWzPw+rA0QU8Q0
         LCYsgy+EV2TRBscVXlgCmE0TYiuY0bzxmzIjmYg3LIbD1P6Mm3i8Vq3zr3dYqweVWTeG
         RdSQ==
X-Gm-Message-State: AO0yUKUHn+APXY/mYMLZ2hu5KVKqHoD0lRJFI8fUocjmRBDXjf/Wcz9F
	gRJHTbatIx0tiNJMvb//gtrGvw==
X-Google-Smtp-Source: AK7set9uqMsOEAiWqWPw3QPsocJFQRv6ctMGqakBIYYpV97+b24VuHfQw0KierQHXjRnN7rGXnwurw==
X-Received: by 2002:a5d:9606:0:b0:74e:8718:a174 with SMTP id w6-20020a5d9606000000b0074e8718a174mr4849943iol.1.1678499990288;
        Fri, 10 Mar 2023 17:59:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k24-20020a02c778000000b003e545419425sm467240jao.84.2023.03.10.17.59.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 17:59:49 -0800 (PST)
Message-ID: <95f636ed-4d08-f323-7dff-92152287dae8@linuxfoundation.org>
Date: Fri, 10 Mar 2023 18:59:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
