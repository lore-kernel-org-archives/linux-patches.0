Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263331DBB19
	for <patches@lists.linux.dev>; Wed, 15 Jan 2025 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736980077; cv=none; b=unCAbS5Jz1CDFN2y9fGIHdPouNRyevE6VxBxkUOKZGa25ZrGbgH2YXAvPNGtgWGgOZoMOXJqgN+1YBBBC/nBRDiATC5nxfvSJ4TQY1DM8/+OAE0ZAwprnevKIlTqY1agHqdIMhQCuW/EVmHjtW5yF57ghYqB56eYEq8806+1YaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736980077; c=relaxed/simple;
	bh=Wsub3r7kUiSE6AHXUccY30xErg779pqEZx0lhPVUf4Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pxyEHszCIZGTfYS05zEpHLeVaRXon2+FkFYkW3ssJGZfV/4i6dJP7xytlb5B5sijqJEMlM7DsOiq9N9+LHmZ5l7j2jeiM6oPBOLUEBZ44qaldiLhPOLfeG0ovdWNb4hIJy+0Qik5/fCi7Ze2AvEsP6PYUByMEZkdjnXWyksd7RM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uw3WT717; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uw3WT717"
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3ce7a33ea70so911495ab.3
        for <patches@lists.linux.dev>; Wed, 15 Jan 2025 14:27:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1736980075; x=1737584875; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZFJuM5NVZ1dVBv3WrImHyB7Brd5t7moiC7M6XsDLsbo=;
        b=Uw3WT717jUf6GHDClZqazmQ5lBPvYecsn+S6EP+E+IsdhYa5FvtzDaGl3WbIpzi9Ty
         EeHDl0ZZpjSzEDhU5RzWNt+nLzp6GX5PgKYquXMigYfwpHjX+oYf8bcgrR5pBTVbMl6J
         jiXhArQY8zj+R1Rw4+Nt3PEcuXARqxddCQUyg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736980075; x=1737584875;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZFJuM5NVZ1dVBv3WrImHyB7Brd5t7moiC7M6XsDLsbo=;
        b=lBzF3n16SxLUTuTz6Jr76LWMC4dPjF/w8c7KD7Os2WDuil42TctzPgKcqXaLl48+He
         53heFdw0ZGvSCxEorQ1J8jDoE3Z5NCPHdea/Mbj8A139hKOL/c/ULifvc6a/gQCMmFhj
         FgYAAlJtIytI4j3lqn84KokdbAyr6lqXWkKWuroPtmX4/7sTETs9ek6PgzH3FB05SM7i
         f9LplfsLzwgJ8UJQ8ncsRdCNNPaG5W4sy2xgC2GfDzwxF7RE+GK8m72WqdoYVDEXHe2T
         FiPk8qI4917jVkLP5meqPqI5QBbF73b9wu2POxHB4GVEH/ZZhCP2UWQzHk8TWfuh3i84
         Bckg==
X-Gm-Message-State: AOJu0YyAyXvRFmlHITJJMYK8A6n+r2UOP/aHJ3ADJzPuIEKFk+0Hs+OB
	S60LfQIkH7oI2uwyz6P8MKRFC83QWrEoan1T6Y/CF9Zl9C96y2ctnGR4ruTtijY=
X-Gm-Gg: ASbGncvG4qfseMLn3exKOBJ60Q850I7J9x4iHoZqt5FO+ZXBmoBMqAEO8tmB7OvYEj7
	nW4l7aaIocEGb/r5cOZRSCdxr+Rr3lznbLyEqomEqc+03r0VMXHWMlnUdnIYpM9FKk12MiqvojN
	uLBntiohoq0OyCUOtM/hy3oosuqoBPX/Pp2URRr0oHj/fxAZQavqXH5PHBwoX3VmL6u6kty9m6v
	/7TeNdKLWbbtDsQ4jQPCyNYmXqPf6aTskoEWYkcAvIdx8hceatGSdFUjfEmZZ1Ny7c=
X-Google-Smtp-Source: AGHT+IF2x6cH7ne5/wc+WpTOvtI5zlQZGORFHrFJKIO8AzOg4shETl4ZD7K30JJP/B9MSY5jutRYrg==
X-Received: by 2002:a05:6e02:168f:b0:3a7:e701:bd1b with SMTP id e9e14a558f8ab-3ce3aa760a7mr251410175ab.20.1736980075242;
        Wed, 15 Jan 2025 14:27:55 -0800 (PST)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce8a6ab77csm4916445ab.58.2025.01.15.14.27.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jan 2025 14:27:54 -0800 (PST)
Message-ID: <412d2b65-e47d-4a16-ac41-74f1e2a16fc0@linuxfoundation.org>
Date: Wed, 15 Jan 2025 15:27:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/189] 6.12.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/25 03:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.10 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.10-rc1.gz
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
