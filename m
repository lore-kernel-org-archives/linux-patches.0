Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B038E20FA
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:42:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BjoqM/sE"
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-35d559a71d8so5110005ab.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 17:42:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701826979; x=1702431779; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nm1V9f+oUMjohhZksyZB+sIfcQOdDZTpiTzY7f5JIGA=;
        b=BjoqM/sE0sxfDINsjsIiDExY5swaxYonjinw4sVD9irGsN0DAV3FR0Hpi0894uIS7X
         a7tymOn/a7mfc49c8wIl7zwOD7ZdlJQz5zYCZkKXN/TTML5Veui5Fbgp28sTvoCmgRja
         UDYcNX7RS+Sb3TLw87qzxqwK7Cfq8t9T9W7j0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826979; x=1702431779;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nm1V9f+oUMjohhZksyZB+sIfcQOdDZTpiTzY7f5JIGA=;
        b=M6M+Ay3M6H3x85/YdWDBfSgFOPviLHB5R9+QKTc0DNAiFz6WaOJ3Rkvsa3j3W2f0xC
         4101h9m0Zn3bv3LuEAOZ29mO3QJtwWnI1avkLh8xQCJ/mP8fr/LHzKEy2OWKBPZw1qOS
         yq9EWDWqMOhyUVoCnXFkFlTbbxWdxDqkAXAJ3vKlzdAPMRHLKqKU7zJUiblDdIVORYgz
         IkdICreyc0tsjoyZjQ2zwsQ8+9Nd88tE+0EuIE2PWo+8XeAkyDnsg6cqTwSFNLwH/XXW
         x5xbm9jxgWG1KYhEvZVBlhC1wKNIzl2bn/zgjMaGbfnyDoXeKAB2xbc+vOCddl4rvDni
         yUiA==
X-Gm-Message-State: AOJu0Yziy3LG+dkeKY2CimDZFok3gqO01sxgb1rp24yH5OSWXzfazGnn
	Up0lmx6reOtLG0vzac5NgaIIBQ==
X-Google-Smtp-Source: AGHT+IEZV9QsCtUCG41Rwf5DS0/ayUasKhUxGXYpxOJu29ansePzFwZheB2UEsbVjklK6ZmE7lxGcQ==
X-Received: by 2002:a5e:c30a:0:b0:7b3:58c4:b894 with SMTP id a10-20020a5ec30a000000b007b358c4b894mr583643iok.1.1701826978793;
        Tue, 05 Dec 2023 17:42:58 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id o2-20020a02cc22000000b004665ad49d39sm3423615jap.74.2023.12.05.17.42.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:42:58 -0800 (PST)
Message-ID: <321a5f0b-e7c3-4d23-9fe8-b4fde383a171@linuxfoundation.org>
Date: Tue, 5 Dec 2023 18:42:58 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/67] 5.15.142-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.142 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.142-rc1.gz
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
