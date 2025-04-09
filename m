Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 065E02066DE
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 18:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744224794; cv=none; b=K85/ONQnIhtfA0FKusj3/eYxrGUNL/c/FWjyPshtXZit31zuwWu1p4MT41msOMJdsGqAcvnvgFrqsVN87gfoh42GLWGOVt0fSl+AFDLLHd41/Hmw5netWG6kHxB5591ACrqliVZEquRc2icnzSoUDxIUeS/TM3xe1+SMNVw1myg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744224794; c=relaxed/simple;
	bh=ev34B4BdC9WbGNJUDSR2Oo2ko6MrEuWxcqh2POvhMM4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r6cSozr1b5XCLuyQb5Q09JnG5k11ItZoDBUr3/ivmZTT7EIdQ+nanpQDidKuuDutjPL152Nv51eox6/zxSkRkAKf8dsa/SFSWX+S/DwBF4dSEpPyyGtyVwTjzERgNqBwbEYBlH1I/G1APeJAfPvBQLfbqm6O4rWb4ZN9Lse0mgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PamTSErt; arc=none smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PamTSErt"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3feaedb4d2cso3909464b6e.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 11:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1744224792; x=1744829592; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uprOTrpUfog8eVjEhCIqe4mihJSdQCDY4xj+acLb2lY=;
        b=PamTSErtKsuwplzYZT44Tjdlv0AbExQSfhXm1FvqKFqrO3zdV9e7khMK8rOQp1F3mB
         ViRLufrUBHoyvYgyTL4ZwaUeptzTEBDIjwE1KpFTiEVfoWQnff2KZ6d83smEOuGFamb5
         THZBfieQsMTDaCSn8/7LU/ws92fR27SlLQPx8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744224792; x=1744829592;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uprOTrpUfog8eVjEhCIqe4mihJSdQCDY4xj+acLb2lY=;
        b=M7xJp4P/zYQUHRs/u59UNvDt5ELbPqut8FIvgCllazwwXMUuQ3xb1x7Av0+41nBY4Y
         ZHBS19RDKHM6nrqxi/kFg0j39ffriYf1WRwonThyE01D7vwBe1tCotD/pnBQu6I2Pf6u
         XbZ6qp/xSDI2BK1avqXHWcHZhgWviHL282GfjsC/t/3lJQdALCXoVb1uj5eZAOe8sgr0
         89p5DUr1i/Grgh5awsZ67VFtf3ORlLki9n5gmJQFJSAizqSEANlK8KJtmNiIwQgbag5G
         rHiw/Jk5FTEy62LHjFfiz0cH2TJw7U69KL2j6g1/YHqBJRT6qafHSSkHtx4P72Bi4krK
         HItw==
X-Gm-Message-State: AOJu0YzPWd/azK4VrlXC77od3QpNCcT3gpjecyZ+zP5jUjW2js+wO8ZL
	lM760mu4d1XhMbnamaixTy4gwaR+NtIThaFUSYGp3VugY3oTmSyHOvf1/z86Co4=
X-Gm-Gg: ASbGncvJurtM5ua3cHtjpIy12CGNQlqgTbD3PTANnYknAhRER5yP2cN3rs1OsUgXLWe
	pWCSxpwq/4V1k6A34Y5AizCFIKnKWeSH8AkQpzYQqD0l542RINUTGfdlpixHAM9yKEk+X9hhpIb
	RgqMfzaYjgXghqnk/zTmSXYZbP4ApgjbV2dN8a4u1NXGVVVa3RR0w5dlJyvbeCKZHIEBF4ZybqP
	ZjjSJQQ6Zyfaj7Rp2BNaCB7JTULxdgIFyYh0EVhG0jPIor2MyDarCGetpdISIOrPe9+27X4LRvs
	UXbpURopRsQdHGsw3YxQqA59rHVrXi3OaJA6cIl8E+zsCSjXc2M=
X-Google-Smtp-Source: AGHT+IFogSAftN0uvxAUx3F88QuzGur+Ouhi5sC7Ds4Nb4RZ5YSZlk1EYlRWrYgi5Mtw/kI0xiptgA==
X-Received: by 2002:a05:6808:2a8c:b0:3f9:3c2a:e40 with SMTP id 5614622812f47-400740a0265mr1871379b6e.26.1744224792049;
        Wed, 09 Apr 2025 11:53:12 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-400762d4861sm259007b6e.23.2025.04.09.11.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Apr 2025 11:53:11 -0700 (PDT)
Message-ID: <84e6a13c-1dc0-4405-ad56-442e5f288aa7@linuxfoundation.org>
Date: Wed, 9 Apr 2025 12:53:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250409115832.538646489@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/25 06:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Apr 2025 11:58:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.180-rc2.gz
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
