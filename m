Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2178A37D123
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786994308; cv=none; b=qoyeMzziMQiQYWPRudXoN/mZuU6f9sD1gsDpSwBGPNQMYYBViuTIPVh/Tjn5Zb+iuJxufNyR4+VT6zZoNansnB4wriBj+IfWwpILaVQ5PAAYLZxwqEEjF06kCpUupBKh3a95Iov+klS7/JJXw5FNJm+1Rxeej6x6B4HFbPDIKyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786994308; c=relaxed/simple;
	bh=29/UPfY5Nthq2RpwxSboYXXvxzzYGsctgvnG0yqUzuI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=L76rh3pB5iYNntDJCLxBW0TTJq3RyiGJshY6NNuC9ofVa3ycQodMS53QdivInjpX/oP4Ri5wlF4H5xTmlTINt4vIKxLp32FwChxRA9ZOJ5c/KvZGFqBLIOuZzIhCAR/pPEhyu7ueW/Pj7gde+zsktvrIfUKazfCIWihxrOeNb3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bYJwq6gd; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bYJwq6gd"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so31215255e9.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 12:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786994305; x=1787599105; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CMVdF/RXKO/xfkwhQ6TWQXJqHUFG6J2KjoazKU+K+tY=;
        b=bYJwq6gdMEKsF/EhPXx2nHUjubGgtjDtbbubwfzJbWW6SYOudzbyB4qKUk9Vh4f/c+
         fgV70FfIDYStOx/SGCFD7hXfakVgO3RsYQ2kcwUcT/hfIwDrSoH3rweaLqYPDdmsfRnN
         d8a2BG3rZ4o0G0DGu9vdzNcc8DYZWK6XG6rgoMmUvZg9wdgdZfmr6RbRzTYMYTYXa8Av
         1QGnL1Eag4TITDyv/gZ22l9+J9bOG4PUkUM/mLiPAaxkF4HiPe9l9SC7CdLv/RHPQzsn
         lqtkLwHqudBgu9P7/wqFvGtFZFl1A+E0jREXONofBgw8HmQcPyx72p5KaSy2PORty8Hk
         i/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786994305; x=1787599105;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CMVdF/RXKO/xfkwhQ6TWQXJqHUFG6J2KjoazKU+K+tY=;
        b=BHNUs+fqObc+JzqmmrEPIsdaYWgfAuDkLqSW41BA0I/yjoLjvYM7VJ7wXbiPojDj4f
         Hkbi5Tv2gc8FFS2+V/DSCXRIfitFgKgcVv60PSa4pqUy6UH+sp+G8TE0Pc0KgV3ugCrh
         rX7rkM/fsQh4QGkeAl6R4UZ0nlF0+M8XFU0aONRSoPN5UAIK0+HS5db7JzyZz+mRTlRG
         K0HDLp6SbnAmkY0qfMHH4M2b7RxqsmcaGsXEhtxbyDqJHyZSQn16Dn4+tgr12uhuNxNo
         K0u/zLlKElA1GvAETX4bB4hWyqSaSJMPXiUArLTPhGPSahdaZZ6s+hJQWPBRolsT4SSp
         giIw==
X-Gm-Message-State: AOJu0YwpYRNHUPnWM3rXqehH6eoDDiy+Giy5ky1Qdx6fY/Qxmt5IRxCL
	dYDikTLVbrOYRM5l1rOAT2fEqFj0opeFNHoLSkzc9Aeo7Xv4nDBEcX8=
X-Gm-Gg: AR+sD1337CxiqK20ajoiWPIORsqDt1dp8sRllXIC8S9n0L83Sy10sgvQyS65om+k0Re
	LhL87AXrH4huDSjPedJr0DNHFkWDXpfbaBZS/XsmNWfRMpVNeSU+46MbDvj5e7hPOXcb5dEVgNq
	2+XklXkFsFQgFf0cY7vu7AFPL6j/zwo2/ajVLgs4+xdyZLs7dmRshaluht8Y1ZWdWnU/ZA8Yc6d
	htp2LuW301CQiR8UqmOSwW9ffuGdnhTsAHH8BN/nYPvx5Lis8fUbFcF2DUAer/u47onewYtTUfP
	e03hZRaeExpQSb2jC7h/DK0bPW0kQD0mPrBcG48U2J4tF8ns5BQDUlWrsYsNyNdYy/ORe4JoXpM
	g1ret2j8X4PcixzQ0pSIHI40zOXZmAofOyMQT1VnWCUMbUlFI4vtUXbfWiKxkSdil+viLRpvUqH
	4oi0MrwofJHof2F0KajOymYsuWQc6iLMEYtHvibLPB8dDUtWwzfWMk0LeGGfXOc0lz2USjfF0eW
	FbtAtU5MTN5OoYWskTE+ThvQ16pBwGI9UayHYLF
X-Received: by 2002:a05:600c:a4d:b0:496:ca1f:a428 with SMTP id 5b1f17b1804b1-49987981e52mr453171115e9.19.1786994305106;
        Mon, 17 Aug 2026 12:18:25 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b466b.dip0.t-ipconnect.de. [91.43.70.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999610966dsm222871785e9.5.2026.08.17.12.18.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 12:18:24 -0700 (PDT)
Message-ID: <e9f71a63-839a-4d6f-abb6-f2b8c579233b@googlemail.com>
Date: Mon, 17 Aug 2026 21:18:23 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/181] 6.12.104-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132535.394764707@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.08.2026 um 15:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.104 release.
> There are 181 patches in this series, all will be posted as a response
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
