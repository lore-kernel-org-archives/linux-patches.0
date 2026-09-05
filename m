Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 577EC14A619
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 20:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788641354; cv=none; b=EQByX5yDaOsvlYZB7EzNRzbF6XgecPO84GQWkAYLg0oE2eaPA+3WAwpZuuNtpEWlYK7T3AzxsmKuydI39a0XFPew5P8t3yYFUOBJokpqLZpAJpG/DQoNQWwOoL1IKqexIBfNLQWqMuVNeCDu9aOqth3+VTgDVXScmiP19q7sq04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788641354; c=relaxed/simple;
	bh=r/z0/C5tMQT5HZYyEl4B0b4VC5XYi8OOIGchid41G5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qd1KB6P5zxBYLZwflOWPoAFizqEr/EP/02RY8x6i7FeWjQwVevAqnRH6iiWbjJyp++oyqmJi+bxGQPCwpbvbVIMq5+LArg2Ip6gaxxXwR6595na7OEByxDIA6eNUwfGTOG+iWBzcY8+bNKmbzOUKtxqefM7wpYVm28bZ/1kjaQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=fWafZhzm; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="fWafZhzm"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4843e397f74so2723082f8f.1
        for <patches@lists.linux.dev>; Sat, 05 Sep 2026 13:49:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788641351; x=1789246151; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=c1EfKIGU/Jrr5zV5deWFk7RgEC9wFJWZJq9htaal6jY=;
        b=fWafZhzmB3GDGmCDreMm3++bBQcBHZMDenPDQSteWAQ1Jr3lhI3GjKlc69F/gp0a6s
         KG2WqKgxoHX8nnf7O76t9EFmVGjv7ftXxVJQmBc4OHESs/zg4xbREhGRPIF+LKrKFjI8
         wWQVJpEPFAFQg75XHXwm5Ldm3JgqvmGH1lyJpP/QnkT8O0R+Hnss9oNo7aheq7E+Ltxp
         9RhlHjnOa6q5o9950vEm4cv6VPKMgNvIZqzFeTigu6n8sIn0PmKx5piz/0+0WlIQkNI9
         /K1dmc0XuvwuLAefeNpuhSBuARyDSHxADqUaEXzx+lmSk6yD3A4eGgTbkf6yYPRgY0g8
         fC8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788641351; x=1789246151;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=c1EfKIGU/Jrr5zV5deWFk7RgEC9wFJWZJq9htaal6jY=;
        b=arf89M06OazrqCVyyn5jlp7kxeEtC4fDOjq4YpaUP5KU5G2P4P7oeTu9B/QynOH2VO
         B5bGjTYR6Ul61uKPwMCpC8rxdpAZ2/2C/VkcUQz+FteRwXndETMEZiNNc09k86Nfvx4X
         BTU0ga+E56dDVZouunp7OfxpgQgNMPv1aEW2wHJKLSBPExMcFAmjTdV2dEVypHbsm48G
         yaMAEyfJbuUt0BL+/XWiM5h8NvigZUCm0r83LFCiHEQ6Cjtkr5pJ8elqsLzs1t+vUklZ
         BuFzAR9jJJOrle0uhzobGEWgGpI2UMVtYr7HocAnQzf1yFUXuGGrne9d8ZhXnKHplqv7
         j1tQ==
X-Gm-Message-State: AFuF++leOVDp0VT9LGyJ0ZUllil4cWM+nvocbfpmCjF97sYSL6CWRYVJ
	yrslOUgsiWEv4wmxKCc8WT4ASF23ExMRcRfc86GwqOmMSkmObxZImaE=
X-Gm-Gg: AYBFou3ANFNqme2aigFbqB5Y8Jr1EXrSU7peLnaG2TW7irsuIlJw/e/e32RHrf/iU6h
	EcjpCYMN7Zd2Te4Acf3G2uY8DwDFvmWEMo7kcqj78Gk8b9UiKoNRo739pGkXKDoSL/8WHHtw1RJ
	K9KT+XbI0A4pam9ZbOxmrjTUG1r+eZkDbZ9hs/AM55FyDxPZtn4wBy7pvOgtE15UQ1Y1YnXqRSJ
	w85fHJ+F4QfyFHQINXG+gM1h34sTDxwv8nvX+pHH/wC4Q+SPlqY+N/3l70fv10a0AEb9tEf/o+g
	zqN5ZOR+uj35Iwr23XIiLkhcnksmzwnRbuKZGssJdHNJhM4IJgz4MOigZ3FCRyeJjkpihAm8bKD
	O18x/58xz4sY/JOFXIoiMz+hdSgHlElrVqK0h56ARPET2nAqpjEa8pKjLyqPO25EhoYMoTX2aQi
	sHVmO0BU4CLPPHUF2eLOw9GYmzeuL+PyOZjijYzCVHpD2Kk7UMPrFk+B5Qt7r3gcQrN9jw1BZn3
	ty1XO5QqTnyu467i0n0wTZJYeCqImwHg/1lgROM
X-Received: by 2002:a05:6000:2487:b0:485:8639:d58e with SMTP id ffacd0b85a97d-485891e752amr13186722f8f.8.1788641351327;
        Sat, 05 Sep 2026 13:49:11 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acda4.dip0.t-ipconnect.de. [91.42.205.164])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-485883959f0sm17241259f8f.10.2026.09.05.13.49.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 13:49:10 -0700 (PDT)
Message-ID: <840c2d45-400c-4540-8238-862aa54a87ce@googlemail.com>
Date: Sat, 5 Sep 2026 22:49:10 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/400] 6.12.109-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260905115627.670276262@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260905115627.670276262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.09.2026 um 13:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.109 release.
> There are 400 patches in this series, all will be posted as a response
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
