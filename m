Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A87617995E
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 15:53:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741276432; cv=none; b=pyjI3ItaBTgUNUs0F35tTsh1J7nL82plRgL+VhPZCCT25zaCasccsHPGRnF9ZoV+mzjJT5pnlsYjd80ONgWpRJnwEHtLgPqCJWy/+q1W4w5VWgEp8IR3vhPYb5K2qa/E5TjF05j8qDyCmkkcE8e3ty3KV2W9HidE9mQMBaZqIQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741276432; c=relaxed/simple;
	bh=9xApzznU9zToGpRvOyi0B+B9DLKySsAQzusSYJseRe4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bSMs34BxNHUX7MhkyXFj6yfa5YzdoVmJPu80zAWXpIb7ub/TZTC1zRtsacHDF/hB22HGpCV9MRSVTiK+XhwHjT0Z/cW0U4hr9odls0CzL0SiFP899+P9KvbED6KFHKjnzNChoW7ejM/7VvQQFv5eb8a7f/hRO4rtoMWxZYSNBS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6sefWlc; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6sefWlc"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-854a68f5a9cso61761039f.0
        for <patches@lists.linux.dev>; Thu, 06 Mar 2025 07:53:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1741276429; x=1741881229; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UGVbwjHGlVQWxl/m59u6FqTt/mVrEMBYDWttRsZVfrg=;
        b=W6sefWlc4blhW8L/lP6/PXNH/qZil7hAsrJK1FMtQjZr2zcCo1hZj4u6SXdavo3/hz
         TyeNHiI3WX1krxH5130wR0/CZ+QurtG1X9z1UvsD8ars8NeVFuLNdj7+2nVJp77qPoiW
         1D0MutLAJ4wkb1OnauFmRj9CNhQsxLFLhZAn8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741276429; x=1741881229;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UGVbwjHGlVQWxl/m59u6FqTt/mVrEMBYDWttRsZVfrg=;
        b=B2mEet1GiK/DPMmPur4o/1n8dyFsOzqXa1NafsOpjJqSQz9mwAyTJ1zRcRyKvFy8tK
         azG6+mqp+XOLkRotNuQs0UFE86jRGUn1Fl1peILKFO9SLnc0y9lUFri1uMHIGIPX2ItM
         fss5uXMFOB4IfQdAREPT2i2h5pTbf7N7S6z+WLvCbV2suJeA7zxwVcXhY8ZhPHiC8cYM
         Skqy/Czl61R3k2cHy0Cs06081fyGA6zm/bvSQW7VTN5T6ZCz3V7wwDa6dQr+QMJ1i5m1
         fycqZiIBIX/lrjyj4DMGpplnzj91FJdbb/lDBUL27aJehatFFmjxDWrlJUdTFtuMJ4lD
         l2Jw==
X-Gm-Message-State: AOJu0YxSBtY+fPWzoET2+N9TF2TMVp1bzyl7FhO1w0ZRl2cYWQ2reNdH
	RarM2sK8sIdQ3gN8qYr3WdCBQ0y0k49YCHTFJYUWsjaWca2zX8dSKWHzK3tDDJQ=
X-Gm-Gg: ASbGncuDRs9dJ93Vx9CQXImrUl4CTi6TceOqxrMpwQgegXgK4yLSZiYN3GLGVztYTLC
	UlxPB6PKuTzg/9u18CjrhHuAy96BQ9huyf2fy9MWQsvXdGXpIMjO+ywaEI5wMB2eWGDBPvAmW3/
	cjhCymDzDIgQrRLjK7Qoq8a0K7+P5zazHTFA4t1ze7w8JKsacaNhS8X+E4CfvcjHUppG6TE6bxn
	tzjtNCAskumNJMnQUzoolUPhRI2Rhxbf1GIZvJUetaI5VHD18PzXUad8q8xAkNmOom9igoqiT7N
	XMIkYN7LNIFlosyhsT96SM77TMwfcZchc9UWs6nhrpHamsNRuezRce4=
X-Google-Smtp-Source: AGHT+IGNfRM6WfvPSmrxwPJSCIIkYyc3wCyGQxjF8B+uwVak9ijJZWpq0YOE6Njzt4Xig2A+t7QPUQ==
X-Received: by 2002:a05:6602:750d:b0:855:2bc8:69df with SMTP id ca18e2360f4ac-85affb86847mr1088552639f.14.1741276429490;
        Thu, 06 Mar 2025 07:53:49 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f209e1569dsm400620173.30.2025.03.06.07.53.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Mar 2025 07:53:49 -0800 (PST)
Message-ID: <0c017b9f-0bc7-4826-89bc-70b9b9d38d4f@linuxfoundation.org>
Date: Thu, 6 Mar 2025 08:53:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/157] 6.13.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/5/25 10:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.6 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Mar 2025 17:44:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
