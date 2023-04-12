Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD2273C02
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 19:39:26 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-329451cab02so163825ab.1
        for <patches@lists.linux.dev>; Wed, 12 Apr 2023 12:39:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fcgOS+OKSCDO8NzRjq8eZKuY5z5xA1+GHktFaJ0VUuo=;
        b=K+THEKrRDwroGrTQQOzJx3ru0btMd/QcNESrSF+0jeNwdifIzNatRJaajfOTJyZs1r
         vDc+AYWrf0o9tP3IlheEUurV5e89oDuzzhce418KxSJaJv40cAkVflI7DN2at1c/gotJ
         DMKEeDBwDFR7zwL6nB6RZET5jHncL+yLxGD3M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681328365;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fcgOS+OKSCDO8NzRjq8eZKuY5z5xA1+GHktFaJ0VUuo=;
        b=isiYbW72Nm3rfLEjvcVSrY06ENiIxKsMPSTSNtteXzLlW0gbUb+WmPOeu3Chl6F5T7
         Qgockfst6a8OdNWEKWIkJ3Doo0WwGqgDS1cZNS5vHW0Rn4no7qR65dCuqNjPmZMTZ3JV
         rNUd5mk17+JpRii/R6hDCyqgogVgT3ozVfeG1BBKXQYtOahbh+gjL7zN9yc3axELlTOW
         HC4aHoi2yUebbgega8Z01cu8gGKP4ztv+c5hmhet3/4Pwwcm7OzOuS5y5BT3775Xtvjf
         YSyT/EGeL/eUCXt9ygWjbWzqdpLS1e9SjRJ/FnB82Da2KhwHQqseFMpQCX10guNaMTAy
         bGhA==
X-Gm-Message-State: AAQBX9e6Nyl8gHc3APvLWCJyXpEQ4MqbejHBi3gZecytfM2mluoU7anG
	GOvKLsKbxeke0W7/pniVYmo5Ig==
X-Google-Smtp-Source: AKy350YbbFMakOATb9v3PBISR7YtOBKNcGKFoPiIsoYlJstGgeU78BZ4LCWB8aagUoy2LY9Pbx6Eog==
X-Received: by 2002:a05:6602:70a:b0:758:6ae8:8e92 with SMTP id f10-20020a056602070a00b007586ae88e92mr1457619iox.1.1681328365635;
        Wed, 12 Apr 2023 12:39:25 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y32-20020a029523000000b0040bd91e4803sm1922883jah.155.2023.04.12.12.39.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Apr 2023 12:39:25 -0700 (PDT)
Message-ID: <276effcd-c83d-92a7-7cac-24fabf7aff35@linuxfoundation.org>
Date: Wed, 12 Apr 2023 13:39:24 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 6.1 000/164] 6.1.24-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230412082836.695875037@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230412082836.695875037@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/12/23 02:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.24 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 Apr 2023 08:28:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.24-rc1.gz
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
