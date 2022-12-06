Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C6F5693
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 22:28:30 +0000 (UTC)
Received: by mail-qk1-f172.google.com with SMTP id p18so8753492qkg.2
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 14:28:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=nc/HddoCOojBCoQWm1ZfH4dnQ1g2zzDiDNX4pItMA7M=;
        b=loP02QYRyaxjpU+3gPXXCePFeU5mlanOkmQkS84M81spAdi3gkyuj7yWbevTc59AAW
         P4Y5F49ENGVzq0MVf7lHQfNw7YKaV8TOmKU74NUTczGRrUZmr0SgpgecNZg1J4DHfIAv
         RnvNrxqlhCUO9TKY3281HguHqYqfTySeC2xHgUOolXpMeGddwW5auNaXwuP6gnRLS5A1
         KIbzzB9PLR6ARAbRy4asR0jjh/zQaXHPtaefSlm/N7VxiPfi1EFW3KZgcGPXc8QOCY+t
         76F1Rqx7tf/g63H8wyrYmozLW+3QBW37r4JU/p+WnomCkLOL0NdwnnNr2eNcUqeT469i
         vMlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nc/HddoCOojBCoQWm1ZfH4dnQ1g2zzDiDNX4pItMA7M=;
        b=2hYsRdm9KELU2OOfUMxuv/J4Y3zxfTAx0w4ZxZhbZ8Uj6oNGWJtcG3wlkIaszlr0ei
         nYcC0+uYQnQLbgTt0EVcLWnJt6R7CZvXLgVLpV4ud/36FUBXJRk9Qa8itBYXZjCw5Drq
         R6cphIBl/qxPFg0ClFngH9f1deDeyO2tyzroLcDaM6b9GmZKfGUFVok+xAEERyjdHc9g
         fxbtPZtt/E/V9hR8cFa83J84fw9GrZn4tf1Kw/7yPObqfVPPQjF3jfStiZDtzLimi91Z
         iqztTfQ7S0kvUFJLhsOpzT00xjPCv4PmlWn3ufg3aYpbKYtkIY6akfMI1eazIa4SzTxF
         Bwxg==
X-Gm-Message-State: ANoB5pknx+8cClTu10PoMIkOOcnsSDmgc5kEY7SFlZ2CaDl+4WrE0JDV
	msN2puMnhEBhjEC4T7d/Wu8=
X-Google-Smtp-Source: AA0mqf5XaXwQlVWUY9uQYY0na59WH9xLANhllfnkOu2zUb1SYr00pbyIbOXfX67FVNKMpKFgHsYXHQ==
X-Received: by 2002:ae9:d846:0:b0:6ec:5332:6ebd with SMTP id u67-20020ae9d846000000b006ec53326ebdmr79698102qkf.0.1670365709677;
        Tue, 06 Dec 2022 14:28:29 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id g13-20020a05620a40cd00b006fc7c5d456asm12952654qko.136.2022.12.06.14.28.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Dec 2022 14:28:29 -0800 (PST)
Message-ID: <535422d3-732c-868a-b74a-dc7d806a4dde@gmail.com>
Date: Tue, 6 Dec 2022 14:28:26 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221206163445.868107856@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/6/2022 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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

