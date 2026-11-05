Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793864339;
	b=MYExuKJhGpaq8/s6A2UFTJpHiBDlzWt6+anbZHp8/rKpL1MsD8gQUxvWTWmzS49BKPc9
	 Lw6Ch1TaYlDKIkDCjyesbHC7MmIuPddhAa7ZZRn1av8ayGZq+zGKNfxHWxR0bwqJgVtMj
	 frvQrcaKBt/6kv73pYaf/N9Wq1kBRUOIq+7UhBLjt/a6FVmrZCpOQgHE+u50FR5/DxWJ8
	 VDvJUb/QC6gar/uWoasvJDyRkigOWTJSuk5lhtPZlsivZJz+VyYocLF0YtA7pIPo0cCfA
	 tuYaICw/29q02fiJ1d0bmQSsoI5lx8t23D1iSvNQ/PvdTz7ZT+t513X9vyjdaHpM2KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793864339;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CnrMMQppxmI6EGSsQCvw1P8oldla87L6eez+yQ0O3fk=;
	b=oacfvs13rVkRJorzKe5OCfD5wtRCQ/tWaIdGcyxhp1K3AWMvwDEJu+8VbaCTh8UEKkyP
	 S8gOxUiaf9579q0VL8bsMuRyQjmCI7Ip42JCB8OvqHRUwolDrxxbKyWc7XER6simQHVIv
	 uiDyIfWmmWwj8dHGfpYm3FRSUojlzAEujOBpJz/60sISpfCDshoURah7onSqaAM9nj4g3
	 dRN3HKtHM9hrkb57BrFh2/COeglQcLBgBO6tkOXiy4bS2o8+CdV/wxCx7OrbQlDuvtL/x
	 4RwNNDBCnqN/goLXqPpBiCG91pNeG3mCIp3gx4gDhM+DqVMhS0blYWv4cZsMVZg+A/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=YlIKMP7S;
	arc=none smtp.remote-ip=209.85.221.47
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892D5606A31B
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 07:38:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 892D5606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=YlIKMP7S
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-48e10a70540so922488f8f.1
        for <patches@lists.linux.dev>; Wed, 04 Nov 2026 23:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793864337; x=1794469137; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CnrMMQppxmI6EGSsQCvw1P8oldla87L6eez+yQ0O3fk=;
        b=YlIKMP7SakFZE7buT4CbPlXFS2ozBErNKfORxVhgQ8/hOFBbVp11TjqTtK8AcAKIkU
         aDPFrFbXHYJ2iLVphixC7eR4gsi8aktfrdiaiRnPG12iLphand28ap64NdgVA9ez/M1+
         QfBp6HwG4K/oVc7iWA9ccfFjimWEKsLjUfkz9JPCQeYR4gRJ4NJpaLYYSfptnm6L8DnO
         HzJu2XdnfcSuKk8NGwQI01XK5G6gjDDr3i3/ENZ2Srhqr2XfNt+r/p56/DkUOaN1610I
         60Nv8F8iaNzq4xwns4u3bcFl+lCCVbZ7GXxQ1r/x/lSuU0Jj8bafZoBA+vEJM+59o+8A
         U6Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793864337; x=1794469137;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CnrMMQppxmI6EGSsQCvw1P8oldla87L6eez+yQ0O3fk=;
        b=BbC25Pw994fufqBXjGGKI6MdZL5h4AblPqnr5Y9BD1ZQkoZ1JUOVqwQTICeCeSDINC
         /g04yjWjO19cEzslX4/RCN+YVLQS2uXHAKS6o5/JsJZ9Evi40bT7upNT14zunQN5Sawf
         sGKJp/0/Wmi4CwqHX7VQTedLby0z0SHay9Z6DLGmqqEmTIsQUT91FkA0oScDddViIOM1
         lSoXr/Bx13ma45xj/LTVxFSATgv4I/Y9mI3kGIOSALutE8wUbZQLMJf81RrztRi/iRDL
         TGsAwNYru5L2yciJdmguCWiKAqAUfyV48oQUztzT1C+BVH/HuoXfFJ4+w3yDjV2AIkO7
         mj9Q==
X-Gm-Message-State: APuU4Z9IFeV9mTdhnYpHaf16jZWde7tWxllFgSQcwTz3XIMs9O0PI/Ev
	/7ZlP5g15v9Ja697RJRmSILgbA2+04DOdXwzPplgQmyzHZ0wuqVKL2A=
X-Gm-Gg: AYBFou37rxc6t0naf60IeMZAq0lMX/B27aBFzRPOALXjI2VUVUQJb47A2HFKmFxgq4m
	+ceLI62/ihGLF5uQ09Honmsia/2FRTC8zfQxEj24SDH/Hl7kvRQ2JtBXeYY6RajjVlxzo4I2/Qe
	lFbOfGbnrRxlhdXwd+Qs7J9AaZRH8qp5WOPH4S2vWDOjsZigjpGQ1MnujK+9u0HD5/B97MTZYqt
	QM9Z2gGva7va0whcmGnoarmljbkCgoSnoNYbS5i7t4QLJiZ6+Q06XSRHEK4p5oI9M8p0EXPRNer
	kuxpeeyLWLN4Ek+qUzfhmJXugj0QOQWCq3YXjqhq+dnyE89JvHb+zKDALBgs8Qea8TOhwPtGRZ1
	6pj2dOeTlJAIIiWXEhenaY5C1c9Lu9m35zSGeInee7pmCjEQTcFenAoDrHp8OJUEiEK7fFfhqqJ
	2e81YchTP2LtH9FJ7IzA9VKgKe++l6JeE0fmglg+nJfvYs2eHQCOrA/52GjGm4BysQ8fjoG5DPy
	Ua2We2oCRHGwxbsT3y4ifD+VUaRCDrAVoj7+TJAFq1jIjRljNCxqsTyrjPPoWjnTCny2TqmFLLE
	Ii9X9Pg49gdp7+3d0QlsL865iAZ9ReowwhOBPvJVupXN8SsUzgugHazNoZTVoy3/ZeY2au8LkGo
	JZA==
X-Received: by 2002:a5d:5f07:0:b0:48d:ef7d:4b4c with SMTP id ffacd0b85a97d-48e6e4f8c4dmr38866485f8f.44.1793864336714;
        Wed, 04 Nov 2026 23:38:56 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4618.dip0.t-ipconnect.de. [91.43.70.24])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48feda1f100sm8472216f8f.46.2026.11.04.23.38.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2026 23:38:56 -0800 (PST)
Message-ID: <5588d6e7-8507-46c6-a872-20c536901f1d@googlemail.com>
Date: Thu, 5 Nov 2026 08:38:55 +0100
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
Subject: Re: [PATCH 6.18 0000/1005] 6.18.61-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211043.516122098@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.11.2026 um 21:55 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.61 release.
> There are 1005 patches in this series, all will be posted as a response
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
