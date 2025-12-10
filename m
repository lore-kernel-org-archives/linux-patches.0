Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BFB15ECCC
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 14:32:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765377163; cv=none; b=cJQEcTsLEE7ckag6yzdgmznziwDSldotjaTN1lFzX7PpHC3iwo440rEv6bUV/lz/DYPzbezaj8cmEytYzzT9b8OEBQ2CDLITdowzgyw1dTBv5q0KNa2gzNNc4Cdt9nkB3Vg2PzlMDzdNl+Dhv0VDvsfgTM8HzO0ujsekHJISlMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765377163; c=relaxed/simple;
	bh=fAmHI50/waGR3z7XY5kpd2brU2wCsvTvGmBEwVhQqtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Spq7HUUtD2+tH8NZ09O0BVsPKI9+0/MsmgrK1ILkt8a4L10Ond/ZYZBLtBWcz2xpAk5lxNedLq4/4/c9WQL6Sx1saxzMS6z37WMCv/qsBU3NCMslejqymiXCHe13csZr2KgLvPe0ekJ/fH8gOTSX9GgEiKN5/wFMfq8sASTURWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=B4oUZKAY; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="B4oUZKAY"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-42e2ba54a6fso2465097f8f.3
        for <patches@lists.linux.dev>; Wed, 10 Dec 2025 06:32:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1765377160; x=1765981960; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R+dq+Hyfal/ZttuoO9xr+RdC3/nhUjFhoCMQdO6MBKw=;
        b=B4oUZKAYleydIuiH/1MjPrfSth1Bn4rcZA2SRXv6moDfhiL3eJ+qDCl1nHDYdaDE8b
         oOzRNjpJPIaMXbos2/qmCzRNAdfi2dtqcbz/JsoX3J+CHKe+42fMTqZMd4m8JLVhUD7/
         4dtax6qaUfnS2mZJb9CnJYzDitZCtfR/EV/gf038p731dymu6S5ILJ+AU7ErqRfSWaiI
         3xTMueTHQgvU9Z0xrxnoaa3RBTkn1tXCT4Qht8zyqBJYqFpS4NqpoPEQadMUd/Uz+YDA
         0RdFVCGuMX9ieh9NzFOtMHlfJvRYuf/fKLw9ujMfEdwnPOT8Xy395cTQv80uKHjXtT8T
         j5JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765377160; x=1765981960;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R+dq+Hyfal/ZttuoO9xr+RdC3/nhUjFhoCMQdO6MBKw=;
        b=vXNjyZfTWHd5tQYI0TJEad3QZq94INYYvRcPtF+97px79/c/Iys5wGZgOIph2vf06+
         /Yt1X62/mCmk2YLgV2xiUe/a1ABRGqlTX2tZY6mmJ84jZs7ZhNPwU41WELG4MH+vyb6u
         tHbL7AnqYassZfcXkQr/EIJgzG9IPhIBUlwSN8ZyDSfJDUv9ioVmBZWg44bRcEwZ4Da5
         gQ4M9pUy1YWd05S8m6BBhP3t0Ceo48m9mhVRHe/Ei1SZXrduz5nFMiAw2Duc/YIvmEhT
         QX5VdrI6ZC3RPXSYBmMZJR1ACad1SDePxhRTzj+bc1SEUUn66ZSWqNKzfFAZ+JNGMU5q
         bLow==
X-Gm-Message-State: AOJu0YzqhLCQuhjmfubm2jxusgMC9SyFiKE9EGqE5QL2qjUJHosWbRgx
	Zpqqm247s16M9Pw1FNN1pFA8nFOUNA7RCIbMn9E17PVhhhjqIhN2Dy14twla
X-Gm-Gg: AY/fxX73dJH50vvG/DSxqZVIm0os99P5FvRcRacd0ftVrG3Gl2LuEwIH+TufcWTzKc0
	CWeviE9AurCnhfY5pPmTA71eIqd5ZOQkyKVX4wSad9b3KgpV4xrl+o/PTd8QfTQVGzuzT0H9+GI
	mBxLRjhelGXA4+gZpgu6ddiCgVtZvHW7fXr3YOOOxdoemRfzgkBxojHAiIYAIvhxtUaY9+4gmzk
	dAPis03iZ4qjXUzi/aOMT6+M3hCYyeoTj9UPp8ikKOzptTF0M4tYgjwcrVmFapxj1tiTqFGLAt4
	LttJwRl5MsMhH8/I7RLa5gg1VA3iC3m6GsDpclSpDk/B4lEyFdnzWUlaL1iRmpc2hvSj70X49aQ
	cC28YkHz5zaIvKwmGq6Sc4CCVvn9PSwNNLHfFtM35ja1EVGx0MCdd4H0ikckYz6gznaMRbbt/j9
	57c4SH9ll8m6PcM1g/Cydk2HDoRRQq3JWOnsBW8Z9B4J2YRjech1wIUskItLzSlQ==
X-Google-Smtp-Source: AGHT+IHd9MBXT6aAV6EneO53yAWXLISadeliQ7pHB3VOO1sKMQzKla0za+YrPjcFB9b9tqA+uscL1Q==
X-Received: by 2002:a05:6000:603:b0:42b:3bfc:d5cd with SMTP id ffacd0b85a97d-42fa39caa5dmr2639118f8f.1.1765377159473;
        Wed, 10 Dec 2025 06:32:39 -0800 (PST)
Received: from [192.168.1.3] (p5b2b444c.dip0.t-ipconnect.de. [91.43.68.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42f7cbfee71sm38244056f8f.15.2025.12.10.06.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Dec 2025 06:32:39 -0800 (PST)
Message-ID: <6050cd73-c869-4bdb-b445-9c910a7e2caf@googlemail.com>
Date: Wed, 10 Dec 2025 15:32:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 00/29] 6.18.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251210072944.363788552@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251210072944.363788552@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 10.12.2025 um 08:30 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.1 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
