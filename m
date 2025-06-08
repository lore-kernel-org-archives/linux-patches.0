Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557EA1494A9
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 17:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749402053; cv=none; b=rw39sQ6v8Lu1DD1BxMF5Drw/n5IHgCKu2O9maKp0ZYFFE3dpX9rR00t3rxbuG2e9iX3tK+TyIx+8eSF/ndNFR7+XTIwliNiJxPa999TXk2CreRaJVHPdIAG5PHaygi4pTHLbF6laNR2WDYqbCRyubKKohae450TbZTesZG8nQ/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749402053; c=relaxed/simple;
	bh=/bNsoVxYwacpXDiayNGuTxJkwc5QaeWgyzPErTnF2F4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ln2dcau0r70Tat+T19YGPkdgGLLjs5NXNcx6cAOlJEbxfzZve707EBthzn3b4E2jIkafHnDMmmf2+jwauNvtmR9qqflQGjWGVAHVpB/yFKPp9/0hFRiw+vLgAzaj/vruSmZrH6MCr3zLOfvPi2Q3kDq347UNsFShfn7anYnFp8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=hAtVG3YG; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="hAtVG3YG"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-451d41e1ad1so28648895e9.1
        for <patches@lists.linux.dev>; Sun, 08 Jun 2025 10:00:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1749402050; x=1750006850; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jemnm29QAMqI47V/wtphWNl1AmFUucMDlLmAcMnzjkA=;
        b=hAtVG3YGhkb93Tya6YJmQtnU52vKa6LldwkcNcbreYQ3PFsXNZhTWo4bCTTiEZ32OT
         szDWHOUcJ+7QbhNhiMFKYWUro1j+FUOgFmh1FRU0NPF8WdgYejOQ2xpjFhQOy7hHy6IL
         vwGRnCLMtrCuS85/OgqZZoGRi+786Rn6Euv04A4xpfhE+mPs9USzaIhve0NXiURK/QjG
         o1hGJeLspYC+VTLapPqylKOetmpq6aq/vLKF96JZnH4JBPusciq0BkUMEK+cIHEBDF/h
         EZv8sDOoIq/7vXbUvgO5kb4fgz3oo4qqivzTFkZwzns7+oyr7qSHztoTBoiJuYPEciTd
         4o4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749402050; x=1750006850;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jemnm29QAMqI47V/wtphWNl1AmFUucMDlLmAcMnzjkA=;
        b=D4fe8hU9PKN+sq6sHuuVbMbND633fHznmPvSNpcuj8unY5VTCSnlb/E3QZgl1BKaPw
         GPwWuQraNM2011etK92ogd4RlfUY+eT5axyMLDlgMv6T/enupFNHxioH7Kq4LL5RmxkH
         bxBA+XxeRcyIH0NhLyEx2Aze+XN2eHJmSZhBvQdN1gj4e5LOoTmIQATGGzDqt5XSXlo9
         TLTCcn6KD+X9ZFPfneyvMtdOi6lCypRlFKlQRdbWEDvwT6QW6sk8A5ImdXCmEbAInwRZ
         7OwYgOOxoPwkVWkHQ26R2JOqptKdPexmiybHgTFXJYhyq5qqGZ28S8xzQJMHDPW/6OOu
         TWXw==
X-Gm-Message-State: AOJu0Yz6YjyWjsqY3AHJorN9YYE0G3GFhu9tOqKn00Lb4KTuSHIOSsrL
	RuNKB1xnk7WbUpy9UQK+YuDd8587Sy2pV6hPHseEJqENIy5SfRgAcFk=
X-Gm-Gg: ASbGnctZO3wgm1XUfDdsm9kSJ+QD+oUjqdnw9A9nGzCWrpQMc+A4YM1jkAHbSxGvqKy
	yQN11mJR24QINgJTkMWVY1i7Um50AU+zmMabNZ3FLe7srqFasQ8GLO9zn8N2tRG4knKtJncXe2n
	ppvFYVWPYL8Oa2L2cuHkcQQOUdOI4HmmpWuAM5Rrk/qRUOo/meFgZdac53Ncs1hOplosfmM+buE
	U9L2M0dXwX34kbfeQzI1V5VK4PGnBBol0zIAotcI4cSQ8GjB+/aBllXv6GANl7UQR7MrFSy8tpd
	ygfluthPMf1tdK6U66o5tMVq6Ung3JrmReyNXMCENrhtshGNnHABE98ss21n3pwqUHhBfZ+81em
	fEJt/8EARJYCskvxF9qkhTi7o/1M=
X-Google-Smtp-Source: AGHT+IGfm7A3on/2DFqoXs5ImVx9+eoZZRrYHo6As+KPSTRBYhewMFv05457onPfASBatZL1COyvaQ==
X-Received: by 2002:a05:600c:518d:b0:453:78f:fa9f with SMTP id 5b1f17b1804b1-453078ffb67mr38485195e9.11.1749402049484;
        Sun, 08 Jun 2025 10:00:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace02.dip0.t-ipconnect.de. [91.42.206.2])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-452730d161csm85257225e9.37.2025.06.08.10.00.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 08 Jun 2025 10:00:48 -0700 (PDT)
Message-ID: <7634f9af-c3c0-4953-be8b-4e8395c4bcb3@googlemail.com>
Date: Sun, 8 Jun 2025 19:00:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.14 00/24] 6.14.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100717.706871523@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 07.06.2025 um 12:07 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.14.11 release.
> There are 24 patches in this series, all will be posted as a response
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
