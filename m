Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E824F896
	for <patches@lists.linux.dev>; Tue, 27 Feb 2024 19:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709063002; cv=none; b=p4HOsO7CVi6ouRwiZk+V10Opm6kNJ+fVokB7LUeIQZIEhMk9WAg9ahOjJkj2lLoy15J70j2vPxa6TdkbDrKjmjsZlini40efFcQ289JuNwwdCaLyc9jn+88YXbDsHo2v06jhqM2i5AaeSWKp2NYIKsDKhhlwOh6AdII1BcQMFak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709063002; c=relaxed/simple;
	bh=dqDyN+KRSfnOwkx8dVPjoi/6aut4zltvBRatniQunAo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GJr/RLshAGboF8JuCsaAZ4h8bs6r2sSsiQS6diqjBzSv0NCKIVETcjvLU4ZIE/7m57rgpHYHhG2rsVSUFIrUTs+5e2BSwIc4v9V0qv5CyO2Om7QaRlAv1smWckIZrgLXmioNx4XIYYdDO48tkOmIm1ROrdX8YBFJI+3DE0qHM4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WA95DBrM; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WA95DBrM"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-787ef8b194dso1248685a.1
        for <patches@lists.linux.dev>; Tue, 27 Feb 2024 11:43:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709063000; x=1709667800; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MHRF9fotsc2Wn1fuFRo4Qf8oTaALfFUASU6mbW+XRdU=;
        b=WA95DBrMbAdZKfOWfI9bHjO0ALq5uNhQhnfrT22TrRMNXL624t8vLArnRWh1BgQxA6
         gpqkgB4bo2/dlSVjv878EUkYNGAVFVXgwe4Idv5oVyNCgVkbUvQ0flMofvPEib4V3lAk
         6Wjxbl5qjxGKEMY+cKN9i/Il4EK6ukFtMT7fahXOOol/+A4dSEvOyTbNQWCh//ie+ind
         rbfzDGnfA/ANGOzoYhHcakeYLvYFqDkwF1m5K4HF5WCThGSsR/8a8QP9GvvlZt+nx3z3
         kB/CUqUN4h4Pv1Knhm+/iVje6MzTwMuX6aYXcC0LmG3Z5MgHE97tFdn3dtjuW0gTBaZf
         uAvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709063000; x=1709667800;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MHRF9fotsc2Wn1fuFRo4Qf8oTaALfFUASU6mbW+XRdU=;
        b=C73roguJUK10O3qiWrVGJEc1PBg/9VV9CoLT4g8FRCOj4RE5Vw3w3eudEjxFD0Mpam
         xF9zX0dbfOo0MhcE3bN7uo6T5Wo7EJk7fkmzWGaVx7HeFhX/3XP6YaZ+hDH5lRgNxy5d
         qjGBvljjHvDkyE5LGozbLCygJTWwl1ICeSMbDFnB8aoPeXSXrPRwIcpozY6pPlzJh8a0
         l6k7xx2zXitcNZqCHCv5P+wdgEylN9UFiYUxNasZJKmN3lglqW1maYdv9MlyDNt3noZc
         kuGPrQRxcsg7lOxksheA4RAW+pdGit3shEY93XeivQhj8xe08fO3nqtt4WSu26DEPwsi
         /MGQ==
X-Gm-Message-State: AOJu0YyIi9aNTaksKk5IzrT407WAS7jMxwVnOiHO5xOu/r7uKQSd3H1N
	cZeIXjaC199S+WeUdUeEeUP3G4z7RGs75FLP2UxrC1411gvslpYo
X-Google-Smtp-Source: AGHT+IE1Djm+XG9j2e22YAFWUsoNpcBWHxoMtJD1HFPL6vmVz2lBTbWoS8ibTv345dqt14KIXoooEA==
X-Received: by 2002:a0c:a701:0:b0:68f:b941:3463 with SMTP id u1-20020a0ca701000000b0068fb9413463mr455963qva.3.1709063000334;
        Tue, 27 Feb 2024 11:43:20 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id ng7-20020a0562143bc700b0068ff79d8d97sm3787473qvb.41.2024.02.27.11.43.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 11:43:19 -0800 (PST)
Message-ID: <3919f8ea-15c0-41ec-816c-dcb8f97b4682@gmail.com>
Date: Tue, 27 Feb 2024 11:43:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/299] 6.6.19-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240227131625.847743063@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/27/24 05:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.19 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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

