Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA14282F3A
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 00:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786149512; cv=none; b=PTi900IutNKYKCeCmfYW6thNAbjMeEKP/cu/ryjhM1ppE1TT4Y/H8hBG/soAwEjGFaSzp26s6Z/+DlItZDHCgTiV/8Hl+pex4eeqC13DBvP7L/7BWx5FdInBPeDVoef52CbAFSRmQ/6g63axbKNxVPRyIYB2LcxHPKwkgIvqLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786149512; c=relaxed/simple;
	bh=Yi3apHusaoa8sda+E3euSgrdABkSXubVEZD5TKsM1vE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zx92wEO0gohk1CuLM7oGRpIqt0PXDFIKtR1gqCp0NpmMnc/2tTYSMEr6sae+8FhPoyYv7wiTh/M130Rb1D83rtih8cWvRgU7y9+uVj0sIuoAQ9Io5QtkFvm2b56JVoEcELzRzEBVR1cRzdVB+vhFNBxO9bl8OWl01QBLOGIPpy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BBVvwVyR; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BBVvwVyR"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7eb545db3afso141378a34.0
        for <patches@lists.linux.dev>; Fri, 07 Aug 2026 17:38:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786149509; x=1786754309; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O9FQoV4IbWecbqvw+TMh5taUA4ZJ+Y22rOmFU2DLpiE=;
        b=BBVvwVyRfVJOBoD6LsPZm541wcROhhYnEij+/tevAKFctGG40GviV1uuTXOnlWXGo7
         N3VvNU4NVeq7u/Pta/zgrFZ0mHujdK/OMYXY6NVNWirw0Su9DVcIQY/SvM/1KxPm5Odl
         N1mgUSZ1xc/4QcY8Tn8I0ayOXLBac4qP6J31g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786149509; x=1786754309;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O9FQoV4IbWecbqvw+TMh5taUA4ZJ+Y22rOmFU2DLpiE=;
        b=g0tR4n7sxfsSJwZMMjY6c19MfD/EDv2j/LtGA8m553L6so3IUzkPwLkeYAaxUFDFGx
         WT9qRXHFbaj1Xq1SjYDgC32APMi1TZGRhiovTrbPF5TnN7CNo1CpDMX+LQFg13D24+5/
         Qe3I6OKq5OEvVNPVkVrIP8Dt0mOuSDAhXne0EhIUlCX9CWn3YDzJ7A4qLINszNnLVtkM
         6NgV+EX+6Bu/AC4/PVxeCvSdpLYswjYhb7hbROSU2dcN5D56G+MUMxhuqDql6VeLcZIB
         KbaRdJc+pdgnyt46+yP37DsDLrBheNk5tvT+Q/TaUJMOYHVNS1/srFnoht6riMnshaXi
         73Kg==
X-Gm-Message-State: AOJu0Yw4nVJS8xZVKKNIez6gA2OtXAP8Nd7swqVLmYvNnEy0STlqVjQu
	LFlD1ASHo9TE+3FUgtsXLvDCu5+92a4DOjUqgSoI7le5NGN7dOEvoqbWxmxhBqZAArw=
X-Gm-Gg: AR+sD13tsOIFWwBtmOFBX3P7oqVejRs0kQ12Q/1kRSdu/sZvMg+PPMc7Nf4T1yk3ZMl
	9Ffjm/y0z2AE2VXVlP8FCscO0zQP8at2D1tJuo8qEiRiXSWBKxaX4rGUpWf9PxOEjiXEwWu493I
	6VDlXakZdh+Y8dWg4ieci328+cX7V6RYhOixvS3Ncy0KQ6zIdWHjTEIn3cXGw9OBnq+C2zEPHfr
	Rddloe4IYX7DbqN+LQFq/rXJ80tfxIONo6LmMHhOMPTq/m6tcO5wPN4rOYtcY3G2SMEfGIPCg6Y
	K1Py3B2J3HW4v1Eo/Gdv7yUNwkNWfS7aHVmzrEC9jwoZ0C2Gdm/DTY8+/EVxO01hQboOrLD33UW
	G6Z7qHm7zNqAoGKAtN/SjdWUukqDjs3evSRhGfs/Z74J86NhoCnBemK8VoTUtCJI58qpg9CeUOg
	/kFTG3VGBkqxfBU/G10O0Qa6ERPbzA1MOem6sZDuTy+nY0VyvUFj2KbxCQJOUfrHdJSDi1IUCxN
	MlyW/Ou
X-Received: by 2002:a05:6820:2918:b0:6ae:4be6:64ee with SMTP id 006d021491bc7-6b0421f92aemr2421437eaf.34.1786149509450;
        Fri, 07 Aug 2026 17:38:29 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-6b02bfca2bcsm3617439eaf.15.2026.08.07.17.38.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 17:38:28 -0700 (PDT)
Message-ID: <2bc86579-1882-43e1-8bf2-d87c8b37ba8b@linuxfoundation.org>
Date: Fri, 7 Aug 2026 18:38:23 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/261] 6.6.151-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/26 08:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.151 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 09 Aug 2026 14:33:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.151-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
