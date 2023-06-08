Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B80F10EF
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 03:35:25 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-655fce0f354so41040b3a.0
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 20:35:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686195325; x=1688787325;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8xiW69CoMUIjxHIQzyXjlAxYnBQMHQabgtc/B1ukDjI=;
        b=RzXUburYEfhlUWJ2Ms4IzfzP4qqvqjX3RT6PhqNQBzEyP+1bevOAD+Dt3uecywLo0u
         9orIw/sAbMLT+ofSVDOGwBar3Xq1tIxxWa74PkzG+UaL+f3L/t5d14prtIF6ED0f84IO
         rGCA9oEBt3dvR0ln/uuAb3aPhcrE9bcEcXPjCTfl6DagNF0WrX7MSRBygldeotxtN3hU
         yrcBCei8ebdLXe1J8Uwa09Y2sJELkTh8JLk1ImnOulAci02YQ1QAjcbrcDUN+ivlcxlU
         JZzkKIHDLrAxQkPFqEld1ow4j/mL6DqkLwmm6c4On7lVDckAPzjsdhBht/lY2ir4/H1A
         5ahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686195325; x=1688787325;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8xiW69CoMUIjxHIQzyXjlAxYnBQMHQabgtc/B1ukDjI=;
        b=WB/wTrfkK2SuSqIMtjgD+aBCYHozgZjRg0J4nw7O1WTcivvNF6owKPBxK5v8C2OYFk
         1Jht//rznHLUsR8w1LoAilpCo+Uk882wON0OCGifsosL2lyj9r/ZWsDeiyZ5ABoEX0UZ
         G8tPvgBpAKDiNgxsPPkWo9qspWmb4zbWi0tohwFoDgsP43xLX1+/3hFn7okH6mlXbExD
         CHee5Lp2sFu4q7HzwUfGldENFJBSC4FEEKiYZIBqmaEXzTL1ekaNP7Bq1nEz1u47WVhm
         L2rsNuoPGTwsIuKzSJMUbBhz3VHnAZrpjN26Y8E+JkpZ+sgISm8IEYpE7kePMA8g+zDf
         FHpA==
X-Gm-Message-State: AC+VfDzAk0MrP2yur5tS9n6dEj4dEXXJdio1mUbjBYD7TuM/Ql7T0BQy
	tdbMAfb6sPiuQdjFr3sDaTQ=
X-Google-Smtp-Source: ACHHUZ4mTyt2JXsKjlbOs+T0Dfrve/D9stmzk9TWs1QPPGYxbMJIYEWifxp5CT3kmUtimd4LFX0YFA==
X-Received: by 2002:a05:6a20:158d:b0:117:71bf:a58a with SMTP id h13-20020a056a20158d00b0011771bfa58amr3040316pzj.17.1686195325115;
        Wed, 07 Jun 2023 20:35:25 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id d7-20020a170902854700b001b00e0ab7b3sm256431plo.50.2023.06.07.20.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 20:35:24 -0700 (PDT)
Message-ID: <b1f1054a-5b15-ab43-e1f3-fa539b6a0b88@gmail.com>
Date: Wed, 7 Jun 2023 20:35:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.3 000/286] 6.3.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230607200922.978677727@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 13:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tseted on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

