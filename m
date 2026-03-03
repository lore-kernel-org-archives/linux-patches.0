Received: from mail-dl1-f45.google.com (mail-dl1-f45.google.com [74.125.82.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15FD3BB48
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 05:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772515495; cv=none; b=GGWAFpSgTn3ZIjCKWs4tzOgyiYCILBfmFUhv45DN1VYtJcOnki0frrA5Ny/LZDNX/IkvWZpoHVXx9KjxlxBDsGpbNVg8Qt6zBXUfuD6x+UCV1kJ102LdLggpfy4L987iZZVUETlDGPiRUgRCxX3Fq4XlyTBLtHML3iSp/axFMkk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772515495; c=relaxed/simple;
	bh=OmgczhLsscjudCIyHZjfg8ToxzB9uU+YWccAwDwgMt0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AwBN59GBj8csniiFqhEAiKxCT6E7K/8xk7SXYmZtQCVM/HfRH3iXSHwQAMz35+opctYU1d7N/AoVN1Z+D/W+avjgXG1kaCSuSxxGii4cV2Z5N2JbuAqR62lklZGvQhiiybePs66V0BivQl593cs/CSeALYtphQP0EO4vYiH121E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SCADNKQj; arc=none smtp.client-ip=74.125.82.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCADNKQj"
Received: by mail-dl1-f45.google.com with SMTP id a92af1059eb24-1279eced0b9so2479581c88.0
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 21:24:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772515492; x=1773120292; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G/yAR5+sTAGjfJDr9FUPTs2m0JPIoNox9adcSPKnJL8=;
        b=SCADNKQjtIEopkPbXD0/yFK2u7phbLu7Mhgz5CpZ7crpFm8/k6qPsJ4bNQqfvtMvcM
         UilB/flmSKIF8+hy9wbj1FtZGsiiOSlxQzMUU8zRYAB6RyUjY7PS86LOiqTgJ4P8nnMG
         6WJ7ptQ2t5E5lmfexgXTtTp2FYIgjGQqPiIK0nemnZmQocYO+qm63/U4FLgnHQam5zL0
         SnOhEnbJt2kUARNh79C3CNf17m0qy7mJsaO9zykpgTo0JmpUULX3Spj1WzVHUTWbp0dt
         8jrASFJ4RCnWDPc1n6ZxCCInhabvyiQ80uK7ytNgB9H/AAZlIo2/o+n01hmNeMFUnnYd
         w61Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772515492; x=1773120292;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G/yAR5+sTAGjfJDr9FUPTs2m0JPIoNox9adcSPKnJL8=;
        b=HBnHOi5jo8BMpUikZuak+iYlk51eCv9W19wPYzt6DfS1h05d2hLxuHD2fulVFdgz5s
         w1bsCYbCu20zT+S1sirbuk4NRvzeaywun7H8ylSSxnFJjUWekR46Hg8+FLS/XwF93hjw
         VM3uOGOXzdSgSP4QbdJBj2ZLssd8dxVshPanWsbVjRmDI1yieXGDxxNMFc0vWA3xTBFP
         EskCpeGuFIU62tfAOVeHiF36iRtDXaeaW2K13QnHP5YDnv3XW3dWdt2Aa4XbetXy9lq4
         fi41nSIIl3XPETnTehjIWfl1YL0We5pz1MKFrtfsSrDqlOwZcEIa1PUOLYtGA9tsk4xr
         1Qjg==
X-Forwarded-Encrypted: i=1; AJvYcCWn71ycIZbunLRUyKRjbYlJ8SSeA0XG3MVs5KjSMTOEqYyw4ZTNcxc4A2V7axc+dMABa3Vdt1Yb@lists.linux.dev
X-Gm-Message-State: AOJu0YwMMaQYngXYffmzK1J5EDi+VX70IkbwdNlkZBdvb/KmCptjW2TH
	GcgkXbNJXG99Y8XSVnnLquARiWSlKpcSkyWvyW3/cLc2vxMnvTSQVaqJ
X-Gm-Gg: ATEYQzx4UCmOxdAwLbYSv7YGq2Vr2GJLcvVpe+JWbnDJSGZW5/ZBvoENxLaae6Yu7rP
	TGiwYDXIZGP4B03zqmAaPGsIQs8aBsIj8wSgJOK0Mz6C8NKVmP+RJhtZJZXZpEb2b5CDkE1a1F1
	p0ndv7fI6fKl3au+RsDiEZUtS9tzrJV35G+kTL011sn7OvKcixTS7AdFys3R9hLqRavYsmyfQVF
	m0FaqBk3c+5rvSCSbc3/Swj2D6jCS3nuOKy3U7oKNHfDuxQcpBk1q6ccWMPXcqDxnFUWV/+FdKa
	Dpu2eiZzPE1r/a0VVu1Cb01BxAjQtdAVe8WurtDFJJ2JnelXTKSn7zGdZ8EWZXUy51XJb0d/A83
	aLO/IV0swC5FrL3Q6Lh56R+FsoEcu/3jgku0uqcSxp+SEADog8qHXXzvLUx7jSeJaPjfyfXhQRt
	wXh2Xyk7Am1RMzzng0iKiYW5Iu3UpA+nbtLtGd8JA5LYfpTvhrRet5KdwPy54J2NaC0wLk+Fjf9
	r4=
X-Received: by 2002:a05:7022:51e:b0:127:5cda:aaf2 with SMTP id a92af1059eb24-1278fb77ea5mr7022543c88.10.1772515491832;
        Mon, 02 Mar 2026 21:24:51 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2bdd1a45a58sm11959744eec.0.2026.03.02.21.24.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 21:24:51 -0800 (PST)
Message-ID: <cfbc3f02-863e-4af2-b402-af80185d5e58@gmail.com>
Date: Mon, 2 Mar 2026 21:24:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/757] 6.18.16-rc2 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260302160853.2519610-1-sashal@kernel.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260302160853.2519610-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/2/2026 8:08 AM, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 6.18.16 release.
> There are 757 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed Mar  4 04:08:47 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-6.18.y&id2=v6.18.15
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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

