Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C45F4394798
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 03:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784690414; cv=none; b=KXCnki/5yU2BHrs+pW0NWsN/nXY3aNQReLgc4sd6Bc8l7sBDrfA9opwLWC1MkXsjm1Le9FCw9NyxzBvk/nsFC+AqFAqoF56YGxJ9ik0/w3VhhlXgisj8lsj1Cvte3vKjmfglC7wiGLMwnL7FxwS8b2dtx7lckWVbWb6ZmA4namI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784690414; c=relaxed/simple;
	bh=EcYK1dQ0d79+pcCrsZiejBUQ5+IjzufA/hI1VLq+GiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ptyNZHjowQotS5EMQWs30KgjECGj6ea45aeQOVEnQNYPYwoI7+ns2SvJMnVz8lyx0IQW/26Y4YD6gv4mxNb8cWoOVop/uKRyxHcdIHXimN3RNL7N/8hyxjkKMoL+kN69waPLQ8Gq7pxQwk1ipbvhDFoqge21qZfPQWPFO/wB9t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=OTBTgyhq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="OTBTgyhq"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4954a2e73a9so30928705e9.3
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 20:20:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784690411; x=1785295211; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=l+DA7Kxw3MpuRlUEVtZeBzxGHuQyYqMlY/rVO/muq64=;
        b=OTBTgyhq2jWw8a1vySeD/l7HFLInvBVGRSE+sK6oBmdZW0K/u6aRcfimJdciW/W9Ib
         I7LSkfM+Y4USYZik3yhlkLtyZeOVwtsd5k4sEuH/oDxfYIOlulxr9cMYKkEMu/uU2IuD
         CH45h1mjZ4hTEms8Maf9325l4oi15DexZKH3wXzApj0kpQ09CbfgMvvcSd/T0UJzBNwP
         MXkA49KAc2OEQOPo83PksefQTYsmlWjQ3umaBR86g9XtBw/JQqmisofgPrLvE6Ci+tMO
         EdicOlpaE5FtWwZXQ4slNrKdwx9HUDO5fyM4Iuxz6/RSq7Lwpsplv6HttqpITokBv2Ey
         YPGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784690411; x=1785295211;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l+DA7Kxw3MpuRlUEVtZeBzxGHuQyYqMlY/rVO/muq64=;
        b=TMWQI19qi6lv6fsp7Nz8fJa6GQQQUK4NsTS6DQ6bDqbcHzA/JEkoJ/Kh3ZmjdtdmBA
         rC71BWQ1LkCA5+OB0ji646q1OnbBg2SMtJ/rj5PzWYl3yI6sDN8449gNq5vBgZZsnO7k
         kzxhWjyh59kACKg+aWC26xH9j+E3sE1ScnTmHzWKZQwGADtcRX3WriBYakkBT/KGltCj
         4OHXtpjBJtKahwuc9c7QWQmF5Z4Us70YO/uzJ9nbfLAA/kASXkGM2JZMysR/mvcKlRGf
         453oDD3jHPgop+5+1x14kzu6SF2XOHFpnt5rozRLqWamPUA9kp3b3Zz+pNtGkjS9cvH1
         oq4g==
X-Gm-Message-State: AOJu0Yy7svIui+80C3UR08TcxviG3qehZPqOS+TI/vWPtxmlC4n1Nb7x
	XpSXafQvtws6rSTA6TGaPMITtFV2WHNJeI6lbaNfq1w4RJWnL/m3v8w=
X-Gm-Gg: AR+sD13cU5zmzj+5qmhVpuMrr+oqoll3YJI0wbAWKa2LEBn5JeFUNVMn+8O00Q2T5ka
	luS7exEMPU79qUjVN43U6izJ91VJy1DyxQERETKrfbyGME+ooQFBd3hlDAte9qRClghqWEqgwwJ
	7LrY0ZtPkY0eLgaBqWHiscLmNRXQn/l3N80paAH4mT/ffwA24O1nWhk6X7R6jKglijbeDDwZ6Fm
	q1r9APGapShG1BSOEewy8GONi7SH713Mq4xZ+cKtXxr9uZ6vMO4LUPLClvIXX65p0EKquy97N2c
	85NX+hsKgZU56q7PyNH4gE4HaoPfntNiMJ+U3Tea6/uPuFrQF4FYWRoAHcuf1gV8YSLSNa/UbZV
	u4ii2fcOipX5edIfFdSqu0lP9vr+YonHeNJ3bCuKZfYuEpikINCHDUU7pfoCVz18cr7MVRXonPT
	wkD43octtD69s/eAvCT2myIHZBbNmU751oEE4QzULhIsMsRkC/OvxDoQ==
X-Received: by 2002:a05:600c:b85:b0:495:5365:c0d1 with SMTP id 5b1f17b1804b1-49553d85ea0mr190568355e9.14.1784690410868;
        Tue, 21 Jul 2026 20:20:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b0575c3.dip0.t-ipconnect.de. [91.5.117.195])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a4f2453sm38586155e9.3.2026.07.21.20.20.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 20:20:10 -0700 (PDT)
Message-ID: <6241a377-7ff3-4fae-b955-d81f4d7ef56d@googlemail.com>
Date: Wed, 22 Jul 2026 05:20:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1276] 6.12.97-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152446.065700225@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.07.2026 um 17:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.97 release.
> There are 1276 patches in this series, all will be posted as a response
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
