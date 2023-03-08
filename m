Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911D28BF3
	for <patches@lists.linux.dev>; Wed,  8 Mar 2023 19:41:03 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id u5so18710049plq.7
        for <patches@lists.linux.dev>; Wed, 08 Mar 2023 11:41:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678304463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QfzISs/vHmZOX9zS91QPhlLPhKdnC+8JM33FXEkiNg0=;
        b=PwpagZ/XHSlsNjw0GSi48RlFC9z4Pju14ELV9qQnyZYTQc98KhnuoCis1WNMWJS+Ki
         wEiCLLFyPiHZxsA/simJm9Bu8v9Sw9ZVKJlToGCe4UP7JMkKS/C6szwlZPHK/I8aRYqp
         io6vrHHGCRHD4siKliBhgU/cxucJCow+G8LDWqLCICPicJ/SHdwFufGsED0L2ef5NbmX
         LubinGIsJvdMhQCYPFVpnSo2NOuthEYQX9JpLIchqLAKQ19YYcFyWF9w2ZI0Lm5EOvRG
         4Gww/JqSHEr0k3Q1C2gNKYN1sxkcXzoI5cRfLgTa6ERnZcL+XU0S2Pirdv2f9fOb6FkZ
         hoTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678304463;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QfzISs/vHmZOX9zS91QPhlLPhKdnC+8JM33FXEkiNg0=;
        b=EdoSqWmXxMJcKtT8mImbKeX/RfK7pC8HNVk2o+CTk7bK165cW9jhlHEWAkrY2bSiRz
         AHknDkdjIZ9MjV4ymOT6kObB286L60ccEdWha+KX6bMkO9xgh3cIcyh7El1yh/YQW+gl
         hBCO3IvL5VA+Dp8sZ5ZLFrwx8t97pxHuzTUuE24KY0ZaytNwkDCAAXxqY0U2x15UUe/Q
         vm1/EwBIScxwTbtqYgkP/biChOAMdBmc7WKTyWT8bXnVK+iC4YSApU+4vxJaqbYcCjzd
         5zhFvkboae6m7wMXYnDV7scfqLdS+dC5C6+nV5vMI5XWt/LJ0brODvHvhEuhVk67y+g6
         dnQw==
X-Gm-Message-State: AO0yUKWwL6mvh56GozFksLXJxwTt/PNbZjXhTOgBTgLvBVaNuxGT6rp/
	XbjyO0rkkhYy6wgLJY+9AVg=
X-Google-Smtp-Source: AK7set/XYS3T6e44xp6eVz+HRnlyus+f1bAzW0d7/CXlIzR/wADIv29/dP+KrJht1AU8lKnIUAtIVg==
X-Received: by 2002:a05:6a20:3d92:b0:cc:8266:9951 with SMTP id s18-20020a056a203d9200b000cc82669951mr20436349pzi.56.1678304462948;
        Wed, 08 Mar 2023 11:41:02 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id w28-20020a63161c000000b00502ecc282e2sm9422159pgl.5.2023.03.08.11.41.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 11:41:01 -0800 (PST)
Message-ID: <f9d68c20-52ad-a264-0988-c8ff29624f15@gmail.com>
Date: Wed, 8 Mar 2023 11:40:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/887] 6.1.16-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091853.132772149@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091853.132772149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.16 release.
> There are 887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.16-rc2.gz
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

