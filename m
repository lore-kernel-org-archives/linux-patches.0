Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFE28F7D
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 18:45:16 +0000 (UTC)
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-41215efeb1aso40648771cf.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:45:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694544316; x=1695149116; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=LwP0PjfGirkQcHRrwmcD1ZMMizzqSK+BkgtwVm0vXbw=;
        b=XBmlfLpz32NPOraVTk3QihlWbMuSGp5uMk6DmgeUHcFybQT94IQ26oou7/Ui0346VQ
         ILff0oAMvfiWgvIlIFGqCODpyHxYYy9q6ex+GZwgle8PFkxjEXBnY6qSEjDuz/XlWp3y
         QUb6xWj0eaPMIkADY8ZOrD2tT3j/vUN6X7ixGrOW+/WQurYBN4PZA/ZHe3ZXN40U94wQ
         rvdw+rSIfuXcjlymB4qU2Hef1cidtOtnyHZg6bwiK+P1KbXhE3fETcta9j6a9tsT4d0M
         acthrnIaUfY2h/1qdoMIuheE8rRmF1H58sOgSebsdfc6ss9j7LbxdJI/N8Wlip7XL5je
         zqUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694544316; x=1695149116;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LwP0PjfGirkQcHRrwmcD1ZMMizzqSK+BkgtwVm0vXbw=;
        b=ZeDANYBYEXvZimfSXZElJUUqQqX/tVO5fj5HoDALxxAEtmV9St1ikpBzG1Ddg7z+TU
         eIyy102pVxF3AWSHkstEVAIK6pXrS/rw7l7QwFobjlDqlvPSXQO4IgjVTVWfSjn+LJKU
         QWua5i1twNpq8qbVBfXIfGhWEyIvOIurTOofc3KaN70VrvMdLiRRXch4+GAyeXLSe1C4
         yKw6J2Z05dogZxyf8XXMVak6gr30Z1B7Utvc+HjHJhwIq17hs89SMRrvU47RM6D424FZ
         7OiR6NnaTtJO9KzVuaG9miU6wJqYcEdNfi3lhheP8pigWyiZfXKC5vwo/UYrp/VYE27n
         gEbg==
X-Gm-Message-State: AOJu0YzZPv4FZD6hQHiqD+9DR3YdcUNlnZhb3UIbrX45AEhVkQJ2b23v
	Xphys7pagL6kYFv2pcji2I0=
X-Google-Smtp-Source: AGHT+IHV4enNEE0L5vfcO799Iy8mcrNrYIFLo33dD07G7QXXpUiQU6T/lmRjwGW82dSfL8bcsHpmzQ==
X-Received: by 2002:ac8:5986:0:b0:416:5f26:b8d6 with SMTP id e6-20020ac85986000000b004165f26b8d6mr148319qte.31.1694544315827;
        Tue, 12 Sep 2023 11:45:15 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o15-20020ac8554f000000b004108ce94882sm3475189qtr.83.2023.09.12.11.45.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Sep 2023 11:45:14 -0700 (PDT)
Message-ID: <f28114e6-e3b6-1d3d-891f-a2a09e127f02@gmail.com>
Date: Tue, 12 Sep 2023 11:45:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org
References: <20230911134650.921299741@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/11/2023 6:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

