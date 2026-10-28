Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793221954;
	b=0RVvYaAvohJVAqglwnIj0RZx+Br/EcQaCnRgeHCrkSyjCHlD7eYHxr25F1sSMLUty9Px
	 4dlkp1zWW8hg7ThM45aBNFlvwfxT363UiCBUhjyWTQ5giqhYiI+OCAcnl9MaK66SgXk7J
	 Ntb5X4w29eQH92bhqZ0evyMgrBNZR65vxBRCF4A/rkPWOhRaqUHmI+ymZmcQmuyaq0uEN
	 L4Svyd+L0U6AzUcd83UNoZVEI47/R3a6wqHUR0bn+R7c7YHXxnNsYDQcDviED0daNBokB
	 ZEHVC0Vtkppxh+OqpqgCjMImXdoGkGvcvI5tKqs4mNh9XTGqoQUd7yEP/gvncqBvAUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793221954;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=82VJuvmKc1OoqFuJLY+l5up9uTowgLJIPwv+wCQN7vo=;
	b=3yCjJcJs5nLDWwlMZDg+IHwfyIGG97WQIZcR7hhW58JhBlApNkquci9IH89h9pwu3Pwb
	 AOIEW1DIIQBI5oL5aFaX1rOSU/PZEj5L/MZuZhhRl4fJWA695a+RBeXUyP7Z23nWPtbU2
	 2wLQXSM1oOPz4TqOZk0fE9efz85fatMC13byNX1CssmEMr0ENK0XLpLt7Gnm+eUW5B641
	 Z2usIKOl1Zkga2kzIPzitFjaBa4u5Ih2Gm0aDzrvnIOJNMFd/+FnQLk376AXQ3dqilna9
	 Bru8qTHWeym8sYbEdl70o4TcP1r3G2VBI7/2L7c2PIL5b3Hi4jbjG9JBge6UKvyRT9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OA946Y8R;
	arc=none smtp.remote-ip=74.125.82.47
