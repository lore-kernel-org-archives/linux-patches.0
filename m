Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9773C3C01
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 23:12:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033949; cv=none; b=LuStSHKVegR51rqn1kTEhIg7NAgPEydBmnnF15RiI6Ll16dz2kx4YUtx/R6Lb2XSG7Yifll/9EmvFu+xDTkcYQDU7JKpVkuc9ip4IbqIxJEzQ0sqccBA3txrseWMmBbi1CcynVLXa5JchvOpjz10qM/qXZifUxjS4fwsHKdfBDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033949; c=relaxed/simple;
	bh=V+VSp9rwt1yIHJp4oRUaIH+3V40CvEr4yIqWXtCk1ac=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n1gFuhUI5sWZCeOlDNRP1MSus17AGYB57/A3bE93FKpHf+BAJjfuBGhqu332WR8IuwV8LEVQYtWw23LxI1rLXUU2878UM9dG9GKBJ6g5cZENMwjPwiMyVb8D2wkThPaF4mqJlkieMAvznCNEfLmdzCvhUcZyvsQPjpoChFgsTjA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=EPZBhgj3; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="EPZBhgj3"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-47122683cf3so3284f8f.0
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 16:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783033946; x=1783638746; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=e1FNGhirFNPRK/vHQgM606Bnc9m4JLZSNgI9So7rAsc=;
        b=EPZBhgj3TAAo7bCphxzG0+iC959+HEh9uzj7kqEgNK5Lj9RO+dzFGeo+3iBatd/AYf
         7MU+1jW3goqT5rgVtdb6nUvPw/LUbPGlu5O9Fv2Qdd03aOumsSQ1459fLg0W92XjLp+3
         mx1185xyK212J0Cz7bxzJcTbweLP2D7hvRR6wy+qHiGj2u5RLWsuMfYPvdHoU467CROd
         JLG5ThE6XcJLaPR7ogDyLUk5bxiT42oHL3dxQYXxfAyJaw1FXDQn2uWVTtF7MTvgQ+wc
         c56CkzUU3owaetiM2SM6koaXqJasGZw7HTcQPE+5oZ/69P6dTI6XHqt0ddBUaRq2Usm1
         4h/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783033946; x=1783638746;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=e1FNGhirFNPRK/vHQgM606Bnc9m4JLZSNgI9So7rAsc=;
        b=eqPPC6+gUBQuS74N4DSewcVyECxprKoXDx70oWVzgUlAzI/gI9tmGhvXjicnl0Q8yK
         33H7zSH6EhpHCEDOfLN5ghW3Xp0cO0BePAdEAryryTdWdpnpbhv7dXnvmiyk3Z380FgY
         E+DCfhA+u4/WHrwyCXyVVVY5SL43a817rZBRXi983sf5G2eEr/3RSCzSfrpjzhop0pwC
         ufNYbXsLGWHlHNS9StWlE26zx3sS18BPUKAiWOUoe4ct5+FxuztmohUHUZKGpOcOdJgk
         rJEhXoMfgwTWlXlSi1+nez2G/9UuJpgIjO5e3uxDf6Kh0JkWRceIi197SL/w1QrkzbI2
         YWXA==
X-Gm-Message-State: AOJu0Yy88YrDqro1wHXRuLxTiCb5Sy7rM32WfU2TT4YuYuk6FwalWMjY
	TKq1wyaL7Mgk6oZR5RaNxG2p4NyK03Zr93t8KvOvqw5ji9M1zjI7u8A=
X-Gm-Gg: AfdE7cnbbVGqiRD781KT9nKnZOCAalR6b3eD41y7U9xc1HsXjZrF4Gr0/MVLNgmSnDw
	w7iaFvLUSaga/48kxhNSfnl57fsBFVux+iEMk2j+Ur8LaJwI9mwnCQLLJaxG9f2rQHvGe9XO9AJ
	AaGADW93FdXJNyo8Av1VKenHLbvwvf/CWoDVIVMVCBX/5VPM73yOhhYdQmChD+L2Lbxv/nRYlfX
	QXlPg3RaoVDZ23hNSqPlA2A8omXvREaI+Yq26036WbE8AArdcxDxlqMudzNoScAaOwClLRW7gmX
	Ov7OD/zvHAGCc2T8xmOQjIpNCeLxj1A8xVBj4nniFrzyOtwzZ/pN9U6NnyzMIfInhc/0mW0O1rm
	Gycg4oATPZWqRCk4Ki33Bi5qRLyTLVEs/UA8CRxSD4+/Fwm9oWw+88RJODUhNZuaddXukrdz7bz
	sExee2g3HT7WXq9hw8S0JlC6y4QYsjD4gnuSwtGPrQfNa2C8KRoizCZmRuVlsaF9I=
X-Received: by 2002:a05:6000:27cb:10b0:460:71e6:e3b with SMTP id ffacd0b85a97d-47758db5955mr8723966f8f.27.1783033946248;
        Thu, 02 Jul 2026 16:12:26 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-477db8a4b73sm12539955f8f.15.2026.07.02.16.12.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 16:12:25 -0700 (PDT)
Message-ID: <075e465d-bd07-4fd9-8641-30066e966d07@googlemail.com>
Date: Fri, 3 Jul 2026 01:12:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
Content-Language: de-DE
To: Shuah Khan <skhan@linuxfoundation.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.964534952@linuxfoundation.org>
 <0585b5ab-f9a1-4922-b2f4-167d0402758c@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <0585b5ab-f9a1-4922-b2f4-167d0402758c@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 19:44 schrieb Shuah Khan:
> On 7/2/26 10:19, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 7.1.3 release.
>> There are 120 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc1.gz
> 
> I am seeing 404 on this link. Maybe I will it more time for it to show up on
> kernel.org
> 
> Same with 6.18 link - haven't tried the others.
> 
> thanks,
> -- Shuah

LWN has the story that there was a mirroring issue due to a misconfiguration which led to the deletion of everything 
under /pub on the public mirrors only, and that Konstantin is working on restoring everything.

https://lwn.net/Articles/1081015/

This is the ticket status at Linux Foundation:

https://status.linuxfoundation.org/incidents/3y1k8b4ky71t


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
