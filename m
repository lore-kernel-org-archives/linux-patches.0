Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9111224677A
	for <patches@lists.linux.dev>; Fri,  2 May 2025 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746190565; cv=none; b=puKdBA2prapzDCznNUFaLg7q4Unrp4zpgj+ImtKjNeiXl6Xr0+mu/5O57MY4qJASTfswIJ9boWiPA1yc3vVGrTCvoIGbAznlEPX2TpOXKRacAWjd63nJAUviFyuUmj4+XZOavS+8zVWT8vt+yapT4IWMHGhnrUNhymUB5zrJqC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746190565; c=relaxed/simple;
	bh=T5RCaQh1OS1YVWXXdYqLrdqh+D9eSumycnqxc6D3umQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qKUWTvWyNkeOerxA2Y2y339xP8UN7KZ66Sm/LtzwJBR80LzQeuY75jWL29XkQkfMSqjAigHDtdTvv1kvM2o1r8ZLDpYRmtIVoI73UbBrKqofmR1e/2XSobAKAS2a9IAtgo5QD1fN9DTfLFCOkOADvT0KIOLzBunOX5CKT0N9l70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TNKrJUPA; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TNKrJUPA"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-309fac646adso2926001a91.1
        for <patches@lists.linux.dev>; Fri, 02 May 2025 05:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746190563; x=1746795363; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=uB/hNXSf2TW7hHGTMgSqzWRu2TdmA38pn6TeFi8PGBI=;
        b=TNKrJUPABuI7o8xR6kP7iSqSRaoywVIckjCBTvieJIdlk1/T4RDCQXAW7Ir3J57crB
         JbnXkvqSrmSsAQkKOwBVsmTQw2boP4kjkaA7NTaXOI4igesfB13hSsR/Cs94+Bfm1G/+
         mPunuxqdRFj5xSTqSzHkPqkwLh1w39HY/PplxqGWOeev30y5cO3m+AOYhWefq0eBmPUj
         ECYqJDw4ewGu9MCMWvBLUuS2MQzes3wwVFH8AlWBkRjOv4DvKRcHZOsaZlj4t04f7GMW
         BU75x6x6k34mdxHZnvEp4uv2qRyglBPKMTTDQeN72GVHMfvT+f63ad3Aw7F3MPZql0eP
         0Zlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746190563; x=1746795363;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uB/hNXSf2TW7hHGTMgSqzWRu2TdmA38pn6TeFi8PGBI=;
        b=TfQrVu1oONVnH/nZw4dFspIFSEf0eKyyj91SLqJEq5YoMF1CCVAG/YrDBEfN6AQoad
         qfLTLw+pQ0FwVvnm02kAN0HbU5+YoHw+JZ/aXyrriS7D0V36yiCkE26faRtCuCeKZ8yT
         9TGRwS/9VILJh+TAGalHrCbmpZXaS4NOs7rKCs+OFxxDZmq4u72FxiQyM4EHOFPJiWdW
         ezSwK8R5qJi5ZkMeihNiIjzcAIiJ34aHnNvd/5VHut9j/+FXO1WFz68OdAawxuzCZQKb
         aTyIJfKu4BfPVLk+iDlVFN+Le7+rfrT5GQD4NAHPXgeNTrE+kYzlgK9QauT1wyTETU4r
         TzTw==
X-Gm-Message-State: AOJu0Yy2E9u55Mdm02DxA6oXJl9U0FItHYdTWP21hgdJq8fcZmmUAyNM
	/PR7M207CsB79nPCdAYWPxpwJ3asgso3KUS6Cx7AgRX9tvuBXw2X
X-Gm-Gg: ASbGncsQi9CuBu3O6MlJHpxfhRNMiwAXeBXIaTtsO9QQC5XmclDuwR56iR+K2p/JGP9
	eCWiclwLP0TOlEL8T9VJU3hWcMlX3W64a/+EuQePk6qMrUboXpCOPkUvmbpWSZsDJr+0XimBfj4
	nYmGUE2sV0os+SXdOV6MstEt9gX01eRcHs3/3NlhTjrrTkurwGkhkM2XCLytj24ljvOCYJpc34H
	IkWD6ySMTYBI6ccuEvGmI0xHS4sORLAmXH+wvMp0liMiZ00Q9GCHs3JVKyyhId1d18JC6ke7zmr
	2tQPFba0kF7MjbZRl1sQYMiM2y0pwQ65y+xoIbkJdx+plAbfiX6rTjrVVz7PoGLcoPNaOiOJHOB
	E1g==
X-Google-Smtp-Source: AGHT+IEZsLyuz5gPjySkbBTwVbbuiFfqFW70gHuZpGjmgca7zpMRw2fN/Bj8nQUWoG6avxHD0ZGu8A==
X-Received: by 2002:a17:90b:2f90:b0:2fa:21d3:4332 with SMTP id 98e67ed59e1d1-30a42fd0713mr8604445a91.12.1746190562757;
        Fri, 02 May 2025 05:56:02 -0700 (PDT)
Received: from [192.168.0.24] (home.mimichou.net. [82.67.5.108])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a34826755sm5575486a91.48.2025.05.02.05.55.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 May 2025 05:56:02 -0700 (PDT)
Message-ID: <6524f500-3fc2-4301-8702-8999edc99306@gmail.com>
Date: Fri, 2 May 2025 14:55:56 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/157] 6.1.136-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250501080849.930068482@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250501080849.930068482@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/1/2025 10:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 03 May 2025 08:08:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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

