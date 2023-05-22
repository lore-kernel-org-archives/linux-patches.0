Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29110171B8
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:45:22 +0000 (UTC)
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-52cb8e5e9f5so2705272a12.0
        for <patches@lists.linux.dev>; Mon, 22 May 2023 12:45:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684784721; x=1687376721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=vCGYl6IZIvRLxU63KxQU2qXn8DNWfF3Co4wSA+QVCTA=;
        b=YdS2IRdufNojXxnoShz3C0cLahSB7BKF89xs4x56Rdiq6ggSZ8cutQ9p6SABxDJ7Ow
         d33kTREQkIy7Uq/DXYZRUsaBKvHtigTIG+4JvG+aJz3k1djAojiE6zfvG7eV52tLgGBx
         C+DXv2Zc2XslrGsIP6jaoiDHTDi+zG6XNfqQ0yw4WZAJRoZDoBcKRfHeqEVeo6mHHmyK
         TviJg36KVmxQZ2U6VeLt/pATIWJfEQUYq1GVg0GUomkL+Y+libdRIIdAHOYstj2om81Q
         oszIYdMN3hnVrnp+Aod0HvZ9FL8yTR2eFj8lZCkkq4KCF1YGd3fzxNlu88lwHf6D9SU6
         tKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684784721; x=1687376721;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vCGYl6IZIvRLxU63KxQU2qXn8DNWfF3Co4wSA+QVCTA=;
        b=Apf/oQzfir0qgx9XWsT/SB2wc7PA1CLajYf5toYUZCAdUyKQ3B9jw8NSBOTp1bkz8W
         WYchYaRiUQehvYZlG+mMd7QD7D3SSmXX9oF84Gqk2+Ut+e/jtUpJoRGXGlrETHaLXad7
         bv6+/rzXoIvLvXtC7dWgyuVHRsbeGrgtA6nu4RY8JQO6/OcLkfVKUW39V25KERx+8L5p
         ZuvyDYZdFByN1fw76dtSvOuZvGIDv8pCPoLQvjEsgg6AbzdbR9/I8JZ6uBqBUcGqDtMh
         bLs14oDngffpOJG3Wt3jfQiP02SNq8H180ltnxkbh5WHkwimw5uLRv75pdQOwywKrh6z
         HvZg==
X-Gm-Message-State: AC+VfDyVqwQTwP8XQaljww7WjNyjVgCeFwCTcPL5CDza50m6Cjb5jNv9
	8J6wiXW5HtG7F9poiIW1PDw=
X-Google-Smtp-Source: ACHHUZ71FKF5etZE2b1weSGm7GtgEE/3SO7HKF/liQMLAoYSUmcuIjrPMFvPAbqFYq93H5bKb0Sbgg==
X-Received: by 2002:a17:90a:b902:b0:24e:201e:dcbd with SMTP id p2-20020a17090ab90200b0024e201edcbdmr12330083pjr.21.1684784721335;
        Mon, 22 May 2023 12:45:21 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id t8-20020a17090a4e4800b0024e33c69ee5sm4434824pjl.5.2023.05.22.12.45.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 May 2023 12:45:20 -0700 (PDT)
Message-ID: <bad6bc72-d87f-4eb1-b2ea-86632a74bf5c@gmail.com>
Date: Mon, 22 May 2023 12:45:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 5.15 000/203] 5.15.113-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230522190354.935300867@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230522190354.935300867@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/22/23 12:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.113 release.
> There are 203 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 May 2023 19:03:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.113-rc1.gz
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

