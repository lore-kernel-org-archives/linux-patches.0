Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8B0C190692
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 18:49:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714502987; cv=none; b=hS0Qz/9Ei2DrHMBsYyTvNehG6PDMJun9G/MSEwStnKSj+fTQZKjaDf7HI5k8aY4ckesYgBReqDwvhv2g9dJ2E1A1O+kKkDP0fnjD1W/T4g2Q6E5QYo0GLcDDMs5c9RgtR6StsBREqyx8gDjldiPgcA9v/fuy6kRW2uI+dCXY/ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714502987; c=relaxed/simple;
	bh=FhrQaeTdgZ/NZwmj37cjeoHdptexvaXyvbepUmbgMMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qq2CwvTjSB4oqKD5a4ev/YFSh4N/5MrZN71qPcs5ADCr7+THaTedQYvCrRq2E4YkZ1eEnvCH9iOtD2K1rJ9dp2LU/qaLKecgMKJ8cuEm7E2Nyl5zAlVSDNdJouTWjwYjyM3W5EWosOx4v7uZF6dNeWaxEtd72xTigIDElxeyXS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ejP1w80t; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ejP1w80t"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-2af800ff18dso5068238a91.1
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 11:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714502985; x=1715107785; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=METv65pV08IjO8SJMBQwsooi61TBGF9gD0NnqLs8/fw=;
        b=ejP1w80tlJ+Q17/LWxxhu1ztG8uGzWIfrJwt5kXtxqdMXrDiRNgPaWFTgbmL2/bhD4
         1KHfSeKKt5prt3b1WtpAxeqKaI2cFo+4P7YyF3HofQjv/5kwFXHRF54rs8nVPvMyfUlm
         x9rXlB24tY1kHt5CvZuQ9DIZUyTcY9/5Rd1dw0j8OWlSl+EX43cn2tPBMoQBinE4AWKp
         FCR6RFBPzcgvhgeCxq2SMPZ5hRYHkinGWFEAt6WazWkYN3KAgkpFP+851qW7Q7IOgcfV
         5I9Ksw1FoBXlhukZN9wZZBlQUrSNKR8rZ4r9WEHBrUSM2K0kzWBACG4Fc1tuGEPWjyJO
         APqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714502985; x=1715107785;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=METv65pV08IjO8SJMBQwsooi61TBGF9gD0NnqLs8/fw=;
        b=fdiSrvwNZtYtWDh46ml1KCd3TmI4Z80SyFC37h+l6lido1oae8YtldWTBwYBn2S9em
         JtoJjEoumYgyQkdSVNCz8tToELK1NrANMusCngv7hhjy8NweNUktVuaWxG+myBcylYEj
         WrljBgd1zVBTaDNczAVe7T+iQlhdntb44SAsPxdE4Hae4x/jyRolRjer6sLyQqOX6BI0
         gASvkUc5yvEPMXDUraCCttV2zuHbpRnv66QZ4rz7f4NquHG2YDXaKveaPb870/VKTHFk
         j342iFpQPQf2aSHBTp8Ns0bufZdiODS0VjJGUXS8oxPwPAljYN93kJuXJjKB46ISAMvQ
         ag5A==
X-Gm-Message-State: AOJu0YyDxxBbtM/3bJ5ysSm0pqv9ASP36noZewuxp6V3OYIDb0jNMqis
	svzBRLFAmTam/MOicckTXDgy7B1qU9A5SEfUAur3rxwkucWslejv
X-Google-Smtp-Source: AGHT+IGBWjUw0lT1zEwMhsWJzOV66gUmz+pv5M6BItPvu9kPj6xn5cJx7yIoE+LTyznwNxaw+lYZTg==
X-Received: by 2002:a17:90a:d0c2:b0:2b1:99fd:91f3 with SMTP id y2-20020a17090ad0c200b002b199fd91f3mr359672pjw.41.1714502985037;
        Tue, 30 Apr 2024 11:49:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r89-20020a17090a43e200b002a7e4b99752sm1895756pjg.0.2024.04.30.11.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 11:49:44 -0700 (PDT)
Message-ID: <33760059-444c-4cd7-b2bf-74e94012f895@gmail.com>
Date: Tue, 30 Apr 2024 11:49:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/80] 5.15.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103043.397234724@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 03:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.158 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

