Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073351369BC
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 23:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723850510; cv=none; b=DsEovo+mDKbU1gMBLjbgX4Cftv9WDo9+Ot5TuQCRVA5kjfpN6j5HF9PoJZB0LI12tP4FZA089q9s7CZA8lcEyAQIehdvu6aPOmhZ08J5GwHj5LvVJ0HXIWv8EGIWJcYKD/k+ucI5KTcaO7Okh6Xe/qVmJJ8Q/fLKOxw1q4lDokU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723850510; c=relaxed/simple;
	bh=CV81POIClX3X7qXJ1I3KNNNkLr1iIaGW9RjKBi9Ck9M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Lsly6BQHWvSCmT9DtItVf3oxcYPE3jfRV5biVbNFdDmdVJNuFRr80ShmMM7s2XRcMBea9lLLdXAJ5279B5AbPWZu4ad6/x+efH07sBHagSlXhfUPl8fff0tmXVx4zuibJIf0777Zjwir6FmecPQhF8hfmyKh9zz7oNOdREWE+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=X3NwvZ5T; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="X3NwvZ5T"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-201ee6b084bso20687735ad.2
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 16:21:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723850508; x=1724455308; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=48ywkouBR9NsndbOhMMuHbOigPSzj4CFV9KRr4U5zl8=;
        b=X3NwvZ5TjgM7LMGQrk2L/ASerOxestoY8kWI0+IXSoTTC1L95Zuai0DEp/kLve26ES
         8HyWJBnH36yKEqHgK63YklVpxPxiVhB7/jH3Ar6wA3SodYIwMoPuzwvSQfLiDPABikAp
         J6fraaDdCG7Bhg0lfYQ4pySdzxnAkAvvhV1nv6f1TyweTMFAvuksWeYNJ7+LUaLi7fWY
         n4y2YfhWvPs/MDvVgyEHAZ7uduyMA3eFLx+GUArskiQyGhj5vKy7NEPHydcn6k7VUzNu
         lVu0nPDDc3BZ/af31zf2VqUuDfojpirff6kIPwFlyHzrcGJESfYowj2HCflcdPYM5tOm
         D+kQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723850508; x=1724455308;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=48ywkouBR9NsndbOhMMuHbOigPSzj4CFV9KRr4U5zl8=;
        b=ItwvyTRy+N1nxZeQbUyrDO7NLLyVQq0pOdbgGd/5BgNWJ9qNZofFwjev+boBmdspZY
         A+Octv4ng96lJlJ1usDtqcqHSbKUBndnvaYDpE0hy5w1bI7sAurMjATYFxORmnT++rUI
         6bK80TZiO4fQbzhTKfYg8H2TCddqkHmRpXRxctyRAGW5AXD2gzqOivzNWSojyvGtUB1e
         eguH5LDDC6xdkleGsI+zmYYHV5MTjy4178fN1yR80hY0g2InenTssE/28b5aSU2WcB58
         ch8zXKhIngSmcZXb+YnEsOWHCWkWzBFLQj98LFnXFy4dHuKFSPaLXkBjoRcExC5Crb2E
         hxaw==
X-Gm-Message-State: AOJu0Yw9AwUV0tG+Qob6IucNeroA171OGM9r+4Ik9Z0VcspBmJpFgfEp
	A2BG7xcHzHK02ksAYu+yPXnMT7eoWhrkZ2/OuuYJPOpw1EosuJqv
X-Google-Smtp-Source: AGHT+IEAmpTN/Fa9RR6HbKj+WSlzjlqus8SmI9QThmBB4T+MCfCyKQb9JtxHo+IzbcOKcR4Na/scuw==
X-Received: by 2002:a17:903:41d2:b0:202:19a0:fcba with SMTP id d9443c01a7336-20219a0fe95mr9245695ad.41.1723850508145;
        Fri, 16 Aug 2024 16:21:48 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f039ef06sm30290985ad.249.2024.08.16.16.21.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Aug 2024 16:21:47 -0700 (PDT)
Message-ID: <92617a85-3a29-4783-af76-6e75740cbc05@gmail.com>
Date: Fri, 16 Aug 2024 16:21:45 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240816101524.478149768@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240816101524.478149768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/16/24 03:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Aug 2024 10:14:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernel, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

