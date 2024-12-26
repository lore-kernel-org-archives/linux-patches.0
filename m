Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FAD136347
	for <patches@lists.linux.dev>; Thu, 26 Dec 2024 17:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735232704; cv=none; b=bHNuk3YLhi8QDnsEzSliK09v29J2tcL7BtrjaS+hzeIN8jOYU2O8GGd+i5uMgtZr9VQBKYUSdh8Q6ltn+z3zLp80M+GlIkpyWAXRUfMBtvzxLIwOip0Xx6TJrWqLDt5zirHSJRRwLr+nEH0p6vhUaTedQvBUo0lZiSJHDfjIlrU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735232704; c=relaxed/simple;
	bh=9A/6PzajXK5v4MXEyYgp9WroyGXvmy32NVlSU5Sq3SQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hkvwJOKAA71IAPIbBgOzhbHHLcKBjdacBNUccR0Atu72E9vOPjNx0DJurkzzoh75rp4A7zAutEQJ87H5Mt55FRoWhFMXJaB3PGFyAmuCJ8FM+131dqnmn1ZK3y8gafmdqxOpeJZOEiV+BPywPLJWXQIeaPJwtydEZ6XKIwnEbMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B0VswGbF; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B0VswGbF"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2eec9b3a1bbso6037120a91.3
        for <patches@lists.linux.dev>; Thu, 26 Dec 2024 09:05:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1735232702; x=1735837502; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=shCuTrBPFRV6aWt1Qyudh0OpHYaMP1Vq1gdc2qO8gV0=;
        b=B0VswGbFWpGPCwEo+tZkQtD80r9QUe1Jy42qNp+zJL06d29imi4IhauwqL5wtp9o1u
         1sEanM0U4DDIx461vvRKmsyMtNW42p0Eqz888IAzaZJHR7fzqTNx2Z+EYxKaoKZNGDZD
         qUPsb4qPB1JKRCyS6TmOj656WHT1qgY+3nuhoC5JrS3W++TboUd34JwXYgU/kw/l0rO3
         fgOtBgRdsmUfdb7oUcYjSE20NsMRQ8INYNLYmuplToosOoiC4z/pFLpuWVh72QSPya+Y
         PhS/FVKdmz5p67vUbKzmwtbUAUerR+NXEFNYZFfCnqrLhB9BEf+plYisxGOC/NpqUVjU
         IEDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735232702; x=1735837502;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=shCuTrBPFRV6aWt1Qyudh0OpHYaMP1Vq1gdc2qO8gV0=;
        b=gQ8ORZUZXA62uhnhmcUzjuflFu+aoiEAYx0OCuuCvDueZTwYFaLNNVktUaarIu30/S
         617821K2uopvZn3Hucgk/Opfjh1kygVmjD2pNRaZDyThQA5bHyxcgIASU5LDP2oQ+0GH
         Y4Wt1iLrpXKvAElachf4hDt2Ez0eMqfS6/T4acw1uUPA1WM+7bVwd22+14CQ8Z6+l/lh
         Jd8lP+ZfRSaxPS6ExF62VFSDsQQU6MBTKRzEPwJ4cU+qnMFpT4SNbJtrsLgamBpSSk99
         +09H+Ni/M2BME0t+nDY3VSagbG3fIaMTIhdBRAk7dfmagMEpDXtgn/glhrYjaxIVNS0h
         l2YQ==
X-Gm-Message-State: AOJu0YzVw0EEac8lW24nQLH9DLasjH+3ied/xZXt/Dq1RVrurHK0/aKo
	vHWSmtqWzL9R1Tnp6QOfcEg3ha1TqEsBnISnZ90OLIjOz0V+nWYg
X-Gm-Gg: ASbGncvbjlDOhohF1lzglWUStOplp9l1sOZgdINasRfI5icoL+p98nF2HKgdPjNDaKk
	0euYr1hjr3m4mXeHRMELrC55cRr4q0xYDKxYaYK7qwo+pkGBWev7CZXnf/nphxJk7SDs4mr16y0
	+UyOR5vD0d0l+4gPPY2XdndxYgalb6hXdBse76FNuVK/ZNeOK+ewt74FTqYs7YCAMChF0qEZS0V
	dDLaCVfFF3xozhvdbPTMn/llSbAuEBCeyrw2rmDQICgBLWruCfDqD7AsfiO0fZIBezX2e04zemU
	IimETaO/U9k+plyyk3Q=
X-Google-Smtp-Source: AGHT+IHh3SDf8LNdeKDwt2IlivkjP5Ho4QllWL86HnVR8gf2ESMAuP3EwvrFYqQqKWrKagwtQj3+7A==
X-Received: by 2002:a17:90b:2802:b0:2ee:8358:385 with SMTP id 98e67ed59e1d1-2f452def795mr35817629a91.4.1735232702438;
        Thu, 26 Dec 2024 09:05:02 -0800 (PST)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ee26fee6sm16143662a91.53.2024.12.26.09.05.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Dec 2024 09:05:01 -0800 (PST)
Message-ID: <69070f57-1f7d-446d-a77f-495a18ba5b02@gmail.com>
Date: Thu, 26 Dec 2024 09:04:59 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155359.534468176@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 12/23/2024 7:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

