Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65167EC4
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QuXv1nW0"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-35d626e4f79so3936315ab.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 17:42:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701826926; x=1702431726; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0fl6uSMPG668/bjfJHguE8uLZnjAsB2+IPr+krcKfck=;
        b=QuXv1nW0MIY6xF80qhvs2rNNfvybyJdkuw1X5NuZ5KK9klh7MTxM3nvJikohRWvuV2
         qUx3skH4cDMSwLG69kHd2ml3Vb22WenXnR17zQeBReekxi8seHehcssDGW64m5KaYZ6E
         M9Rt905tWeMIfaqbzM6o6Vmx3dLZthnmX2GF4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826926; x=1702431726;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0fl6uSMPG668/bjfJHguE8uLZnjAsB2+IPr+krcKfck=;
        b=eb1ZxrPOwqq1PmQV+0KwLDvpLBdrkphPOzqf0JERGZDlX3yyvNUn1cl+cybuXSoM//
         EZntl7bURADAzpv+ULqjUxKubDuJE6AYqwvW7uGCe1LjvkJ9No3uX6atMg0WSjlbgp5J
         1+p+kfyHxt185fj13Z0xpUh2cG/vODHjRTviPkNmr6/x2kxxgrcVpZcS3GT/wWDCkWuz
         OiNcDs5QKPvji0CcwMHS5f/lp+IRamkw62o84rPdkR6EGFXxnPrh/KdsxoYud5oMJe6s
         BtMbDH1q/eVU2j6/jadTSLZax2UPJzK4CZZOZY+vhiHVSJm6AHmqOZPu8gJtyjKLURz+
         8m/w==
X-Gm-Message-State: AOJu0YyBmUrh7nnWwEt5J9IJzHqh7b5lcyLY+48X71u80ZufUNtTtNwa
	ijyAjc/wTmDaYJb1p0FF05kWvg==
X-Google-Smtp-Source: AGHT+IF7hRY676SlJdoe9e8zBAvOI5d9KgVkzLLXriIYVg++bbCrtMIl8ujxLr4pqmY+X8IPNmWltQ==
X-Received: by 2002:a5e:c30a:0:b0:7b3:58c4:b894 with SMTP id a10-20020a5ec30a000000b007b358c4b894mr581932iok.1.1701826926536;
        Tue, 05 Dec 2023 17:42:06 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id o2-20020a02cc22000000b004665ad49d39sm3423615jap.74.2023.12.05.17.42.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:42:06 -0800 (PST)
Message-ID: <45e7a76d-6003-4840-8d0a-b20adfa42a36@linuxfoundation.org>
Date: Tue, 5 Dec 2023 18:42:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/107] 6.1.66-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205031531.426872356@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205031531.426872356@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.66 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
