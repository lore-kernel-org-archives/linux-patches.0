Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795231071;
	b=y9OpU+j20WgbKaG9ulk/ETLdO2QjOvX6pMPQXBxI2wzdY3FDsJA4CppnGaBQhHHwDY80
	 R3hO5J+jJz9Z5EFPA1zPNbhMLfM+GybiQgdl2Nwo7eadfJdrqtQZ8kBn0cYyQHP9yuQDH
	 3koA7crsV8L6NTfcIKz91tiPpzmXhCr2S+xyxMAea/OQh3wZuQl3Av95gV98mGatDW7Jg
	 lSYenXvlg9LL50gBBC0lnwx4KiWjB9cEflvtreeYDL01zfdFvNtVoq5Ggb6dne6h8HAe6
	 WoMzVTv4jTitLkl94y5ahny+96y66TMlZCj8jdzSFhwO1IR4UtUS31W1n4B6PiaxH0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795231071;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ARUUOXphysUaIVQ+Q3NSspxOkVH0D/WM7AIA+6teiM8=;
	b=lm8gGhrTSHCwKWMLDlxYeoaWdFGKpfSY8Fo7se/vzYjm+lG08SFz5+sflLn+AOPi8s9u
	 jc8oQ/tT/7w/SJwSHbrCSJb1hX/szqYKTmQmQQL3gTvu0CLJDHhkvZOXBY2lSiCqbmN1J
	 uQIens7PszSCnyTnzsCYBSlqOmtKqRH3bQtvpzXsugIzYV6US4UEEIk5jhVzmDMCL+fSv
	 E4czbzxsdOH7ihxJ0AXSG2gUZvWL/FT7cN4BYZr4makVpaJXrpYhTPh/SetRiWaXrKx2p
	 Xf7/XABlZEa2xvPd8r/v4CS1gtdUt715QqYT9A5iDEZj9eWG4eH4QMAyfqcOa2k1slA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=xJb2Ke35;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64812606A32C
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 03:17:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 64812606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=xJb2Ke35
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4bb64ef5a14so16705915e9.1
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 19:17:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795231067; x=1795835867; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ARUUOXphysUaIVQ+Q3NSspxOkVH0D/WM7AIA+6teiM8=;
        b=xJb2Ke35wxOaErdN2DXwbA6M1j14ytJUyBJSIbra4gUpG25g1TmnaovrqxCNbUCo6q
         D4J9AEuepXXqdcSZfBW2BX9440wKI7MlMKpCZPEOIho/Ndk0t/RtIcgxSBBlz58Vt9oP
         2h5ovf+n9oA19gK1hh4Q3rCnJzGX6aSptHbeMjCN4WP3uDhtmEJkLf4lIicg/Yu8V3jv
         mGaxi73jXV6lB2DRtEyQMSuVA4V4ZOAKCW5jeGNv7oX9TjCkxjgvxKSKlOTp8Bp07S86
         fzTxvdY8kn8BcWaSZzvgBbPPthFdeTHAqE/99R0EplvWzvuJV4+YTWbvI5UjWd822JYT
         X5jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795231067; x=1795835867;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ARUUOXphysUaIVQ+Q3NSspxOkVH0D/WM7AIA+6teiM8=;
        b=Af4h4zupxUgs5DQsU5TwMA3RUQwvt7sE0BvbKRoPMkeqMVEsF6Dr4Aj/+O62b3fB7c
         X/uekCm6sFxIOcTdQGIiTxT/RPVZqowVCwv7h3LnsO7K/Jo/P77BkbA0azFztXo8OMqi
         ZaDuQGirKnxvC3meIK7SmL6v9eUjY6Tla3NkBeFCwYp/kuLDsatKJRqOnr7FIgE2Pdu6
         xBp+aADwaEf3z7XXuTCN0rVOvkc2na7/9WjtpBuSIc8qLHGcbYcGhyt3wOZw6FsKu16D
         jd4OUZHBfDS91DBiCf2DElAOeaqkViM6l5m4ewVHZ1fq+TmEo2PefWQaJjhYxZE9Clvq
         lH8A==
X-Gm-Message-State: APuU4Z/FAyadwKHcNFWR8Sy+V14VPDTM0r9iV9nGFA9pas+0gxb53rj8
	RmV5kp4+EOPsnSuo83YML1wHa6PRHzcRlFoSazuVY5OjUSPqNM3a8Vw=
X-Gm-Gg: AZFdTZc+E/nhTsQ4vk/n3Fwl75FlDeK5mopKSf74Y9mxCTGpg0tkzp5lm8IqjY0bVSt
	P30WUR29lUgJqKu1FBfi44IW9EruvQuCdfCIhNztknTUxuv6FJkMo5v/DFixs2oH7XOMvGBC8Cq
	CosvKPlR1UDT2On2/sB6LVRpLL4uKbXo8XkQQazybi0ZwXq6N9SFygRwCuP6Jq+8dgqFzg9CxWV
	JiIawq55YLiphEfdCrJZCo3Z8awE+IXNPmBARCTEoFREMsNbXVD6Oipb3tm1B37iopFPt2R5uWa
	uKuWErJz0a1bwLMTxgs9rMAWyDIj2RN9O0ojnrATDKOYuv+WFLXdCF4spM3X6ezT1whJ1NLTfmu
	p+VCq6OOxM+bmDpdbZg85rwrvchmbwpAbhGUlCHP5iYiezA0u5t1Xs7mt09hPrffxDK6S5+CcEq
	OKr1f0+479e6pjHDo7SvcKkAu7X1JzbuWWfCQp3D+oHiwt2zZgFjtdQHyXpyj32y+umykNm0bPV
	rswYFMNBFrer1xwxXmId3CUw/ZTU9cEweXVAkxf51GeyNCfmfsIEqLU5yFd0g4NVQehSVyEF9qJ
	DV29VDpCVgGFIV6ln6WKc9dS8oVGsm3lEgeACSAKTGYwRc6RKtyKNTrSIyzPHJuQveaTVW9R+G/
	gq2X7wHwKpHwaaiG3lTlAvqSstw==
X-Received: by 2002:a05:600c:a08e:b0:4a1:fae5:f2e2 with SMTP id 5b1f17b1804b1-4bb887e0682mr116990495e9.4.1795231066634;
        Fri, 20 Nov 2026 19:17:46 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac65d.dip0.t-ipconnect.de. [91.42.198.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88442995sm143683365e9.2.2026.11.20.19.17.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 19:17:46 -0800 (PST)
Message-ID: <72361086-b932-4fbc-b9d3-eca7df52af82@googlemail.com>
Date: Sat, 21 Nov 2026 04:17:45 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120054951.366579794@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.11.2026 um 06:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
