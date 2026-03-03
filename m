Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2CA62AD03
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 05:01:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772514119; cv=none; b=KpS2ZSfy+P0j9Naz/DVHMM/z8ji5K1sB5V3f27O3G1LCrMW5B03d1MsJCvLjFVnt87f/HE8iP/7oxmIJ/BVOBMl/3yXBFWCH7Fp8kVqpWfNPSkQgMeFbzUH+p3Ypubl9WfRKMoVBseCORIxFFs8it1M+owOcIBWCKsNpP58UZmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772514119; c=relaxed/simple;
	bh=5NmHXSIqFUGmEsfXJnMjdJ0mjLICbBExU7EmpUZLC7o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ET2I5nRUJqfSObM/+2eaJmlrkHrA+Qhgi7tT0UzvJL34cTNnPhSlw5XFeMd8i8GMoqbnOHbNVIkm2lp6nHJ4hSzW20ZagQ8hkVX9b9+1sDNkjPSvRS1OzJumYF18ht6fqVYpEGjhSuUD2PWA5Q6wXp71j8bwIQsXJ3iQkHPe3sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OGmzyfRw; arc=none smtp.client-ip=74.125.82.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OGmzyfRw"
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-2b4520f6b32so5970092eec.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 21:01:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772514117; x=1773118917; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ywsUjyg2uH/dQpIhZoRPIwK9ClhDr7/lcr7K8x1S4Bs=;
        b=OGmzyfRwpJVBVCANkxezncRq7nGjy2c4qqMpqAyD7XVgcE9E75AdvtVITgdzRs7KYF
         o9Bcqx0Uq+wTyXrVCG0nHy6NRycbyFwH+5snV7cZc2Qhtl9bbXv5x0geNCq3lq0pqiN4
         7p2OdJXi6urikA88ewqy8P7WlIJoRY5LMpvWMKWkGAAJ0J42GfkIj0MlEVq0mOefXVus
         Q3U4x4BmMbdekSmW0EsdEGu80NEM/qOPH3WQi5Et0TujaoAwYNJluy6E8P4ffXsntXGI
         tRzQs/CSyMPpZz29LdxUvTJcG3XTrwj4CH+BW05cAMGY0eCB4SHQu0zUQvV8FzseV+GN
         Xy3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772514117; x=1773118917;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ywsUjyg2uH/dQpIhZoRPIwK9ClhDr7/lcr7K8x1S4Bs=;
        b=gwW9s3tI62zhDijXgvgQMrqMmgUoqPxt2jJFByFIZmn5u3nCCq1XTpEy7Z4E43/wV0
         W/qE2EaEjAR/EopuUq7KCY+Ngj3xDJKcDNV0FIU28HVVINGxkFJGCXKkPOTNIri8DQVP
         B9V8dzavxHnbXPzDAbmSxL21nMSEF/9sH5p7wZFAUPwjvfpMaNJAdVCZ/EzHzj8WAAeD
         3L/iR4wL4hm8M8p2ucRd/S153Ta2cXXq5nJzdV4XyFOf2wPEgkZ5bD4HmyvvL0fxiNgj
         wfwFnYCFaqYx8cRgRWlmNGISCngWa4bhvcNwHRB8VH8zgiz5grWa948mKUQxYpmYKu5P
         9AyA==
X-Forwarded-Encrypted: i=1; AJvYcCU0BoBnOjU1hEUT5a53Jm/g9UYX+b7FY32sTcpY+NbuZqx4VvooBCZ/Iq/Y4L3ZpRaQfcjogewo@lists.linux.dev
X-Gm-Message-State: AOJu0YzUO0+FQDvipSb6TN+bk45IaYyD1MkhJq+cMgU+FQ7PykPenkyJ
	Y8pmDuLrBBpa7Koy9be7Uig523RWGtvqOIYDz6KeMtEmVEAOR4FdHSDE
X-Gm-Gg: ATEYQzwG0Y0cLHPxftb1QF88sqAiy3/o6zxlPOuq1ssY7p8vyRWHRzWFvOCVS8uuA18
	W97c1jSO0gxDNGD1Us8LlGDfl+CyMYyoNZWatleEO3NiU6CLD4KGIua4FOoxGaVjVoFJT4CgCtp
	P1Ev3zML67Lci7sejNtGB+TLJfTs5Pdy/hOiaK+MPqnJ1YWVOgnmOLQUB1jipOX2d59S7ZvM+t4
	7K74n7H73mZ6vFnASBvNbVZeRfLBdp6fntUyZVjeJRrbLpAqzTkAKbAp8x2cB+kNi4a2It5awxB
	c4Yfv4SQoLuK+MYChwCsgL1YTpN1So3eRSRDUn3YHCaWxP9aflg61gZZT5OCf0ezmm7BZSgUZpg
	RrKTM3X/LOC7PKJxWY1M6SbXg7nfzoa77jY1+KYYIhDab/8UjB6POWyNt/7l0O0VfqI89d/cJER
	5wDtigEWQndzqKueNsKhhhQir8tC01K191g9pvu7pqhOPjBZ6qaLZx/oE3vaXxjW4F
X-Received: by 2002:a05:7300:af06:b0:2be:18eb:1004 with SMTP id 5a478bee46e88-2be18eb1899mr1440007eec.6.1772514116935;
        Mon, 02 Mar 2026 21:01:56 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1f48c77sm13918913eec.26.2026.03.02.21.01.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 21:01:56 -0800 (PST)
Message-ID: <bc5718a9-4041-43f5-ae5c-6c6d7f12eef4@gmail.com>
Date: Mon, 2 Mar 2026 21:01:56 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160934.2521545-1-sashal@kernel.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/2026 8:09 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:32 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.6.y&id2=v6.6.127
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 
> -------------

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

