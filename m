Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299962571BD
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 20:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755547923; cv=none; b=q3shsn7zhzbEXu9+qjGR+bwiqscrkxpmbILunqeNbq6tDShagziNf4jBQ7E0RgDdjyoWNPGJe4ONjsql/uWnyJLibS4+rOg1iQmYOr9IV1sM0jkuzflVVyyPerbEUyA3nVDqcQSYUBuVqKeU15Y4u+rdZiJJ0CNZlGLvA3TfpQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755547923; c=relaxed/simple;
	bh=ZTEw3v59byAbxSZgmjys08ROhmY00iv+6lSpKMPh+2s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ELhbhWciFlUBa8Ss3VvG+hvpymkZFvWxAiV7/o2IWiRF+s/5EmC1t9gSjQDAHl3J3EKT3zr27KaotQDpm5IuvTIZSwfwYwd2EUTn85Dxhq9tDV04bKTzQRK6z8Rfs7lm6MD3Rkl9s4Z+XRokwJI1gooDuF+nfaLMUjKwdGoU1ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FhAYsdai; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FhAYsdai"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e582bc3720so15521545ab.3
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 13:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1755547921; x=1756152721; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sfUMdozgYccOdsGAt0DPTeKUGhDvpTTBYKEk2M/luYc=;
        b=FhAYsdaimdquc4zvMgO/eKUaDL0TSmEK1J+7kWIFekgtgsDrRUnTvql2kk1ApznPt1
         LjgfdHQ3JWUfYbwjkLRIhXHf2oOhcuA1UChDmBr6BRz/EcmEkvGq8rmWnCRBFo+x4DcA
         eUiaeRi2igFJpnPACjkjZa5msfJLF4Urx1qLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755547921; x=1756152721;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sfUMdozgYccOdsGAt0DPTeKUGhDvpTTBYKEk2M/luYc=;
        b=Eb+JJfV0ak/gtuburfJhmkDOTeZObLBIAx6PjT5yUYXeF0aGOKf2cvAUt3f16mikAI
         YP6MET3WdwJ3U6uvyLacxIfz9LFQ6V1VV3cPDrx0m2P3GGg8tymUT9fEHzfzNcCiW8qE
         2I/fEJuLmA/MUUz1puuY+K3riVW05DOx8edbv79k6rlBsYmeS6SCyoco7r8HOogoRoOI
         6EOmNSGKitKXNdd4W1soLSoRE+07XwMvZ0lyUz1zwGAj4ura/nUK5oBNpodDDL9j6rRw
         taT3Schk0SmQ+bLFLfxuldYPsCPwLP/2MmVxwQ/rFaDnR2gexKux5AuPK9ctjx9EccQ3
         285g==
X-Gm-Message-State: AOJu0Yxer31aqqXpqaCfMcdhODVpoiJILdte0qOH/+6WQIRNb5c/15an
	VYMN/5y31pnWPMrZok5XLFCtxxx3tgW+w3/hyEPbtMgco2rQgdN+a82P8T0qPZH8cqA=
X-Gm-Gg: ASbGncvsM8tWjCrq4Is7J++pZ0XOXJLqmnWQv38TWfZdX6y/d0U9pbE/3AqUzBDmqVs
	Lz3eukIzcJDYpSu8QgNT7Fy06hZUO8UwOhABBVq6Hu876zmWmUMYJveYd95wooPGh7vtvsNX0pR
	k9XdfGdQMDsbOer5xOjdawOQae6wgovv4vWF09n5YA/0q/+b0u/4QpuTCgYsQk2OVuZfeDjSmYc
	lWMBb8dipvDOs9ZG5TE+7o88RsNcge/g8wXlKy9VYXlq9AKfqdx8XX8CVFgiF0Gxj+75LLw3yBi
	uGdpn22MVUNRTMUzUHQAcX0Eeq6dih9ZSA029yYbha+yC8F0HpBFr4Ioiv/EIxpuEx47U00i0Zx
	iBe0L19/iGVqrUtbteQIFwtQkK5x5JDOtP+n65Mu+/NlYSA==
X-Google-Smtp-Source: AGHT+IFcGP4eRLk9XuN/IRxuYbZSmR1FokdhKrwhASissjzBWd2Po9X+zsiqxt4bWrarLNWlvZDNHQ==
X-Received: by 2002:a05:6e02:3e93:b0:3e6:72e4:c5c with SMTP id e9e14a558f8ab-3e6766555d2mr930395ab.19.1755547921189;
        Mon, 18 Aug 2025 13:12:01 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50c9477ef61sm2927751173.8.2025.08.18.13.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Aug 2025 13:12:00 -0700 (PDT)
Message-ID: <bb7f37d2-dba8-4d9a-81f3-e1125a620bc8@linuxfoundation.org>
Date: Mon, 18 Aug 2025 14:11:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/18/25 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
