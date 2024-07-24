Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C04515748D
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 13:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721826735; cv=none; b=DQR1FpVfqBy5idEokUl3A5orenbyCIaLFvBxJravJmn095Wli6/7Okf+S691dhlz237DDumaOKlYITK0hQFuAkIzPLyvGWiE9HqalJBIu4XOlnfwJLer9ruMEiJuHE592mh8ppFc7QnBWRzUFBZt5KhRTYVewt4dDiV07tAZCrg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721826735; c=relaxed/simple;
	bh=okQJO08cg1z+VKw5TZoAGSyIpXrmh6t0Fy4RAysp5ZA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ghSvFVPR8wlzgvCP9rvpJ2tZdkv13XJ0FhPvKUXc9NcjIG48xWPy8dQF1kEj1PtXIJGb/Wl28OjmX2KRP7tikO43eZa1+OIb/oqplCJPt3Mug+79YXg3J4PXRLxYHnVER6hLjiqJE9r+3f/OlGCwK7V5R9PsoET1TXVbVG2sZpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=U7EBeqZp; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="U7EBeqZp"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a7a8553db90so236491666b.2
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 06:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1721826732; x=1722431532; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=k6SyZqu8Tx++VUI1E1JtOKm2pAJQRvY3MmRJGI28d08=;
        b=U7EBeqZpogQZJ9MW344RDu33pQbFc/do52iT2owUKvcY84pPeHeJIARvDN4LFFAdvs
         3qxOfCmAYYGkHd5aCsp+RVSZJI2TPwxVbdt0PVyW0AQXI9W714VSubU7Z53BZ5SNNiEF
         8wTzknJ8OhkhqMeFdLGaLBYFRWwrxS+tYo8cky4pIpGZSmXaq20ZoB2mDQQY2F4zdhoQ
         b66SP90vltWjZgUES9DcEvS7XKkHe6EIjtJU6sQgr2THSwpzP/98SdB9Rk5XwgGS+FSB
         9ON2Es31FO8y/KCNH9QSLJXAA1Sn4xM1UMzXgQx601fd9PGk1glRNZkwGgQh1Vn22nYk
         BSFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721826732; x=1722431532;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=k6SyZqu8Tx++VUI1E1JtOKm2pAJQRvY3MmRJGI28d08=;
        b=AdhUIZY2MPpFXHjMyQNZJdaqrL+bq2kJ/AM459/NjbhEvv1mvtEi+XXMqc6xxczmhh
         XFVZ03Rp2EoZAah1Hfxh551tiHl7j0bpPEGmtnbCFZCBLxjFRo1U9qf230y6vYAzbIDx
         hFwtwJfyJOWHw9khmuziVZoko/4mmExYFMU06qCg39rbse0AE0TJNjg31TrGIYlyHrN0
         sco/3eZcUB0FtjRzGwFMxqYywjA+ff+L4Dvb4ob6GJN44t7sdGpvYvKrs9Wq1ly0S0IL
         y5+VZq2GCAIJwVGeNRQUgWYap5i911Ih4SVbEfmfHF9sdJbwmPHoZQK/fUEZadV8FKYu
         O/zw==
X-Gm-Message-State: AOJu0Yxt8kDmBL07Qq6Ma5BjHNaL0GaCkQjElI8njQMeW1ZxBdY8nYYP
	T4ZedtH0yTvrUJpMhtjvB6lHiAhiQ3/AXhVFDA5XY9Dd6fq0w5QgHRmzBvE=
X-Google-Smtp-Source: AGHT+IFPILakQyCipw5kBSFqvZG6rNfHySm90c3nN2evpAn2HZOh2tr/4kB/5o0WyxC/vSHivwDCpw==
X-Received: by 2002:a17:907:2da8:b0:a7a:8cb9:7491 with SMTP id a640c23a62f3a-a7ab10c3ed6mr167395366b.54.1721826731485;
        Wed, 24 Jul 2024 06:12:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b1e.dip0.t-ipconnect.de. [91.5.123.30])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a7a3c922d6dsm646600966b.169.2024.07.24.06.12.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jul 2024 06:12:10 -0700 (PDT)
Message-ID: <ae5b02e4-3c12-49b9-95a3-c1da06dab146@googlemail.com>
Date: Wed, 24 Jul 2024 15:12:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240723180404.759900207@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.07.2024 um 20:22 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
