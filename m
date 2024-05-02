Received: from mail-io1-f52.google.com (mail-io1-f52.google.com [209.85.166.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07929182DB
	for <patches@lists.linux.dev>; Thu,  2 May 2024 03:05:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714619123; cv=none; b=jWC5aD0K79l5KTt60w/nXo6aRHITUJESCILtO6aC6ohV1YF1BACQTOkj0FSAFwHzaSjzAR5lja+orT7ajEQIHSatM8ETcMW5rACoGk+DDKFLicwov99iyaEVn2yaLu8kzCELNPl2Bb1MGNh42qP3aH+vz34fdv3H3g3DbxIdjkg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714619123; c=relaxed/simple;
	bh=nfmYTsnX3AMaJEe/kqKIfKQICnp0SW1m5dBH5gihgn4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=eu60IzkspEgyrRcg2XhM6BD3oxBuEt7qHCllz5xulY6VbP9vOU2CmY7ek+0pJcaYlyVN8JiY1j23fIszpUxr3+1NIerID3ywjw6BfYr5UzYyNP6gi8ix4rn2mg8D7XD+jznuilD+Nnqo9N5QrHZTU4VCPIr8GbeYOMZ9EbU5Jxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5bdH6K3; arc=none smtp.client-ip=209.85.166.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5bdH6K3"
Received: by mail-io1-f52.google.com with SMTP id ca18e2360f4ac-7d6112ba6baso48787639f.1
        for <patches@lists.linux.dev>; Wed, 01 May 2024 20:05:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1714619121; x=1715223921; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DS+1zXzwuR6V2/P2D9232/ZCNuYtFHvtaRPFbRgTEm8=;
        b=C5bdH6K3SrjfjZ/mBPqLzRsWFp04QRzbgjFikW8pnSJH+m783iTkxCtTHFbM4RLRcA
         FAhv6XUmyqCCJRq+2tk+xzWJWdDaNg45KJGonm8RUY9NGjJ0ascuElbw/cSBfW/3eDhF
         u7Ng++LWVl0P38xXtVtZ9Kvdb93mz8v3Oxpoo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714619121; x=1715223921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DS+1zXzwuR6V2/P2D9232/ZCNuYtFHvtaRPFbRgTEm8=;
        b=SnC16O+Oa08D9eLogqFrp6pd8DfDZPIFdTCFo1SJfsmrEXGBzb8+njtKjOQzXYQ87B
         TuXfQvx57ltGeMn71t5Qp5/u9oe2y8ZneZFmimjp30L54Ie0vxQSwJaDxYV8jEPyb8iJ
         YlGRVww3UmPS7cFLmh9uD3tzQqN+UXladReJeaplkXWbi+bkzIgJD85NbFPvelHGw+cD
         /JhuSYLwbHraQsH90GvMw1MX95/od1TEfdzBFFzJLalfjVTubWn/ng1e9flXZHlOY4Yl
         CeMZzRjDs63dFJrqWzzqt+zeLK8wUB8/Hfj4pwBQx6tz7QP9sp2NkjCRobcbOJt9u9lm
         1lJA==
X-Gm-Message-State: AOJu0YzW25cvlERKAc6qAn272FCVHvYHINXc8dh9AEDjYKDnqHDJg6Nj
	CT2lw1ioEyf1/Gwm1AzfEWF2syvni3lLesWe0ISMPTpJgJgOMFDMzUmT+tP5Ryk=
X-Google-Smtp-Source: AGHT+IHYtm+/PoEdKYe9tO6lc/PTgVluvUMmOJC2EdNkzkzCTQuyCCgqVcyWjO7QO4uKTaJEj3Phjw==
X-Received: by 2002:a05:6602:6002:b0:7de:f48e:36c3 with SMTP id fr2-20020a056602600200b007def48e36c3mr1740127iob.0.1714619121131;
        Wed, 01 May 2024 20:05:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id im15-20020a0566026d0f00b007dee04738d1sm11732iob.23.2024.05.01.20.05.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 May 2024 20:05:20 -0700 (PDT)
Message-ID: <159ac07f-610c-4f49-acef-c67d981e3a56@linuxfoundation.org>
Date: Wed, 1 May 2024 21:05:20 -0600
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
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 04:39, Greg Kroah-Hartman wrote:
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
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
