Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E50C107A8
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 18:14:11 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-34ca6863743so1448715ab.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 11:14:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692987251; x=1693592051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SVSLXoOsTyXLEzOs0W0ib6N5y3HnYxkPVrVURCOBEa4=;
        b=bni3FFGTOCdK46/5M1KV8akVuCXT5d1r2apSO1ruvxPqDZmROr/xbr5QjZoHkc1uHy
         51UZTppzHiwNIrqHz+DZ5XgpHtAQkLRyaMKBF63vINuko2PO0V9zGHQR+NtpZfkNqNc+
         +LfWtzMhw7NX94Aa1448tqgoqOwEBEDlqDvks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692987251; x=1693592051;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SVSLXoOsTyXLEzOs0W0ib6N5y3HnYxkPVrVURCOBEa4=;
        b=Xmi6P32B4sYtWrFiH6TpXgysxxzKV64JzeJykf5rUZQ9Q1mKtklLQEFhKUcFGCjoBd
         yAYrRvyWyQQ2EHx5Vchd193wAFvFu/gg3OfUbHI4k02vDiOGBUjVKVXFl7i52fw5Iezy
         fg0dARuDGFalesKhYUxmiPk3rLe/KfFsit0Gc45Aaz83zQCt3nqzsfka0AKmMwZtGQBn
         bw/OYWoWBJAYb5zij73cDI+LbAZoSCQOt9jvk2i1s/dC4s5x1Xe5x81HmkjkS4fESNoh
         mUjjQkHghI9c5Z/jhSLoo2+SDgLcPcM19eABVEaYpXiH0J/F7AgsNfhcMNWkyzQeSs0G
         XFXg==
X-Gm-Message-State: AOJu0YxgyaK05aFthJD1Bo8IfNm4ra2nGkmqSiKVMrpAvyArFJ4ZQSwt
	lNh9DgWELyK/Psn9M2pWsyAvbA==
X-Google-Smtp-Source: AGHT+IHOQc+c880Pbgay0O2LYgUvi7dGUVWvXC5nqN1f/cy1gl+uGyz89zEAp1c6M4SdCtDr9PtznA==
X-Received: by 2002:a6b:c9cf:0:b0:792:5f79:ef9b with SMTP id z198-20020a6bc9cf000000b007925f79ef9bmr8010494iof.1.1692987251054;
        Fri, 25 Aug 2023 11:14:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o22-20020a056602225600b007916ad69ba6sm637746ioo.25.2023.08.25.11.14.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Aug 2023 11:14:10 -0700 (PDT)
Message-ID: <b790b050-accd-442d-3585-e872834c7b66@linuxfoundation.org>
Date: Fri, 25 Aug 2023 12:14:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.15 000/139] 5.15.128-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230824145023.559380953@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230824145023.559380953@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/24/23 08:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.128 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 26 Aug 2023 14:49:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.128-rc1.gz
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


