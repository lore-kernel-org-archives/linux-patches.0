Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B641A01BF
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677979; cv=none; b=I31LrTJdpoYHAyNtXI184ORgWZZ0XXz+YcNiYMPraHmLewbW2+Kj8py5pbxLaEKBxRDK4UuRr0iG6vv+f+6rwzs3o0cmKgyx3KIVlu63LcKSa7gCyK0HoOKy/BEgneXlZeHj+JwLYI07V7wu/eD6AOqF1u7RlMX5Tgm4KdOBnIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677979; c=relaxed/simple;
	bh=pElvr6OAn8/o0rsAhu8xEJ0k4OTTaUohXepM9+sPZes=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=blzNIcV8CPnkE2fMgSsqOgMOb26xHP8AFkovBZE9oek1OAE8CerKR1g6uRkK8o3j28Io1ZERkwG/IfRUl+JznoZTmbdbn3mpyBbt29e3ZTiC1R+P3cW6tWDe63scbvFJ6pQJ/kppCGi8azEbwJcoP1/bGlX5Sb97+/d4Q+UTj8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhvA8Usu; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhvA8Usu"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3de18fde9cfso43358435ab.3
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752677976; x=1753282776; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eJempd4OJNDSO0EWYBVMBDa2dGUd1yxIO1Ir4NFgQpo=;
        b=BhvA8UsuI8TTQdnQnztIkDZM55QNavfj2kxzd3CRMwimGFojGFUM3eHC0WQtsmHX6l
         19/gZ9MgwGqnB9AYu3W976FHIbwo3RTv73F7rvj40EclLBz6nUCgIem3HmZk6eH3vF0F
         AC9jhiMHWMYSZYzhvs5zPyzUM0GsktTGnGzwc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752677976; x=1753282776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eJempd4OJNDSO0EWYBVMBDa2dGUd1yxIO1Ir4NFgQpo=;
        b=oi3E5B8nTPHhfxaDRxsGbxO9Xak+2ZOhRFeN58ZpgwUkwd+geZCahzoEdn+NhHC8qe
         8ecXJ4jTT/0ggLpGWgk9LYjK1YLApCrN6BBQ2hHFmWiyMGxCV0dvEBtzsRzkH46braDn
         Wp9LEK1+FZdJw6yV9KiRfRBp1At0AlwjEf1xxp3H0WvxQ2IQbeJ1+0akDEZ0d6Aj52Wh
         4A2F2DlGH29AKpg3JnIO6dDgwr/5V8xQXbqQ9nejSu6ltWjW10ERi8x9hw7gP2iCXdgo
         0LhEiJLBac1QF5gJB0wWC6gIrBo4NPXsHc0JfXFwPq009lZMI6Y+YqgDjpd6RaFJ8xdE
         mdzA==
X-Gm-Message-State: AOJu0YzZCbR1YzbmOaZorI4ZdVxKdjXUFQ2ht4+TfvuklJP9oXp8FKEx
	oOuKltiLXP1sZcT6JWiSaqUnHAflSNIoUB+t+tkoP6NksXupB4iirbH7YMTw+kgpbBhbtA3tYEn
	faZRI
X-Gm-Gg: ASbGncuTGyfnvB8RTz/Gb+6kNGSiGSSRmaQC63NcPAKW+D7nWMg2bBkyGYgGb1GTPe8
	cRbguheZ1ev0AnhfaH/NcGlzsPt1eDnGquJ4pMkTEhhsFJagjJvUND7ol2T5QG1LhKw4P7xDjzQ
	Ne8xYUBGf5zuQuWdVmlSQAyDDXbpqd259h8O8dxP4kmpruDepNTf3oCDwo6FPJfnp40y7PhWyIF
	XQ9zCBKmQsTehuxUcYo0xsABFequMAWUjuDqwvm2MHkrSqxhY8cUr9cJeElqLha9zZLbomU37xM
	EFCEg1CqdGLSVPioBYzsc1s18mRk7fFCIxWReP3d4ebqATAUDsF+4keliwiDDYYy1GDEiQ5bzuL
	/+vW7MFmLDa/6GioCFK9c6Yml+jIBKaR6XQ==
X-Google-Smtp-Source: AGHT+IEHyBKfKdnKKqLqyogPmYS+T+iV5IDluzDqDwsG+9OoFrySizp12bUVr5zit6PtTuV85Lqb/A==
X-Received: by 2002:a05:6e02:3497:b0:3dd:b4b5:5c9f with SMTP id e9e14a558f8ab-3e28307b2aemr34336545ab.19.1752677976330;
        Wed, 16 Jul 2025 07:59:36 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-505569d0e4dsm3015334173.109.2025.07.16.07.59.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:59:35 -0700 (PDT)
Message-ID: <d0459758-767c-4593-8954-bf5f23be861f@linuxfoundation.org>
Date: Wed, 16 Jul 2025 08:59:34 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/77] 5.15.189-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130751.668489382@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130751.668489382@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.189 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.189-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
