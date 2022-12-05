Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F3D2F3A
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 23:01:12 +0000 (UTC)
Received: by mail-pg1-f181.google.com with SMTP id q1so11781068pgl.11
        for <patches@lists.linux.dev>; Mon, 05 Dec 2022 15:01:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NRfbi/7mK0992Ud9pUnMAZNOCs3Qjj5lk/O/IQ8DmTg=;
        b=OJFopkK4vdpDj5kA1KrDG8LWycERHKy0KH9cz8AbsCOtyGKt81ko1B/LZJYHhY7mRa
         F2bgA61LK3+SPChVepJmGUPDRr1H9o1IfF8LfbFwuy4ozZi9mb9Aud8YWrepRgvrX+YE
         LZCiZupBHjcNdlPfGhY6qKAPUcttkzeJ7AbKHyAisUhd3VdzW5MxdYo1bGCsF1A6kErx
         5QFKpVjI5JmgJ5po8yeUQNYSrPyLbjw4ecjhzcUpKj/Eha6LY3IH7C1/EYwDVTUPOW9v
         1gBYZfgUuh7RGc2TJgdENDkJ2nA+KEyQALiN510CnO7PCjhwWKkSNq1HY3r7YDZsNclx
         vAJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRfbi/7mK0992Ud9pUnMAZNOCs3Qjj5lk/O/IQ8DmTg=;
        b=EjqpOy4N1kqPNmjGlbSiW0NDM7+EBaeASSTpxTqOCdzy0g0KJqyvRSnslUniQ2fo0w
         jahqzBvop/oNv52/ktnO9MBl8qqkxqNu2263xvscVrt81ai2/0LPA0qM4ps4/PyhQCj9
         YAqKGenzLuSPZk5ny0WoR2bGL9w4zDxRKB2+wpkDvqMmM+4uXFAIY1lSBuHeK8zTfPin
         7b16U96ZdPFCVcuH497f9YVsQuyPpd2fUCReFpEKo+CtnVfAD0ylHD3oXvA/AFdAV2jx
         eUIAyf0BL1iiL34/dYypnJl8LzskEqMyYsFS4IrXJYq6I+CXi5ELMWb0b1PXJt9O1ZZ3
         wxNA==
X-Gm-Message-State: ANoB5pmr4+rWMdaGVWkP91bDMgR2U2MgMpLy0hgiv5NwJ7cfysdCHvs5
	VyamZ0vVrYeBpeTXj4i1XsFcYs1zpx5LEA==
X-Google-Smtp-Source: AA0mqf6an23h6z5qDBR5RyQpqy8s40D5A5vlI1NjTnQaCsuOpdGbRYVMdr4Pwmjnm8LCVVUm4XZMTg==
X-Received: by 2002:a62:820b:0:b0:576:a748:8fa3 with SMTP id w11-20020a62820b000000b00576a7488fa3mr11629502pfd.37.1670281271795;
        Mon, 05 Dec 2022 15:01:11 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q15-20020a170902a3cf00b00188ea79fae0sm11211276plb.48.2022.12.05.15.01.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Dec 2022 15:01:11 -0800 (PST)
Message-ID: <f849932f-0a9e-9a41-1663-d3e8e47ea5d2@gmail.com>
Date: Mon, 5 Dec 2022 15:01:09 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.4 000/153] 5.4.226-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221205190808.733996403@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/22 11:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

