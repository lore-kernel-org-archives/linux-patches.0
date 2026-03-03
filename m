Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7240F285C8B
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 04:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772513578; cv=none; b=OoM9VTNkooB4oODLTugHuzpE3xMf2+yu+gxtnKOO//mk4MiEtPuHu7XVnxj/BBADE3JdebQZonyIY7QNnr4L+RPMIHD1csWNs/DWe20mMW4PR3MhqZQ+VRIZzk5SGPkMpvAE1DlwtIv6UIavvgcdUxjN7vqxJt/Lnlo+18WJ2RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772513578; c=relaxed/simple;
	bh=76pU4yOTUlCEB4N6xjQe2L4sGaw5m/1Efw2KjH0jUE4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gBhlXaSNuhCjtXj6NRZrZZm3mCkozguAxmAzX0lCACfVtZp7GS5btq+iAVz7LP8ztE8zUaMvkNVaqk7w+Vu8GXWQFX8tvKvr+gpkGOrfvyCxBLPS92AYIAu+7sa0+OtNCnPtIF4/boylBXVuKS/6tYmxHnmd9LHZMUrlxgIx2bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZijeQlR; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZijeQlR"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2ba895adfeaso4542725eec.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 20:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772513576; x=1773118376; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q6gtj2vVqjmj8s6qx/7E7Q2PARo70h++X7UZ1hY8M7w=;
        b=hZijeQlRYelSIVxmFCnwEnDG9oXC/jsDorlxcYjBD9v/pXTirW8Z8U4T8lLAEED7kE
         PY5Iyd+UE/gCAixm/McOTEgbEGPHgghutqZnjG1Jou0zr9nkEBtjvcZcFTN517K/XbLl
         x1huNCicvMgikIgCBHw/QtnRVY5YTFjbe8jZ5U8rHtFknAezi7iSVwCETXdOSaNewX7+
         BXW8u9pCZP6cCl+i4ArEfMl2sCfCN9jDaHtq7YFs/fulKpw8EKbyDIaeMEkZrCXaN94g
         0lKyY7mlhrEqJYOMqsMGqOBUQZMzjUgYp+pVBqItgxN0p9OyaF/xXrGgk3OpoOKVPnYr
         gGbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772513576; x=1773118376;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Q6gtj2vVqjmj8s6qx/7E7Q2PARo70h++X7UZ1hY8M7w=;
        b=QIUscWp1jq9p9sROfLIf6A5LdfFfAF2N2Or5LXYA6O2QQYGHTs6XT28My2+MME0sCP
         Q6/n7JnvRG4uaqOcEyTCZ8fTl8gZ8+udAriCgSq8RH1ejFsIEtVoEjdb6FMgWrL+PCfn
         9VXhifdeJbSlvdF42ZwlHljBX9z++Y2lJdCdlzG8B6dRlqcJkb1nmiFH7Dppw9govQ26
         F3b5ZC64mmsRHn3kUjAD28b/poX630YtGbZQg0ACIeDNt/y1rKkosbuJdt2Rq38eCOD+
         qBJLAZElW2fQjA07FoOTo3Ls8RC3XMly7ezfU7splRhfPCoc8uRVSfg0i23+iKASObPf
         vwNQ==
X-Forwarded-Encrypted: i=1; AJvYcCUp9i69Tr0fMz8n+QnrA1uIqDwaaerH7vuIHnqLHiX/7jLrEenq6LdfuBWuIYiUWaPnRpQmchZc@lists.linux.dev
X-Gm-Message-State: AOJu0YyBInLRQhqxzPedCBZVA57DlhaJ01R9TWcQFDxrjqgfV+4NDQMK
	F8SIl4v3AYtL2bXHVUDU+jrJgYMBR/LLCGCscPh4Mo6aUqWLFvPP7tan
X-Gm-Gg: ATEYQzxYC2uEKX7T8nKzC/fNmeyykU6Ox6Gq7RemeNnb6yMfkrmKg2uISdQkKonDmrQ
	hkptW/mdMHVDQl68jvtD+kvk6fq/gBh9gQoB9PzKbELuiXW5gfA5dhgb2wlll8U+XjmyPDZfpWB
	ivUPBw9CPrOfwIDxVvhbAqJe9oZMCSlJ+4JDvULw8D+SSuuvWuoeYYqVZUk/wuEBRihyG8LNukD
	dAKKl8QmXJoSr2YkHZlwtoJ45I2PkwGSz0wGUFy42MjVin5//Am983raXMLyRurFkGd7SogkVSs
	zuaH0csJda+bX88Tujkk7I/fXspC4p0YVsrPt0un+7lj7qzVvlqzgS7S1f7n5iLgA18DET8FYv2
	tJIgRxMOL9HzTv3AAf81H1Zb66eN+OHXtCXxjjkwJmo1uykKba6Y7l322a7QkoX18+CKdctvPKQ
	wUr5tZoBxPImTtmqkfLnZg371sNua536HkMLkN2WkLACQJzA8CLsiNvWngnsofGqk5
X-Received: by 2002:a05:7300:6da6:b0:2be:1f58:329c with SMTP id 5a478bee46e88-2be1f584074mr939914eec.11.1772513576371;
        Mon, 02 Mar 2026 20:52:56 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be002ee839sm7755255eec.8.2026.03.02.20.52.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 20:52:55 -0800 (PST)
Message-ID: <5a7d24f1-bb84-4dfe-a979-f7f8fe2ed54c@gmail.com>
Date: Mon, 2 Mar 2026 20:52:55 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160943.2522184-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/2026 8:09 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.1.165 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:09:42 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.1.y&id2=v6.1.164
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

