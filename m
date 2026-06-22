Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9522BCF4C
	for <patches@lists.linux.dev>; Mon, 22 Jun 2026 16:39:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782146399; cv=none; b=YnALmIjdVGMKi7AKFg5E/p6cGX4U7gauYFZL5JOGY4ii+fVOA98pBp0fQUW5cPSY60/mbh+C2IM1wYkOj6X5v1a9VGZOzY89EAW36bHrdGPFTaaDuK+O4qsxNS8lJT9oXvDpwkMRurDLtLIKM+UpOF0W9gFqAKhj7VQGE5lGvKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782146399; c=relaxed/simple;
	bh=5+tDMdsJThIYK3BfVinjMIZ2VhLWEN5NWD5f7yUPuRI=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=DZn4Ia+yMreYTl/aGP5GcaBr1HpXMglvtYsDy65mygqDArzLoFxBGK05qXBUIIHuY37n2xBuC1SDP01ofjfdgbk3EpBzfJX/fA3LcukZ6VRffqTq6NH63swtwMWVFDJKs/15cutGhYcGfvPC9KY3Q7DvBl0BkUr+g7SUbExNZZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dXpqF+Lg; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dXpqF+Lg"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-c07d76ffd0fso453766266b.0
        for <patches@lists.linux.dev>; Mon, 22 Jun 2026 09:39:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782146397; x=1782751197; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=+UiOBa/IqtfWsMn+EdSXuBzHGb6PpRZ4HutiV+njy7k=;
        b=dXpqF+Lg5sOAhrZeU5dpYBZevVY9qLuUv4eQeZr9GGMTtQCm+RNucMycugFJl5dWLt
         ir3tQMY12mPJsMa2Ds5n9GZR4qFklSaOYulMKcXqgMWQhFf+5h6gmDCPRs7L6WdwBLS7
         a2GBSRWxOE9bz7qU3GfXSft4x8IIOokCj8iNMEngnGLTMPydfokvwFn3CGByfw+MHZI5
         QaX9ydyg8PGJrjy8zzW5tIuKW/PfXWYXHobVh33voc7y3UUP8I7V3ZYO1YQzyP2KzKuw
         h4MT0xEIlJF8tbxcX0MsgVLri8Lq+tK8pLA7fQ83tx5/lLZJtoWRabjJSde28sbJT5Fo
         STew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782146397; x=1782751197;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+UiOBa/IqtfWsMn+EdSXuBzHGb6PpRZ4HutiV+njy7k=;
        b=iQjOpdyqpRGMDnbPtIDOSJrDcevcdw/vyY/mCKGuIgOCj6DZLSm6O4CRt2btkXZv89
         kGu3wtWU1nPiWBQDlHbBCJdry910menSJC+0LU2i6vng7dbxIm3YvwIfMVQUJ+SJNFp6
         DJk6BExA4BhawyOPaHS4matMQOg4uvpXswfPqUMLuMNBXYpcDGxU/BEOPGSG9NE2KR1M
         7NiAbK8sDlp7M0mtd3PXA5HbcS/ubLKWSPr0J8R4RvyAAKLo7fZoDAOkeNkKgBG72+rh
         pl6AyS2zpO4v2ybuMg6sXt33zrJje+GBSGcRnfKm5yCLeDpB9Ila4bbQkWs1yfvoymHh
         v3tw==
X-Gm-Message-State: AOJu0YzEBAhgAI0PRJzLnuP6m3LXkVSC3USYKIiQfjkt4R2wKvGkIzVO
	/rUK/xowDFJk5VnJg+zJQVVGdV0F+7qvVD3JLPp0J3V7wvKZKSluuXG+
X-Gm-Gg: AfdE7cmZBt3jB4YHNvEMprRofIoyG2w7jBUU3KnXB4OF5sSjrnZewQcILeCc1QqofVz
	eXbyhFH0HIp9Ci9UWSVFRp3ERj0HuvBquV58tw70keXhQtkLhogmGECEVLM3I3uGCcN4PFjHGf9
	pySnmGNjXKPIo1LPVoG/dgWhk8n2gfbBj5V35/KhhJ9IGP0zMWCR/STNrTqb7aA2SsxSEGWIN4L
	nR5Jfr5S5GE1HWgVZIPumoC7iu36rDq46hPcGGq9eb/qccGXAoouXOHpou40rdwOTcUwdO9CW79
	IK3SyRr2giOhY6iYPA2hK3arCVfEXJGn0YJM7CCjvKpaW19lGH2DrKkmoeKtKIdIqeCkRalcJbc
	IZu2KXDEbFWZka1WKAngbzrk3iZCz7rSMwl1p+OAqQ+RyJNCABG1Wxx64UpEML8aBOg9eVA/2A8
	S2vdGhsn40EvOGEwN+LwmaI2Cp/fx94g==
X-Received: by 2002:a17:907:26c6:b0:bea:5ce6:4267 with SMTP id a640c23a62f3a-c0b74a83ebemr698183966b.35.1782146396793;
        Mon, 22 Jun 2026 09:39:56 -0700 (PDT)
Received: from [10.178.4.71] ([192.19.176.219])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c60bc01d2sm379776166b.31.2026.06.22.09.39.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 22 Jun 2026 09:39:55 -0700 (PDT)
Message-ID: <ae8667b4-8bff-428f-a725-44f3d1fb8d8b@gmail.com>
Date: Mon, 22 Jun 2026 17:39:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 7.1 0/8] 7.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145523.335696673@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20260616145523.335696673@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:55:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

