Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6CD158DA5
	for <patches@lists.linux.dev>; Wed, 15 May 2024 18:38:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715798308; cv=none; b=O0T4e68lzKT3/nmKVkRpj4AfOghP9vp+kLQy16FjHNpNy7JrMcZMT+eLgJyXyT4IUSOLi4NXPmUNbTOnqxDsi81Rtu52CjRRD0st/I4wWPaoK4Tl7offFxi3+66ovJSH2uC8cJahntNLVWcAzBt+3e7etu4RmiKUCEKw84F3ceo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715798308; c=relaxed/simple;
	bh=7UWh35RnOx85WzoHXW3ShB1J7NQ3C/kFXJrXqt1QCuM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Of6swUzNDVl2CdJSdQeVOcahYkEr7/mWuW87s/RSoYmL551Tw8TIFp9wQXNsKvPxYVvzMuS4YKzfKHDL3A2IiJ4pX43WNDOt5zzTy09dbo5oVC+6VlUIr7v3wx5ke7kpWZip4cF/Y17G1kEauy/r0+KX06mISqINSx+A03gIBpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=RjM79Dfd; arc=none smtp.client-ip=209.85.222.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RjM79Dfd"
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7fc2827c872so868181241.1
        for <patches@lists.linux.dev>; Wed, 15 May 2024 11:38:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715798304; x=1716403104; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QXBg9mVwXoRV0q6l8YLggJ0IrqIqcDtLEUB2QLOTEmk=;
        b=RjM79DfdzCb6TddJPxdg5q57T8T8VtJXiy/wjyTXF5ym3gOasPbFoX1ZH4dWuHDpNa
         jVDeDoQZTqPeaU/nyT8iZf0EiQr/Ozd4lkk36JQPmJMqSb7QaT2QdVaiStnVgXZ0SaTO
         8siY6KkLmu7d2sIBW/SSkP+Bc4zaAy1yZSH08qIfyjLMdcRj/uWcPJclJbwyg7c13ieI
         SvwyxCbuTEdomXoOZ3nAlJizAe06fe/7czVsHFNeYVM16VAWawgxJA5e9MneC+QxnMsw
         SdUnhLsWyKGRyxkfun1I4sup72JfvHlDKGp8dk626KJgQF19vlqxX0hsLf2kw6jqqmPh
         kVGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715798304; x=1716403104;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QXBg9mVwXoRV0q6l8YLggJ0IrqIqcDtLEUB2QLOTEmk=;
        b=rnI5v1dEavp2wr/Fzl+1pYJ3+Z+eljRz134kNaXhu/kj3MgYaypDKOZ8YmpSGxNggS
         WHLK45NsqqCh2KzpTG2r6co5HrcMKeEQULhIEyOcntkcJxKyModG45Urwyxj/VVe1dgG
         qDe3hVGG7TPvNCmIgJo1QV9ZFBFf0qVFgvb0ie+CGmP0IE6GapzjzQnUrXltaSq8152K
         o0DUXxkECAJA/KqO+Om8WdWkLtx+DMq4EEGA2Adcu+YjXvhUO1l+zZ1fDS8GHBEPPpBm
         S7KM8jnjh92I/0226tut4clxxZp3ljysE9CEiMLGyf9JqGg4q27nzwiRlM5Ji8RPyHwL
         ty0A==
X-Gm-Message-State: AOJu0YzAmG/uj277SrxvH3aKS/q/wug3QVj9ZK6YB0HpUmULtSIOHAza
	bte1+AuKL7VRsYndVRJHpHDncPpcd1cwqIMSohAPiKhDM/wEUfHN
X-Google-Smtp-Source: AGHT+IGJ4YpIkrblaSjESWs+y/i264n6Xjtgzn9q8BT5cApsbhZKOZMVFQO86OCAZ/NfNw5zVugNTA==
X-Received: by 2002:a05:6102:c05:b0:47e:facd:5515 with SMTP id ada2fe7eead31-48077e5bd50mr16455856137.35.1715798303447;
        Wed, 15 May 2024 11:38:23 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6a15f1cd25bsm66747806d6.85.2024.05.15.11.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 May 2024 11:38:22 -0700 (PDT)
Message-ID: <ac149d9f-50f7-4ce5-9ffa-d1d367e0224d@gmail.com>
Date: Wed, 15 May 2024 11:38:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/340] 6.8.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240515082517.910544858@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240515082517.910544858@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/24 01:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 340 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 May 2024 08:23:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

