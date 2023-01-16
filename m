Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 821B18BF0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 23:57:16 +0000 (UTC)
Received: by mail-io1-f42.google.com with SMTP id i70so5004415ioa.12
        for <patches@lists.linux.dev>; Mon, 16 Jan 2023 15:57:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=v0z1gMS+9HIPFVX04fyPNMYdGM/BSmGc5mjByFwg7i0=;
        b=MXJfyBQvzfc54+UEP1wsRqVTY4QGsxrQ63Z7MCjyWylFeNA1Pa3fYeC9WUJ3m2xzs9
         M3hA594jAD2ayP8peodHINiSIOAspjJu4eLIQvQyuIQTU7IXe9tf+UTmPRoDR1lPiDb8
         iATk56rwoRdUbU17sNhQ+VYWSGvAkJUJX1Q7k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v0z1gMS+9HIPFVX04fyPNMYdGM/BSmGc5mjByFwg7i0=;
        b=TaQVl1ypo5P8a7sgcf3S0H+9I26/UVn6DS+KFJZIE74dxukl+trFFh2WkeSwN41fmu
         qvhVRbsvVmYj2JqC3g2cNfWOhG3+z3k30Dn/UCclmFd2j9aawRbBzjnYKSLFViu+hnM+
         be7rdBM7M9oAp3dPTDuOo7YcyjvcRgduSOQeIWGS2ydXcvhaS1AA3Kd1tm0zeL/0u+Ac
         1ewLIeGIUCiRE5XZ5eVZTha5fvAFYuirk3OOlVi+Be/IllaMzkUEESRafnveK+6TWZT1
         WtFrzubm+aasNgqSSm7RG44GJG7+DUn8aetOtQMNiqZvyDHPcTA6/ANDtD0e76iJOqWl
         Uz0A==
X-Gm-Message-State: AFqh2kodqMRF9/QiO9RSM4VLTYaMpo4NMGhjYX5lT2yHM5PVnAqhfNtp
	D2FnHfg2vFkTBePWS5GtX2edkg==
X-Google-Smtp-Source: AMrXdXsjU0a1tX7qEMEUNAqff5oTL17K5yyhmGG4LaKEQHNRJHN3N3WNSCLFPuDSKB+dfDPcUNLA6A==
X-Received: by 2002:a6b:b70f:0:b0:6db:3123:261 with SMTP id h15-20020a6bb70f000000b006db31230261mr144145iof.2.1673913435528;
        Mon, 16 Jan 2023 15:57:15 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id k66-20020a6bba45000000b006e2f42a30c2sm2685817iof.35.2023.01.16.15.57.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 Jan 2023 15:57:14 -0800 (PST)
Message-ID: <88c77a57-c96d-ed03-9a5f-ee73ea1071dc@linuxfoundation.org>
Date: Mon, 16 Jan 2023 16:57:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230116154747.036911298@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/16/23 08:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
