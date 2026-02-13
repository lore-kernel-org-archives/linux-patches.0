Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB6723EA88
	for <patches@lists.linux.dev>; Fri, 13 Feb 2026 16:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771000429; cv=none; b=H+/Kopz+sUrLWWJ/bqB1B57lBjbgOTJ/8yySBzpuGM+FJ4ORPA6AB4lLOFBXUBdjQM0DHeuzGMQo/grRdJduMP6xzIwRgeFQz4mQ8yvBtkpyBypfpmjCjUqqE44HoUo81GyzYIjQlo6cJhHc1dmHtIgd/U/91GTePZZrVOzIVls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771000429; c=relaxed/simple;
	bh=dtorZ1eXQQYnzmmxUntRXWIAuA0jPyHcXFUhhi5qYlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Hnandq0yIhX3diJjYL79UdKRacWPD0G9Jm1W7n+8hOlyOMZ79yo6adlHzB+PAUIY8fTdr6oMdEKCeZtCTD/DfLUDHubfeBOsiyNeeUJK0D6Wde0hxuBtgbuZ8twHH+TRWC7PseufZANGR3w2q4mRCIoNdwL6NvAE3D/FPhJrGis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=DfejnPlj; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="DfejnPlj"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4807068eacbso9088195e9.2
        for <patches@lists.linux.dev>; Fri, 13 Feb 2026 08:33:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1771000427; x=1771605227; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WTI7f0FcYtvFBidqNRRmKjcaE9y96AbIePq1Ojynhzs=;
        b=DfejnPljxoJnh8ephEDkTMOb/UX9DQlUonh6QyQDrRCQAUAh3eqtJp0L9KOaOXDecV
         M3U2NuVFfiDLkkI7kM26TchzbZG0jpI9jhY3ICm6FoifA/ilaSsQQ9QmwYDhgcghwn+M
         56VJA5vRQWEySYHXLiEhaJq/Jx5cLuUFYunW3iY1qoJaV9kPreBZDkR196f+OvL3SVrY
         NQHp6n5jR2n49MpPl9TDoBD0MRj46dsd7uCp6IHIWbdWlPVSgQbLpCRCOqOTSjACxhPA
         8etFbt0rZaQGYHbC+ZSb1qE2XsADaLOA8LxXbuN3W6/86UNObW4VSQkbxwf2whDnI7jH
         le1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771000427; x=1771605227;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WTI7f0FcYtvFBidqNRRmKjcaE9y96AbIePq1Ojynhzs=;
        b=d/XU8eiPD0M7qhnr7wVxRrfvs2sJ46TBaPK/MPdXPAnfPQBRndyP1QXE8wBJRFwGVn
         3tTUKUL0jx7BWRpA0Rn0GfHMWYQXqUZCA5MojScASIL/b1hqJPQhhsg7gKuX+SQnVrw7
         MYRZ928KTuoV/O3KoCuMZetODdnnv4gi1GOZRdyl3SR0XKdi2yYf2ipf/4LyIhbTBQan
         L2j++wcHxeZrL4AOFZClYkqTzG+NpvM/yRrFvNAV/47NlschpenOD4nF6AtecuoD/9wx
         eCAap7jhfjswW3NVRegJT3iKyDFiWB1KnPFj+fFPtrPHJMD7iSCqGfw4VBnOxS0fdIYm
         DGoA==
X-Gm-Message-State: AOJu0YzVjfdnzOBp8o74vj4aZgOQb3JRisAb4lM2WhnuDXM6CgMa1PUl
	KmbRptju08+J0VJKJRJ4Y5bSX6BdWUeGkdKkgLeBgu7I21HtUvably4=
X-Gm-Gg: AZuq6aIkAKfZP+LdkhOITUPBZX3E8uA/AEBQOHPGDmFigU/D21tCZEz2FCqKQTUrMHu
	v/DvaX4UUP5Tf4WrPMhrwikZFfhAPAxSEHTh4YV3jnlhQdiVHBoMAwjH6CqD+K7JRY92ttpcnnD
	ZI+HsviWXPr9g9ObfIDcdP330bA+tCl4tnIkM/xXcZAWdAOUBpi0sG/gvmfGTWK1exNP+XbR87K
	Ob31UetOIJafNIa1ogMBSU5q09WvRdsq6wfn58p8+mIE9LqFGuT8oZWnF6bh8rlDprUPNBNot4+
	Zr170lHTYI3N1IMERJxW57DLG84NZ88JjybCLUBTgQwS1Ido8XsDT3ED7M4bZjruHlOqYWqCzbk
	t+IKv6+EglSJ7Qzm2gysw/Vjf0ds0BCF/X5puOqxT49zSfjxIz7hueRwaECvdYwKwGYT6kgVmoO
	VPX2+u8x0a14viNrcekwRmOJCbW1iNEOnixDILTlFy4YMIKPiuhzFgwGmXPmTP6eExIvXso3InP
	KgY
X-Received: by 2002:a05:600c:3d87:b0:480:3ad0:93c0 with SMTP id 5b1f17b1804b1-48373a5d6d5mr35181365e9.23.1771000426741;
        Fri, 13 Feb 2026 08:33:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4a9.dip0.t-ipconnect.de. [91.42.196.169])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48371a29982sm19392215e9.15.2026.02.13.08.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Feb 2026 08:33:46 -0800 (PST)
Message-ID: <db18bbc8-2e47-48a3-ba53-9b6939cd33ac@googlemail.com>
Date: Fri, 13 Feb 2026 17:33:45 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 00/49] 6.19.1-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260213134708.713126210@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.02.2026 um 14:47 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.1 release.
> There are 49 patches in this series, all will be posted as a response
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
