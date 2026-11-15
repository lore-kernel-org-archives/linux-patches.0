Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.182
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794714486;
	b=klSnaLOsmln6Sowbvk9Dj7ydGTOkdADFB170Ckt09myrxXaDMAPjkcEvxz5nJ0xCc8lV
	 D3TSZ/dNaFzeKRrZfncghCdcQIHi8tFw8mRtAfd6UjjIDU+sZPro4xSkOU9vUXT25E5k2
	 6f2mRY4U/7KpGtHTBdLj3nNr04MOvKd6xY9App+HLzh1GRAZDz6YBhxAMpRHkz7KMfKDW
	 fe47fmKZPr3dKrTGFAvJ83VsQlvsA8yAzwdR/yJgn3AIb+UplJGLGRyFkuTr8Mr0o+ACd
	 1YkTp//mo8ZjPGd0uXDfRQxmGPjfhj8d77QwqgNWSyRkbMyhLfplm51iB0scGJ36vfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794714486;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=koJgHflpF8SlmhITyVQWyV+LPgkeAJc/hP06L9RsOYI=;
	b=Jchp11djFrJ9jqduBXe5DiydFtomtDu1CBx5wUEiBua43FkN5KA52EW9GQYvB/EoBiHx
	 aYTcnKDM0cHOmXlIdvHy9zhNixQ6VrtQ9ZxRWiBCCk25sTngzRUl4pY/uYnwiO0MZYbsr
	 SLjX0dJb/KaG4TvorXBgP+ma4yrGWOgkWn9q0qWzm8o1JgLel9YAzQhl6rM9LJm4dx16D
	 vy/ta+A2jnqJmq5J1+uQu97l9tgMGQ6sfHsno1pNvlrjizQsjKS04cwFb39uD8guwE0HO
	 7REXnXMTit+TzpqLZrsqkkK7gRUmK0bzXNupyvK0JFvXhjjwzKgO8yQe/esLyYN3Weg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r6rs9SRP;
	arc=none smtp.remote-ip=74.125.82.182
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 483E5606A32D
	for <patches@lists.linux.dev>; Sun, 15 Nov 2026 03:48:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 483E5606A32D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r6rs9SRP
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-36e795af1d4so1704488eec.1
        for <patches@lists.linux.dev>; Sat, 14 Nov 2026 19:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794714485; x=1795319285; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=koJgHflpF8SlmhITyVQWyV+LPgkeAJc/hP06L9RsOYI=;
        b=r6rs9SRPtm9pbEoLz+QBn1D9jjp6B+EWsTk7GJ+EIE4peZ93hDPHA2vnTb8g0IScgM
         SIZZsAeh3HAffRzj85xUKaTEsN01X4U3yVSgwqAxYAJ1XOdJLHKThdZocSKFAw1Q1d/m
         ypJycvRLXnmrYe5V5UNbrKnK2SEmGLHi9mGVrbigrqKIP3dZybOj7ZdhEb/T2PXN2rk6
         0S+3voZCG2U1THf5u/YdhxsdEgJFL8SOeXgD2JGNUpOc7bIaHeVlWzD5omxUgVVR2lGP
         HIFKs8EcAvjgAMOZ24kdnxIvvW0Sclz9/Z8kgZDXBZvDLvFiNug1/6D8KGPPj11jLb6y
         1pag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794714485; x=1795319285;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=koJgHflpF8SlmhITyVQWyV+LPgkeAJc/hP06L9RsOYI=;
        b=nphE6H5O//EzH35llvF8c9LzSia06968hMDqDJTtY7yaA0RHWQZHlPPTElITfDOHbk
         SwPMYc23uUJGsIlZ690kVjiXdsIUqFaFnayUeNPVHMqUY1ekWUUAf3/7l1gT2Rs6cu+n
         UrJvxJjUQBmtcYxYXuTjL5j7AtZ7NFrovsfA44LESUd+aECLALTjIcRDL5/XDQEPnDTH
         OMID32UYNdhVPm+RrhYdaAtSgFdrMpmr4pmZQrMKJgGw/J+TPplkZWPHvGW68ut1j4nf
         Sh7H+mQe4tZeXpifYy59wQzOgRaxFPCyobhdeBFXiQ7+FiPnsKnv4h2LaLvze6TIP2Kd
         B39Q==
