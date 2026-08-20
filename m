Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 696F33AFAF4
	for <patches@lists.linux.dev>; Thu, 20 Aug 2026 21:46:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787262406; cv=none; b=hIAU4oZu9GS2HiK8K1mQVkvySnas+iUq+v/pB+Smy684owVKoe0gKnVlMRfdG5Y3u3z3nJdCQoOizKdFJxCAYRTJbC2zoyaAtAqZqSHLLs0svbRs/JJzA+23016YLLPuEv00liv2qOny+nixIKew57UGmkIJ6HwsYInlp235F4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787262406; c=relaxed/simple;
	bh=2lT6OB/GtPMoBr9FD1+AT1Nwzq6OXqGxFpN5k/e6z7k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MKWPcxZLPXnQUrCfsfgw7NWi5gJa4TQbeuBrd0bxMi07mVXB8hW/GIetxU3ub3Xy5smn8lRAl9bhIVC+LvBzijGN8tFqSTC4D1Ei7j2/va1Jk2CDTy2xKQxHJ3oRx0BTRqcUmoUkOM4WYFryQDBg+c2IMJ6eoJKEFXq86f9hTIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oMZ0qTLO; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oMZ0qTLO"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38f0f132f56so1015947a91.0
        for <patches@lists.linux.dev>; Thu, 20 Aug 2026 14:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787262405; x=1787867205; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mQXCqKcyXrhHXx5UzddqfNL3pKWNMmyEzCsuSg6E3xo=;
        b=oMZ0qTLOHwlUsMxAZnD0scQer1VnnlsU2epJ5pJEAbk8sSERO3iYilqSix9J2Nszoz
         zLObjxsO1UM+T4WFQdrkpAFUvxyXurPw9yyiNCeeQ5Is4rD5qwRPR4ZPMDcttcZTjGQU
         mmc8IN/lUXMMxPi1JnB7qRDspuGTZpiwCyfVtgm3HcDsc9xRHY1dYK4rt1Timvb7FvXz
         Vu3XKk8xJv6n4dlc3Loic2IBI1V2Qlku/W/KpRYsskwpmJ7EkNiwMoZUBh9HVBW6R7mo
         QtvEdUW8RQ0IYy+L4/bn+9FaRiB+kf1AykpncGhUIZLodRHA+s5DliaHDGpc/gQzr5OB
         BRCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787262405; x=1787867205;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mQXCqKcyXrhHXx5UzddqfNL3pKWNMmyEzCsuSg6E3xo=;
        b=Qdinisj7bul1lkVo0zYuDZPtSeyrV1j3LQVNGVrXh/1oUI86C/bkvKvXNSRFKnyeiB
         4wnYCm3yoR4hf50hG91baKltAN5/5XU6x/gzCe8nvAhToWwt3+nfpt2vhXJGV7OXgzSV
         60hMzi7Iq9nmrwZ9+41buUSlRVsY8CyU+cOnLItLYgC1JL61IxH7vwUXXpltZWOy+Zrh
         1XFaV6a4pYLJrqd1qCRKMHnbXXcOl0lDrh1R/n8juuRgssbAr2gJfWCXBYGhmWdlpxmf
         mRNIU/GHl6W6T4777qdNyRznPln904L03AHoOvyhS7mWXxhU6wlWTbJIMWUWcGduWx/c
         ruRg==
X-Gm-Message-State: AFuF++n/MX5sfFILMnkPDCMxKLbqQzlAiHBP2V/GPche8fnmxFVcPmKz
	L7VtcytbDyrwlIaJ8JD+cxLz5anpg3DWj2wYM7GJNvMvNyaqjCabffvP
X-Gm-Gg: AR+sD11GQFUpPASf0auMTaKi3CQXPyoxATC46XfzLGtZA4o7NvqFPiVq0KOkrOAlVQF
	uLQcbQyus2AJhmaoUjF6AXvrMA3hBsJZAOKDuuG7s0Bl7oZtFubs3GEYlECTc+zworNzH4UrDBw
	gUw3t6uHgZIeygMjr+iBBRcVYe4YGrBiWOkcKSqMTxSe7MRYbBDUKqAr2AYbzw2VDjX36AVY5KV
	nUXjWdL2SxlhmFo5DV0sUS8E1kIb4HM+LlCi+UaAIR2yQBqd3FVYCjejaz5wEo2O2CZGm61j0gA
	Ao3CQJ+VLYTm3BvPEyv1H0eed57KVY/k9DkG6bwmbzH58awofAjGEPRi+aWbaCpyimHSAp/YTOD
	r35sqVuDSIr33dhOxoUfFue2rsK7vZ4iISVKmdLnERydb5zivHrvLbYDT31f3jgtJOnIXWp42oB
	oQL+8ruvk0KHUoq/MW4xOt8xryYl4P87fSme+50StIiMzDTikHNEHKP856C0d/dfTLbISL9gHGY
	W8pKkc5vq5S08nfGlt1bjcDZw==
X-Received: by 2002:a17:90b:3851:b0:381:10a3:8b10 with SMTP id 98e67ed59e1d1-395a06ac272mr11204850a91.14.1787262404673;
        Thu, 20 Aug 2026 14:46:44 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-327d01ff056sm11764692eec.19.2026.08.20.14.46.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Aug 2026 14:46:44 -0700 (PDT)
Message-ID: <2fec5509-7247-4279-8973-2183a6f0ac01@gmail.com>
Date: Thu, 20 Aug 2026 14:46:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/228] 7.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260820145244.450574346@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/20/26 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.10 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 Aug 2026 14:51:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
