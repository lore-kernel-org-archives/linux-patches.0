Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1FBA2222CB
	for <patches@lists.linux.dev>; Tue, 30 Sep 2025 18:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759257437; cv=none; b=fI7aXzd5EE9uFjm5JQn4LVjf79cvoLGAheLxkLiMQS1NBwfa/UCLLPDpAWS0J1IvcKwDxgg63f16JR0D6qts3jQfCTgxd9JLphnZM87rvNPIKAZrDZAuHJkWG7jFywRb/rTPtCSkLuNxG6Ax04s3EHtq/ayjxyIoeB9LaA+6JOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759257437; c=relaxed/simple;
	bh=UzISaNqBnr6oPeKPZ/ZMlptaIWSDz7JBW9vqCatixqc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S8+irewYPOmTzz6o6+i+j2E8rBqCa+z31NlYRyyl4Wlyq6FbiTfs6e55hg215ig7QeJqih3208eHeEzDYebfZx0+cHioLsmj3G5EcAV3kdaduN6Bkjdg6i2bf6qpYm9EaENTmkvoRUt1Nqn75qQ3HLuCkg53AOaAFEs+5CeZ2wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fKSwe6Vm; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fKSwe6Vm"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-796fe71deecso44067266d6.1
        for <patches@lists.linux.dev>; Tue, 30 Sep 2025 11:37:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759257433; x=1759862233; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a2QGQGEsrfTFXVfCocwQk/OlKEvR0Qi5M6Cv20Qoyek=;
        b=fKSwe6VmQFCXslpam9yOnlepYznpO0EUKJKNDB+60YMYCdTvS+O5hEDLekmlf3SWcu
         PXnbX/DRNqDQ5hAQoEvKVDv7ZBkMqKv6PnF29x7QMhwyc6B5wDp9h3leG0By7s+XTH5N
         032n2ycupDS5ZxIT0VDFkiqi9Ho3f1Zcgubn+CBxW8dfnbIk2l6SO5x38tYYfUYDvXaW
         xdZ7B+65rrhv2506cYEyjBb5Zjs/86ogJr2J8KA3ElRsWuChf0irUD2KyZBQnJd9KkH9
         9zrYSCfcSOO+MKmb9KZEhMqzfoWnMFKsncnoZI3lxS9phS09NczHIlv9p3VP2BkRjU/v
         GsUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759257433; x=1759862233;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a2QGQGEsrfTFXVfCocwQk/OlKEvR0Qi5M6Cv20Qoyek=;
        b=vEbbWLIL5Z/SvlXJz+pZoPwRrtjhKP4TIpF0MQi2eCK8naZU1bu55AojnqHE/wb4Ay
         +6U7WQu7MDNe5hIqF/ONi0TszDN7fTuZoOpTnS36hg5S940O/FG17FarptdeWgrBA4fV
         k1mCKFv9OS6W8JqUaNaFNZlehrJN6+IH4NEr95t5zgQxDiPXkxcW37W1hXCt2u3MRID2
         fnBrS35RnmRPLIYXePLTKD8xUmEPOVHKzrcWS8EnuTp0mC0R1kXZu6KMhlfVAEJj/Amk
         GSXK4PCcIHywBC2GARveJ1AnjVxy0XZmD6q/S3+VZZHr2t9xHydKYnjcbr49flxTlMpp
         okbA==
X-Gm-Message-State: AOJu0Yzn5xIw2PllhKuvbQPDYaa6RQDKIHPB3kdYVYI4Hpqa8xfmE6St
	FDwmo4epRR/W0JiMmMU24eFd2SyWVDI1ME3XLNd6+Fjw/sjoWN0q4PbE
X-Gm-Gg: ASbGncsyPnrek+LMQXFzGzrWzfCUc+aD5XkxR4WiCMpDYRT5LbzFZfEWAxJP74aJNck
	CJ4vEhtSRQOdO9CTWk783crlp02nvWeNIibnPeFW8TgNWrbsjz9+UHhIc2oUv8PHSzCd9uoWNI3
	w7fPYb4WziU4JBnKOwqWPmgVa4V6XGaffYG/OwxvWykcBwCm84qU2wombHzsaRAyuaY1EvYk9xZ
	0p7pxCTXAhlBmgJEIdfwYaBl0WaubgNi30Wz/+H21/1jXWx3Afxt27bgstZMc04kOoing9/M7Po
	JVs7u2WNrjpxqj+GKlX4ruX6XemN0P0IloDbkwXwhY+bQFLXNK53ypVX4aFSVucaTMkMHTDfE1I
	mU0tMUfEPwjZHx8/pTykbgzwkMQJ1hlYN3dzPG7rEloVoHQH6xbocgf14obE0Ak6qUg/EBVMMZB
	2AOLAJUYY3
X-Google-Smtp-Source: AGHT+IG1ZzECb3HDDfSi//Asq0waIXTic0POdoKNFFJPYCDQ78uGhB+aw9swukGFQsfSRdJwVYvYxA==
X-Received: by 2002:a05:6214:1bcc:b0:7f1:c596:e1cc with SMTP id 6a1803df08f44-8739d051ce4mr13159286d6.19.1759257433401;
        Tue, 30 Sep 2025 11:37:13 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8013cdf424asm98541956d6.26.2025.09.30.11.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Sep 2025 11:37:12 -0700 (PDT)
Message-ID: <94f572c9-36b8-44c6-86c6-cc28f90de64d@gmail.com>
Date: Tue, 30 Sep 2025 11:37:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/91] 6.6.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143821.118938523@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250930143821.118938523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/30/25 07:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.109 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.109-rc1.gz
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
