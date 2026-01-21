Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 484BE3AA1A8
	for <patches@lists.linux.dev>; Wed, 21 Jan 2026 23:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769038668; cv=none; b=IEMrIl/tZsvJfNw04t4haqqqzOLZiHtW+BR/TesyZT2XEgh9S+Mu9eZqLb48T1ameRdwmiJLZSiGOwOSh2Zgw6FHCnVW4BUVJRyHFxYNv8u38ZV3mfl39FdkAI91IWozHvLO1L41zBg8C9mrRTqZ3kBVPt8FWp1rJ3FEw++W7lA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769038668; c=relaxed/simple;
	bh=8fEOLru0G7fvqFglB1tYJ3qq2/9gQt/XW7KrBiuJdM8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kZYp4WGa2At3minpy7EP/2F69SObeI4A15mvPRMpgN9MkPl1uFzJb4GUj1Q5jq951F9czVj22Ayxd+MQSFAz2fDrLwSvrhJ2OiHAfM8FowXuqigW2l4Z8rEJZ9SV0uOMSW7xDAjxmAtxzn7VXx8c+Bn2uB1w/6G/mnadQsNBFcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gPefr1om; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gPefr1om"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7cfdd3146deso176775a34.2
        for <patches@lists.linux.dev>; Wed, 21 Jan 2026 15:37:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1769038665; x=1769643465; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=as/ujYEMKTJ+1vzNUDKug0B7Dg4H4W2+gS4ldR88Pk8=;
        b=gPefr1omod0IxUdNfDSuMEIcZRxzsnM7JwSuAH+Y1DWGLrZablQdr0hdZfejpmeZ+Z
         IJVFgfUZv14ME0HtJaUifZxXGRfl/jt30jfu5LhegxXeE4FuuVfEcGfo3wrmD6obUGSe
         lad9g1Fpc0Z/SBEtR/tA/ZV5HAQ0sS4MVJDwU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769038665; x=1769643465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=as/ujYEMKTJ+1vzNUDKug0B7Dg4H4W2+gS4ldR88Pk8=;
        b=t/kC/MrbfBvHBCUNDCFjL5SebdprpE7ZJJQ+M3u924C3+mVZ3P0ZrYRH+OhumfL/0N
         wEF7s+m0MMpSHcvLZlrNSkgFKnSIbJgvf2QFHIlFeVEWDOrB0xyV7Q9gtScfmfCjm+da
         CFm+RTgdY+xd/X8IJ3x/skOf3EHesJZbOJsEMjEuHSY1mD1BgNa2xXNlL4lO/7hG8ILX
         Mde79s+8dEg3bDtkPJHWxo6cUZtS7M8bh6mo0dMDWirZiy7li3xG+4sLr7BwKcgcYnGp
         VMYb8dn1rfYQz0B4p7XSWUeCCJNYpRtuPf0YRGZ3+BVOIZhBggx0CKlDKT24rDCeP7Ym
         sAng==
X-Gm-Message-State: AOJu0Yy3BOUVUnX3baxfV2mwA7EnDRUUst62wuMyIuyXIQ+3eBtDe+/E
	L0WRSe+V9KaQ0k4zDxeSgBo4C6P7mjLi8pZ7jPmrEu3Tj9rzfEd2rSksk7lHaKVh4GE=
X-Gm-Gg: AZuq6aKbHLqDJ8xO0fqdLuPLnv4M601aEdtDVqL9XGkVIxWQhVWHi5994/rfRzwvmPk
	qyp3kPZcEa1tF7E7SpINgSP/FJJon3SLaZ3uQiEVj1jbDkfiaqsC3EuWaXt50HWAcSJTIVJp5kK
	QNtXFUHd048NJmsPQK/5mbGylhe0RXjZOHt+IdVa3CNSeiUejnVOCho4mECNmwuPEGHJgMzDr4H
	7D/9r7S6H+pM57Yq1hPdGsaju72gj1EUSAWejpsl65X2aPowmwzkhpzyss43dLUuQ+YRdajJ14o
	ZTh6N64qPJyi0KWgrVwZ1ELPoA14xWewknadI5YPu2Q/H8EZM+KMak4XQgr2yoQWyCFmbQZ/Xk7
	ptyMieYLkeO05fOeUsfGXfpwX2Sz8oJ2r9EWpy08GsaCi/BcwiqqKb/cnYpyI1YO2fP4DvOltQ4
	fVM2YtI5skcMIGyskXfTPTWxQ=
X-Received: by 2002:a05:6830:10d9:b0:7cf:e4a1:8b56 with SMTP id 46e09a7af769-7cfe4a1d9c2mr6653764a34.36.1769038665113;
        Wed, 21 Jan 2026 15:37:45 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf2b55ecsm11822215a34.28.2026.01.21.15.37.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Jan 2026 15:37:44 -0800 (PST)
Message-ID: <947e84ce-50ff-4dee-b79e-0f934d8a5c06@linuxfoundation.org>
Date: Wed, 21 Jan 2026 16:37:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/139] 6.12.67-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/21/26 11:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.67 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 23 Jan 2026 18:13:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.67-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
