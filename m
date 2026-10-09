Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 750B93033F8
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 22:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791584544; cv=none; b=o1PfrqaUmSX8OzXZlVJC28tORZuFzQebjBAFJ4I5BzbRMKgPIpgT0oyb5icmBRUQXTlsI9cqMJGPFYjuwjM0j2fTxDUWBFyUoSy89DNIhEkaRkXjvf21Ql89u+ohNEoN+8uE/KoiFJt53620HpRlMPQ8F8ceZcjb063tKnFJA8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791584544; c=relaxed/simple;
	bh=T9C9Dx671FoCAaBeLOB/jLPQcri7Iav3zqe7LP8JH1k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Oxy5dpy8qQ1c+8Z8XiqvGTsmTAN5AhzOhoP7fFr1yggej99RAb76UaQnZHiSBJoMUQSwoRvxI7VSVCSFxtlVdEXhFE1Wle8PEaOUsyI4flBiUrXZAOjFU5cXrmPzmOZbPQbL9sFZ527DFirDF5+77INyy2nhQCtIeY0mcbByuK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=mDL0E1pg; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="mDL0E1pg"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48441a2ba1bso137043f8f.1
        for <patches@lists.linux.dev>; Fri, 09 Oct 2026 15:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1791584541; x=1792189341; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6WYypNTC65goxZZkmEPVPlFK5GKJ31X+7uhWYZx08fs=;
        b=mDL0E1pgIfoeaosHPi77bAp7hgb3APfWZloNaqYA7GEW+DDTE1soQL3zEgpV1Z5WXF
         j/IfUdGusKZo+d8Gh1TuMGjsfDTUGaFMQ3CYPJeTodwsLesLKRGrWTT7rof/c5/DQZOG
         Usif8JXk44K/gRn4hcf976Qq/b/olgAJh6Da1cWDhDlhvvfFBG6dKvaL4v/kFu03jbLg
         41HKsJ3tAAXt8gIlAxhcYVFjgKPeEqKyJOIywenKA12d3gS6W9UxdnO4L3nnb49qk0I7
         yu5PtOZpxi7J77B4TpLHpMHBnBR6C/Npl1UwnMreO+euIFpFaMUwoMubpjgfznaV49ca
         tWaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791584541; x=1792189341;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6WYypNTC65goxZZkmEPVPlFK5GKJ31X+7uhWYZx08fs=;
        b=QEQ4h1NbkcszuQK2bdkkd0R13BIc6qlTO5H3mVA+55vJ0WR4j5VkXIB8ZTHAsuDJgK
         J9oceRjcH2sz8uHUdXpa/ZrjK6yAu6jwuZshsCw887+1XJZFAJn1qI3o//Glb691sbOR
         AHQWxj8IAG63XOgk+LNli2lLHTNSUE9Rk7dGmiu87IcJe4brl8ubIO6IYQmKzGxngGTC
         oQEi8//LNbhmanSbZldgfbYPYfHOoN6qrpsJUeaXk7AhJu2Qo7dSS68Fn3/4NO2oBT5L
         onkI1GEpBfFKX3YGeiP3jxNWS9BFCY7hy0Sq6L9Z6/hKj4TQvYroFHdCjpYURz5jchdh
         x9WA==
X-Gm-Message-State: AFq9FYIIOAOBXbDFX18FqFD4sSwRty7UwBYg7FR6d87Th/A5lh7TYERW
	5rhs08nxLZ7ofBKJGM2nOyM1JaAVCLhOF68jtDgvc2mdKA1iI/dRDvQ=
X-Gm-Gg: AYBFou04OwiP7CpiaVrS9HVDsx07kh9snUKWsk+XdfjAozHfxEWUOyicPiZEkZKTKgj
	tOVC7i3jb2F95n4WQNKnxWlJg1fzCpXKliN6hsv1aTB7fkc1EDXffEX5HRWfEGpqIBwLJ06NTHA
	g2x02+KESUBnftOaINg/kZ/fjD94R6YtomqazPbRROkdwhBGszM9B6CMYa9pV/e10Qz4rdOBe63
	zIGKQ1BvBmeH8oQAxbL6Rgo1ZM1tJuhSaOtGh4MYyA8HnQBGPTCILsgPPIyNOwtn032l681/SX3
	RBIpEBHWtinGR2h7aqigu7nZwKOP1duBpQvMmyvkODJyF0oAIdXNW52KpMiVxHhP88fK/dOQu6f
	PZG73Mdp95HF8rQs7CcJmtZfgC1mfyjLEoKgk4F35c4G7Mi2nKMGdNXSgPyZ/oGSZt4Af3KNobX
	a9fAKixjHHXD5C0paoYap9rZPylli5Q5hbRBtuzyEfRAHku1hb76DNt32WJSGADg6nCUCYMwVT8
	ysKJwrQXaqalSlHAPFPmAJJ31kN5n2gR80KsY5eUKoEHGb97w==
X-Received: by 2002:a05:600c:609a:b0:4a1:717b:7976 with SMTP id 5b1f17b1804b1-4a18e4b15e5mr64393555e9.35.1791584541444;
        Fri, 09 Oct 2026 15:22:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4680.dip0.t-ipconnect.de. [91.43.70.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bb68abfsm93450405e9.0.2026.10.09.15.22.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 15:22:21 -0700 (PDT)
Message-ID: <be5d217e-ee85-4596-a8c5-30c1d3202b77@googlemail.com>
Date: Sat, 10 Oct 2026 00:22:19 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/428] 7.2.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261009140946.008206689@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.10.2026 um 16:05 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.10 release.
> There are 428 patches in this series, all will be posted as a response
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
