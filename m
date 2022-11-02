Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E21324F21
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 18:06:02 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id z30so12268985qkz.13
        for <patches@lists.linux.dev>; Wed, 02 Nov 2022 11:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1FawLtOj3OntSQ6QbcXv3/K+wWEttHo6aOUD/Uwg2LI=;
        b=XfWJXgkUlMrJAd2mpR41r38BryqiLS3BYDO779aPv70Flf9UUe6KA6S9lNhTa1pjeL
         X78SMV3BdG6ZQZxuT4OZ9bHEC+b1C+9dOcGo3y5MDGxB7C6wBGGMmW8ppZd5Ome+44Wz
         AJCEX3W8EweLwpt1sksw5jdUczFQhC5bgAHH8y6+Hi2eaFylnCODbJ9261pUzhurBd+I
         +9A9wo+OymhuZ6Cy9ujXN6I8qo0xWKYzCdJjs9mD/qiXC8KYFWgwanfE8z3Q4GwiIhb6
         dYG3e8M+/9vXpPQdJBprNDvFx/JD6rSjZkD2DBBf3HaddxmlUCYGm/+zqjoSh4hPMUps
         d7uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1FawLtOj3OntSQ6QbcXv3/K+wWEttHo6aOUD/Uwg2LI=;
        b=vDhkacW7hKUC8CjSxuDt8bbCydNWNPvGaAsbMjzWL+KNU8TvK9h+zjM5+hu0E3x1q0
         Awt+NJ9SdXEVC1F5sm0Hg5IGwY98UcCbv9Itx1cQUzpOxoxLsLgMCa/3gHF1kH4XPXVS
         pP9FxoykcJv14zOJQ9mvaYhSAQkoGLo8VoGQmzcaq4wztVCi/ulZ1xb8AQeDOyv8VrHZ
         9x+qHu/b/1saXLDNs7kPAHLH3dlaKdnxCNUzAifDHuW1VY1/mfpTNWnuMJDhmTSLIvrB
         We6ocBStiACYQzTRmiUAw6InPauitDT1W5swtN6Gm5N/RfTsvIwmMFeyLzND8soFpYbr
         l2Pw==
X-Gm-Message-State: ACrzQf3Gh969pjzxnYntxN/WRKuElMJudoM5y+N0n+yce3SkAIf4Iabj
	6NvCi9IluRpx8MuRRzVe20w=
X-Google-Smtp-Source: AMsMyM6AMMLW+lcABqDIB+62scV3no2yZto2ebOt91rO0ggQRfxWchR8vF2G0Bke20MUiNmKiysvog==
X-Received: by 2002:a37:312:0:b0:6fa:1585:3fdc with SMTP id 18-20020a370312000000b006fa15853fdcmr17766688qkd.467.1667412361202;
        Wed, 02 Nov 2022 11:06:01 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bm8-20020a05620a198800b006ed138e89f2sm8951793qkb.123.2022.11.02.11.05.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Nov 2022 11:06:00 -0700 (PDT)
Message-ID: <8ab6171c-5336-2f99-cfcc-4e29d42e594a@gmail.com>
Date: Wed, 2 Nov 2022 11:05:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221102022055.039689234@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/1/22 19:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.153-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

