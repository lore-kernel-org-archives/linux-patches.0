Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7C136351
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 19:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765395698; cv=none; b=Aw4zbQAAf+xHAwh5kr3YaxMK2W9iTF19TTu9Rr7cvh2nKAWZRwT/YijwD1k2TC9ovvMzaL2UA9AK95uX/GqKIutOBJhkJcCVqPb1Xv6cH9k8iFWbyonjA8OO9W/gqsZs2dti0dFdasIdbKsnCPLRBauje6cWQjF/5L3v4kL85Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765395698; c=relaxed/simple;
	bh=H2UbaewyYDxXbGPUYPl615Ee9D0OcnAn+pJ8ldB/FAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pp0LA9wwJ2k9Myqz4SM9gvrIuKPIxj+c+xis9GBuU/vaX/pj1FgXynNn/QhlXawn7cZ1nHkNGyTrjzrQlJ2KJgAP4YitFBw2qB0v1LMOfsX4jrLDtAJrMjYA6o5K2j6GrcKT+hmP9ZUbHfQP8NTn2VUPnB2ZIQ4AzRkmduG5yKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=KhlW1Wnt; arc=none smtp.client-ip=209.85.210.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KhlW1Wnt"
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-7b852bb31d9so194967b3a.0
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 11:41:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765395696; x=1766000496; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4ayWZzup3rNWWFgGka8ZcFlOv9iBXAIIL9mvMssIfMU=;
        b=KhlW1Wnte2P4Jn5OflH+63Qy/4LfKAXa/a4qpQ/YxFMq1wZkrx50EbzGQXUe7vLuSi
         4Fh6th1mQK4eDFJceKd+qjRHgVVapxaJew5NsVB41IraiWyUsPoAifWOEh/BmPxHkJ6W
         ati99/fTL0aoxiWm0H3HfImEI5P1fIvpA/4j+Qa1IbxNllLWYPmDNbqJrhoBHg9MWMiW
         PVbJ/L0bT9xYUHAatJcGo8ET3HS3kO3s0wTjEU1EpPfXZV/br6oTOatPDEGG2ESSDw8e
         nXIDyH/OoQbx0LcpXxHBzfY7hy/MoIRx9wI9wrUYOTK9LMFy/QEoji58TNADglQVszuD
         hfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765395696; x=1766000496;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4ayWZzup3rNWWFgGka8ZcFlOv9iBXAIIL9mvMssIfMU=;
        b=FcHwpQMbPBxcWuA0Nsl0q9YJ3HabwopKtbKDZUy9P2Z6lVSJ/tVM4EM/ufCdFpAEUL
         726rsmwSiILS0olcJkL8DTaCnPCZwb4e9m8q/niY9WU3+9HyGHfbUZs0metaOnXNnKRW
         LD4PaSloCdfsZo59ktNZO1hxDavSmtQd+k5ZFfO3acQhcic0m6F956ZBxucd8vyapcJO
         aNE0Uqvh/4eCvSfXjTuVT76eQawdJWn07jYDKI3BXEasH5PiNllTJWa5+zeVHDju3q9M
         f6u2/U01jdVWyGTLIgSC9bNv5WHGQik/iuN3tE6drOXYHBJMsnLXYRktu7z+6J0d6TKw
         CEaw==
X-Gm-Message-State: AOJu0YyrkbjGaJcagHFCw198k3+rLG4cWy27Rz6jcGPfkrbqKL/wRXiL
	ZEBEhIFjtDgGydVSwlIBjRPOuBa7ArU74JRDs9svsC680u1ve1skcaHF
X-Gm-Gg: AY/fxX41/EAtV+aidvVk+szbCEbfAarDlxbuonBvstLaF68DGziPz/LxGxX7ybn5LW9
	JXd8D63aR50Hdl77wSulzAb+Y807brrJnDnFIu4o6iUySCrqgkMN4oldq/LZ0T7tAe9yEQaqklA
	AlQdWxTEeRcdX93St+v6eZ4SyVK0DHhE+wWEO3AG5tVsvqMbXrYvtHAkBuLcNNMpGDZ5fwplpML
	8P4Fy2zAgr62XlD67nR7HUuFIQzVZhBF2JIdGFmBHw5STYq+cAkh0UqDLmKKvebinVZyKJYS54x
	2fg87bsbUamqv4PpJAHB0aUVSqUQ9I9Zln0HBR4HxaWEPPcPNU9AMMe6nVq2ij0uX5x1j50UpVl
	0V91RuN12jd3qOzYJV0WFA48Xsicx+yAjZx7Q3mV9j/d9QkZO+K9mNwx/ckjTbO3iNRSE8qtuop
	8TDRGuhCbxMrxwc+A2ZzOt1PlS3pFJOC6IbDSLlg==
X-Google-Smtp-Source: AGHT+IEPZtIv2trsU7XOKEqJGqHY/PlRFhDAgs6iI1I7+3++Yd6TxqMeakvcI33scxh69FctDHKnSw==
X-Received: by 2002:a05:6a00:1145:b0:7a9:b9e0:551c with SMTP id d2e1a72fcca58-7f22e09f895mr3415890b3a.21.1765395696493;
        Wed, 10 Dec 2025 11:41:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c509415bsm294854b3a.52.2025.12.10.11.41.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 11:41:35 -0800 (PST)
Message-ID: <a9283ec7-993d-4de2-8ff8-ee48a12a5124@gmail.com>
Date: Wed, 10 Dec 2025 11:41:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 00/60] 6.17.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20251210072947.850479903@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251210072947.850479903@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.12 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Dec 2025 07:29:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
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
