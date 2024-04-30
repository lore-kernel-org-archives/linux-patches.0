Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F91017F36D
	for <patches@lists.linux.dev>; Tue, 30 Apr 2024 17:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714497857; cv=none; b=avTus5CNT99CL2v1HzU941zyaMGWeCivX3hMCNZOoro+6ck78Z50MI7jV8prf/G2cXifxjQ6ptFPXcGxvsf5EWPmmd8UyJ/a+FbJnf1NyNmSKAoUJQFvxlfB1dNO0hzwK/XYP6krrFJ1qjXu7hjPC/eb1zqnuxaybgAWK8vv8C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714497857; c=relaxed/simple;
	bh=8c5E28VHtG6A/vJvFkJYiy9fvK9sNN/lCptMz5ClFbQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uSLjihXR43su/eaOgf+CGBwpL1mjeeIhBhYu7f7xVTT6DyXj58Rg3gwZNwenicvSdGKS2C3bENpE8IYWaqe439jzzkjENNiBnNJTEU2nCqcHNSkHPG75hTvA+hyVpr6bdrx8z9Mv8/GkBKT6RGDpCSiKIrVQoGRJRWysvSu2aXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=juirxG3e; arc=none smtp.client-ip=209.85.222.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="juirxG3e"
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-790f4650f93so239932685a.2
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 10:24:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714497855; x=1715102655; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gC3Wisg+vFkvbQKP24bf+0UkU9wju72UQF1jovD9/R4=;
        b=juirxG3ea6loTLkukGsdFYbshx96kSa5fKLpJ2lnIQOsQq8j15ZqkckX0e05T93UBd
         /WcB+mxoGxt45ODS9AMGOipo68g8S1TQQ1z/iMlgaIus+ERuk6TQ84eAjTljlV6YO/EY
         vt3+EjwEa8BDHvJe6Hz9UD5kOjDppJ60JUysxHHDPiUGpseGKo27dJl9xn+F8Fcp5V8M
         R6UwsfCS5iGyNnka4wqSiHlO9nwNV3iKj5ApN1mgyuDnUlxqaPGTiA8nrJB4P1H3T1r0
         0ut4w7wPuYOc+TpJuMu01IBvfxrcdFl+nHjCCr6ILOQvBj9R8DulR67rnG4anBsje/3P
         7iKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714497855; x=1715102655;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gC3Wisg+vFkvbQKP24bf+0UkU9wju72UQF1jovD9/R4=;
        b=mGOkViRtAxZdlz/l8zjaJ0iUcOdriHQWjxq44+31iRpeHDR1jbqOQtApzIE/sxFDWB
         h7I+zn1AG6TUYteinW1W1eB3PmofOy6xhZN123PjEYNd1O7WyUhvwsrRDZn9H7H29VLu
         MfqsDtZrkYZwJuOXEHVE61/d1t5oee1CjK3qNkfzPhe9p/3HChLTsTSRxZsetsXmMlkC
         LP4CSoQFDFmdnCGdq6kNAFmUAC5R8jKZVPVzaE6JPEVnuCzP9O5JS1n38bVRR04qX5uo
         sy1LoaB4duFOOnhVJ19WnmYFX6H8B1brTntZSUsD2VC8adDTo4abCw0jUtNEsmZ0iFbB
         ArUQ==
X-Gm-Message-State: AOJu0Yxa/xFDSeiIADEGmMQAKi24rUFk7qLgiakcRZvNxLlVJe7TdRwd
	6L63CGsR/hFsYUEsbOWA+uEWK8dcK4zhYfIXxG4IV3LIGC56I4SG
X-Google-Smtp-Source: AGHT+IHz9lvNYsSw+CvuqUMUtxWUkw7sPyOBE1PtcyqOo0C+WKn1PnKvtaHa9EZUEusZtIhHDiEc5A==
X-Received: by 2002:a37:c206:0:b0:78b:d7a8:84f0 with SMTP id i6-20020a37c206000000b0078bd7a884f0mr16060504qkm.46.1714497854998;
        Tue, 30 Apr 2024 10:24:14 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o15-20020a05620a0d4f00b0078ee090baa3sm11577575qkl.10.2024.04.30.10.24.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Apr 2024 10:24:14 -0700 (PDT)
Message-ID: <84ef302f-2d49-4465-b5c4-91ea4c8fbdb6@gmail.com>
Date: Tue, 30 Apr 2024 10:24:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/137] 5.10.216-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430134024.771744897@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240430134024.771744897@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/30/24 06:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.216 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 02 May 2024 13:40:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.216-rc2.gz
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

