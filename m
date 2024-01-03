Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 921171DA2A
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 22:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YufA3rD1"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6d98ce84e18so7989390b3a.3
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 14:04:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1704319471; x=1704924271; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O7iewc9p+e5BRzaH3h+6ugVYrcUX2L5YJYU1XW/tpRA=;
        b=YufA3rD1YbP0V2fSZfA9KTbqi8qHcv5MdxlyTOzh3+aIPRPdT9xPMkyROeyC9iQ0d9
         qt7Nn2g2pjKTfsTHbQSPzs7k7cx2uelsXPh7RtsMgweF0SytGRyQozyGYZ/+kxgFqGli
         ApVAYedhmOIAKpMW0ZgFfpqgypYItE6s7LKMFL46dSI9SOsLHG37X3UbHXFdDRhCUddT
         6bOzGuiEnECeyZUs6nwuAFkgIQSTTcqXsb7+RUKbSdl03wr6knplwryagVRaTbnDVHqz
         atP7C2/JgKNcZvSEs1BUiceOKL8DK8AOHUj2EYVUT844TH38vclk42SSbk5wA9bIC7n1
         LH0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704319471; x=1704924271;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O7iewc9p+e5BRzaH3h+6ugVYrcUX2L5YJYU1XW/tpRA=;
        b=Zb69TmgdxR+/4OkevPRRyUD8PYIQrjjcMNBFdIN/hpn4qn+pAtlokdBNx3/tEc20V2
         XBCocbIgpzF+U195VHvfYGIJsHnB1MQY7/Ee0L+Srriodbn94Sgb1FFIGYLdMZ4LEy4y
         7kCpOoRze6M2qRDcPJiOrphk2GpCTBMx9PeNcuH2+cvlRnEVBXM82m1WSPBVwmBsF9Dx
         wAgtS4vM8fxkzetG9B/6kTx0FQGVgnGhuQ3nk4kzsZ3HvsptTGh8aFDYASe15YFN1464
         u6+CPW5NacHj5mhBwpSl975Jcodrhy/qWt7hEvHLvThQUTie+yjTHg+bAwBhhPvElVYV
         jx3Q==
X-Gm-Message-State: AOJu0Yw3+a4Tdz+6f4WO8IqcfMuYYsunL3Pm1D3uVu5VCZPc08fSThor
	IkoBauJPHHnKpKPAcQwxPrs=
X-Google-Smtp-Source: AGHT+IGFAU/chI/igQ3rX6cuspXRekK0D0+GMOnXBB/fR5lCzwlRPqDmltazxxBLKaSkiMUBVHC+1A==
X-Received: by 2002:a05:6a00:3989:b0:6d9:e91c:a5bc with SMTP id fi9-20020a056a00398900b006d9e91ca5bcmr13608036pfb.38.1704319470948;
        Wed, 03 Jan 2024 14:04:30 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id u36-20020a056a0009a400b006d9b3b38525sm17876588pfg.161.2024.01.03.14.04.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 14:04:29 -0800 (PST)
Message-ID: <c0525f2a-3871-4500-b941-a35e1224a4f6@gmail.com>
Date: Wed, 3 Jan 2024 14:04:28 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/49] 6.6.10-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240103164834.970234661@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240103164834.970234661@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/3/24 08:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.10 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

