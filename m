Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E6F29A2
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 12:29:03 +0000 (UTC)
Received: by mail-wr1-f48.google.com with SMTP id j25so970625wrc.4
        for <patches@lists.linux.dev>; Fri, 03 Feb 2023 04:29:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kKvNVgYeUjwA+Oe850kCJHJTjQ1Dw4P3Xp5/glgkYYg=;
        b=TkNCUlYh5Lc5h3lEWH5jatV3Xd/poo096etZ9WvgUKbvJ/ZMI31hWyQg5XCbPsJwOt
         5kyWxKamrNHWp1j+zppHnGe+drEOIUGcsrDk/d19SMQ4E1kbXnglORPqOnbSG2Rf127F
         MJcisFMjY442WcutQAm+pncCwD2I7gGFFvRvB5DNlYz7fOmOeDlYvSk6ZqOsvF8MiMZE
         eWegRx1CAdIl1fsaxHKGMjuXOzPa4/b7fmeWcyfqncOb1CKsP20AzLbAyngex+aT3xpJ
         MM7TBH5wXPZCiCY/yEsgp4vCsgAvss+pmrD6ZkkujJRcM3nUhKE2BSh8xok8mkO6oO1G
         S/YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kKvNVgYeUjwA+Oe850kCJHJTjQ1Dw4P3Xp5/glgkYYg=;
        b=xz40VhQkWoh0FvnfpX3tcFflmaH/FJnqnvhRGl+yqZuh01r6Bcl8oovH9OTnafalaQ
         WC6+uEX8HGNoEz575oQzKocgpjsjf2tYhX+gxdLfIMJdMtvaOf1g20t86mPNZgd+EdNy
         ZtYodcSa2UqbuSxxR8oEORb2x6yEnOFHIvCxa+Bed3b+KZZQysDEyBsqkYIcedIndp3k
         oiXz52DG0JmZD9FXUiktclSYKAaUEv/i0HM2mbVt/q1La8HBh/vFSKNhKYThIDDcDP2c
         z/zBiqgfjwrOzM6AuDw3McxN7WqkJ2E9YVFHguEFV2E9p2Rq46f6BivhfD1N9sVOZyC4
         J52A==
X-Gm-Message-State: AO0yUKWgZFbjl3jKpehJgyK/dWb99x7SgiZ6V6sJv3P0DxgSRqxb+iw+
	oeS4Crb9ykQRfWdm5GeswEsgyQ==
X-Google-Smtp-Source: AK7set9+9g9WK6HPqk/RheNncpsJuRHpA+CPqFTw7poHMlCkFqjVHZ0hPj6uLYmsWb+VEMuCpVYfFw==
X-Received: by 2002:adf:f006:0:b0:2bf:e778:6500 with SMTP id j6-20020adff006000000b002bfe7786500mr10134624wro.64.1675427341839;
        Fri, 03 Feb 2023 04:29:01 -0800 (PST)
Received: from [192.168.1.109] ([178.197.216.144])
        by smtp.gmail.com with ESMTPSA id i14-20020a0560001ace00b002bfb8f829eesm1951766wry.71.2023.02.03.04.28.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 04:29:01 -0800 (PST)
Message-ID: <5ed630fd-8bd7-4b80-9fa8-a3dab2eb0447@linaro.org>
Date: Fri, 3 Feb 2023 13:28:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 4.19 00/80] 4.19.272-rc1 review
Content-Language: en-US
To: Naresh Kamboju <naresh.kamboju@linaro.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Gaosheng Cui <cuigaosheng1@huawei.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de
References: <20230203101015.263854890@linuxfoundation.org>
 <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
From: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <CA+G9fYvd8D3LfxPg2afZXKFC3WNHrhyE7c3fFLViaG4WhJeHVg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/02/2023 12:04, Naresh Kamboju wrote:
> On Fri, 3 Feb 2023 at 15:48, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>>
>> This is the start of the stable review cycle for the 4.19.272 release.
>> There are 80 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.272-rc1.gz
>> or in the git tree and branch at:
>>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Following patch caused build error on arm,
> 
>> Gaosheng Cui <cuigaosheng1@huawei.com>
>>     memory: mvebu-devbus: Fix missing clk_disable_unprepare in mvebu_devbus_probe()
> 
> drivers/memory/mvebu-devbus.c: In function 'mvebu_devbus_probe':
> drivers/memory/mvebu-devbus.c:297:8: error: implicit declaration of
> function 'devm_clk_get_enabled'
> [-Werror=implicit-function-declaration]
>   297 |  clk = devm_clk_get_enabled(&pdev->dev, NULL);
>       |        ^~~~~~~~~~~~~~~~~~~~

Already reported:
https://lore.kernel.org/all/202302020048.ZsmUJDHo-lkp@intel.com/

Best regards,
Krzysztof

