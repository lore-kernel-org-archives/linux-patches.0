Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6537A13D52F
	for <patches@lists.linux.dev>; Tue, 23 Jul 2024 21:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721770234; cv=none; b=qoT+QqTycL8F2q4r3EpdZcTU30Glcr0lbfoDUdoyuF1fcfU0ghrLGAC1aS3cxeHdo0A6WhHJ5iv4Vk3QjUZENwT1cIG+N8DdaLm/fWlDFazCVExijstp95nPhVPuyFf2jVUKgUCZSdJbsrjW7MnTF00WmCVy30CKG9otzcZh31c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721770234; c=relaxed/simple;
	bh=fJdNLJeK498HpfUGwQRCMcC+1DgcJHW82eyWYubI50c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KJNoCb3z5dWbJqhzP07BCRUjOtXEjR64IINunEJlYihglpVOsyqWSDa+4wAb9qnAGFFOjplgBo8jNSW956rD2wbxlpOZEeO0b20liNs/KH9HixOODeqdA8aUrGVex2i5sFhNxy4fWJ+5Jho6lsCvLKnTM21de+sICCXE8H5Vytk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hZ2oQizK; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hZ2oQizK"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-7a1be7b5d70so211865a12.0
        for <patches@lists.linux.dev>; Tue, 23 Jul 2024 14:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721770233; x=1722375033; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o4de4vuoAzGU+SJJd8nCBnpgurzTAF1hcwQExoCwyjo=;
        b=hZ2oQizKIZTpTENAk6F5AarBuES9R5yopY3tQljHMkvkOZ3NqjEnfulk03Akv4gDzU
         rHU60eLQVWbGX/kYp4YTqLWymu8b83r84Qvlu3E4OmYYwv0bXSC2ZbGH09Xdk9tiryf1
         S8kM/leONF3tltY3Y3Qq9dsZ3hXEeHPfnsauMpujE8VXQP5xpOtWSGqctZa0csTWt9/A
         teurelNlcuhQwlUmizN3gkZkswr6tttCSsYWxSZ0zn28380/hCtwdLe3trqlfQDCj1uZ
         9sfXPAmlf+aMZ2QQZaGMHkJygED4zI5nzy6sIpcv0kJJW0eytNtu53fESO+gsxtvqfa0
         Ppng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721770233; x=1722375033;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o4de4vuoAzGU+SJJd8nCBnpgurzTAF1hcwQExoCwyjo=;
        b=VYmLCfpTatXoRK6ye+p/OMDqU5AiSAU8hQXtk6Z2jb65QZ6nUrtNpsrZeVeolYD75J
         mwZBCpsW3fqiNKIvNzMpAz+KyP6/vLEhronCUSvbFOZoKbZ4HsJ5g2M51Lp0mnBzBuAN
         6t+BHl9ZjxysqUHmHpOM3RhIQR2EclMnbsPGM/L1YqEPszp08kd9dARfQNEqvN12KcEK
         gQu86jVrEzLD5HjqhxkwdJPOLfkpOK43oaLuuWhi/5TFtx0dj24OkNXiBo2CREcZJO4/
         sn2vMBMwZxludIMMYzeP5zmyAokpIXnysYLGlx0BRWdrjiW/vYV53mPxWc6/rlwna69p
         FvtA==
X-Gm-Message-State: AOJu0YyO2Ibsj+NzKQI8bOnjGajdysHUHtNpKBnG9pH4taoOm/A9QSYE
	aQXPEV2GIob1ISfCMuLqu4pdpxhYH+fpdwzEIkMBKmIrOli9/pbB
X-Google-Smtp-Source: AGHT+IEZPydGcXkIKzmVjkgsWjzY/dfGnczk3SL53btNvASl3GMszGma1sYiHacdObWCOH0ZwWZltA==
X-Received: by 2002:a17:90b:1d91:b0:2ab:8324:1b47 with SMTP id 98e67ed59e1d1-2cd8d10a8b4mr5452982a91.15.1721770232546;
        Tue, 23 Jul 2024 14:30:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2cdb73d8897sm67669a91.17.2024.07.23.14.30.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Jul 2024 14:30:32 -0700 (PDT)
Message-ID: <ded16d98-696c-4481-894d-1ebdc1a019c6@gmail.com>
Date: Tue, 23 Jul 2024 14:30:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/163] 6.9.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180143.461739294@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/24 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.11 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 25 Jul 2024 18:01:03 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

