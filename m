Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845D83451AE
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 17:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764956285; cv=none; b=gS/KjMDp9m5gYQraPr3d24Tua0tamdt87JsKGwjKMMC+RwolSWPFFri7oNhsZjdgTj4W1XshIoT4kxVyBa1vTEFxTjw6l+vfq5gpgXe4i7UMvT4d+z0+VY13nWhCz5iCivYCcRzR7mHChgVmM0TPdkJeeGRZgIjtMRSZOdGqaZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764956285; c=relaxed/simple;
	bh=7N61ZWdUgGewQCkngjSTQM2NGBkmWGYlzXrmuAp+FRw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EllNX1c5mYZvSz7jqfrAKjb1xlsRXx7oe1yH/twB1wbmwdKMz1OZzdeZgSOkNSjJOVuvvhxPOWe20IP5U5stH8qsfiRBfq6Kr3wfU6vqvtRGqHMSbF/WwGhA4PoIxnT7iClngG7Ooru2VvChM6Vjah6LGvUiLalxCLgH/KVdJVY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JhrfMOy6; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JhrfMOy6"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29845b06dd2so32309215ad.2
        for <patches@lists.linux.dev>; Fri, 05 Dec 2025 09:38:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764956280; x=1765561080; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/qRLfp3gti/bgMDKIs3NH6sgb69LJ4uhb6OjyGC2EJ8=;
        b=JhrfMOy63R4ETajRJIMXcUt1nHOkSkp7x90YbzIRdb7rGzvUolsmq73N2ICczXQwxc
         G3UALR3Nt/OBfgPmpSLXL+2fy2hSFkHtGY0hcHOwgB6omwqNuwV4vf1dTMVYAN5FDc0w
         Sj73ZKwqgpKJIfEUXo0n5WKYMtdEYxAs8GgaUkQ7TWuh+bzZOoggn0OwaC581Gi+bMSO
         5yiaedepquwtRaDgBipVyE88hQseCfp5qu9Spyxoh2sRAspL8pzS4mnh8xZI2I6giYHq
         NFby3gp8nYMAVrPEf9AbAOqlva60aMSnjypMgIBrBMobhCDUKuvzQv0mexs1dKfj4pyk
         j4IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764956280; x=1765561080;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/qRLfp3gti/bgMDKIs3NH6sgb69LJ4uhb6OjyGC2EJ8=;
        b=RYhxeb/6xnJkKj80CrCS3Qvymq2rG2WNXm7ezQ2JbSV96focT4X8y6ydH/4DdrouyP
         llklaHGdclXwc05n2Q/ZWhML77licvS6xi8+2TTWXbThNR+rwKf4Ia1m68p7tqb3sBGM
         IFjHJwvbqLMkfkdolNjSoy6XieyoxedLPRwh72LF8f2KGBEPCCsChcuTJ/ilDqhO0bTz
         TMbH3O8LHPbwrAzG+1TzbP5X7EF416TqUT7csM+Nm6RE/cTnqM2eqQ0jWbhHdEl+3IYr
         I8e4kGrfwd6YzVt+hVDwFnEuVI01MyFDcdQzqpMV14DbEzCfjnTZGehc0K8RrCaNr9Pt
         KlJg==
X-Gm-Message-State: AOJu0YwYmY7KEdm8xLjqvjZ9I3J8jkFvZXveYTgXi82kqfWQfk8PFy56
	C8pVI3ePtsfjbPMzTJMLF/jGUPsvfUqvFF1qA0Szes5eMxkklUI5pS9F
X-Gm-Gg: ASbGncvjds9qhFpz4LB5v4Hf+Gn2elSGHBlsibcbSBeoxEyHfZGGRxSk7QsIqTh6hBk
	cl1h1o802hpDldhN3MFvVm1E/w9tyiVDITvYyMZZOwBZQb16GUtvojFBFp0mJcoAP3QSD2ldrDR
	5KvmQkKnLcGFDthVj8HSfF8670vPtV62iaDYJ+ccFco8xDgzRf+tUWsqCm+rrlRHVuJVGoi4FhR
	rHgmMf0JSK/n/hNXOc3yWaJlrTNmAw60eNTL7ZZu6ir81xf7T3C2CCBC6PvmaQuUI0phlEHGs6M
	KLlCOWbG4HFLXCGWaEVTdsX+wadDiim0ebUL+MQiNvL8ejKWoT0vsTvtsOULe1mM7R2SP2HV0RY
	YyenoFxU4Kvwc9B3plwN0L7z9YnGu//bBZGHE8xuUEuZVsBh3Jlsk3ToJMfxogUXwK+PIhavZ/R
	jgamacvF0HF/yf1I+1VRicOjOB0/lcZZtOe9UoeA==
X-Google-Smtp-Source: AGHT+IFO6xi4psrGQDuhNf8aWIFpB2Da8ZDubG47osi0nuAvuKENfYPttjmkJhDp68hVbPuojZcXag==
X-Received: by 2002:a17:903:186:b0:297:c638:d7c9 with SMTP id d9443c01a7336-29d683434b4mr121468205ad.13.1764956280493;
        Fri, 05 Dec 2025 09:38:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29dae4cfa2dsm55286825ad.32.2025.12.05.09.37.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Dec 2025 09:37:59 -0800 (PST)
Message-ID: <cf81a11b-c051-491c-9b8b-a286c884229f@gmail.com>
Date: Fri, 5 Dec 2025 09:37:58 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251204163821.402208337@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251204163821.402208337@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/25 08:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 387 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
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
