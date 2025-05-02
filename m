Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80C823E34D
	for <patches@lists.linux.dev>; Fri,  2 May 2025 12:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746187505; cv=none; b=X76q0O1uqrt0enrKjQdcnSjGjYVzGFooMJ0VwqcTMuwav5BKgGoLj2WV0yoBiALZpo3dvnPIL0b8YVBydAMaYeRDTBjaO2xk5bUoGKXn+W4nIuNbIlMMrLKVJChwzKj9ccPj/+xhnzijZCM4v2BYv58F5jjG/MmzCt1+0bFuZhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746187505; c=relaxed/simple;
	bh=YbtPxww+zzrpNWSONytmbu8COkRtxRn0ypsvL5XHv0s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FVa/Vc/hSPlvF/ilGK8XuwyX+FZfLsZRJp80rpei2ilt6bZWBspJx/zqXdoG/ZSS9uzvPRa8jNFd9iykrTBwl084B3jYJYv39Z5N12rEQCp3KaIC/VIEFaG/mwCIcyAVCByOQd0KtI/vGNSmV9Fh2zw0zXwALyTGdF15JJ4HTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VNhYi+fh; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VNhYi+fh"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-223f4c06e9fso18087275ad.1
        for <patches@lists.linux.dev>; Fri, 02 May 2025 05:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746187503; x=1746792303; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=c3NmqJcH5D8xpXBtQZl2s2NIrrtHM4pVYtqOA9APXCQ=;
        b=VNhYi+fhEDiC65MsaOfAWIXK/4WaUNMUjqFn1Ou1bwaVs1m2F+xWG6G6Uiv31byrVc
         YFYeG1rPscpb/BfU1/wUZYR3mGAC5++sTeceG9bHK5mBE9mla3PBzPPxdGha4m4J6C/u
         51KOwZJ33VQAsNpB8pOl2t1wwgwRN18uxgoFoNqLLRKo5zLlyjz1mwLrixgmkR9c8Sdr
         GNRakxSgzpvAVSudMjzF5Qv40CSNKy8w1zAUyY3ufw4MxY4k5oYtLO6rrhO+N8QXMLUT
         bRB1DOXSod3+WQyVD5yQCMqlrq+owYxmEInFqKTGHquurDgxtz9GaBX5cuajKRy5khi5
         HiKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746187503; x=1746792303;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c3NmqJcH5D8xpXBtQZl2s2NIrrtHM4pVYtqOA9APXCQ=;
        b=wKy+4j1H5nHQLwYJB7Q4wb5ctzfwUXrAhdXbQwxvFV+Q2kGy1KSmydgdOc0WYYfZmc
         nqrs4wwwsqu8+Ihrznq9O8BzxvWlogsTr1HaWHNbqfPgd10ZUWK4MzPKtl5s/YROlnnM
         MgZPnVlZb6LM37kOjpV2iggaE58aFkCtQks1rRbz+XyCSiMG4+oKvr2LrhYM2BzYasUX
         fvoHKW6pKnewCfrWYTN6OEAv2C6DpuulXK/z1NFRt9ETwAmxGqgorQTuY2walmVH8KUy
         3vJ4IvK54bKa/+uftkj0z7JrzPfdrR/Cg8BBDLwuyWU1L6XbDyoJ7iH5LYiQ10qTed08
         2ozw==
X-Gm-Message-State: AOJu0YzpRm1Zm0RuRSC/RuRgjp3u2/9Su44vUFjghupxsCmVwmvuN9Is
	QBe1tzNKPbyo+AmobM0u9OhWIs7o11CewBvSY2JE9CgEmT7/6tgb
X-Gm-Gg: ASbGncs52/zx7jDYTT3UJb2XYJiXjbLPJe/EkK+mISz4Hx3pwcFpsy3jxT4/7mlSYKW
	kn+jxHaNpV9yfjxfohPFj6/+H8J/VnuGApABzippiXIuz4SNTX/C1ifivN4FvjJY1gySX+lnUX0
	wA0/eZJtGUduV7JQuLnHykr2VJ4ltskR+ai5wTdTDQMyR3y9uEDSk4FLsOKHPLeC3+xtCbBRDOF
	LtRkz4Ve2mcqSpjaO2szPcNM9e42J4Zt4BEx7b8wLEHbUPhyJhAZQMuLgUJQZu1tYw/7iuSl60b
	gVBGlqZwBFZ0jQK8uSkujn+3KfpCUVIxhIrf99391WIrVS+KxoUSiBuYSxhOa2HIR0c=
X-Google-Smtp-Source: AGHT+IHfNghsUY+gX52hEhA2Yajn0CORyfn/JRMeh96oMPVHQUf+ZNF7U1LQZrPoVa3q+PaJPCJCWA==
X-Received: by 2002:a17:903:234d:b0:22d:c846:3e32 with SMTP id d9443c01a7336-22e0865e10bmr86805305ad.25.1746187502803;
        Fri, 02 May 2025 05:05:02 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b1fb3c439f2sm540102a12.53.2025.05.02.05.04.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 05:05:01 -0700 (PDT)
Message-ID: <0593e4e8-2ed2-40d8-859e-1c421ccf01bc@gmail.com>
Date: Fri, 2 May 2025 14:04:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 000/179] 5.4.293-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161049.383278312@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 4/29/2025 6:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.293 release.
> There are 179 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

