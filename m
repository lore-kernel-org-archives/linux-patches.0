Received: from dispatch1-us1.ppe-hosted.com (dispatch1-us1.ppe-hosted.com [148.163.129.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FC5B1EB192
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 20:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.129.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740084398; cv=none; b=VQmK54HpHYjAh5wKmnww31LzZ2a9SsceNVtxoVCHZ81E1u0CjKGhCixqoCuzbVNCO3MCxJ04V3pAHKk6t7vFBl4hiwEJ8UQ5a7Tit7qsD8EjqDRJQ9cR1jtEW193RuEOTIZ/nqy+O2Rqj05B4KbyMAXUQgzPdgiyRXOteWoU8+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740084398; c=relaxed/simple;
	bh=EXXbsELd4TnDhPR+oLxmC6mb4dDV4YYCWuYKmzQgrW4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V0LH4Ny2qv1Xtby8C39cDhQeWs1cXYXLE9hUsXNon6PqQ7RuivS+qB97vkRvU0ki/2sL3VXhnYi/ZL5pk3FKoGPS/VC/IdBWsg7OCOVLAiMzeXgkOeMsVnRywvA0D5JOZ4Uw7+v3MEWSLSiVouDh/pLfDWotsLGFl109u9QL7gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=b4iQDpzK; dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b=ndeP48/J; arc=none smtp.client-ip=148.163.129.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sladewatkins.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="b4iQDpzK";
	dkim=pass (2048-bit key) header.d=sladewatkins.net header.i=@sladewatkins.net header.b="ndeP48/J"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sladewatkins.com;
 h=cc:cc:content-transfer-encoding:content-transfer-encoding:content-type:content-type:date:date:from:from:in-reply-to:in-reply-to:message-id:message-id:mime-version:mime-version:references:references:subject:subject:to:to;
 s=selector-1739986532; bh=MWhuwPKRWHuBZzoHcb+oOoXnrhWEnQoYXYXKtP6logA=;
 b=b4iQDpzK7Qt0irFVVmnSEieIo7FsIkqKYnOUsZi2ej5L2FXEEULlgE5U2bExNSOVRIBTGIyhaeUlYzDAbMTgAgwWmcf5sKckOezpRyYoFBBAeNxTtJLVi3OO+S0/ZwnXwE5Z6R1gq0bBYw1bu8CyCTuIvTGk4SQJURoU1+u2YI8N3fEajr/8pniN93JOO+ovNcTjS25adgOC7p5ZHzIpBxfkSRclJc1i95Lx/pBFd5TDcpXlhq1W5ViBLk5EzjrD2+2GmnxEtrXofR7Wh/u/hPFzbxzDpbWCEt9NRv46dVKrZnHmCG4Cz8JaYok4Se01uYCY8Kp48xAaajf8WnoTcw==
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 35F5E60012A
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 20:46:33 +0000 (UTC)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-472107c4b5eso25686241cf.1
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 12:46:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=google; t=1740084392; x=1740689192; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MWhuwPKRWHuBZzoHcb+oOoXnrhWEnQoYXYXKtP6logA=;
        b=ndeP48/JqNmfyQUsdxSQ2Zbg1Koe1KoyfXdaUaD1AVlL3YEsf4RamjRQGaal9QiBu1
         DNHO5quKGGqV2Vbm6SJIuVB+hpx9+B/M4Y5F6V9E8OSCHljbrnAQe1QXMjYio+JPipOZ
         se5zWEPM9LYbV01XlfjwzmUOnk3zjMaycslyBcipvpy1OFbbL76y6z3Hctir0LWfhSqb
         fFdu+LFCW7ABs38qZ7SV6UDn+t1Ja9h/57rSZ696Uxw1Z8EWx4t1yu0d89OZYjQvHnWS
         naesHGj26a6qcKC09hmaBi5YF47QomR/0d+NLX8BDv1YKp82qLhQ2JqmnP45BVhfuqik
         9iWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740084392; x=1740689192;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MWhuwPKRWHuBZzoHcb+oOoXnrhWEnQoYXYXKtP6logA=;
        b=YsH93OghjDYh306kN6fn7egLCUr6ISbpFqbWi+iITjZ5V338OA5cJTHWOQKLotISro
         oLAteH0uioq4EZAeE5JKxrwPNEPbO411vzae4ExfN+NgaI0wUcoMv4J4VGF6yKP/s/Ac
         jn57n2sZieSWrmNbDfCLSlF/XdmRADUxLWjt+UIHdJwfL7VNcSXLpwmtqzWHEifgdilI
         9lZOwqwM6xqCPxNj60wC39QQNn5drY08ooBg6uPfKXONRvflUSzbjOUuPjs4LzQ/3T3J
         a98D0IVVCGsZlRDpkBcAPMNZgEfNoSkllFW0RnuP09rvGqgBCR2eJ08zBP/cmThwqfY0
         nISg==
X-Gm-Message-State: AOJu0YzLQ7I75xDD3m4NIn5tsMCdNmsBkvVSILk6R7x+LoUa37le18U1
	aJXS3FOcBaye41mDJLoi5ViSpQ6af8dCy0lNZ//zrzCrHtkT9oxmbarMrL12fWWtsEfPjmI5QmJ
	TDRTxgvY8AkWYJS2mLvZuggJFuWeAAojjWl854ozv+f97C2tbQu17N6TMg2koXAPVsDOpvITyTj
	wh
X-Gm-Gg: ASbGncsNqMmqrvBrWUDcGqm+Z9cXzCgEakyjacWQAiEXpAO5Tf3VrV3lvPM3kHIMJoc
	3dtHO6Sf4y/DZOPUskS6T80gLeHqdKho9D8prv64C7y3GJ4bvHufisqrnAChiHFPy5VNGw0F8mB
	U80fezylRirF/GZN7BDerA4/dPFsstfhoihOkR6Aswkx9ToMD4clYerz0CaWtUgIJjOZ+l0IBHq
	2W5h3aEoAoSfn3KzjhSHIzQpVzcD2DqlDI/u3ahWtw0mH6DmCtKt/cnvqGn5yHb9iuc+019UrZh
	7uzo2ytAswdZDsK0SBQ8g9pzUHzbyd3a7WgQlxsjrsfSjegate0GWxPVin85txz1JgL3
X-Received: by 2002:ac8:5d8a:0:b0:471:fa00:fb9b with SMTP id d75a77b69052e-47215028ef8mr70119361cf.7.1740084392168;
        Thu, 20 Feb 2025 12:46:32 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEwIrdDUc97c/BKbB21dPMuIBxKNLN7eS9xsTKAR4FBChuikeOlqXnwO7mamsv7/7FKtD0kyg==
X-Received: by 2002:ac8:5d8a:0:b0:471:fa00:fb9b with SMTP id d75a77b69052e-47215028ef8mr70119061cf.7.1740084391862;
        Thu, 20 Feb 2025 12:46:31 -0800 (PST)
Received: from [192.168.86.34] (syn-076-037-141-128.res.spectrum.com. [76.37.141.128])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-471f0eba93dsm49479581cf.80.2025.02.20.12.46.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Feb 2025 12:46:31 -0800 (PST)
Message-ID: <7e94a24d-d2dc-4f77-b2ac-dc900552ec90@sladewatkins.net>
Date: Thu, 20 Feb 2025 15:46:28 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/258] 6.13.4-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250220104500.178420129@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <srw@sladewatkins.net>
In-Reply-To: <20250220104500.178420129@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-MDID: 1740084393-GmRbjPHFDdbg
X-MDID-O:
 us5;ut7;1740084393;GmRbjPHFDdbg;<slade@sladewatkins.com>;34a45300d431351f6eba03f8f221989b
X-PPE-TRUSTED: V=1;DIR=OUT;



On 2/20/2025 5:58 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release. 
> There are 258 patches in this series, all will be posted as a response 
> to this one. If anyone has any issues with these being applied, please 
> let me know.

Hi Greg,
No regressions or any sort of issues to speak of. Builds fine on my 
x86_64 test machine.

Tested-by: Slade Watkins <srw@sladewatkins.net>

All the best,
Slade
