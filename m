Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB9D4242D65
	for <patches@lists.linux.dev>; Thu,  3 Jul 2025 22:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751580967; cv=none; b=U/okANgqnEtGwZyJ66dHI5B8n5dRmQ/YHeVGDVGtl80MTzC4SVntjR4Z7zP5jLvhCVRERURYs3TNU34m7MrGfGI5WNEVAlUEsF0VJ1TfEBb2PCktLCazxfPZKvRZr5+xPlDl1D7cNTP2siylS1JNEFcojcGaip1bWDulmIhMcmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751580967; c=relaxed/simple;
	bh=30eSpXy4De1lX70AW8XZs3ihzdfzo6XZ/C3uT7syH5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kb/syES9tVvbkbYNhWzJYX2QuZZPJqe8NUebBxp0VrXqTw8imOx9krHbIHSIA3gFUKr7iz4crzmW6fTFCdCAD+lu7uzuxd2U/wqwRiudWMWGVnNBAqQsiHntpHFKRg3WFwDdZAj4Yr+lz7/fJe/ZcP6SwmFde53DNOGcQiH9Tpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGKKsISy; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGKKsISy"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3df303e45d3so1587835ab.0
        for <patches@lists.linux.dev>; Thu, 03 Jul 2025 15:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1751580965; x=1752185765; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6+8Lqju2v3JEpna1RtwZcpnJkSUldnP87c8e45HlgwE=;
        b=KGKKsISy+xAoTWZovokmqRvhOZPjUDEg91kHDLyd8zA6OROX9VD/4qNXXxRHVajJmY
         vcLUQhnKrU17LLzovJn/dI/xU7Bqo3/01J9F+AwV63TMcQoQiJOpAnylXuxweR9/vy0h
         tM8KLLq962gmjcfGJnDd/p5g9LE7WKvL+4RZg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751580965; x=1752185765;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6+8Lqju2v3JEpna1RtwZcpnJkSUldnP87c8e45HlgwE=;
        b=G4UIcmwP//o8IIbWnoD329WQR7DlCp/ImEBYpySB9Nb0tD9snFrfOWg6jjsKkkVntO
         WQvlu7RJnuByOBuRkvGOcGTncGjJmJM2U50C2winI5U18saxGtN2vw2lMWNPkyi9TTEa
         aWcZza4N7yZRIP8+PuEj8AGuPByqZfAKt9EH6oWk1h8MM/BXl1UYyyYSYwPH8UIuDaZA
         ERKPpYWfpa021SSGOwzvfd83CsANB6o5qv+BnbUehETDKIMOk/6ONteo2dxgqTryAZ8M
         oIFiC6M1VaAOk+m3skx15GQOmf1VTW3+VhCRTGAx8N9l5i3XvfriNk0mItE80cImFJeq
         TwxA==
X-Gm-Message-State: AOJu0YxbUADSzi7bI1qCp+/sMJHxxr4+P+gSeSj1cZPHhLWutAPPbb/5
	vkjFVZ5QWR5y8Zd3JbHZ79gDoAqWSkA3alrNB/ZbiG+mdJ9CV5hvU3e9F/zpnGsEv7o=
X-Gm-Gg: ASbGncu+9Nz23MGB4QHY/gBtBVeCuqqnQCKvbEUgCBEXWY6DKuSQIQ9qB0N8kyoCvm4
	FaUnD0Hv/mO2iGtJIbHh+vNkCLhhPtGXhUNiS2UDWvtdoTmG+yRii7lWOEO8HhJj//T2C7JyLVU
	nqrTCZvtX0Tf2Qq1Hxf0Lifkv5NfQAKW24Sn24Q5Em1TyLEOPlrdM/oQjDRPceuudIEyZzBq+ha
	aDITyt2sBJw0oJcd2IdrgH9mMY5gcWujonNlpWpm1i9GZ5pxoFmeUT2qc0PggEcLcmbqbSbASAI
	N/iSBli8AIEdmodXlahy4KHwL42akdzRQT8gucNkZwk3aZv61jBp0h6g5WCNedQNqQGJ23tNNw=
	=
X-Google-Smtp-Source: AGHT+IG4hKTQLow1Kg67H0QZK1tw9mJw0uWny6JBPFtWfdVzPOL4FEhBvhn/KJThkLj9LlPS0fuDrg==
X-Received: by 2002:a05:6e02:1c06:b0:3dc:7f3b:aca9 with SMTP id e9e14a558f8ab-3e135576383mr2032415ab.14.1751580965094;
        Thu, 03 Jul 2025 15:16:05 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e0f9b8cdb0sm2167885ab.17.2025.07.03.15.16.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Jul 2025 15:16:04 -0700 (PDT)
Message-ID: <1a3a5dba-b42d-4f4d-8441-ec34fb37d10d@linuxfoundation.org>
Date: Thu, 3 Jul 2025 16:16:04 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/139] 6.6.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250703143941.182414597@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250703143941.182414597@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/3/25 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.96 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.96-rc1.gz
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
