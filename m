Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8E0B1465A3
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 20:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723754442; cv=none; b=mbeB+0GJ6/mzxcsvklt1aUwiu6GAwFTpfrajTnZ9HVo9emAy4SyHBpQWauwgo9oDBlrXMU+PWR4JKJZ+GGsPyVg/6ql8aKkTNCwXMNZlFA9s3fQ1iBaqt6HJYZdyAMna76m+zQQ19KDjTQopK6hyPK7jy0wxsuwUTss0MM2CMfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723754442; c=relaxed/simple;
	bh=yPrJ50VXI5nJ2rby7f8Ln8oGQi3wYrAEG06B/vm9Abk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cGxOO+1fllCb0ntYpllpIQsdy0WeBb1BBXRFEUULSORbvXyVeTece9U9hE0tq8uCXocPvzpT2XZeqaJRJ1rqLm+A1YbI1jdwAj2VjdopWwmCCaQg+qN1ArXRn7J/y4zzVpHDZunwCOUUV/d1AxiUitIq6p5S/5/mL6d4yHuV3QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LrIfkJQE; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LrIfkJQE"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fee6435a34so11534475ad.0
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 13:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723754440; x=1724359240; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9WkB5SkQtbWMRkXaB+yKolATeCu0MoWvQKnYm5st5Cs=;
        b=LrIfkJQEFmmtnuXGvX+RIHSRF6sOCQSUxCPZY9rvQWhQMQMbu63BvIFb0XM6emrcd0
         09YK200FKEd87Pdm2+H/rNr6RBba6zA1OPON8VRRz3UG556AuAub8ArmoZoaghHKauTM
         EjSGcbd7jnJfLA52qVdlr4mvGnXrW/qk6sLdgMiXT9idE70zfPSfFjtboTfQ8AiitgTy
         pv24cF/AMx6qCB+go/Fmi2rDBgraG722VFc1RU1gRFFmPEFeIgEcPz9kvXB45nyFyfh+
         Rj8XIOxxdKzmyg8+DjugwKcsUzr+0ZbF0mC94ZldILPR4MHKwAKECOZuBNVeWO37nqIl
         KBXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723754440; x=1724359240;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9WkB5SkQtbWMRkXaB+yKolATeCu0MoWvQKnYm5st5Cs=;
        b=ivjc7bleVgdO9gT1kiStumivYtxgVeLHNbULXOswjvwzk/m9n6Mbwh9q/t/ZF/uFGL
         98DdcZG05rnYHRSIXk2y9yl7Fg56J1XO7KxA6nq4gugTKULriq+Tk6Z2S9bNqtFgv02q
         jGsXudzFubWRvqwlLTG058ioEUCgv4FQyvQhf9JY7hCRtwp1NGEG9GdntdKpOeSUfGCr
         sgnuIH0tA5sRlG0kRDLbmTrixu1Cu9TSF8yPw6YifoaQv48JHc+fPpll09XfhD7J9tEG
         eg3ExP1bY8UMzupLkRH94c8dRXLmF00d+w0e4V/+qD3e4wzu6W/Jf4cWFBXWFGwHyQq7
         apIA==
X-Gm-Message-State: AOJu0YxKbqvGCAndhCOgAAKVvaE4ryLeAeVfWNDV/zUOy5pkWmHtLKKB
	GPDYARfsrvsHbf0TTFr9xhWu0Fa3mywgpA+vwxffZEmIcfuvDqCu
X-Google-Smtp-Source: AGHT+IGMhDTyIayyAG2ydk7g1y0+W5VoTqLRXWve72ZnKng+f2tGdhpAlIk2AfPn1zlJ7KkoxKrwCg==
X-Received: by 2002:a17:902:ecd0:b0:200:a9da:add2 with SMTP id d9443c01a7336-20204050d7fmr10407335ad.62.1723754439669;
        Thu, 15 Aug 2024 13:40:39 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f0375123sm13919635ad.139.2024.08.15.13.40.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 13:40:39 -0700 (PDT)
Message-ID: <22ee17e3-5bd4-4c62-9619-7e105bbd6ef8@gmail.com>
Date: Thu, 15 Aug 2024 13:40:37 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/352] 5.10.224-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131919.196120297@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.224 release.
> There are 352 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.224-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

