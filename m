Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0188915665D
	for <patches@lists.linux.dev>; Fri,  9 Aug 2024 18:35:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723228511; cv=none; b=qfduutawLTNBCaLhk6+iumE0YikpRqspybv1HYnd6nLMsyiL8MPacn93EqOqhfo/wr4iAlf2TkTHnrCkpxrKVsczifrMPBk2CRJaFhHNY2VPMKqforWXe55GZ+T5bJG3Niwl25qzRj3SoszqzPw++sm8Wqygqr54fSpZRvJF/wU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723228511; c=relaxed/simple;
	bh=GBzaLQaNZ6M2z21ceLlhGZ8CycU1DoE/e0LTOcmZPvg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikmVsenbuZNVHCuBdEqysiL88mZTUAUdWbvWFoIDE7wj1FBHUfeNQGNKUpUSrFKpxPZwo0titdIFJ7Id63uMhGqNd8FpwYTeAbnXNdoi1cgQqJZMs2vF5l5dJTNXSNGPN/ro+kW24vsh5xSX/lSeD7piABg2sJVdWJWl8RcGDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j8w3yEja; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j8w3yEja"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-447d6edc6b1so13118691cf.0
        for <patches@lists.linux.dev>; Fri, 09 Aug 2024 11:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723228509; x=1723833309; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZKLnO3NzNrZPScOiuu1Er/4alnL7NJ0165pjeuCDvB8=;
        b=j8w3yEjaQbX1aJvX9tFavJn5zIPirSZy1bCtOuZIp3hlG+7xGqVyMcg08UGg95RHlU
         0PKAo6jnrThwBozuUtCslWxSGSWdEPtan48m+4Q1uJZ+oAHnR5UKU+K5E1IVh9/TtFx3
         sjPsBWWn+9amggKR60a/Xi2C5BqT29rkWWYHw3vqdC2fFc8OpiOKI4bEUykZfAroaSoS
         eGXnfMDtg9JsIAkACy3OjqMIwlw3gP7MmGPzaejoofLOUn+Ixxl3uItQMYr84ryKP+E+
         AV5RCUcCrjdDGustEXsjnxrZkUkxt5xUa6WYkkZLiqRmTJEjSxl2JCyKq++CoiFNKgrD
         Tnow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723228509; x=1723833309;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZKLnO3NzNrZPScOiuu1Er/4alnL7NJ0165pjeuCDvB8=;
        b=LWPaXAbGlFyefGPDlxlLGCLAL19cZxbAKcZV76mUUf+7pW6/pW2asTCGJfAwNo/e3x
         km3QDTB23ewXes+t/oEkNQsrOm+KVzHdLI9S2Avc82TPTswYC8wMR2IJZpuZ8OZJEVvU
         +C64uglbsRPckFASQbPxN+fsAgfCSCFPzjkz9kQRTAwpWSIh1VTO1X5KRF8TQ9+hnJxW
         XpG/1eU0fr381sxUd83xMUh6HdhqGwvSFxRWfzDVhr/rXzpbh696CGsQBWFhlpLaHb9J
         KcVv5hzu+YOxifzsvMs3QlWrePAkTF5CPGHyhm36WbMNx4FSCn176Xr/Lj6j07xvKOHH
         dR7A==
X-Gm-Message-State: AOJu0Yzl0YmKAY+26XRdgpjX9f0RIBgxRJw2v3XP153YHBTxrBp4fDd1
	nYZzHRMqEsBfT9nxhWXtQmhXkqlpDq371KJsmc/91tUoz/rPTm30
X-Google-Smtp-Source: AGHT+IGvOBdQGy9B0d4iLbiYIuCoHAJBcm/SlEVS/R0YZCbAPVGloz5VZdbDZ4emSyzwOWP9wkzLiQ==
X-Received: by 2002:a05:622a:1c0d:b0:451:caeb:8cfd with SMTP id d75a77b69052e-453125b87c8mr23675521cf.31.1723228508674;
        Fri, 09 Aug 2024 11:35:08 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d75a77b69052e-4531c1c4c56sm342601cf.23.2024.08.09.11.35.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Aug 2024 11:35:07 -0700 (PDT)
Message-ID: <a74d414d-7701-436b-a31f-ed8ec54435d3@gmail.com>
Date: Fri, 9 Aug 2024 11:35:04 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240808091131.014292134@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240808091131.014292134@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/8/24 02:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.104 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 10 Aug 2024 09:11:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc2.gz
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

