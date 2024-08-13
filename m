Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91DF3170A24
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 09:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723541832; cv=none; b=eQfTe8ZT6kOMv7RD2DUiIDptdcth8863NT3l2a0lWKP8Vj/nD/bw7+bLffjESlhIvMaRYQQzXFNckcUKS4fyiBwSUh0RM63KOk1i4NDpDWXYp6Hg73cYuu8ZJEZh6ODsWhRV1zM9yByGrt3Lfema7HgfV00oShxsWQ+G6fnOhgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723541832; c=relaxed/simple;
	bh=wCyOeoKe9u+sJD0iMFdk6GI4anN9adrDopq3IECouso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FNAMEVgDllZn2LeWyGOUyL+0WltZNbpdpRMbKWEvVp/00BLcmqrkJR1UFYb/mn9hGw90P1XW+F8kLyuUbk+XjiJtJqDr/L2o1wbCcQ2Fx0d6+akGVWJFq3JqwgQBNfdCfnKg/D9D84wH94pmLuZm7uRYHGrOVaBIx/xIPsvMCeY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NVtOSYvs; arc=none smtp.client-ip=209.85.167.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NVtOSYvs"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-52f01afa11cso6455902e87.0
        for <patches@lists.linux.dev>; Tue, 13 Aug 2024 02:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1723541829; x=1724146629; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JE37tF2wmw4c/jkkN2/rwSonuOgWb2m/+qCDds7vhx4=;
        b=NVtOSYvsrd846j+EsgzyShR24RYSKnjQaKlqG4gnbJzcGET4jv+s5xhImlkWm70+vJ
         q5C3183HlQN/lN7tagcPhqkAbGTBMh34PKTGUeE3S/NgWXuNsJYQL8dhl8aJ9k2QCvfz
         tTTgQzGXcQYWv8XzzWzF9pf8xGA29U43UyFKD8tB2byXKivhWBvL1UFtt6NQvB2K5r8q
         F77z+BNbQKqu+GH9PYWrz+ZzHrB1owpQBL71cxMpGltCiM0wjsfA+5OytQjfeIagPxnX
         n2Xqrn/FASJnkBae8Sdbu5+LwsxOtjaDnp9tVX+L4nusbvxrvVEOMsvp9IbBN48AhQsS
         IdZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723541829; x=1724146629;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JE37tF2wmw4c/jkkN2/rwSonuOgWb2m/+qCDds7vhx4=;
        b=uE0FEvIJMv1vGZLe/ocZmyxRQu9fs/LJTLaS2hniCLvd8eImaJ1oy4jPuVH0GE+XKs
         kcxNJPXFZe2ULLWjQI5yc/R4BpPVEKbRu0cAhmX6ENfnxkVBm5Sjb4DTXXAMtZMEeG08
         rjObOAFaAihTaIWAbSD12zAZzToaq+D/fU+xiyhURZwn77i5Y/NGSbCBODR4vDtbDF8y
         IY0r6oBH+CjpEI1lUBYVkqjk26IjZ8NKVSad7gvTk8VZBSDlVhaoeyEScz2yMX7SApCJ
         FNWqnXLpOn/eauGLFkGQ6IHCydR/kjmmXpUpvD/R3aBXvqh6bQbEkYGDNyr2J0Pfdtk9
         IfFQ==
X-Gm-Message-State: AOJu0YzL7lWyvT4BzK9iHoyEgd9HjaOfarH78bGg3yCuqXFC1emJOqRr
	NuUQEUD+f8VyyddaaTghjID7hmAbQ3dHrI4OpxiMDtLjaCGWiZ8=
X-Google-Smtp-Source: AGHT+IFBMdzCkN1pfeNXsSOgKOTPTbLurD1G96vui642G+9uzDO80cyO1+j8cXtp04kUD3RJI3658Q==
X-Received: by 2002:a05:6512:131b:b0:52c:df6d:e52e with SMTP id 2adb3069b0e04-53213657bd1mr1976632e87.16.1723541828126;
        Tue, 13 Aug 2024 02:37:08 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac34a.dip0.t-ipconnect.de. [91.42.195.74])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4290c777017sm216251795e9.35.2024.08.13.02.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 02:37:07 -0700 (PDT)
Message-ID: <8114fea9-74e2-46e8-bece-9118fffd3983@googlemail.com>
Date: Tue, 13 Aug 2024 11:37:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240813061957.925312455@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.08.2024 um 08:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
