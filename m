Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C538A263F4E
	for <patches@lists.linux.dev>; Thu, 18 Sep 2025 17:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758216973; cv=none; b=nwNDgiv3TSOjZAQIvFz1EkoUm8qKZkFgFaI+aGBPngQUCgprbytDkUWcsAVPMuNh5gyS3fAf9AiXP6mAlqnZf9zf8WxTgz0KiyYx972fhoUaemUFF53o0EX2ahBDzNOOG3KgmQlok0FnbTWW2k/5lzRj0ynwUaMfqXoFmQEa01M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758216973; c=relaxed/simple;
	bh=ZXbaHmRM8KqMo9Rpcnfozlk/rnX9FPWIWh/XsK0EWNo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NG5ZH7bJR4LxEb0w0ivkvvxalxpyqdYFi5NaW9ZdIVw9tZl9wD7U2gB/xrdnVLAqXeF+zlMJysr6TdPX+JpoPs3P6pMNbPwSGw6bFUlGFAf1lWL4mJ6SnFpvAN0M4eWmR69rQaoCQOGW4iCgIyiYr2wteaTb4Vz+R5XDt3O/QUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbaV+F7o; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbaV+F7o"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7761b392d50so1649827b3a.0
        for <patches@lists.linux.dev>; Thu, 18 Sep 2025 10:36:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758216971; x=1758821771; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tsxf+NCfwQTy7IF7OgULgyswOvJ4vCb8Kqu8TwhCbLo=;
        b=HbaV+F7oMcuJGMYhTusxVLxlh058PtxOCvfKMrbhvVi/LVLOa/YLKZuhMJmHoQRGI8
         H6ny9EmQdRVT3EXt85bVWDmsAa4opiCk0LtGWpqgQw2fhy0HFcQ8yHGCbYbECUsScvHc
         5nA7yhQ4vI9CPCz0sKiNy3vbEmy5RgCeGjymwoMIV6OiPSYSaNNc6Opp33asZDJlmbHV
         +RdVRS7ax0NwvmCWAMGLNPXkaf9F7tyiyhtykLmeS4w2LNoKQPy1JKdZEUjSO2Ukn8rK
         hsfLQ3R5eDvjwn8dJRNe7KsQtafbCln9KE0pP+bMvXo5StI39opFhHPo3FPv/sqZe0+A
         C2qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758216971; x=1758821771;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tsxf+NCfwQTy7IF7OgULgyswOvJ4vCb8Kqu8TwhCbLo=;
        b=DzaUBYDdv9pQ4QjlXQ7e56TYoD3cMwBnKWUg4PbpmcL3DGWCZZbUUM+67ZPBbPQxQY
         BvApOrKK47fBSVBLlmL2JAH28lW9VHURLXsaH4pid0Xmx3k9qX0UOe3VfCnMEd1z5EI4
         NQ+fGQG0wC/i28bQX2ZxqFl1qufqpQPUUuBYDC/S+5ZRVCZWvdBtDq4mckSI/xAGfXNy
         GqBlRnPrEfICnFmxJTwBHv8DUnZAK4n0uo/uh7sY0oKw1dVcjWxugiaH//mGk5O5srGD
         d/HPKxSrPiZ/ys9mpgZLBWvP7HeFcC5l+uMTXTE/IM541nEWMHVZ0/fMe9GS+WlTT1/6
         iL9Q==
X-Gm-Message-State: AOJu0YzePxSwqeF9z9oabh+YV2uHp2LeawrS0unv7qIMU87Q0DoL052K
	BEAJX0Bbvd1yqmfH7eDPX0fQlKx59tYGSrEHUGE14y29I7WQs7ULMnbj
X-Gm-Gg: ASbGnctTGDZJh6EA5eKLrKvc+SWezaPZxiR41t2QLeotVqaX21SSAiww9IMT8DlxDC0
	gB6t3sFwp0pTja0mouTinFz5V3ttfg+LeZb9MfVqytTLsPV1ZZ9pCKM+95mqNPDZHJAG5UobqXj
	7zqoQBV3GBxELuq0+yH2rW8IiuYP2OVAGrJCiK/MH+OTADk/IfMjurTTgd4wVY0K9z29YlnIELf
	10k8sueEf2Sg+2BBLuOMhtzVZ+Gbi3U9xdN5ufKhMseigzbAhWTFkTK5B21yaSra8i2/H6xd6rI
	FWe9YA86OTZ1tx+IwU/vNvHKT/5OJhMeLrnxrtroH2Fi8iSiXkD83dolZjF3Fn8tIqcOy6NJMw4
	OZQoXSsYKrw8kjXOUZ4+NNkyNh2P337SwGikEwHpFNPqaz2jGQCWFKJSDdDsMWCarmm1mLCqQ+N
	SKAdU/x/c=
X-Google-Smtp-Source: AGHT+IG7T75VR3u4XEDScR897hF1pONMvlMSo/qKOoVmTWVYgoLPja/DFLVz8OBuqgW1WDLHm3c+qw==
X-Received: by 2002:a05:6a00:39a3:b0:770:73ed:e6e8 with SMTP id d2e1a72fcca58-77e4eabb491mr208476b3a.22.1758216970917;
        Thu, 18 Sep 2025 10:36:10 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77cfc537cefsm2907090b3a.39.2025.09.18.10.36.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Sep 2025 10:36:10 -0700 (PDT)
Message-ID: <8166556d-aea7-4e69-bbc4-e8af2f3a466f@gmail.com>
Date: Thu, 18 Sep 2025 10:36:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/101] 6.6.107-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250917123336.863698492@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20250917123336.863698492@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 9/17/2025 5:33 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.107 release.
> There are 101 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.107-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMST using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

