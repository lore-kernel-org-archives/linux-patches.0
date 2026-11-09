Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794254802;
	b=AZsqOeN0F2YAfvtqQKRXo97Wcjs0zQsupNHBJr+zd4khNeAGFug1NtuHaQ25o9GOMnD+
	 uwJgnQ16Y1bYa7OMZHtXdsQuD3i12Qd4jI6G9nDefmWjLLvyjwv07YBDO9bJ9hbKjbafG
	 6hhSbMoQpZKfS9DLceNDEQe3s4R3iWztknZYHwyWV++0MJcvjHqFKVfnr/T/gyGwy2+Xc
	 +XH604HP3dvgurP2wAILJfn6EDJdoLmWYewCKHMlp5Vw22eDePQGw+79/c0PKks6HwGoH
	 XSgoeK5/WbIiRLdkjKKlNkIvAJe+vOp/Y7+txChG3Fz8x5hOX0SjVB8MCjqLfmt30Fw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794254802;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=foef8cSuDtXRvHW/3i9rIYIPK5SqXDCZtNX9m115QFs=;
	b=iK1/nvHWANiNwum2yXRabFC1t/X8t3ER5fLeVvQgJ7QWxLhXx3tkj0Le5ck3SvsCFlXt
	 SXa/+47ZV0e6BpcoDT6uwOw+em9oGk6pORm5M4KXYX/or3aBJPfDDEPWaBT3Mr0ibgYlH
	 BZgodw9q+jOrKzWYL4sa9LlOjiNT1d0V0Zm6TDFN05DQY0Hh6o6lGGhLbRHvNoG7sZMLm
	 IZi2orD6MHlGIkrQdYQHSfqvyKYpIAwDBCpQT9A2WNAZmbMynD0QB4Q4W4etNuN8J/fDO
	 4rhhLXWWUsAk8/NCE/EyugPrO+NMGgHtHHEnvPbauKS24qWMPea4neg9mZeDMVUdWAg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=BuhrKEXl;
	arc=none smtp.remote-ip=209.85.160.45
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 071B2606A321
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 20:06:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 071B2606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=BuhrKEXl
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-451a49abd8aso1285551fac.3
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 12:06:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1794254800; x=1794859600; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=foef8cSuDtXRvHW/3i9rIYIPK5SqXDCZtNX9m115QFs=;
        b=BuhrKEXlBXTNE2DUDSWjv40TY1qJ5jbY50iwhmxpdQ2bPtx5tnksjz3ybrX39lM9a6
         fz+ncnvER55Npwd+73BLzRDOFAuoL2ATXHMwsmKorWkVH53ZmnaSVbJeV/WqNg9xpO0T
         LP6Ucv9ZzfTEbQmL3Jw3VZqQ9T2TTjWGLrk58=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794254800; x=1794859600;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=foef8cSuDtXRvHW/3i9rIYIPK5SqXDCZtNX9m115QFs=;
        b=whIUZ8Kjjfe+VGbuJ6iHo/yX4iRqb6A5ok6F1EZZouT0YGNo46QmrWi+eIn0ZU7Xl8
         vVszU4BWSQpEjC03kOR/Gyd7edbEHkcMC88A09Ul4t7tIMKmeGYPXt8f7sCMmDCk/X3g
         z1v17z1QdHSuFfXLV6Qfum1ZwOiVds06ic/DY7eWXWW9R8JsK/4wwNu1+pjtLrdCzRDd
         Tt4D80VRz6ilpSpqN8aruB6hPFZpD0Q5A/sNvgZXOWTP27QzSO0hFWA/h2OSfw2v00fT
         bSD1LVyF74EGW+olyfOe0Q9laGEgf5nUEJBipsD+WbY83fZNcAT/j8VZSV6/YvgWTVqN
         kbjw==
X-Gm-Message-State: APuU4Z90mo0X5Rt8NBbhuubZ9rxBnHXqezkYeGRFoo3DM/WMwAjFbNh9
	cWErKeCxtAnyHh+Q7KNML5iY4iZmV8g3/Wsp344sSkGPS8Mr31wX2CtAaNO2oPHLGdM=
X-Gm-Gg: AYBFou0vjkjx5U/IL6SvFwLCzdY+39rcLxrZJhodWfNofUAKpQCi3V+4OJF/m9kZw2Q
	ogbP4jddDT8VO9Cm3EDqTqFnT0YTLZpR7fM6tJ/i2CNFfkvzJdOw8vqjJDT4eBlDvyE2BZlFzER
	FcFBy7lgQ8C6hMd8Po2QFK3ryNmU8Rt5qZ0KAtZUehP1hPtTfXzERmi9epcWg53mHAutk4cxhrN
	1SbxhpbcY7glFkw73bmqP4kGL2S2miidjG+ZYDK3IJlrj7TA49rloLL9Tf4cHCr9VdmTSisrk0/
	yhnUeI6dzdsZ/b2FbaYvqhRyEUajIr+awOq2BCMRg4KcNw0sGwXc+1TZPzRLFpZzqW2V619iZiN
	JBFJu8s0ipD1WErlG6XQbLu73RC8k49Q8sPrNIS9MkutvrMfiGDW2gxe2qkujgiqIPEN6Bf5hTF
	XI9j+Ek7vj/2Tt3rhIOESUyWKWJaiIxCqv9Tous29kYFU2KMmBFeanjJAx0RyUBiEEP69qdhgjX
	KGVb8zwJEZMNHrxR0s/ozxZxtdNhuEP4pf57gbFmPNQvoJaW5kXtfy+ILbjT1D/3+UhneSCkjnj
	K6Dzkan6KKHywiINFp/Pn4HedF/jAM/gCnHiFg==
X-Received: by 2002:a05:6871:d212:b0:475:e066:7711 with SMTP id 586e51a60fabf-4ae22612a18mr178123fac.24.1794254799938;
        Mon, 09 Nov 2026 12:06:39 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4ae2308e3ccsm85800fac.15.2026.11.09.12.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2026 12:06:39 -0800 (PST)
Message-ID: <73aaf4d1-3cfd-4128-9c2e-b8bda16d535a@linuxfoundation.org>
Date: Mon, 9 Nov 2026 13:06:35 -0700
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
Subject: Re: [PATCH 6.12 0000/1536] 6.12.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/7/26 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.117 release.
> There are 1536 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Nov 2026 13:46:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
