Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481CF3CBE91
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446390; cv=none; b=b1qtgSI7tmQ9C/c52gAbjvcVL1I2t3mjoBbFWNX8BM+1UTTdf7Dkuv8TlgafDVpO9vRugioGjwCdBSbCMBLvuhuHBIO25j5LfAHdiSce3r/rR52YfFDGY3mwC8CcjqUz9FwncM/3zLuGyaiatXFkspwjzMdD819iaBmP4cHrqk0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446390; c=relaxed/simple;
	bh=G1XI+5GBTx+oIkqPxinIwBou1X2aVA3QOE+MAiC5iyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V3UcVWI5ctRp1bHRK0ZPRPOjXOwpX745woahxuMQHUkx7C98/GeFJr1IXMgSAmoSITZQtlqYb6jWKFm76fz4ZVcq3qG0KipGE0/tJlxLk8MJh0b9EHb80GbfC6TuTFSKtkmNklnlursOL09gxQ5Lcs8+p9paZ9UUDyjJb4UgLDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XwDG25am; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XwDG25am"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-6a168dc590cso125209eaf.0
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:19:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1785446387; x=1786051187; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ssRbo33iKLdgp+nHO0enQlsAP107KZkbYC4ZS/Agj6U=;
        b=XwDG25am3ILQ7gZIUM2tMeynqhrs27deGmRuAlgAbek0ktwIwdJm5gGlOf9mj4cQWs
         DNrHvD/fwLFb1qY6iH8xnl1sQEfDMie/ztzIB+vGnQ1l/JMAZetkylR99u020R1WIt2t
         JOH7KsxjKhHKLXyExF69i0VybBJZDQ6/ZuCv8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785446387; x=1786051187;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ssRbo33iKLdgp+nHO0enQlsAP107KZkbYC4ZS/Agj6U=;
        b=lx8A4wdfpwVtmP519OGibga7xED80bsujcK6wTZ/xf47v5Z6BXgGtE6NjfZss1BpbN
         5FgEHWX+jaBJZjamnDKWH/uoW8xCfMeR80NS+g9t5rPjO/h+nZAeoe6Bmxk2Zffa3JvH
         VV/un/f6iQLkfIaSZ+XfgK4JtjEttwIOkzrYPmQajHpCMO0HiMIBoF4d40M/ZUVwh8BG
         gZDSvyRACr+7NeOqfUQ8DBE8JE3shUI2g+3xx4FxnNF03TpM1xmp0iVRfkp4ubs8qMa0
         bfd/IE2mVBBr9OVwKbyBHTogDbv0t5N8tqoTa/cFajsMYYq/t0OPkfQNQKaIf5ls2Pdi
         Kstg==
X-Gm-Message-State: AOJu0Yyp/xlJzXrvY1zA95hH9zyo67exmbB2Fn3YQUoESUe+JifL/AHO
	bCa9XUFfJFGWXFfhZR5uprD/B9SG00EbH0H/0LwCMOgwfvcj/06eJOKsOBFIrwR4Sjg=
X-Gm-Gg: AR+sD10kgOa9hdiIJiyoZBBaUDsXXMDeLWAbI3xdXx07i1rXiKVv4SWrL6w0XWgIoQh
	siFCThYpOGEhyWSim/y8DtpLvmi+mTJHjbsZ5APKKDWTF+7ls5u9pp1k6zS0Zb5MQyUVHvKD1B0
	J7feVaD4NTzS0BHJooVaLINTxFFSfHONwLOLlW3aPqOcep0q3+UurgDsxP1GCq0SVUOQcnKm/A4
	MK2WFRtNvXdrbAhkPAQ8TjC3WpKerkmWI3M4I6OY7dQlM5RlTKaQ0Ed+aYLC/m/w+KytohyteTN
	I/lA94w2yPPQnTFFzTTLjxAovhdOzrWdo/44z/abrW/RFxG3dD1gXibCK4nZ7O1+b1cGGxJFRG+
	Xszx8COxdfUnB4t0PsKiQrwcVHZr8Du9qM1q71PW/8PzP4zbTN5X7kHZ35qwBw8Gd7psmwScezL
	4z9Rk60VN1PSr7e56rP2SoLoswK8q/6S79+f779vxNlPN3CofJugNu6Q9ymH5ZHUXmQ+dCYw==
X-Received: by 2002:a05:6820:f013:b0:6aa:cce3:ab61 with SMTP id 006d021491bc7-6acf7faaf82mr1374038eaf.9.1785446387072;
        Thu, 30 Jul 2026 14:19:47 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6acbc29ab04sm2278140eaf.4.2026.07.30.14.19.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 14:19:46 -0700 (PDT)
Message-ID: <640ad2a0-8303-4478-a210-45fb3dc9b1c8@linuxfoundation.org>
Date: Thu, 30 Jul 2026 15:19:43 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 08:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
