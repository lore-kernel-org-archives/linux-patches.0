Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D79413321DE
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 01:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784685066; cv=none; b=Y92jNoUn7Yntv6StLMOwG9yIQ8/xY8fNaF3tleqs1ejG6XDVIsxko2aUOI3nIshC1DxGr0WvtptacjCoApKvmvFBHbVx3KXU0yX4NaAsTt6ULoFZ8om353DA4AVbDk8kYNKqBEReB1dmWh5PoMpV4rSKNstuzdTDf54QTsXVJLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784685066; c=relaxed/simple;
	bh=TXfB4ABh+89iwnKH/McCMIH4/ZFKUeUvf2Q9g7uVgX0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fhvNBenzC6NX9ZYyoKrEsyaxLlv8lY1eCtU1HqT6vu1aNxR4783eqyQmVYqFsUEge3Y5BSWHtK2S/7tYcnsnuvkeW9FnoNAQuR6KEXvkgXkgH1qDtC14i0RyjOz/8IRgcKcA6+Moz8AVQwcBaeOUKTm5L153uJrK4Gm/KG4E6h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=HELrGeVa; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="HELrGeVa"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-47f71156e1aso1594219f8f.3
        for <patches@lists.linux.dev>; Tue, 21 Jul 2026 18:51:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784685063; x=1785289863; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=xBjB96HwVGtMp1ml2z9h2HsIvFpnCvmsF4SKp8ImWjo=;
        b=HELrGeVa5mNeTrl2RlqwarZk/j2ZUTF6/WL+XLzh6uBrEYu2Kl37g9/E2OFXM59EVK
         gPXLakpe4cKqo82p+l0cn+U7FkR1CPsB/DK1L/83kY4mYcetBsw8WaWJ+6LJEIkaWzJd
         CCLmATYNPSiBcLTZrtRvsi8QOPHRJbkE/CtMIDH7Bsa5/LsU+lL9ESgZWU0RcxZHUtYn
         ViZVct4k7cL8r53w0CNNRByW88Dxs5QN9Ug6LWSbMwSgZwctEqm7I0csKqFI5BA/0JRv
         p8hokwVMWsZ2Ouf+4gUg1WEXuchCe7SB/1WdPw5GbncQOGoZy+gXdsLPNelrVL4RTgOs
         ytYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784685063; x=1785289863;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=xBjB96HwVGtMp1ml2z9h2HsIvFpnCvmsF4SKp8ImWjo=;
        b=nTS+HurjU8olWevLI1x0hVEs1ehPZ2J81iwOMerD1EgaOMhrTs3Qr2faIU0LJRaSep
         0pH1n0pn7PPagtBQgRMzdbEVcvU0AML7L+JILSoDlfWTBUglzrmBBbIMWOrDVHWT8ZwQ
         PL6gd3A2oQBUCpLazo7RGimsgGJteV5D8odbcNiS4I06aQO01k0FAbLo+rNnSjIwXlZ/
         BhGhimu3IhDl/WPr5OMtAbFI5Y6CewAliJ3lccJjL6GkZasEnPw+41K2dLlXDPLFaZXu
         D5qtL553wSF7j+rB8GY2CvBdTcI0f72VDG5k90F3ACxHqILKaqc4JY5svAJH9Fn9yZQL
         xAKw==
X-Gm-Message-State: AOJu0Yyx2bnPVAOz7hZdUilQsDaXsEMGqUIBhPC1EVQDuOUI6wAbDMp6
	PvM1fhkyDmqguIDT31DQLqQV9DxeXUDW9keKHUkKuBTa+2o1tptj3Ws=
X-Gm-Gg: AR+sD11C9DA0xTDZb8mLarUiw0kAU7onOLci59Q8RZL0LngBNWlF7NN2ffLPjICQ0F3
	CzlkG6gDVc3mVZQ6rV1LrJZJtzafmk+kT315fujILTAkmcscq0iYmNK3PW0cF37ddMYkuUyO+6W
	yB1CBIlR5gTP9JpCSH3s22SVHOTjx/JNuBlxOQEquKvG/zsNH6vy3MLsAQVcSBsavuPSHBfAe3l
	usdHVTOrAM4r/6J2nPYDodtZpKiCPkJ1GN3GmH2ZvorMkxST4jQvyIOqLJdPNxiUUlwez3dtVGT
	JOboHIhg+59w84kYIptuGebvk3BegjtrRLJiOecPt7JQyJWZbuN5O6qyh+Y/BQdb3aOA6Cp98FN
	H3yfNBdmLCrBvzNDSb63IXI/Ma947jFjPrLDGKGSkXT7n05EoyAxIZB2Ymf3X/uAui6Bsn1poLT
	JjS6GmEGUeArqhqYC/3MSi/HrXUeS1i1583pOc46A5Z/iW6rW0UJX5uQ==
X-Received: by 2002:a05:6000:220c:b0:47f:7c4c:8144 with SMTP id ffacd0b85a97d-47f7c4c82aemr10880687f8f.10.1784685062919;
        Tue, 21 Jul 2026 18:51:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b05768a.dip0.t-ipconnect.de. [91.5.118.138])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a60asm1366024f8f.3.2026.07.21.18.51.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Jul 2026 18:51:02 -0700 (PDT)
Message-ID: <2dfd695c-cd5f-4949-9e8b-3a06e99aa47c@googlemail.com>
Date: Wed, 22 Jul 2026 03:51:01 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152424.521567757@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 21.07.2026 um 17:10 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
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
