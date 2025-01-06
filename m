Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A3711DF73C
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 19:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736190717; cv=none; b=ld+jR5qZkVO/1zzHiQgXygufPa/2pYCAVvAP61DyJSW3OH37HlTkJkgIWug6Y79DSZwv73ayGqHqg5UYqNSrG8BOxLuaIZadmPp/dOghRbakFzIrqf192PeNLtZDYd2WCCFzaj9SBsxjRMymM18S3SecAhYMGtMS5rBSztI/Qs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736190717; c=relaxed/simple;
	bh=4bnJouhl3Fn0czsmNLrIkLHZYVAywAD0MWE1RgDLs8Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DA+wrtJHs12Oz3TbasQtzfWc6JD8dQu0Nmd7x1TrRsKPdzmM6VXOXFtaZChcvgj28eRsn2Vlom/UGfSs5WU2VoSkzb/TW3OyJ3dshM3pZ1YKzJLhX0bsbOgu8Uv7iKWQ78cUc+YeVUXb4Q8h/3S3PqlsOUP/q0sY/AmMNuweLw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JPy9qees; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JPy9qees"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2ee9a780de4so15782146a91.3
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 11:11:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736190715; x=1736795515; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xNcgslAq8coyl/n5XKt4DbJIGhPR1eHHxRf8/YdlWTc=;
        b=JPy9qees/GoS73yL6qFwJ5KgVwFLSmUAeay7e2zfmyRbvj701lf7g4b1glRihH6p+h
         X/a+Bn50fBEmJSdy4Hx7LIvj7VFUyNU0Vk0kcDS6rNVoaKWRrIir/ZXQ0ral3KbD2oMr
         glk6U0pPT+qIUWQlfB+GgneThu7cliIlR55jR3Di6zkG547fqj63R6Q0jP7rHMQvzVMM
         mbc+xIF3tk8J8HTlbU2g6y21ca9EqO94IicM0i4BQ7HmqFirPmeUEN+VyaSEpAjH9cAF
         m3snffj86nA3m1wFLbCnnTLw/6QID8CQecz5ID28UbgBDRiGlh4hi/ZVjjvEY/07LgT6
         wulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736190715; x=1736795515;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xNcgslAq8coyl/n5XKt4DbJIGhPR1eHHxRf8/YdlWTc=;
        b=hG7avZ4YCmcpbejDcIvLL5AoggTmKH8H/WNjtTVJ1gkTcKysxfkP0iqRPB6N6tlHZ2
         ApIF6alyNha7XC85kSkxhspVLLrvrHQvDJZwlRrahI8CY2Js7BTZI1FYfHgi4DhCugHH
         EdT8ZJ3hxdME6PV40PH2ujbohGymirmwXAcBqnH3wWiFxTdyj4yzwVfprmg2llKd4gfu
         TWHEPHEHUu43ecXFONBjRWKyX4DV/mmajUV8EYyIAKtFr2ZO35QvzWkAT2UE8ku8j9qp
         C+ghbxtK3ZlV+2vk8ZBbMu/ZnIhVal6dQi3aLTtidMIKTnj+1yyLzd9HhfGFswe+09dp
         4jLA==
X-Gm-Message-State: AOJu0Yzz7KzANhz9HtQ4YIe41R0gfn9nM+wlxn5tqQPmPB54MRpMXP6u
	uuzxbVVwLk/uUax9W0GqOKO1HEoL+0EVvVfTsUnk/ivgyjlgo8Wg
X-Gm-Gg: ASbGncuuTr4BQsPzDrypAuKAHGlmEXYdAeR30Okw0oeiYPGtnvvCinMd8Cqd7JniThx
	jxbO0mnZgXJcP388lhNhDXIWLaHQiFl2WyfcSRPmuF6Zm+Jenc5lUCQ1eGLe/6Yy1oI21JS68IR
	QEaJeLDnmGFXEsvXUrqBdX0xjsNayG3gCoejy4jmha5H44VRmreajMWPrU+O00cwKKyh9nPGZY2
	ibyngXziJykvleBDedkXUHovlhHBw0CIthW9vh4oEbg81gLHjlafRJrc2RdxRo82CipqvPfEq3q
	bVpeMTzI
X-Google-Smtp-Source: AGHT+IEzqwc+8Il5TgTrh//Qdxy8eQvafKJ2eP1eNCBEq/izr7NWT0Mjur4MXNgl4trbVix4/JRW+w==
X-Received: by 2002:a17:90a:e18c:b0:2ee:e317:69ab with SMTP id 98e67ed59e1d1-2f452d33b98mr104243667a91.0.1736190714616;
        Mon, 06 Jan 2025 11:11:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f2ed52cf9esm39711568a91.8.2025.01.06.11.11.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 11:11:54 -0800 (PST)
Message-ID: <88330edc-db2e-4bc0-a21d-172636b7b10f@gmail.com>
Date: Mon, 6 Jan 2025 11:11:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/138] 5.10.233-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151133.209718681@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.233 release.
> There are 138 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.233-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
