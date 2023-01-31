Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E6DA92D
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 18:39:17 +0000 (UTC)
Received: by mail-qv1-f43.google.com with SMTP id jf11so7986211qvb.4
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 10:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a5bhN7BpeXO0zsBNEiLmOP22urYR7JBKuNRMAigGlSA=;
        b=miQawrxs53UWUQMUfq15K7NHSEODdHqDcf8flxyoAGy/CZVxHJISwixIQuNoop9dpm
         N3T6QeLh57+G4evVS4MmMhuzNauCgXRQzHAmf94fGS6d8Bw8OgzrDrk7xKIh0SjFkY/F
         qJxEtJqP/nGAZkzPQlPvtSdEJxcT91jdWl2GIqzwfGk5RAc8fO6Nm5G58MgpndnEb4X/
         LL+gaquzwUkQJ+gYCVv219UG5lWj2OBXn8e0QKJlGhJux+7qAly1jDMU2MjGO2oKc6HR
         lt2nF3xRRqqEUllbIKCBRkyBLwQOXvawXgRLD9GsdwTToM7yyL/Ax2QX9HTM+l3XvMZC
         otNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a5bhN7BpeXO0zsBNEiLmOP22urYR7JBKuNRMAigGlSA=;
        b=N63qUiBlL6aw31X29hDXsvEvSmSLNBWRdXaK+TKFjvWHPT4zXcn1kCQglSCGphw/NW
         qP3cLL1nCLBnlnfFYzmV+eoK+3Ui4XNO+j/QUHZHi4GntwiDSR1vgIU7/qkQxq1tJ5xe
         y9Y6oOw8ao4obnOsddRWPCLGbJje8lnzi33Gqop5BEEpeIoWzCXWn95qIb115pbslldi
         hvN/wGAXLE0md+Oer9hN5I7/tPgNn8tOIG8GiDxFprmie8wjKaB7XKh0Ibisxf9R813J
         VpizzhP5A0GuarsNEseAf4Lsim5js9XKQcQ2Z5zaqwfTbrk0Hq+Jt6oz3BffxMfE4Sgx
         XAzw==
X-Gm-Message-State: AO0yUKWujc4Umcd83YVq++EGbLOEgeH7HQTsXeWBDtgq5AAn8MIcNIKw
	tDBeudRb/vjW0FX5mCBMUHY=
X-Google-Smtp-Source: AK7set8+nzDfobB9Iksxv/h4Z0qTOMJ8cAQMIQERiTHT3zqH2UcMfA5WKy/qJbERMeZDir58IxIcrw==
X-Received: by 2002:a05:6214:1712:b0:537:ab77:fbd9 with SMTP id db18-20020a056214171200b00537ab77fbd9mr25289308qvb.28.1675190356955;
        Tue, 31 Jan 2023 10:39:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x1-20020ae9f801000000b006fa7b5ea2d1sm10433563qkh.125.2023.01.31.10.39.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Jan 2023 10:39:14 -0800 (PST)
Message-ID: <9d50f623-e088-a234-0c69-4e84f1bab625@gmail.com>
Date: Tue, 31 Jan 2023 10:39:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230131072621.746783417@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/23 23:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