X-Gm-Message-State: APuU4Z/I+thIK5RKNCsoQTWZKSdaDcPw3tvgdcnhQRfeTclFvNFFXPTB
	n6Qz7ZMxuZGfsOCxcNE4kbIqX1198FnBqqQffdJMBlisXeR9FwjBAOFk
X-Gm-Gg: AYBFou1uaRPmE3JDWJGFPCJO89YsaBIo0MtstmicXv7nWYjV8n7MLNhl8xlPOl9TRKT
	bq2ciRqnmpOAHX52r46j2jFbDeRrEudNq5DqZHySfAjF+jUsHUyWjNGci6OCKSthZULM+LpUv9O
	QnDmFCy49qjTB1Z2eX++rDXHav/OfkOjqiVmgUjI7RWQnVzuq0nEfDoba3xDZgMRjUBNF3zi6m5
	iqvOM9nnjz2ikJb13y7lSzZR7rMaqoFCEnaQNTKBFVycgiTIpVGJOOhEPZk3vuPUJHV2oQ5VOyw
	vpkxJviFAB9/jxmoq4bVyGOrguMo19G7C1zRA6PXsLCTn2RKmyNgqKYJsnZr4co51o9ADNpk+ZR
	80cTPmMZGep/7OvKkUOGgpTF/ffCC3JBYGx9EIFnsvChvm8vOEfjilnSkYY4nZgJx5mHm1R8rC7
	Q9UWSDBtiAmV/bhi23XglVNBUjDWjF7kCDiJAZDtozkjOklpQ+S0dTbMD3ILi4qaqacCeqO44lS
	ip16ngYkvlaAlFM+nwC9n6unrKnhV1uWYbOh136IY6gHhzVypvzSiAxa7qizox9Jx6NK48pn2Zt
	hypxp9uYR+fAc9mERm3nQR4mvX84GqPrLA==
X-Received: by 2002:a05:7300:c00b:10b0:36a:647b:2d7a with SMTP id 5a478bee46e88-377db7c8ac3mr10822333eec.0.1794714485325;
        Sat, 14 Nov 2026 19:48:05 -0800 (PST)
Received: from [192.168.100.6] ([121.144.254.242])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-379563e6b6dsm37381434eec.21.2026.11.14.19.48.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 19:48:04 -0800 (PST)
Message-ID: <84aaed30-5259-47cc-88b2-437b81efc90f@gmail.com>
Date: Sun, 15 Nov 2026 12:48:00 +0900
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/686] 6.18.64-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153820.902362109@linuxfoundation.org>
Content-Language: en-US
From: Joungmin Lee <leejm516@gmail.com>
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/14/26 12:42 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.64 release.
> There are 686 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Nov 2026 15:36:17 +0000.
> Anything received after that time might be too late.
> 

Hi, Greg:


6.18.64-rc1 successfully built and booted in my system without any notable
regressions.

Distribution: Gentoo Linux
Architecture: x86_64 (ASUS Zenbook UM3504DA)
CPU: AMD Ryzen 7 7735U
iGPU: AMD Radeon 680M

[    0.000000] Linux version 6.18.64-rc1-900-myllvm+
(user1@gentoo-zenbook) (clang version 23.1.5, LLD 23.1.5) #3 SMP
PREEMPT_DYNAMIC Sun Nov 15 12:36:52 KST 2026

Tested-by: Joungmin Lee <leejm516@gmail.com>

Best,
Joungmin

