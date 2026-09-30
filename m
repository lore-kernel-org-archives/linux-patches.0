Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F94447CC6B
	for <patches@lists.linux.dev>; Wed, 30 Sep 2026 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790809026; cv=none; b=OQ7PaOhjivHmhGAA9eE9cPWqDul5dsdGk+sUJxCG2r89toDU/Fam25taIIeARZneuPZtUzFYM2T77iFYXCkeruR//+BULXKBbKV4VvUs499QQhN6+HpxqtDNuPXWhBO+InW3pcRxf7Kug3QM77TlTDHwz84ffFNNcdKdHBCncls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790809026; c=relaxed/simple;
	bh=Hke2G+4Wij2r2NahZT9DM+vUuFtMN323JUACpTjNzGg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rS42rIOoaV8yOwLEj8uqJnpxOUS/5CiIrlNreFgEk6wvoveeRfKoTS4FtPOfeSeqjEdc8IjNmkixL7V5lmkqR5YYJ+brW6zwcEFx874TkcMFH2F4xtYtp8O/z94qJHgJx2mtiaxRcolPriO9W9d8QK4Y1/GsB+avMR2osV4MVqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=q6YOmCBs; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="q6YOmCBs"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49d1fb0cf5eso54206815e9.3
        for <patches@lists.linux.dev>; Wed, 30 Sep 2026 15:57:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1790809019; x=1791413819; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBtOSawkeFkXP42NM1qSxi/aAPisSJdBIxTS7Qmx0XQ=;
        b=q6YOmCBsHJX+SuoW52HGkEgQv15OpIKkd9R6aZ9hIU1JYzvtF86ZhzG6o03A5AFA1K
         XSrciX/3QmCe5qrLfDqsqcbigbtksd7NDLAgAqZvjeEu67PPE3F+Bpmrf275LbR4MAlD
         0X/VmZKhgHPtXGTBrNwrBJEM74iSQzLVJ3ufDrpCSyvRijGGPG/6SYlzYSYGSn/pRBTh
         z6htT+mLZJoh0Wz5Hg+v7+EKxOGHY9svyr8twggFM9ZuUadnFYSYTGA7XSd1ENfjps/a
         2WNNHSr//13IITCK1juPeVUNof40ozYZuJmMDsYRlamjsWRgujPoDpPOlMzGAUWvKBod
         bmYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790809019; x=1791413819;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lBtOSawkeFkXP42NM1qSxi/aAPisSJdBIxTS7Qmx0XQ=;
        b=uKQl9ElVBW+AnlUptEvLVEBOWtp7zmoSUdbFnnispq2c3trWaX8nWsgXuLJYGXw7U2
         K4L94TgXUdRMnawks4SujOr3xFJfD2qDDRgM1MaSRJdKC0oHxQVRkAwUtwUjg37/N5ZI
         WIh4bV71k58uVyhGOx6A1iWiWHNTKDJsmdv8zU26o9hsJ1Qe4tW0MMLq0MgVvil7FRSB
         JFjwodvVq0MLj03vyQjdsSZoYIR16krHxeKuxMEFk9rEwF56ZccQE7SQ3StLl6rjmX/G
         pWY2wHR2IVPpPERoWCjfy8n3oYoc54/RX9B5K62fXh6UJfm3ckv75Cj87G7OICWAQRMO
         70LA==
X-Gm-Message-State: AFuF++lLBj9YKD/j8zQdDoAb32Ui8NHpC9KRbetx2z/tFwSPmuMwMAmZ
	MIML+go5uWs/vr92nMRMGhTnrhXJ1M5jZRXCrc40pktdSlG4zbI88u0=
X-Gm-Gg: AYBFou07140kPP+UH/vtuxSDg0oKQ+J6YCwyYPB4K41bs3+fp/bfYVh/TSddc7U2rp7
	zReqw2L+QaaJotE4RioFnm7IIbDuh3DkJP6GlCQ1/uGAkGdyxfA2IoYbpkZEJ7W33tcYpo5mmvF
	GrHVL++r1FUmP6airVpDKGWRDYK7BkyinY4dgs5oDEZ5fOR/RG6voyaLW6414JJAPhdMo5q8vGO
	dhVfQprI49CczXNNHieRayz9y7IDwmh6ichrnxINaOThVN/HR+Fc49BwMz9zwn93tgefUwr4CFO
	EE3QOnvni//xcP0ezRHEBGjBCNrwiEf3PUVa9DEvIdwghsSYXp3PRrnqCXcde8PfSqvyTZdNUrD
	jP22v960StoZxhCiFBbeWVq02iM6OzXnf/7aw0TkLQhfuqcrT2+la6w2kKyFsJ7yBRSTZNeicO4
	cKpKN7bYbK3ox+li1/gvocmfOrPoPY9M9lydspwQNmfOIBoUXCVeorJO6OhJkU8jiwd5vsfDBv6
	gC1pC+Aesc1LQ0BfGK64mf15tep7z6fU701PRaB31XF9KA9HQ==
X-Received: by 2002:a05:600c:628b:b0:49d:1cc7:5ec3 with SMTP id 5b1f17b1804b1-4a01afe7ed5mr45606825e9.9.1790809019416;
        Wed, 30 Sep 2026 15:56:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b057568.dip0.t-ipconnect.de. [91.5.117.104])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f922ac4sm16784975e9.6.2026.09.30.15.56.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Sep 2026 15:56:59 -0700 (PDT)
Message-ID: <d3f4f4bf-9839-45f6-a3fd-e8b0062ad032@googlemail.com>
Date: Thu, 1 Oct 2026 00:56:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/457] 7.2.9-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260930152346.024115587@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 30.09.2026 um 17:21 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.9 release.
> There are 457 patches in this series, all will be posted as a response
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
