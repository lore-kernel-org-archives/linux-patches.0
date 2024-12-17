Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C18731F942E
	for <patches@lists.linux.dev>; Tue, 17 Dec 2024 20:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734466906; cv=none; b=HP/A/DZjW//qJtoWrArxnbd5gCBxu53wvQwD7tjAy7zkWXKrco2Sx8JSX7zQtHGnQ8Uv9iJmgXO9aJxfbXtPeznd0+uE3LZmYV2kgW34P20jFK10kihjXYdEZR7SCno9Z3Br5TTLBlP99CgjNRM+0kRTSApcM1YH+5iNj2ebEiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734466906; c=relaxed/simple;
	bh=agT8eWGMj/IgFN3ggsf2C5m/AKg0Pqn264+e4oPJwz4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i8L3BEqogdIe3RzAAttW7tteB0T7KykELcm4bb5BesyTtnvMwnLt7n3ZaVcqmc+q0oZSM0sm3/8iGf2GCBo0ASCF1KQzjas9bfksYxYbH2gOR8b3wawpUYiY3F8Jr6VKbpxp90rqrKxO7gwEz80OngwV0iApPSvn+crWy+SGnnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KVGYfxc9; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KVGYfxc9"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43622354a3eso40327485e9.1
        for <patches@lists.linux.dev>; Tue, 17 Dec 2024 12:21:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734466903; x=1735071703; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=3SrVH1ogv/0HKKAXcg+vVrcc6mwA8k/OcLLwOQZtTQM=;
        b=KVGYfxc9gmcPwF/iEMtzpSUzfz9ag50Svb5oK/Qx8lo7HMpge+5uy9sQn9ybj2eFam
         Hqk/OiMtkH49O/Y60Xi6ZQvnKdtB6ArpLzaJrJ6M76sg8YlJTw5dKKM9j9vwRid9kTQu
         BFVMDAoAmWclLLT7rQMiRR8ylUpeca+UsS3fprWV4haJeIdPFnpd3D621KodKP06CRpI
         BBBZPfS9+bXW8qxLszjwXYg6DB9iGx0fEqz+F4vg/mn62TYLJMzjcD0GWMkyKiBTodkU
         NsaVqoBCM55UtZTu5cKzPCQypCtUGoBXyE/gsaFq+PVIN8PgsRqlYaVUWPtmVFxyoT41
         sWBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734466903; x=1735071703;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3SrVH1ogv/0HKKAXcg+vVrcc6mwA8k/OcLLwOQZtTQM=;
        b=AFytUqYFUGux1nwQG6e0h9jqsnLoEEHER5RE9vNTWOvn+mJNkxPmpP3ps22mvTk6PN
         thI10MhxDFk2LqTMJMiyk1CcbF2Ni2KuplnSigehUmau+EGFezAXi/gWCEtvznzO2HS/
         xg2HehU/3c2jGjxXJehu/zo3pMWZKvCZczFnoNKTzBTm8Vj55GQ2vlPNJfL5Zq2RvdQq
         uu9B0+q/gfQYrZzf4vzskk8jRXV+FdoOvgWJvdKeNj7kviZ/7xLUQ4dWnIWjVssS/yhh
         WMDAkR3Tm8ECCGxkIzKbC8qnWOeeaq1rGMRygkmdL42YBu1gakL1x/YGq29X9bC5YO23
         aY+Q==
X-Gm-Message-State: AOJu0YxlF8KDuhqYNIc2mtgscriBppdWMznnCEPnxWUUXnZqVqjszXUF
	TfO36OD5+jeKP07S6+ye+LdzsOTmGIVSozMnDETXFljI8yjul47H
X-Gm-Gg: ASbGncsTU7NrmqVHj7aFYszj48H6jQfoYE7Xdd+iJRKd2HR5pdcEjzlseg5jNcSvtni
	q9pYJe2XpfSgEWEOBRktoqXLvL6HjRfyvhC1jLua7uYuodU74iu8sbo/kFjoIiamfR6sjSGvJHB
	oYda8s3DMz0g/YV9bWcYuaBUhhnGUI1h6hx3sp+2M4qDYLjHNPPwIUICllxEWGy0Qjw37LPRqFG
	fqpAdUhbgEyti6+4eCPs83chyWEzdcSIDz2TR2JnDKYhWfz6ww7MXhYZGQC23GeQ9ut+7pHTjTg
	wbcGDIiY
X-Google-Smtp-Source: AGHT+IE3SiHJy/aH1NN9e0/wEpk+tFK91XI00NEQT+6sU4Xyd2W6jg2mcnmB229Ymf4mP07DcZ4wWg==
X-Received: by 2002:a05:6000:18a4:b0:386:2fc8:ef86 with SMTP id ffacd0b85a97d-388e4d41d82mr227693f8f.14.1734466903010;
        Tue, 17 Dec 2024 12:21:43 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-388c8012029sm12002041f8f.12.2024.12.17.12.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 12:21:42 -0800 (PST)
Message-ID: <443815cc-271e-46e7-a668-14dd42a8ea70@gmail.com>
Date: Tue, 17 Dec 2024 12:21:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170546.209657098@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/17/24 09:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
