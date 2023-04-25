Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C888A93E
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 21:31:48 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-51452556acdso4694667a12.2
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 14:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682458308; x=1685050308;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=U0vA8QVHgUjZYF8qTpB5oq5FSKH9ueIB5qfKOzgv5Xc=;
        b=hPY2LO37GIbtiYPRXa/2siJxIqWLgMyESBN62oAnpjqtLNRYrJhLccrxSIq1UNWjN0
         zD4ViPkefQJtFDxeQuErNIr0xHM6xsgH8jua+VhE6+4mxXH0YJr+kFfqVw8qfA0mi58n
         RVBrR+enrU82OADVik+hyEX2F+slS8ol1A294IGsQSdgsuCd/yjcTwPoX/3k3jnRyM+Z
         gN28H0vr2PTC0F5y1SjH3mT93IkRlkJ8eJVcEcaPyP/EMLWysqxUGv0fyBbqUyMcRvGg
         0UhMM2zdRhHPfSDyHkE+mT6Ma2N2c7+FREBxo2OsxuXZn8UFnw5X5wl8IFH13nX7qUmn
         y9TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682458308; x=1685050308;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=U0vA8QVHgUjZYF8qTpB5oq5FSKH9ueIB5qfKOzgv5Xc=;
        b=dpCDQwI9tt/phK4BaRY2rRIjKTCBJS3PX9iY0oMwPsm5S02Y5ZLFmE0arZYSyKQVNF
         u5VTpaC7b84CzyY88Vb6EsXY4zeJ+cyT1xiL1iuyQEVk9uz1bMe9K8un230z75jIbJOf
         qvveBiWJ/bqT5K2XhNwEG14hg8GRqlo9GFNsC5WKHsFmZxpfY63133E8wth3FyKw85I2
         kdElnmiH3Pod8J15UvqH3tPhFPB8kfAsggVga4AZPlpzTlhTGpAgtQBBZ7ZsoV5XX0UN
         3J0OSXs0WHllibNjkOv8AlWNIcYBGlMGVmopzrobC1OO6zpsziLQVLBXtOnGP5OtPnkQ
         t6KA==
X-Gm-Message-State: AAQBX9cN5RD/ygRX/osjFOfIbk+/88O6TcHFf0/JYQBMh5IHVMJmvd68
	OOO7J+9HTVm/2Lh+V/RzOQo=
X-Google-Smtp-Source: AKy350bF25AEWPOXQ+bACbox4eVWJ40M5EawJIvGlxlrMteGmyzBOuqlmqCY+G4YxLtvcRS0w0WdQg==
X-Received: by 2002:a17:90a:9747:b0:23f:b369:c159 with SMTP id i7-20020a17090a974700b0023fb369c159mr16787769pjw.49.1682458307691;
        Tue, 25 Apr 2023 14:31:47 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y18-20020a17090aa41200b00244991b3f7asm12704831pjp.1.2023.04.25.14.31.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 14:31:46 -0700 (PDT)
Message-ID: <2d1346ca-a82e-d297-92a8-1fa0e5ff786c@gmail.com>
Date: Tue, 25 Apr 2023 14:31:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131133.829259077@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/24/2023 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.26-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

