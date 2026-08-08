Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1545737CD45
	for <patches@lists.linux.dev>; Sat,  8 Aug 2026 18:02:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786212136; cv=none; b=ONCmPmSEIO9zRDQTXVzOWMNhVWF/SkWdgvzn/8HqzsAtdqH0BdAA/0tQlZUMtNq3a9f0uVG2lddhPgKSGBUPxby9DxGPxtqemDqJZYNY7UxDXdPnXwLzCPJX0RXQRmnBmj6uOU1g9CY7E1OlYt3p0yfcZ7HksqR2Vi+N8LOeSZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786212136; c=relaxed/simple;
	bh=JwHp+4Apfr3z53eMpOYaq748p1NV0fmJMKuXfD78Vjg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mag6JlHa6HRpZJ9BDmEJbanxwjguY4jOWQHfo4Nh6fYooP7YW/i6DXbaWL2Fv0lhkbV19oKqnSBBnIMNl1Rfic8sZq1YkoFoi28GPcarfPMKa+1Mj7XbFkE9qn64H9iuXKErMW8gN+/0S9qDRn8AuOftplm2ct4BDjhjAxwQBkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=iLixPcmt; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="iLixPcmt"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-47f6609c657so243741f8f.2
        for <patches@lists.linux.dev>; Sat, 08 Aug 2026 11:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786212133; x=1786816933; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=rf0bfYJpwFLd6Bf8C2FBafT9wVSh4J46LHTstg0yZPs=;
        b=iLixPcmtJahXE11JnRZjUe4f1ohS9WVjy7FU1luLTsqrH6h+b9hFmnTSdxjijlWc8V
         1qUP51K7pJyuDiSYmS2q+t74j97om20MA1MU7fdYf7qdWzyZBBNOjYRaHlW0ZvNza0jF
         SrUlA14npirtbzfuxjdMWq+9XC7ptpHiy/+zmAfup6guUthhWY37WT6b7WdWI2XFJDdi
         WCaKd17PS2ODrxZXVoS7oGriCl0EHLRUbvEnbCJrnTwAjrIajrIcbWxBgq+1SNNng24m
         nMib0kTKFaM94F9TdrTOccMraQIuK3p1LX031rOhnDorBwVzdLNzF9PIFzdegmn4qvg+
         gPjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786212133; x=1786816933;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rf0bfYJpwFLd6Bf8C2FBafT9wVSh4J46LHTstg0yZPs=;
        b=qKTTwlrUaNFKnYy6usgpWM+jkbV40fI+7mNUGHDiBZiBhDWCmYlzBuSPa1lrK30q7B
         EYDZrHtBNuMOX9N/DxJziXDISOxTiAs2KJ/t8DaBUQ5ytir6p8GwHVuPvqa36VFciBUL
         wbOg51vmXnbLUO2M7T3CZV9dA/BNyGnMFC2YxMQWgJhUnHbE9twSsm390eqWa8T2x9Jm
         lU/aLlq3edWrOwu6y/HsNykuYfiiH6g9pn2zCAMvprklzO86T4a12fdPWYnwPczAAcqG
         er7xiPTfDwouW4iS87gI9imgmhvSrFHBCTQOWAjH5k3eM3CHMG7i/6swBXy8oqkd8Vwe
         HTyg==
X-Gm-Message-State: AOJu0YwQoX3d1WtO6zY8QKzO6qAKkkhP6yM9mMij7LwIlZ+bt9/SWBfY
	Ah2Br8jsQr9UgTXRRPZWF+YXHFQA1JOG4cPz54iILSsHiZp8SajyDi8=
X-Gm-Gg: AR+sD127YN4hXmRTRorI+7uj35IvHCGFSZuftAUC9syMujzI22gGr2Kc/ifn52Cu8Sx
	Rw3Yz1m41J7kcQ4ZqO+tsb1DxSChVMvdodjM1T7bV0ES9T2PYm8UW2a1w0PEVjtOQ90XHT0OTpg
	I97lmU6hKdeLJUaE9qEUZFwE5pSgxQft/2SmZhCm9g5iPV9AhFjng1VJXvlaDipHHKWVnDbObiO
	MiAt4ihQveMVK1GuFgpDx/98KRd18ftfYoCwO3EsF0OT7KgvgjFBOebSP+6G84fDCyK5XvPv27P
	4SBXn/SMVM5ENBL+Ru2sJ1KH/fQsrrXoYjUjBHr9jolfLpeP+dQjy1GYNFtS+azW4/kG6spd/w8
	xpG4LpAOefJGv/amJrF7tmxL4h1H5FteEy62eIBWD2OucWWPTb+IlsGAv2dhxFkn/Z0dzIVu4HF
	vYgrQM2IJA1n1LwJ3I++ROH7t62HUHNwsDArNvMZKJI6/4J9gM+xMoS27sWO9kpGLw3no2Agt11
	UvRrTw3PatXfpDtAeHxzVEpCali+1rXlIiMHr0z
X-Received: by 2002:a05:600c:470a:b0:493:f318:3bc6 with SMTP id 5b1f17b1804b1-4995e0df176mr131947075e9.13.1786212132897;
        Sat, 08 Aug 2026 11:02:12 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4d93.dip0.t-ipconnect.de. [91.43.77.147])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021ec565sm16065065f8f.22.2026.08.08.11.02.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 11:02:11 -0700 (PDT)
Message-ID: <f4464eb3-87a6-4ddc-b44f-74b9311d557d@googlemail.com>
Date: Sat, 8 Aug 2026 20:02:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/438] 7.1.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260807143428.008222056@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.08.2026 um 16:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.8 release.
> There are 438 patches in this series, all will be posted as a response
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