Received: from mail-dl1-f47.google.com (mail-dl1-f47.google.com [74.125.82.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23826606A31D
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 21:12:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 23826606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=OA946Y8R
Received: by mail-dl1-f47.google.com with SMTP id a92af1059eb24-1931ff67a29so503885c88.1
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 14:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793221953; x=1793826753; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=82VJuvmKc1OoqFuJLY+l5up9uTowgLJIPwv+wCQN7vo=;
        b=OA946Y8RMASZsyx6d8YjLwRkp7qZZKM9aab+tb4zQftW8YKZo430nSYhdmuQUg1OAj
         5KT6DjdMU6+MCgd0pK2Quz5GUem26gPfUcemQwjMz5gK2ADqcdeuXm72iDGe6zY4LlZH
         M2Ov6Er+FA0u3VAZ/G2Nu8AOH3DhgVXUlEOFZhHStqrIhOn3Oi33Y88vWeZcIZ+QEWJ4
         7zt2vxMaY4zcEZB3KmwQgbsRkU0v4YKe7EBbbj9OJ2NEPxMm26gND3loKXsMH4MwKJ61
         vs4Vx9r7NbeEqjRo7PRsPL9SwWMtp2l4gQjQ+v5RjaMLv1rwTTjE2TVg2co3Mr/QZoLo
         E8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793221953; x=1793826753;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=82VJuvmKc1OoqFuJLY+l5up9uTowgLJIPwv+wCQN7vo=;
        b=XKoAWUbWifPNkQhVSIziBbzLUpBvWnjuny0pnwENg3SJh6UAqhkWpdg4NIGP8Ufg0x
         6hFQ7Q8SsMT/yN0vsDIIyOhicGpRQlNPXmP11YYwK6hHv4LGoSu3vmMq+AQQ32f+COtG
         twzDhafdePN0LNZAmLplkCoA+e5cxzC6s3B7T+csEOQjeJ6Dgnc+kzxhPI7vTsEELBMs
         GJEO4VsCo5voyqDgwqfme65kgsjUysFATzr6/XHiveGvCfSvtM6EcOQxEZAWtAPqmdmR
         MsWi61WnJiSURU7HjsW4ir50a0P++wQM739wktDz0fQ8j0lEwgDH2u+fChUyhco7V97s
         Q3Ig==
X-Gm-Message-State: AFq9FYLmcLgtNjKpAPuZ5y9tLwIqdEbSC+cta2FHP7U1RJ9TV99iMg0i
	uMe/d0DeAzORoH1bZmOxYoXOzHd+pagkgn7Q9vZ5sZNHBjn6jLatQK4U6CkoFQ==
X-Gm-Gg: AYBFou3Zd2z9n87je+zc09IQFZe3bqgew0mqhSSh+iTpLgJgqaLrZY482We8w1hJ2MG
	px2DvMBkBqknTb01dctbNaoYdmEmotkcsYl5wclnFEHko9+9hBec15oL3qv0Ls6GJSlvcH04xcg
	jFqhEqPYTkK4/xqdLGNhd8DWhD2+7VEfQjxVXPQw4cNkSf3hxToBFBbo4SrycJiUOcphzlxD5yi
	7/QqZpPWKJuwZclWW88mt2uUYP7DhmRavsi4MeZMXUzH1YKlG8eZRWWudKBKui1LMhBaDYGDNV/
	XbgbD6oz1jR8NJ4XoelsZ4g+O2G9jXRdyEu2H4WiCkvvqUlhqqdakhA6HLkK1/Im3mD+AmkQ3Zl
	Nhk5zjdLQf/UeeJwZ7ATasp4BieX35qaBZzLAKLsnMoDOzA1PwllDV/Irml3wxXh0LHl9KHC1H1
	vTYlfir5zMz1poZHv4+5RL2lBmDZUEWnvZQ9//nWysMAZu0rHD696A2bMwGyg1hz9KckOtSkpRZ
	NPRgR5w2LwVdd+AQOccnwQgq5Ib9EP2TQj9E0cxPyKyCcrHzq3MOUUoEpwt/mdOzVi8aZXZrDI3
	qc2zitpwK/zVVLGC3Jy6knznRKSwG5RisOqfRy2xSPJtuQMUsWXoUFKO
X-Received: by 2002:a05:7023:88c:b0:143:2984:6518 with SMTP id a92af1059eb24-1a6ce209cdbmr5369225c88.39.1793221953208;
        Wed, 28 Oct 2026 14:12:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1a75a37093esm7126375c88.3.2026.10.28.14.12.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:12:32 -0700 (PDT)
Message-ID: <f09f94df-c5e7-45d5-86a6-50be145f6655@gmail.com>
Date: Wed, 28 Oct 2026 14:12:30 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1887] 6.1.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028170459.200466217@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.191 release.
> There are 1887 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 17:02:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.191-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

The ARM 32-bit kernel fails to build with:

In file included from arch/arm/probes/uprobes/core.c:9:
./include/linux/highmem.h: In function 'memcpy_from_folio':
./include/linux/highmem.h:427:21: error: implicit declaration of 
function 'folio_test_highmem'; did you mean 'folio_test_hugetlb'? 
[-Werror=implicit-function-declaration]
   427 |                 if (folio_test_highmem(folio) &&
       |                     ^~~~~~~~~~~~~~~~~~
       |                     folio_test_hugetlb
cc1: some warnings being treated as errors
host-make[6]: *** [scripts/Makefile.build:250: 
arch/arm/probes/uprobes/core.o] Error 1
host-make[5]: *** [scripts/Makefile.build:503: arch/arm/probes/uprobes] 
Error 2
host-make[5]: *** Waiting for unfinished jobs....
   AS      arch/arm/lib/csumpartial.o
   CC      lib/math/lcm.o
   CC      drivers/video/console/dummycon.o
   CC      sound/core/control.o
host-make[4]: *** [scripts/Makefile.build:503: arch/arm/probes] Error 2
host-make[4]: *** Waiting for unfinished jobs...

this is due to 341d4e6294d9 ("highmem: add memcpy_to_folio() and 
memcpy_from_folio()"). We would need to also back port 00cdf76012ab 
("("mm: add memcpy_from_file_folio()")
-- 
Florian
