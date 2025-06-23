Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7504C450FE
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 20:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750711538; cv=none; b=JQEkMuvdqO+Hm+k3aitVcbWF01BcSB8wE0TFa/K+RVJw4RQIAA/XKYWiHYNlJauZqI9Mrl6Ky9ZFDLic4M4bxhNDTthtvZ1n1t9UhqII+v5sWp1aznAXZl9zzeOYFIvGZOJ7TTk5vb/o8ItxqsjPFJNIPaRRycN+yumC89ahmg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750711538; c=relaxed/simple;
	bh=nJOfIgX2j7I2He+le6ibzRaeN8icl02bpC/vkM2ViWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XnaXh6UNaFdpMr7ZR0orLHFvsh4+mOSekQQAZykw6n8FPGAuWvB4m7MSHL1m4IKcx3764UJtHw22tXEE4jFiW1rjrdBu+v4NHhbK2n2ShTlthLLEED7wKOZubcnbIG5NLPubQ2WFXLWzHUUHgj9yTwlbwWiedkE3cMbsKGrB+H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Dco/5Kre; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Dco/5Kre"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a57ae5cb17so2590077f8f.0
        for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1750711535; x=1751316335; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=cOG7zqQvApgpVEilf4HIPlQCZTxX/a/I3OsuQlR1qAo=;
        b=Dco/5KreQUFI8dzt0jRsHH4TZqMYdb1lz7qppijZAlJk+T8WbD/WZTHsT0+8Mlz5Ab
         /nAyc5Mmzppv9Ce5vrn6mdfsaN8oPlB7mBAfzyJ0N97fSP93O4XdTY5qqlmKeEeQ99ja
         JGKHJqKfzmD2T52s7dWdh6BTiS4QXObh3NrFBLuil9LGEwdQqTJaYT91TUyBt6rH7DEJ
         xui8wlhNr+6nwB/01aozlstIDVmkxSo9rvD73+XRCBtR2xaG8pISp1+CHPJWMeqAB8uk
         vW5ptAsUm+kMrbWrOROs98SM02eZTdwWfF4GpbVsOTklez6hh7kesDmSVKJdDC05Jnzr
         TvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750711535; x=1751316335;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=cOG7zqQvApgpVEilf4HIPlQCZTxX/a/I3OsuQlR1qAo=;
        b=ODNi7S0z6KbpvqxNJy9TYgQhW4w4GkFsmMgBFtnzcfsXuMpoPx06wThzpvg+5ucW05
         ftxhoX444bLgqx/M9qYB2ZwVxrMl+AP5ZfygZL6kz6FSAtgg3+2mdGWxO6LGwdV6g+sh
         QOtxiK8GueKxm16TIhp8k0kaMTT5XT7b5CXS+xy2e8OfPa5EIMhifnpgp4rGghL4jFiD
         av5MiltSMUrA5S59UrF0NJguKv7xG97tP7Dh8KgJ8Gd7aanYmInuNT/pzOTcxwuAvbBb
         Gs+xnbkbkzdL3hBE0q2syttYSGt4M5S0BmwRrsTYO9nypPyj2kZRHoL6WdSyosa6Ky29
         jZ+g==
X-Gm-Message-State: AOJu0YwXxm806IJ2FlqEeunpF7ypQZc2U2ESIuFM7XyHQ2FgFvH1dk+m
	up+9+LS14o1woEwebAj+pszT+qcpHvmLsFaTHCKFP9H2gGSiiGIdk/4=
X-Gm-Gg: ASbGncssbJhrSdrxK/rq6QbyLABUcvQo15cRCe7IcY4zK1PSUOSTSzsO/3tCjeXK/nu
	fGMl1Qs6jrcOS0SrmDJ7W87rI8rcdto0muS9WE1O/w/llBAnH021DiuzMy/NWi88dvdoCsfV15j
	VDNyI0sAaGc+cMJWwxiL2zppLLspXZPYLCY77qO1KnEtm3Dz/g1lltCCwPnnRq+lZLYM+dBekpP
	e1fTYXtxM9eWKPF+//zjCftUlZ9V2Fm/fcPv3+uKasx0lZzqnlKBBDC8GCbq32ftpPTCnIBiiT1
	ABDhW6IzIW+Z97VBfvBhLlU0SOsnmHYjlemEVoa1+EKrczVguvvCxMQPFsAdswuFvwOEnJmJnwP
	kvslvCIQnTaoV8+U71opJOLKyXKVxNY8JdNPcmvQE
X-Google-Smtp-Source: AGHT+IFAgt/Ra61XB211TVnlOI33e0YkZh3jnGT9FfvUN02IX6xMf6NIS4BltWT50lcUvlaFjvqL2A==
X-Received: by 2002:a5d:5f4e:0:b0:3a4:f6bc:d6f1 with SMTP id ffacd0b85a97d-3a6d128db11mr13461052f8f.14.1750711534542;
        Mon, 23 Jun 2025 13:45:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac778.dip0.t-ipconnect.de. [91.42.199.120])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a6e805d342sm103224f8f.21.2025.06.23.13.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jun 2025 13:45:33 -0700 (PDT)
Message-ID: <2f3fe45f-28f8-4ff2-bfa9-4769eb1415dc@googlemail.com>
Date: Mon, 23 Jun 2025 22:45:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130700.210182694@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.06.2025 um 14:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
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
