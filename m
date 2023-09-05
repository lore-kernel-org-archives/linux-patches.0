Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA44DDB6
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 21:01:15 +0000 (UTC)
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-76da22c090dso176640585a.2
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 14:01:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693947674; x=1694552474; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=UkbcyPlypG/y4wAG7EhwouSp+fvI1ifnR0lvfN/ArfY=;
        b=rCIRljnBS8J7Y0mp4FWmxszEJz6d6LE9O6sXgm+iQLp/abKjK/zvs9c34gueSPxx1F
         E4M0C2F+6ymVkA1RARtdEOL89N5yJl9tSW6AI3GZESs5aPdcT0BTPYkepHvt/Hh66B6b
         02yk6lRLqk4K7Lc6pnxmvYvPQCHx4z9I0iGwdorH0mWbymIH+vihDK1s6R0wUBAPS0V+
         SoF02hywQs1Ms2erZq8003fvnaInArz2+KRzDJFgH2LgyvdheXqHx39lOA9Ks9zlQBF8
         s9JblVVH0sIcMXS1K8YbUEZkQ1RIFYu9xGxOxwigAFHy5ADhYrB7S+Yldb2bDKyxS/ef
         tWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947674; x=1694552474;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UkbcyPlypG/y4wAG7EhwouSp+fvI1ifnR0lvfN/ArfY=;
        b=jfY+qxL+ykjnbSJkGyYMvc4c1cpya80E/9OpgsycQsXX67SNzxCFAh2li5d5gpPlm9
         M8aJnBsOx8LmJaWwwf+bKOREU3YSZ2fZ/+quFWd8xu5rF4FRaKlMDdpK36zyoUHGhN6y
         ISu2qPaKjaOOKr+VIT7HmyJ/BFBAln7jKK6ESOUfz9jc6bNVFgPJVMB641tpCK7UKMwt
         bnbzxKF2ZygApvHbXWKCPnXeFLiyetn6oyCJ4kjFau93dXCrNeiQcrgj1XT5GMjwCOQ6
         bNk4CKCEKnM6SR/wBR0b8OWaNPYyZy9gD5d0UWCEwMg/We+NW7Mh7ptuVZOIOwPRjFRt
         Q5Vw==
X-Gm-Message-State: AOJu0Yw7rwsfDmdEs4oOTyYLMGoCEplv90qZoJKLEI59W7EKjMHDylNv
	HgQHMAoQprTEH4rHceBU1zo=
X-Google-Smtp-Source: AGHT+IFtGzKMy07ySd6obZfnUISJPd/4918qznY9cK5aT+WdE/lcKDBRZ8lo5G8awRYIr+ztYcb4Gg==
X-Received: by 2002:a05:620a:4004:b0:76f:3e5:8b59 with SMTP id h4-20020a05620a400400b0076f03e58b59mr17268977qko.15.1693947674318;
        Tue, 05 Sep 2023 14:01:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i2-20020a05620a074200b007676f3859fasm4390702qki.30.2023.09.05.14.01.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 14:01:13 -0700 (PDT)
Message-ID: <f32910b1-ac50-d387-81c3-9e1142eb63c1@gmail.com>
Date: Tue, 5 Sep 2023 14:01:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.4 00/32] 6.4.15-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230904182947.899158313@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230904182947.899158313@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/4/2023 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.15 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.4.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

