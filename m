Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24ADE6A00C
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 18:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aMU2lgoA"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1d0b0334ffcso19570275ad.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 10:45:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701801918; x=1702406718; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=flKgYIE4IwSJ2fUJsrVvCXDFvYHVpDfSU5/bd5JZy5g=;
        b=aMU2lgoAWOdpi3uwgHIq2zbVI68ik2MV/z0j2ard1z+5D19czyHNZ1KI1xN23XqDUa
         DIaGbStaEsD0nID6DB+BiYjMrfCH45OyKkUVRC7m5vHpWvDXwDCajjPmzEIZ1Mv7d69o
         +4pz3B3XRO8P6bAWafISUebNqgdzuoBfPjTt0OA3V6nD2HpQp4B1vw1mjKHR4fX89ADk
         sWzPZW76LXFY8OOU8w2y/AhzNW/AzcJfiYO62h3F1TkAnCtb/cVKOg3yADBWOABUa9MC
         ATLK4G+12DAscBBGMlP7KGf7DhG9IjqC0sEMewnUdRxUI3KRT3a63N85SaCoDYMPcuHy
         WpTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701801918; x=1702406718;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=flKgYIE4IwSJ2fUJsrVvCXDFvYHVpDfSU5/bd5JZy5g=;
        b=PSqV1PTSktpZ1tiVcgxiyH8MXOhuB6sTKJGIAryjR3kjB5fIH10JwCXhcfN9e5ycxV
         bCQ/oeS3xpiRmfhfPt13/atYm6Atr8ybDVZXApSrPsKfVUZS4nC8X9JvBZeqb8hEJKHR
         x9QdmN33KR3m6SE9R6u/SYQPmrMAb0rzbprCT3OptBPkgObCoRmC5qCePPV8Uslu38J5
         zkeRgAGXZsKa93asb+oXO7f316bmW/R7mkLm0e8xKSliIoJOhqvJ8atyVvm4U8zWk1aB
         7SrK3vegGh2L6C8f1uNkZw1rlchIl+ZP6Fa354r3PGlb8M4jAFQpp1h6zYVExt6WU3yU
         tGhw==
X-Gm-Message-State: AOJu0YyByBsDuyOrPjoJNTbmOa1g6Ayu+Kn7uOYU/yR0Y29HcF1AfeuL
	4DptKKwVTTZ8GYz8gox9A8M=
X-Google-Smtp-Source: AGHT+IGczgLSfDMb+5nx+kA8WVFhT7MdlDViILaqT6EbIEY451+EMdH3QvSTDARDC1u1ZoLDPmLNkw==
X-Received: by 2002:a17:902:bd01:b0:1d0:d312:bbfe with SMTP id p1-20020a170902bd0100b001d0d312bbfemr290385pls.15.1701801918190;
        Tue, 05 Dec 2023 10:45:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id z20-20020a637e14000000b005c68da96d7dsm2520922pgc.38.2023.12.05.10.45.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 10:45:17 -0800 (PST)
Message-ID: <d2194d36-aca2-46c4-be3b-cfe3c3f33edf@gmail.com>
Date: Tue, 5 Dec 2023 10:45:13 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/93] 5.4.263-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20231205043618.860613563@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20231205043618.860613563@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.263 release.
> There are 93 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 04:35:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.263-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Same perf build issue as reported by Harshit, will be waiting for -rc3 
to confirm the build issues are resolved, thanks!
-- 
Florian

