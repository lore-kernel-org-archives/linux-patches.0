Received: from mail-il1-f175.google.com (mail-il1-f175.google.com [209.85.166.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A72C4278E68
	for <patches@lists.linux.dev>; Thu,  8 May 2025 15:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746716510; cv=none; b=DZkWC01w7lCOuRgHFQ/e2uSXvqjFEJoKGVNmBarUBkALMw4ctYQ4dBAegBuBWYjtF3xlOyoW/6DVLjzsRpg2Gpyl3EvIsNNc6GO9YAxmseOCTibx1vINcTfGlpJS23erKV4vjaY6lVEfIuVbBM+okXa0Mt2zLJ87EPI2kQ6XJWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746716510; c=relaxed/simple;
	bh=JqqemTbAWfFy3G2dBsz3H7ba/gEl9MKRPBZd0Jm+alI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oA7Ht42RwbRe+uAyrqMxyM2Rc0vGc2DmqCYF9saEY7nhVvva86i8pa1ck3WIufwcbsB+0Z/Vg4xVyU1LvGBw3emicVAXpGb8Ae4fwLoMbHyr6hQ8Bo4MRKFTtHyOtCMTh/NdJcmXhj0SQ+/zdofSNHYdAbfR//1IpVWq09klF+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ge/qujdX; arc=none smtp.client-ip=209.85.166.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ge/qujdX"
Received: by mail-il1-f175.google.com with SMTP id e9e14a558f8ab-3d817bc6eb0so5270895ab.1
        for <patches@lists.linux.dev>; Thu, 08 May 2025 08:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746716507; x=1747321307; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2mDu99DgpRCVho8Q8v6dvmbfmspAGucRRs+7nWo0w14=;
        b=Ge/qujdXqiWy8qPZAdEBK2L9qwfutIAGPDRvxoEDyRwnp4K42eFIgQKivrbfNLLXHC
         w73TfeQHBaXhVYQZEPAw1AUn3EKRdytS4HMJzQoYZ9tJ6x9le5eCsze42fFGb1t9+tF8
         JV/xw9e37mJUzeIxKSaiPnFt19zMrqhLnfF4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746716507; x=1747321307;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2mDu99DgpRCVho8Q8v6dvmbfmspAGucRRs+7nWo0w14=;
        b=kijXZAypP54uRdMEEaqSG/mhxEYyuWgYGhqhmlKrNTUtWzsRh7F2Moy3SA+1hr0KTJ
         95X5Y7TSf4VJv1QWO/AZQMdY3j3o9HCcDEosaAdRgGovQifT61Rf4PYuIzoyPcSDhbJM
         X857YGK6K3HbqM09PXSbBKH4ayYaaCs13Vz2rdYfn+lRA8AEn4FAVzLDxfL9Whl0eBwt
         I+adHWp3JvfTlFaDC7ngI2L+kRmQaSgZGXCQKw4HuikdgY6X0ZJrfBqDoykYzOt30OFh
         XpqrgBC2hf0GK00fawKijt6OsQUe63EZHI002PK9a+JdPjaxbxJwKEQwKBRb8OwBJQKk
         PKVw==
X-Gm-Message-State: AOJu0YwxfztPBHHJy+qb0QAHUl4l31ihLnfkukwf4AtELI6DgUFUavfD
	Ld5kn5VHrgdWMTveqTpov+/HG8d9dX/4aTGMDejox6wm0QetgYPoPPPQmXds0N0=
X-Gm-Gg: ASbGncvLK+UUcsR3R3PBDXInVvX7/q8kpoTXs7gZjt117g6sctHVgkezY9DPz/VQqh/
	YNiqZ+W5pN0lrPl6iDqG0n1FX2ZhHZLIG9SuB63Lq2VFz+hpHa+B5vlc+kaXmasjC6vZtAfhJHv
	lvuSKOLVGNGTQg9Z1EshZucEPF+l4EUE7mM9FHD8K9hGoxISnn5zRKCqLyBlCAlMDou+kIeXP0M
	VDb2byKuZa9GvW8WUzbulH0dUi/zdQ3Fh3zpdiZl0+2T+ZiFx+btFQ0X9Eg8ObFnKq/t7FDepiw
	RioVTzAgQVfY71+xtv/Ohv+zUNbdZYvxMJoAeeN5psPY0lc8SiE=
X-Google-Smtp-Source: AGHT+IEjElot/pRkGn8TyU+I4k+4o5FHfUYNKSw5kW2R7zgt8vtADtTFXrdJYKCaroVX1HTvdtiKdg==
X-Received: by 2002:a05:6e02:b2f:b0:3d9:36bd:8c5f with SMTP id e9e14a558f8ab-3da739082a0mr87711895ab.11.1746716506710;
        Thu, 08 May 2025 08:01:46 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f88a8cfb51sm3211127173.3.2025.05.08.08.01.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 May 2025 08:01:46 -0700 (PDT)
Message-ID: <33b5edff-4842-4145-9ac8-805e62c40bf7@linuxfoundation.org>
Date: Thu, 8 May 2025 09:01:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/55] 5.15.182-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/25 12:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.182 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 May 2025 18:37:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.182-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
